import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../data/learn/exam_goal_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import 'exam_goal_setter_sheet.dart';

/// Compact single-row countdown strip for the user's exam goal
/// (`GET /user/learn/goals`). Mirrors web `ExamCornerCard` — the daily-path
/// hero right above it owns the ONE full-width primary CTA on the
/// dashboard, so this card must stay compact and never compete with it.
///
/// Shows a "Đặt mục tiêu thi" prompt when the user has no goal set yet (no
/// `target_date`) — mirrors web `ExamGoalSetterCard`'s collapsed state.
class ExamCornerCard extends ConsumerWidget {
  const ExamCornerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(learnGoalProvider);
    return goalAsync.maybeWhen(
      data: (goal) {
        final targetDate = goal.targetDate;
        if (targetDate == null) {
          return _GoalPrompt(onTap: () => ExamGoalSetterSheet.show(context));
        }

        final days = _daysUntil(targetDate);
        final l10n = AppLocalizations.of(context);
        final overdue = days < 0;
        final headline = overdue
            ? l10n.examCornerOverdue
            : days == 0
            ? l10n.examCornerToday(goal.targetLevel)
            : l10n.examCornerCountdown(
                examGoalProviderShort(goal.targetProvider),
                goal.targetLevel,
                days,
              );

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.screenHorizontalPadding,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: DesignTokens.card,
              borderRadius: BorderRadius.circular(DesignTokens.radius),
              boxShadow: DesignTokens.shadowSm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: DesignTokens.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/exam/readiness'),
                            child: Text(
                              l10n.examCornerReadiness,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: DesignTokens.mutedForeground,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => ExamGoalSetterSheet.show(
                              context,
                              existing: goal,
                            ),
                            child: Text(
                              l10n.examCornerChangeGoal,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: DesignTokens.mutedForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                GestureDetector(
                  onTap: () => context.push('/exam'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [DesignTokens.orange500, DesignTokens.orange600],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      overdue
                          ? l10n.examCornerSetNewGoal
                          : '${l10n.examCornerContinue} →',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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

  /// Whole-day difference between today (device local midnight) and
  /// [targetDate] — mirrors web `daysUntil`.
  static int _daysUntil(DateTime targetDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    return target.difference(today).inDays;
  }
}

/// Collapsed no-goal state — mirrors web `ExamGoalSetterCard`'s closed card:
/// a one-line prompt plus a gradient CTA that opens the goal-setter sheet.
class _GoalPrompt extends StatelessWidget {
  const _GoalPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.examGoalPromptTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.examGoalPromptSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: DesignTokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [DesignTokens.orange500, DesignTokens.orange600],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.examGoalPromptCta,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
