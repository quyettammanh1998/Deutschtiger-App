import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/confetti_overlay.dart';

/// "Hoàn thành hội thoại!" completion card. Web parity: the `sessionDone`
/// branch in `conversation-scenario-page.tsx`. The holistic "⚖️ Đánh giá
/// tổng thể" verdict (`/ai/conversation-examiner`) is MASTER P8 scope — this
/// shows a pending note instead of a fabricated score.
class ConversationDoneScreen extends StatefulWidget {
  const ConversationDoneScreen({
    super.key,
    required this.scenario,
    required this.userTurns,
    required this.onRestart,
    required this.onChooseAnother,
  });

  final Scenario scenario;
  final int userTurns;
  final VoidCallback onRestart;
  final VoidCallback onChooseAnother;

  @override
  State<ConversationDoneScreen> createState() => _ConversationDoneScreenState();
}

class _ConversationDoneScreenState extends State<ConversationDoneScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: tokens.border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.conversationDoneTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: tokens.foreground),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.conversationDoneSubtitle(widget.scenario.titleDe, widget.userTurns),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.conversationExaminerTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: tokens.foreground)),
                        const SizedBox(height: 4),
                        Text(l10n.conversationExaminerVerdictPending, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: tokens.primary),
                        onPressed: widget.onRestart,
                        child: Text(l10n.conversationDoneRestart),
                      ),
                      OutlinedButton(
                        onPressed: widget.onChooseAnother,
                        child: Text(l10n.conversationDoneChooseAnother),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ConfettiOverlay(controller: _confettiController),
      ],
    );
  }
}
