import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_tokens.dart';
import '../../../../../../features/writing/domain/writing_submission.dart';
import '../../../../../../l10n/app_localizations.dart';

/// "Tiêu chí Viết của bạn" — averages the 4 grading criteria across every
/// graded submission so the learner sees which one consistently loses
/// points. Web parity `WritingCriteriaTrend`. Hidden until ≥2 graded
/// submissions exist (honest min-sample), matching web.
class WritingCriteriaTrend extends StatelessWidget {
  const WritingCriteriaTrend({super.key, required this.submissions});

  final List<WritingSubmission> submissions;

  static const _kMax = 25;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final graded = submissions.where((s) => s.aiFeedback != null).toList();
    if (graded.length < 2) return const SizedBox.shrink();

    final criteria = [
      (l10n.writingCriterionTaskCompletion, graded.map((s) => s.aiFeedback!.taskCompletion.score)),
      (l10n.writingCriterionGrammar, graded.map((s) => s.aiFeedback!.grammar.score)),
      (l10n.writingCriterionVocabulary, graded.map((s) => s.aiFeedback!.vocabulary.score)),
      (l10n.writingCriterionCoherence, graded.map((s) => s.aiFeedback!.coherence.score)),
    ];

    final rows = criteria
        .map((c) {
          final scores = c.$2.toList();
          final avg = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
          return (label: c.$1, avg: avg);
        })
        .toList()
      ..sort((a, b) => a.avg.compareTo(b.avg));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.writingCriteriaTrendTitle,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
              ),
              Text(
                l10n.writingCriteriaTrendSubtitle(graded.length),
                style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rows[i].label + (i == 0 ? ' · ${l10n.writingCriteriaWeakest}' : ''),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: i == 0 ? const Color(0xFFDC2626) : tokens.foreground,
                        ),
                      ),
                      Text(
                        '${rows[i].avg.toStringAsFixed(1)}/$_kMax',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.mutedForeground),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (rows[i].avg / _kMax).clamp(0, 1),
                      minHeight: 5,
                      backgroundColor: tokens.muted,
                      valueColor: AlwaysStoppedAnimation(
                        i == 0 ? const Color(0xFFEF4444) : tokens.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
