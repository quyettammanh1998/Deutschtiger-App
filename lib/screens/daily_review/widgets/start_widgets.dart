import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Big "X ngày liên tiếp!" card with a flame icon — shown on the daily review
/// start screen.
class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.streakDays});
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        boxShadow: DesignTokens.shadowCard,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: DesignTokens.tigerOrange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: DesignTokens.tigerOrange,
              size: 32,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reviewStreak(streakDays),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.keepReviewStreak,
                  style: TextStyle(color: DesignTokens.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Hôm nay" stats card: due / reviewed / XP.
class TodayStatsCard extends StatelessWidget {
  const TodayStatsCard({
    super.key,
    required this.dueCount,
    required this.reviewedToday,
    required this.xpToday,
  });
  final int dueCount;
  final int reviewedToday;
  final int xpToday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        boxShadow: DesignTokens.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.today,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(icon: Icons.style, value: '$dueCount', label: l10n.due),
              _StatItem(
                icon: Icons.check,
                value: '$reviewedToday',
                label: l10n.reviewed,
              ),
              _StatItem(icon: Icons.star, value: '+$xpToday', label: 'XP'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: DesignTokens.tigerOrange, size: 28),
        const SizedBox(height: DesignTokens.spacingSm),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          label,
          style: TextStyle(color: DesignTokens.mutedForeground, fontSize: 12),
        ),
      ],
    );
  }
}

/// Primary CTA on the start screen — "Bắt đầu ôn tập".
class StartReviewButton extends StatelessWidget {
  const StartReviewButton({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FilledButton(
      onPressed: onStart,
      style: FilledButton.styleFrom(
        backgroundColor: DesignTokens.tigerOrange,
        foregroundColor: DesignTokens.card,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_arrow),
          const SizedBox(width: DesignTokens.spacingSm),
          Text(
            l10n.startDailyReview,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
