import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../leaderboard_screen.dart' show LeaderboardEntry;

/// Rank medal pill (gold/silver/bronze cho top 3, số thường cho các hạng sau).
class LeaderboardRankBadge extends StatelessWidget {
  const LeaderboardRankBadge({super.key, required this.rank});
  final int rank;

  static const _gold = Color(0xFFFFD700);
  static const _silver = Color(0xFFB0B0B0);
  static const _bronze = Color(0xFFCD7F32);

  @override
  Widget build(BuildContext context) {
    if (rank <= 3) {
      final medal = switch (rank) {
        1 => _gold,
        2 => _silver,
        _ => _bronze,
      };
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: medal, shape: BoxShape.circle),
        child: Center(
          child: Text(
            '$rank',
            style: const TextStyle(
              color: DesignTokens.card,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    return const Text(
      '#',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: DesignTokens.mutedForeground,
      ),
    );
  }
}

/// 1 row trong leaderboard — avatar + name + XP + rank badge.
class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({super.key, required this.entry});
  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final displayName = entry.displayName.trim().isEmpty
        ? l10n.user
        : entry.displayName.trim();
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.spacingSm + 4),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? DesignTokens.orange500.withValues(alpha: 0.08)
            : DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
        border: Border.all(
          color: entry.isCurrentUser
              ? DesignTokens.tigerOrange.withValues(alpha: 0.4)
              : DesignTokens.border,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 40, child: LeaderboardRankBadge(rank: entry.rank)),
          const SizedBox(width: DesignTokens.spacingSm + 4),
          CircleAvatar(
            radius: 20,
            backgroundColor: DesignTokens.muted,
            child: Text(
              displayName.characters.first.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: entry.isCurrentUser
                              ? DesignTokens.tigerOrange
                              : DesignTokens.foreground,
                        ),
                      ),
                    ),
                    if (entry.isCurrentUser) ...[
                      const SizedBox(width: 4),
                      const Text('👤', style: TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
                Text(
                  l10n.streakDays(entry.streak),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignTokens.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.xp}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(
                  fontSize: 12,
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
