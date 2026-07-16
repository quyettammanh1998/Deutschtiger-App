import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'practice_editor_buttons.dart';
import 'practice_editor_card.dart';

/// Pre-submit action row: "Nộp bài viết" (+ "Chấm lại với AI" once a grade
/// already exists) + the "min 10 words" hint.
class PracticeSubmitActionRow extends StatelessWidget {
  const PracticeSubmitActionRow({super.key, required this.wordCount, required this.l10n, required this.widget});
  final int wordCount;
  final AppLocalizations l10n;
  final PracticeEditorCard widget;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final canSubmit = wordCount >= 10 && !widget.isSubmitting;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: Material(
              color: canSubmit ? tokens.primary : tokens.muted,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: canSubmit ? widget.onSubmit : null,
                child: Center(
                  child: Text(
                    widget.isSubmitting ? l10n.writingSubmitting : l10n.writingSubmitCta,
                    style: TextStyle(
                      color: canSubmit ? tokens.primaryForeground : tokens.mutedForeground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.gradingResult != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: (!widget.isGrading && wordCount >= 10) ? widget.onGrade : null,
                icon: widget.isGrading
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(AppPhosphorIcons.sparkle, size: 16),
                label: Text(widget.isGrading ? l10n.writingGrading : l10n.writingRegrade),
              ),
            ),
          ),
        ],
        if (wordCount > 0 && wordCount < 10)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              l10n.writingMinWordsHint,
              style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
            ),
          ),
      ],
    );
  }
}

/// Post-submit action row: "Sửa bài viết" / "Sửa với AI" / save slot.
class PracticeSubmittedActionRow extends StatelessWidget {
  const PracticeSubmittedActionRow({super.key, required this.l10n, required this.widget});
  final AppLocalizations l10n;
  final PracticeEditorCard widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: widget.onEdit, child: Text(l10n.writingEditEssay))),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: widget.isGrading ? null : widget.onGrade,
              icon: widget.isGrading
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(AppPhosphorIcons.sparkle, size: 16),
              label: Text(widget.isGrading ? l10n.writingGrading : l10n.writingGradeWithAi),
            ),
          ),
          if (widget.saveSlot != null) ...[const SizedBox(width: 8), widget.saveSlot!],
        ],
      ),
    );
  }
}

/// The AI grading error card (with retry-with-cooldown when the AI service
/// is temporarily unavailable) shown between the editor and the grade card.
class GradingErrorCard extends StatelessWidget {
  const GradingErrorCard({super.key, required this.widget, required this.l10n});
  final PracticeEditorCard widget;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.destructive.withValues(alpha: 0.08),
        border: Border.all(color: tokens.destructive.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.gradingError!, style: TextStyle(color: tokens.destructive, fontSize: 13)),
          if (widget.isAiUnavailable) ...[
            const SizedBox(height: 10),
            GradientMiniButton(
              label: widget.retryCooldown > 0 ? l10n.writingRetryIn(widget.retryCooldown) : l10n.writingRetry,
              onTap: widget.retryCooldown > 0 || widget.isGrading ? () {} : widget.onGrade,
              tokens: tokens,
            ),
          ],
        ],
      ),
    );
  }
}
