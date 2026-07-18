import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';
import 'clip_tab_bar.dart';
import 'dictation_diff.dart';
import 'full_dictation_diff_text.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Active-sentence body for [FullPracticeView]: clip tabs, progress row,
/// replay control, input, diff result, and the check/next CTA. Pure
/// presentational widget — state machine lives in the parent.
class FullPracticeSentenceCard extends StatelessWidget {
  const FullPracticeSentenceCard({
    super.key,
    required this.labels,
    required this.clipIdx,
    required this.onSelectClip,
    required this.sentence,
    required this.sentenceIdx,
    required this.sentenceCount,
    required this.correctCount,
    required this.controller,
    required this.diff,
    required this.onReplay,
    required this.onSubmit,
    required this.onNext,
  });

  final List<String> labels;
  final int clipIdx;
  final ValueChanged<int> onSelectClip;
  final ExamDictationSentence sentence;
  final int sentenceIdx;
  final int sentenceCount;
  final int correctCount;
  final TextEditingController controller;
  final List<WordDiff>? diff;
  final VoidCallback onReplay;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        ClipTabBar(
          labels: labels,
          activeIndex: clipIdx,
          onSelect: onSelectClip,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.dictationSentenceProgress(sentenceIdx + 1, sentenceCount),
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
              Text(
                l10n.dictationCorrectCount(correctCount),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: tokens.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: diff == null ? onReplay : null,
                      icon: const Icon(PhosphorIcons.arrowCounterClockwise),
                    ),
                    Text(
                      l10n.dictationReplayThisSentence,
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
                if (sentence.textVi.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '💡 ${sentence.textVi}',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ),
                TextField(
                  controller: controller,
                  enabled: diff == null,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.dictationTypeSentenceHint,
                    filled: true,
                    fillColor: tokens.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (diff != null) ...[
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: tokens.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: FullDictationDiffText(diff: diff!),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: tokens.primary,
                  ),
                  onPressed: diff == null
                      ? (controller.text.trim().isEmpty ? null : onSubmit)
                      : onNext,
                  child: Text(
                    diff == null
                        ? l10n.dictationCheckCta
                        : (sentenceIdx + 1 < sentenceCount
                              ? l10n.dictationNextSentence
                              : l10n.dictationShowResult),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
