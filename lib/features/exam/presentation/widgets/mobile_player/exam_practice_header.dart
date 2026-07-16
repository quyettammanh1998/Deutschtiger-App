// Compact header row — web `exam-practice-header.tsx`. Single row: back/exit
// chip, title, thin orange progress bar, timer+pace dot (test mode), reader
// guide ("?") + settings buttons, "Câu X/Y" counter, "Nộp bài" pill (test).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/icons/app_phosphor_icons.dart';
import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/exam_models.dart';
import 'exam_player_palette.dart';
import 'reader_prefs.dart';
import 'reader_settings_sheet.dart';

class ExamPracticeHeader extends ConsumerWidget {
  const ExamPracticeHeader({
    super.key,
    required this.mode,
    required this.title,
    required this.progressPercent,
    required this.currentDisplayNumber,
    required this.answerableCount,
    required this.onExit,
    this.onBackToResult,
    this.onSubmit,
    this.elapsedSeconds,
    this.totalDurationSeconds,
    this.currentSectionIndex,
    this.totalSections,
  });

  final ExamMode mode;
  final String title;
  final double progressPercent;
  final int currentDisplayNumber;
  final int answerableCount;
  final VoidCallback onExit;
  final VoidCallback? onBackToResult;
  final VoidCallback? onSubmit;
  final int? elapsedSeconds;
  final int? totalDurationSeconds;
  final int? currentSectionIndex;
  final int? totalSections;

  Color? _paceColor() {
    final total = totalDurationSeconds;
    final sections = totalSections;
    final sectionIdx = currentSectionIndex;
    final elapsed = elapsedSeconds;
    if (total == null ||
        sections == null ||
        sections <= 1 ||
        sectionIdx == null ||
        elapsed == null ||
        total <= 0) {
      return null;
    }
    final expected = (sectionIdx + 0.5) * (total / sections);
    if (expected <= 0) return examPaceOnTrack;
    final ratio = elapsed / expected;
    if (ratio <= 1.0) return examPaceOnTrack;
    if (ratio <= 1.3) return examPaceSlow;
    return examPaceBehind;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final isTest = mode == ExamMode.test;
    final isReview = mode == ExamMode.review;
    final pace = isTest ? _paceColor() : null;
    final wordLookupEnabled = ref.watch(wordLookupEnabledProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      child: Row(
        children: [
          if (mode != ExamMode.test)
            _ChipButton(
              icon: AppPhosphorIcons.caretLeft,
              label: isReview
                  ? (onBackToResult != null ? l10n.examBackToResult : l10n.exit)
                  : l10n.exit,
              onTap: isReview ? (onBackToResult ?? onExit) : onExit,
            )
          else
            _ChipButton(
              icon: AppPhosphorIcons.caretLeft,
              label: l10n.exit,
              onTap: onExit,
            ),
          const SizedBox(width: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 6,
                color: tokens.muted,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressPercent.clamp(0, 100) / 100,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: examProgressGradient,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isTest) ...[
            const SizedBox(width: 6),
            if (pace != null)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(color: pace, shape: BoxShape.circle),
              ),
          ],
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: l10n.examReaderGuideTooltip,
            icon: Icon(
              AppPhosphorIcons.question,
              size: 18,
              color: tokens.mutedForeground,
            ),
            onPressed: () => showReaderGuideDialog(
              context,
              wordLookupEnabled: wordLookupEnabled,
              onEnableWordLookup: () =>
                  ref.read(wordLookupEnabledProvider.notifier).state = true,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: l10n.examReaderSettingsTooltip,
            icon: Icon(
              AppPhosphorIcons.gearSix,
              size: 18,
              color: tokens.mutedForeground,
            ),
            onPressed: () => showReaderSettingsSheet(context, ref),
          ),
          Text(
            l10n.examQuestionProgress(currentDisplayNumber, answerableCount),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tokens.mutedForeground,
            ),
          ),
          if (isTest && onSubmit != null) ...[
            const SizedBox(width: 6),
            _SubmitPill(label: l10n.submitExam, onTap: onSubmit!),
          ],
        ],
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: tokens.border),
          borderRadius: BorderRadius.circular(8),
          color: tokens.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: tokens.mutedForeground),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: tokens.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitPill extends StatelessWidget {
  const _SubmitPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: examNavBlue(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
