import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../features/daily_path/domain/daily_path.dart';
import '../../../features/daily_path/domain/skill_emoji.dart';
import '../../../features/daily_path/presentation/daily_path_provider.dart';
import '../../../l10n/app_localizations.dart';
import 'daily_path_hero_pieces.dart';

/// Server-driven answer to "what should I study next?" — the single
/// primary CTA on the dashboard. Mirrors web `DailyPathHeroCard`.
class DashboardContinueLearningSection extends ConsumerWidget {
  const DashboardContinueLearningSection({
    super.key,
    required this.dailyXp,
    required this.dailyGoal,
    required this.streak,
    required this.onStart,
  });

  final int dailyXp;
  final int dailyGoal;
  final int streak;
  final ValueChanged<DailyPathStep?> onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(dailyPathProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
      ),
      child: path.when(
        loading: () => const SizedBox(
          height: 144,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ResumeLearningCard(
          dailyXp: dailyXp,
          dailyGoal: dailyGoal,
          onTap: () => onStart(null),
        ),
        data: (data) => ResumeLearningCard(
          path: data,
          dailyXp: dailyXp,
          dailyGoal: dailyGoal,
          streak: streak,
          onTap: () => onStart(data.currentStep),
        ),
      ),
    );
  }
}

/// The hero card itself — header row (title + exam countdown), XP ring +
/// plan summary, primary CTA (or the "all done" banner), and a per-step
/// mini-stepper. Renders [DailyPathEmptyCard] when there's no path data yet.
class ResumeLearningCard extends StatelessWidget {
  const ResumeLearningCard({
    super.key,
    this.path,
    required this.dailyXp,
    required this.dailyGoal,
    this.streak = 0,
    required this.onTap,
  });

  final DailyPath? path;
  final int dailyXp;
  final int dailyGoal;
  final int streak;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasSteps = path != null && path!.steps.isNotEmpty;
    if (!hasSteps) {
      return DailyPathEmptyCard(onTap: onTap);
    }

    final steps = path!;
    final currentStep = steps.currentStep;
    final complete = steps.isComplete;
    final progress = dailyGoal > 0
        ? (dailyXp / dailyGoal).clamp(0.0, 1.0)
        : 0.0;
    final showMinutes = !complete && steps.estimatedMinutesRemaining > 0;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        boxShadow: DesignTokens.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.dailyPathHeroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.foreground,
                  ),
                ),
              ),
              if (steps.daysToExam != null && steps.examLabel != null) ...[
                const SizedBox(width: 8),
                DailyPathExamBadge(
                  daysToExam: steps.daysToExam!,
                  examLabel: steps.examLabel!,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailyPathXpRing(xp: dailyXp, goal: dailyGoal, progress: progress),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showMinutes
                          ? '${l10n.dailyPathPlanSummary(steps.doneCount, steps.totalCount)} · '
                                '${l10n.dailyPathMinutesRemaining(steps.estimatedMinutesRemaining)}'
                          : l10n.dailyPathPlanSummary(
                              steps.doneCount,
                              steps.totalCount,
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: DesignTokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (complete)
                      DailyPathCompleteBanner(streak: streak, onMoreTap: onTap)
                    else if (currentStep != null) ...[
                      Text(
                        '${l10n.dailyPathNextStep(currentStep.estimatedMinutes)}'
                        '${currentStep.description.isNotEmpty ? ' · ${currentStep.description}' : ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                DesignTokens.orange500,
                                DesignTokens.orange600,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${skillEmoji(currentStep.skill)} ${currentStep.title}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Text(
                                '→',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DailyPathMiniStepper(steps: steps.steps, currentKey: currentStep?.key),
        ],
      ),
    );
  }
}
