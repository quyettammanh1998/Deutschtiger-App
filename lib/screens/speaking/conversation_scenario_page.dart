import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/speech/conversation_display.dart';
import '../../data/speech/conversation_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/speech/conversation_dialog_controller.dart';
import '../../view_models/speech/conversation_provider.dart';
import 'widgets/conversation/conversation_context_collapsible.dart';
import 'widgets/conversation/conversation_dialog_body.dart';
import 'widgets/conversation/conversation_done_screen.dart';
import 'widgets/conversation/conversation_examiner_sheet.dart';

/// Live conversation-practice screen. Web parity:
/// `conversation-scenario-page.tsx` — routes `/conversation/:id`,
/// `/conversation/custom/:slug`, `/conversation/interview/play/:id` all
/// render this one widget, differentiated by which constructor arg is set.
class ConversationScenarioPage extends ConsumerStatefulWidget {
  const ConversationScenarioPage({
    super.key,
    this.scenarioId,
    this.customSlug,
    this.customTopic,
    this.customLevel,
    this.interviewId,
  });

  /// `/conversation/:id` — catalog scenario id.
  final String? scenarioId;

  /// `/conversation/custom/:slug` — free-typed topic (de-accented fallback
  /// recoverable from the slug; exact wording preferred via [customTopic]).
  final String? customSlug;
  final String? customTopic;
  final String? customLevel;

  /// `/conversation/interview/play/:id` — saved interview scenario uuid.
  final String? interviewId;

  @override
  ConsumerState<ConversationScenarioPage> createState() => _ConversationScenarioPageState();
}

class _ConversationScenarioPageState extends ConsumerState<ConversationScenarioPage> {
  bool _contextOpen = false;

  bool get _isCustom => widget.customSlug != null;
  bool get _isInterview => widget.interviewId != null;

  String get _cacheKey {
    if (_isCustom) return customScenarioId;
    if (_isInterview) return 'interview:${widget.interviewId}';
    return widget.scenarioId ?? customScenarioId;
  }

  Scenario? _buildCustomScenario() {
    final topic = (widget.customTopic ?? '').trim();
    if (topic.length >= 3) {
      return buildCustomConversationScenario(topic, widget.customLevel ?? 'B1');
    }
    final parsed = parseCustomConversationSlug(widget.customSlug);
    if (parsed == null) return null;
    return buildCustomConversationScenario(parsed.topic, parsed.level);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    if (_isCustom) {
      final scenario = _buildCustomScenario();
      if (scenario == null) return _errorScaffold(context, l10n);
      return _DialogScaffold(scenario: scenario, cacheKey: _cacheKey, contextOpen: _contextOpen, onToggleContext: () => setState(() => _contextOpen = !_contextOpen));
    }

    if (_isInterview) {
      final async = ref.watch(interviewScenarioProvider(widget.interviewId!));
      return async.when(
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, st) => _errorScaffold(context, l10n),
        data: (scenario) => _DialogScaffold(scenario: scenario, cacheKey: _cacheKey, contextOpen: _contextOpen, onToggleContext: () => setState(() => _contextOpen = !_contextOpen)),
      );
    }

    final id = widget.scenarioId;
    if (id == null || id.isEmpty) return _errorScaffold(context, l10n);
    final async = ref.watch(conversationScenarioProvider(id));
    return async.when(
      loading: () => Scaffold(backgroundColor: tokens.background, body: const Center(child: CircularProgressIndicator())),
      error: (err, st) => _errorScaffold(context, l10n),
      data: (scenario) => _DialogScaffold(scenario: scenario, cacheKey: _cacheKey, contextOpen: _contextOpen, onToggleContext: () => setState(() => _contextOpen = !_contextOpen)),
    );
  }

  Widget _errorScaffold(BuildContext context, AppLocalizations l10n) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.conversationLoadError, style: TextStyle(color: tokens.mutedForeground)),
            const SizedBox(height: 8),
            TextButton(onPressed: () => context.pop(), child: Text(l10n.conversationBack)),
          ],
        ),
      ),
    );
  }
}

class _DialogScaffold extends ConsumerWidget {
  const _DialogScaffold({
    required this.scenario,
    required this.cacheKey,
    required this.contextOpen,
    required this.onToggleContext,
  });

  final Scenario scenario;
  final String cacheKey;
  final bool contextOpen;
  final VoidCallback onToggleContext;

  Future<bool> _confirmExit(
    BuildContext context,
    ConversationDialogController controller, {
    required bool sessionDone,
    required int userTurns,
  }) async {
    if (sessionDone || userTurns == 0) {
      unawaited(controller.persistSession());
      return true;
    }
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.conversationExitConfirmTitle),
        content: Text(l10n.conversationExitConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.conversationExitCancelCta)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.conversationExitConfirmCta),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      unawaited(controller.persistSession());
    }
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final args = ConversationDialogArgs(cacheKey: cacheKey, scenario: scenario);
    final state = ref.watch(conversationDialogControllerProvider(args));
    final controller = ref.read(conversationDialogControllerProvider(args).notifier);

    if (state.sessionDone) {
      // Persist once, right when the done screen first renders.
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.persistSession());
      return Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: ConversationDoneScreen(
            scenario: scenario,
            userTurns: state.userTurns,
            onRestart: controller.restart,
            onChooseAnother: () => context.go('/conversation'),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _confirmExit(
          context,
          controller,
          sessionDone: state.sessionDone,
          userTurns: state.userTurns,
        )) {
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: tokens.border))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(scenario.titleDe, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: tokens.foreground)),
                          Text(scenario.aiRole, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => showConversationExaminerSheet(context, coverage: state.coverage),
                      icon: const Text('⚖️', style: TextStyle(fontSize: 13)),
                      label: Text(l10n.conversationExaminerButton, style: const TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                    ),
                    const SizedBox(width: 6),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      onPressed: () async {
                        final confirmed = await _confirmExit(
                          context,
                          controller,
                          sessionDone: state.sessionDone,
                          userTurns: state.userTurns,
                        );
                        if (confirmed && context.mounted) context.pop();
                      },
                      icon: const Icon(PhosphorIcons.signOut, size: 15),
                      label: Text(l10n.conversationExit, style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              ConversationContextCollapsible(scenario: scenario, open: contextOpen, onToggle: onToggleContext),
              if (state.error != null)
                Container(
                  width: double.infinity,
                  color: Colors.red.withValues(alpha: 0.08),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(state.error!, style: const TextStyle(fontSize: 12, color: Colors.red)),
                ),
              Expanded(
                child: ConversationDialogBody(
                  state: state,
                  onSend: controller.sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
