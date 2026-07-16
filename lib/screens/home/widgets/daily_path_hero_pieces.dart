import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../features/daily_path/domain/daily_path.dart';
import '../../../features/daily_path/domain/skill_emoji.dart';
import '../../../l10n/app_localizations.dart';

/// Sub-widgets used only by [ResumeLearningCard] (`resume_section.dart`) —
/// split out to keep the main hero file under the project's LOC guidance.
/// Mirrors web `daily-path-hero-card.tsx`.

/// "Bắt đầu lộ trình học hôm nay" fallback — shown when the path hasn't
/// loaded yet (new user) or the fetch failed, instead of a bare error.
class DailyPathEmptyCard extends StatelessWidget {
  const DailyPathEmptyCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          Text(
            l10n.dailyPathHeroTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: DesignTokens.foreground,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: DesignTokens.orange50,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🎯', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyPathEmptyTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: DesignTokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.dailyPathEmptyDescription,
                      style: const TextStyle(
                        fontSize: 12,
                        color: DesignTokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
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
                        child: Text(
                          '${l10n.dailyPathEmptyCta} →',
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
            ],
          ),
        ],
      ),
    );
  }
}

/// "Còn N ngày đến thi ..." pill in the hero header — amber when close
/// (<=28 days), muted otherwise.
class DailyPathExamBadge extends StatelessWidget {
  const DailyPathExamBadge({
    super.key,
    required this.daysToExam,
    required this.examLabel,
  });

  final int daysToExam;
  final String examLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final close = daysToExam <= 28;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: close ? DesignTokens.amber100 : DesignTokens.muted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        l10n.dailyPathExamBadge(daysToExam, examLabel),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: close ? DesignTokens.amber700 : DesignTokens.mutedForeground,
        ),
      ),
    );
  }
}

/// 64px "XP hôm nay" progress ring at the left of the hero body.
class DailyPathXpRing extends StatelessWidget {
  const DailyPathXpRing({
    super.key,
    required this.xp,
    required this.goal,
    required this.progress,
  });

  final int xp;
  final int goal;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3.5,
            strokeCap: StrokeCap.round,
            backgroundColor: DesignTokens.muted,
            valueColor: const AlwaysStoppedAnimation(DesignTokens.orange500),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$xp',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: DesignTokens.foreground,
                ),
              ),
              Text(
                '/$goal XP',
                style: const TextStyle(
                  fontSize: 9,
                  color: DesignTokens.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Emerald celebration banner shown once every step is done for the day.
class DailyPathCompleteBanner extends StatelessWidget {
  const DailyPathCompleteBanner({
    super.key,
    required this.streak,
    required this.onMoreTap,
  });

  final int streak;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = streak > 0
        ? l10n.dailyPathCompleteCelebrationWithStreak(streak)
        : l10n.dailyPathCompleteCelebration;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignTokens.emerald50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignTokens.emerald700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onMoreTap,
            child: Text(
              '${l10n.learnMore} →',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: DesignTokens.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Checklist-style dot per step — done/premium-locked/current/upcoming.
class DailyPathMiniStepper extends StatelessWidget {
  const DailyPathMiniStepper({
    super.key,
    required this.steps,
    required this.currentKey,
  });

  final List<DailyPathStep> steps;
  final String? currentKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, index) => _dot(steps[index]),
      ),
    );
  }

  Widget _dot(DailyPathStep step) {
    final isCurrent = step.key == currentKey;
    if (step.done) {
      return _circle(
        color: DesignTokens.emerald100,
        child: const Icon(
          Icons.check,
          size: 16,
          color: DesignTokens.emerald600,
        ),
      );
    }
    if (step.premium) {
      return _circle(
        color: DesignTokens.amber100,
        child: const Text('🔒', style: TextStyle(fontSize: 13)),
      );
    }
    if (isCurrent) {
      return _circle(
        gradient: const LinearGradient(
          colors: [DesignTokens.orange500, DesignTokens.orange600],
        ),
        border: Border.all(color: DesignTokens.orange500, width: 2),
        child: Text(skillEmoji(step.skill), style: const TextStyle(fontSize: 13)),
      );
    }
    return _circle(
      color: DesignTokens.muted,
      child: Text(skillEmoji(step.skill), style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _circle({
    Color? color,
    Gradient? gradient,
    Border? border,
    required Widget child,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        border: border,
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }
}
