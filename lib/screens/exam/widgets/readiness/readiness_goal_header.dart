import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/learn/exam_goal_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/providers.dart';
import '../../../home/widgets/exam_goal_setter_sheet.dart';

/// "Đang luyện cho" gradient card — mirrors web
/// `exam-readiness-goal-header.tsx`. Reuses [learnGoalProvider] +
/// [ExamGoalSetterSheet] built for the home dashboard's exam corner card so
/// the goal cache/invalidation stays a single source (same as web's
/// `useGoal`/`useUpsertGoal`).
class ReadinessGoalHeader extends ConsumerWidget {
  const ReadinessGoalHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final goalAsync = ref.watch(learnGoalProvider);

    return goalAsync.maybeWhen(
      data: (goal) {
        final provider = examGoalProviderShort(goal.targetProvider);
        final examLabel = '$provider ${goal.targetLevel}';
        final days = goal.targetDate == null
            ? null
            : _daysUntil(goal.targetDate!);

        return DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(tokens.radius),
            border: Border.all(color: tokens.primary.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.examReadinessGoalHeaderLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: tokens.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        examLabel,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: tokens.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () =>
                      ExamGoalSetterSheet.show(context, existing: goal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (days != null && days > 0) ...[
                        Text(
                          '$days',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: tokens.primary,
                          ),
                        ),
                        Text(
                          l10n.examReadinessGoalDaysLeft,
                          style: TextStyle(
                            fontSize: 11,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ] else if (days == 0) ...[
                        Text(
                          l10n.examReadinessGoalTodayLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: tokens.primary,
                          ),
                        ),
                      ] else ...[
                        Text(
                          l10n.examReadinessGoalSetDate,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: tokens.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  static int _daysUntil(DateTime target) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final t = DateTime(target.year, target.month, target.day);
    return t.difference(today).inDays;
  }
}
