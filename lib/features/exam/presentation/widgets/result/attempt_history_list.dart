// Attempt history — web `history/attempt-history-list.tsx`, backed by the
// existing `/user/exam-attempts?exam_id=&limit=` endpoint (already used by
// `ExamAttemptStore.loadResult` with limit=1 — this widget just requests
// more rows via the new additive `loadHistory` method, same endpoint).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../data/exam_attempt_store.dart';
import '../../exam_player_provider.dart';

class AttemptHistoryList extends ConsumerWidget {
  const AttemptHistoryList({super.key, required this.examId});

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final historyAsync = ref.watch(examAttemptHistoryProvider(examId));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.examAttemptHistoryTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 8),
          historyAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, _) => Text(
              l10n.examAttemptHistoryEmpty,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
            data: (attempts) => attempts.isEmpty
                ? Text(
                    l10n.examAttemptHistoryEmpty,
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.mutedForeground,
                    ),
                  )
                : Column(
                    children: [
                      for (final a in attempts)
                        _AttemptRow(attempt: a, l10n: l10n),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.attempt, required this.l10n});

  final ExamAttemptSummary attempt;
  final AppLocalizations l10n;

  Color _scoreColor(BuildContext context) {
    final tokens = context.tokens;
    if (attempt.score >= 80) return const Color(0xFF16A34A);
    if (attempt.score >= 60) return const Color(0xFFD97706);
    return tokens.destructive;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = _scoreColor(context);
    final mins = attempt.timeTaken ~/ 60;
    final secs = attempt.timeTaken % 60;
    final date = attempt.submittedAt;
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${attempt.score}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.examAnsweredQuestions(
                        attempt.correctAnswers,
                        attempt.totalQuestions,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        attempt.mode.name == 'test'
                            ? l10n.examTestMode
                            : l10n.examAttemptModePractice,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: tokens.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$dateLabel · ${mins}m${secs.toString().padLeft(2, '0')}s',
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
