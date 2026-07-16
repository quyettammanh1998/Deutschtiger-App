import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/home/dashboard_data.dart';
import '../../../l10n/app_localizations.dart';
import 'stats_xp_math.dart';

/// 2 progress cards: level-up XP bar + today's XP goal bar. Mirror web
/// `stats-progress-cards.tsx`.
class StatsProgressCards extends StatelessWidget {
  const StatsProgressCards({super.key, required this.data});

  final Gamification data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final xpForNext = statsXpForLevel(data.level);
    final xpInLevel = statsXpInCurrentLevel(data.level, data.totalXp);
    final levelProgress = xpForNext > 0
        ? (xpInLevel / xpForNext * 100).clamp(0, 100).toDouble()
        : 0.0;
    final dailyProgressRaw = data.dailyGoal > 0
        ? (data.dailyXpToday / data.dailyGoal * 100)
        : 0.0;
    final dailyProgress = dailyProgressRaw.clamp(0, 100).toDouble();
    final dailyRemaining = (data.dailyGoal - data.dailyXpToday).clamp(
      0,
      1 << 30,
    );

    return Column(
      children: [
        _ProgressCard(
          accent: tokens.primary,
          title: l10n.statsProgressLevelTitle,
          subtitle: l10n.statsProgressLevelSubtitle(data.level, data.level + 1),
          badge: '$xpInLevel/$xpForNext XP',
          progress: levelProgress,
          gradient: [tokens.primary, const Color(0xFFEC4899)],
          footer: l10n.statsProgressLevelRemaining(
            (xpForNext - xpInLevel).clamp(0, 1 << 30),
          ),
        ),
        const SizedBox(height: 12),
        _ProgressCard(
          accent: const Color(0xFFF59E0B),
          title: l10n.statsProgressDailyTitle,
          subtitle: l10n.statsProgressDailySubtitle,
          badge: '${data.dailyXpToday}/${data.dailyGoal} XP',
          progress: dailyProgress,
          gradient: dailyProgress >= 100
              ? const [Color(0xFF4ADE80), Color(0xFF10B981)]
              : const [Color(0xFFFBBF24), Color(0xFFF97316)],
          footer: dailyProgress >= 100
              ? l10n.statsProgressDailyDone
              : l10n.statsProgressDailyRemaining(dailyRemaining),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.progress,
    required this.gradient,
    required this.footer,
  });

  final Color accent;
  final String title;
  final String subtitle;
  final String badge;
  final double progress;
  final List<Color> gradient;
  final String footer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: accent, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: tokens.foreground,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tokens.muted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: tokens.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(color: tokens.muted),
                  FractionallySizedBox(
                    widthFactor: progress / 100,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradient),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            footer,
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
        ],
      ),
    );
  }
}
