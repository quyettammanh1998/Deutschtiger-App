import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_models.dart';
import '../../../../l10n/app_localizations.dart';

/// "⚖️ Giám khảo AI" bottom sheet — coverage checklist (live, from `/turn`
/// responses) + holistic verdict placeholder. Web parity:
/// `components/conversation/examiner/examiner-panel.tsx`.
///
/// The holistic verdict (`/ai/conversation-examiner`) and per-turn scored
/// feedback (`/ai/sprechen-feedback`) are outside this phase's documented
/// contract (MASTER P8) — the coverage checklist is real (comes from
/// `TurnResponse.coverage`), the verdict section shows a pending state.
Future<void> showConversationExaminerSheet(
  BuildContext context, {
  required List<CoveragePoint> coverage,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ExaminerSheet(coverage: coverage),
  );
}

class _ExaminerSheet extends StatelessWidget {
  const _ExaminerSheet({required this.coverage});

  final List<CoveragePoint> coverage;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      minChildSize: 0.35,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: tokens.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.conversationExaminerTitle,
                      style: TextStyle(fontWeight: FontWeight.w800, color: tokens.foreground),
                    ),
                  ),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (coverage.isNotEmpty) ...[
                    Text(l10n.conversationExaminerCoverageTitle, style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground)),
                    const SizedBox(height: 8),
                    ...coverage.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              c.covered ? PhosphorIcons.checkCircleFill : PhosphorIcons.circle,
                              size: 16,
                              color: c.covered ? const Color(0xFF16A34A) : tokens.mutedForeground,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(c.labelVi, style: TextStyle(fontSize: 13, color: tokens.foreground))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        Icon(PhosphorIcons.info, size: 16, color: tokens.mutedForeground),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(l10n.conversationExaminerVerdictPending, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
