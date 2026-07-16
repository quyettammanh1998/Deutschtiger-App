import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/sprechen_chat_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/speech/sprechen_exam_controller.dart';
import '../../../../widgets/common/gradient_button.dart';
import 'sprechen_bewertung_panel.dart';
import 'sprechen_exam_header.dart';
import 'sprechen_input_area.dart';
import 'sprechen_instruction_banner.dart';
import 'sprechen_partner_chat.dart';
import 'sprechen_session_history_sheet.dart';
import 'sprechen_study_panel.dart';

/// Web parity: `sprechen-exam-mode.tsx` — the shared engine powering every
/// sprechen exam page (Goethe + TELC): study tab (markdown + "Luyện thi
/// ngay" CTA) and practice tab (partner chat + input + bewertung), see
/// scout report §A.
class SprechenExamMode extends ConsumerStatefulWidget {
  const SprechenExamMode({
    super.key,
    required this.title,
    required this.subtitle,
    required this.teil,
    required this.topicSlug,
    required this.aufgabe,
    this.hinweis,
    this.studyMarkdown = '',
    this.contentLocked = false,
    this.startInPractice = false,
    this.onExit,
    this.onWordTap,
  });

  final String title;
  final String subtitle;
  final String teil;
  final String topicSlug;
  final String aufgabe;
  final String? hinweis;
  final String studyMarkdown;
  final bool contentLocked;
  final bool startInPractice;
  final VoidCallback? onExit;
  final ValueChanged<String>? onWordTap;

  @override
  ConsumerState<SprechenExamMode> createState() => _SprechenExamModeState();
}

class _SprechenExamModeState extends ConsumerState<SprechenExamMode> {
  late bool _practiceTab = widget.startInPractice;

  ({String teil, String topic}) get _controllerArgs =>
      (teil: widget.teil, topic: widget.topicSlug);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final examState = ref.watch(
      sprechenExamControllerProvider(_controllerArgs),
    );
    final controller = ref.read(
      sprechenExamControllerProvider(_controllerArgs).notifier,
    );

    return Column(
      children: [
        SprechenExamHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          isPracticeTab: _practiceTab,
          onHistory: () => SprechenSessionHistorySheet.show(
            context,
            teil: widget.teil,
          ),
          onBack: widget.onExit,
          onSubmit: examState.messages.isEmpty
              ? null
              : () => controller.submitForGrading(),
          onExit: widget.onExit,
        ),
        Expanded(
          child: examState.grading != null
              ? _ResultView(
                  grading: examState.grading!,
                  onRestart: () => setState(() {}),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SprechenInstructionBanner(
                        aufgabe: widget.aufgabe,
                        hinweis: widget.hinweis,
                        onWordTap: widget.onWordTap,
                      ),
                      const SizedBox(height: 12),
                      if (!_practiceTab) ...[
                        GradientButton(
                          label: AppLocalizations.of(context).sprechenPracticeStartCta,
                          onPressed: () {
                            controller.start();
                            setState(() => _practiceTab = true);
                          },
                        ),
                        const SizedBox(height: 12),
                        SprechenStudyPanel(
                          markdown: widget.studyMarkdown,
                          locked: widget.contentLocked,
                          onWordTap: widget.onWordTap,
                        ),
                      ] else ...[
                        SprechenPartnerChat(
                          messages: examState.messages,
                          partnerLabel: 'Tiger — Prüfer',
                        ),
                        const SizedBox(height: 12),
                        SprechenBewertungPanel(
                          grading: examState.grading,
                          isRunning: examState.messages.isNotEmpty,
                        ),
                        if (examState.error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            examState.error!,
                            style: TextStyle(color: tokens.destructive),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
        ),
        if (_practiceTab && examState.grading == null)
          SprechenInputArea(
            sending: examState.submitting,
            onSend: controller.sendMessage,
            onFetchSuggestions: controller.fetchSuggestions,
          ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({required this.grading, required this.onRestart});
  final SprechenGrading grading;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: tokens.success, size: 56),
            const SizedBox(height: 12),
            Text(
              l10n.missionCompleteTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${grading.total} / ${grading.max}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: tokens.primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(l10n.sprechenResultBackToList),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 140,
                  child: GradientButton(
                    label: l10n.practiceRestart,
                    onPressed: onRestart,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
