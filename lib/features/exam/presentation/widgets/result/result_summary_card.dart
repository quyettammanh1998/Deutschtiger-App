// Result summary card — web `listing/result-summary.tsx` (score block +
// motivation banner + 3 stat tiles + review/retry actions). Simplified vs
// web: no multi-tier rating label / AI-writing-score block / confetti (no
// `rating`/`schreibenAiScore` field in Flutter's `ExamAttempt` — GĐ1 scope is
// Lesen/Hören only, no Schreiben grading) — pass/fail banner only.
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/exam_models.dart';
import '../mobile_player/exam_player_palette.dart';

class ResultSummaryCard extends StatelessWidget {
  const ResultSummaryCard({
    super.key,
    required this.exam,
    required this.attempt,
    required this.onRetry,
    required this.onReview,
  });

  final Exam exam;
  final ExamAttempt attempt;
  final VoidCallback onRetry;
  final VoidCallback onReview;

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
    final passed = attempt.passed;
    final mins = attempt.elapsedSeconds ~/ 60;
    final secs = attempt.elapsedSeconds % 60;

    final scoreColor = scorePercent >= 70
        ? examNavGreen(context)
        : scorePercent >= 50
        ? examAmberFg(context)
        : examNavRed(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ScoreBlock(
                    scorePercent: scorePercent,
                    scoreColor: scoreColor,
                    label: l10n.examResultScoreLabel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MotivationBlock(passed: passed, l10n: l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  count: attempt.correctAnswers,
                  label: l10n.examCorrect,
                  color: examNavGreen(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  count: wrong,
                  label: l10n.examNavLegendWrong,
                  color: examNavRed(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  count: unanswered,
                  label: l10n.examResultStatSkipped,
                  color: tokens.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '${l10n.examTime}: ${mins > 0 ? '$mins ph ' : ''}$secs s',
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReview,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: tokens.primary,
                    side: BorderSide(color: tokens.primary, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(l10n.reviewExam),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.primary,
                    foregroundColor: tokens.primaryForeground,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(l10n.retryExam),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreBlock extends StatelessWidget {
  const _ScoreBlock({
    required this.scorePercent,
    required this.scoreColor,
    required this.label,
  });
  final int scorePercent;
  final Color scoreColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: tokens.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$scorePercent%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: scoreColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _MotivationBlock extends StatelessWidget {
  const _MotivationBlock({required this.passed, required this.l10n});
  final bool passed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tone = passed ? examNavGreen(context) : examAmberFg(context);
    final bg = passed
        ? examNavGreen(context).withValues(alpha: 0.12)
        : examAmberSoft(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(passed ? '🏆' : '📖', style: const TextStyle(fontSize: 24)),
          Text(
            passed
                ? l10n.examResultMotivationPassedTitle
                : l10n.examResultMotivationFailTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: tone,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            passed
                ? l10n.examResultMotivationPassedBody
                : l10n.examResultMotivationFailBody,
            style: TextStyle(fontSize: 11, color: tone),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.count,
    required this.label,
    required this.color,
  });
  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
