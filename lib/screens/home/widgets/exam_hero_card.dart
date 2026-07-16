import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/learn/exam_goal_providers.dart';
import '../../../data/learn/learn_goal.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/exam/exam_ecosystem_providers.dart';
import 'exam_goal_setter_sheet.dart';
import 'exam_hero_status_pieces.dart';

/// Exam-first dashboard hero — shown INSTEAD of the compact
/// [ExamCornerCard] strip when the user has an exam goal set (real
/// behavior: exam pages dominate usage for these users). Mirrors web
/// `ExamHeroCard`: countdown badge, readiness ring
/// (`GET /exam-readiness`, live), one full-width CTA.
class ExamHeroCard extends ConsumerWidget {
  const ExamHeroCard({super.key, required this.goal});

  final LearnGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final targetDate = goal.targetDate;
    if (targetDate == null) {
      return const SizedBox.shrink();
    }

    final days = _daysUntil(targetDate);
    final overdue = days < 0;
    final providerName = examGoalProviderShort(goal.targetProvider);
    final readinessAsync = ref.watch(examReadinessProvider);
    final readiness = readinessAsync.valueOrNull;
    final hasAttempts = (readiness?.attemptCount ?? 0) > 0;
    final percent = hasAttempts
        ? ((readiness!.readinessLow + readiness.readinessHigh) / 2).round()
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  overdue
                      ? l10n.examCornerOverdue
                      : l10n.examHeroTitle(providerName, goal.targetLevel),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
              ),
              if (!overdue) ExamHeroCountdownBadge(days: days, tokens: tokens),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.push('/exam/readiness'),
                child: ExamHeroReadinessRing(percent: percent, tokens: tokens),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      percent == null
                          ? l10n.examHeroNoAttemptsYet
                          : l10n.examHeroBasedOnAttempts(
                              readiness!.attemptCount,
                            ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ExamHeroCtaButton(
                      label: overdue
                          ? l10n.examCornerSetNewGoal
                          : l10n.examHeroCta(providerName, goal.targetLevel),
                      tokens: tokens,
                      onTap: () => overdue
                          ? ExamGoalSetterSheet.show(context, existing: goal)
                          : context.push('/exam'),
                    ),
                    const SizedBox(height: 8),
                    ExamHeroLinkRow(
                      tokens: tokens,
                      onReadinessTap: () => context.push('/exam/readiness'),
                      onChangeGoalTap: () =>
                          ExamGoalSetterSheet.show(context, existing: goal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
