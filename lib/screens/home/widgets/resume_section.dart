import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_tokens.dart';
import '../../../../features/daily_path/domain/daily_path.dart';
import '../../../../features/daily_path/presentation/daily_path_provider.dart';
import '../../../../l10n/app_localizations.dart';

/// Server-driven answer to "what should I study next?".
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
          height: 132,
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
    final current = path?.currentStep;
    final complete = path?.isComplete ?? false;
    final progress = dailyGoal > 0
        ? (dailyXp / dailyGoal).clamp(0.0, 1.0)
        : 0.0;
    final title = complete
        ? l10n.dailyPathComplete
        : current?.title ?? l10n.dailyPathStart;
    final details = complete
        ? streak > 0
              ? l10n.keepStreak(streak)
              : l10n.learnMoreToReinforce
        : path == null
        ? l10n.dailyProgressHabit
        : l10n.dailyPathProgress(
            path!.doneCount,
            path!.totalCount,
            path!.estimatedMinutesRemaining,
          );

    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor: DesignTokens.muted,
                  color: DesignTokens.tigerOrange,
                ),
                Text(
                  '$dailyXp\nXP',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.foreground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 13,
                    color: DesignTokens.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          IconButton.filled(
            onPressed: onTap,
            tooltip: complete ? l10n.learnMore : l10n.start,
            icon: Icon(complete ? Icons.add_rounded : Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
