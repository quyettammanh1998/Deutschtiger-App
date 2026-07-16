import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'stats_achievements_data.dart';

/// "Thành tựu sắp đạt" — up to 3 not-yet-earned achievements. Mirror web
/// `stats-near-achievements-card.tsx`.
class StatsNearAchievementsCard extends StatelessWidget {
  const StatsNearAchievementsCard({super.key, required this.achievements});

  final List<StatsAchievement> achievements;

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.statsNearAchievementsTitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: tokens.foreground,
          ),
        ),
        const SizedBox(height: 10),
        for (final a in achievements)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tokens.muted.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.border.withValues(alpha: 0.7)),
            ),
            child: Row(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: Text(a.icon, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                      Text(
                        a.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
