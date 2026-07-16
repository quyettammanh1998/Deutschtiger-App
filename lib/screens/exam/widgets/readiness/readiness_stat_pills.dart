import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';

/// Row of 3 tappable stat pills (attempts / recent avg / best score) —
/// mirrors web `StatPill` row in `exam-readiness-page.tsx`. All 3 link to
/// the exam hub (`/exam`) since there is no dedicated "past attempts" list
/// route yet — same fallback the web uses.
class ReadinessStatPills extends StatelessWidget {
  const ReadinessStatPills({super.key, required this.snapshot});

  final ExamReadinessSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _Pill(
            value: '${snapshot.attemptCount}',
            label: l10n.examReadinessAttempts,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Pill(
            value: '${snapshot.recentAvgScore.round()}%',
            label: 'Điểm TB gần đây',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Pill(
            value: '${snapshot.bestScore}%',
            label: l10n.examReadinessBestScore,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: () => context.push('/exam'),
      borderRadius: BorderRadius.circular(tokens.radius),
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(tokens.radius),
          border: Border.all(color: tokens.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.5, color: tokens.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
