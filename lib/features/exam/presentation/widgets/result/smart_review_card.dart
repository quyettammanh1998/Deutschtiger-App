// Smart review card — web `smart-exam-review-card.tsx`. Simplified vs web:
// no `buildExamReviewInsights` (missed-vocab / per-section wrong breakdown
// engine) since Flutter's `Exam`/`ExamAttempt` models don't carry per-word
// vocab metadata — shows wrong/skipped/score metrics + jump-to-review +
// practice-by-section actions only. "Ôn lỗi cá nhân" CTA omitted: no
// `source=wrong_answer` query-param support confirmed on the daily-review
// route (would need a route contract check outside this wave's scope).
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/exam_models.dart';
import '../mobile_player/exam_player_palette.dart';

class SmartReviewCard extends StatelessWidget {
  const SmartReviewCard({
    super.key,
    required this.exam,
    required this.attempt,
    required this.onJumpToWrong,
    required this.onPractice,
  });

  final Exam exam;
  final ExamAttempt attempt;
  final VoidCallback onJumpToWrong;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final total = exam.totalQuestions;
    final unanswered = (total - attempt.answers.length).clamp(0, total);
    final wrong = (total - attempt.correctAnswers - unanswered).clamp(0, total);
    final scorePercent = attempt.maxScore == 0
        ? 0
        : (attempt.score / attempt.maxScore * 100).round();
    final needsPractice = scorePercent < 60 || wrong > 0 || unanswered > 0;
    if (!needsPractice) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.examSmartReviewTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: examNavBlue(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.examSmartReviewPointsNeeded(wrong),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: examNavBlue(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.examSmartReviewSubtitle,
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (wrong > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onJumpToWrong,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: tokens.foreground,
                      side: BorderSide(color: tokens.border),
                    ),
                    child: Text(
                      l10n.examSmartReviewJumpToWrong,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (wrong > 0) const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onPractice,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: tokens.foreground,
                    side: BorderSide(color: tokens.border),
                  ),
                  child: Text(
                    l10n.examSmartReviewPracticeSections,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
