import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../leaderboard/leaderboard_screen.dart';

class WeeklyLeaderboardCompact extends ConsumerWidget {
  const WeeklyLeaderboardCompact({super.key, required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final leaderboard = ref.watch(leaderboardProvider(LeaderboardType.weekly));
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.weeklyLeaderboard,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.foreground,
                  ),
                ),
              ),
              TextButton(onPressed: onShowAll, child: Text(l10n.seeFull)),
            ],
          ),
          leaderboard.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingLg),
              child: CircularProgressIndicator(),
            ),
            error: (_, _) => _EmptyLeaderboard(
              onRetry: () =>
                  ref.invalidate(leaderboardProvider(LeaderboardType.weekly)),
            ),
            data: (entries) {
              final top = entries.take(3).toList();
              if (top.isEmpty) return const _EmptyLeaderboard();
              return Column(
                children: [
                  for (final entry in top) _CompactRankRow(entry: entry),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    l10n.learnMoreToRank,
                    style: const TextStyle(
                      fontSize: 11,
                      color: DesignTokens.mutedForeground,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CompactRankRow extends StatelessWidget {
  const _CompactRankRow({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final name = entry.displayName.trim().isEmpty
        ? AppLocalizations.of(context).user
        : entry.displayName.trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingXs),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${entry.rank}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: DesignTokens.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          CircleAvatar(
            radius: 16,
            backgroundColor: DesignTokens.orange100,
            foregroundImage: entry.avatarUrl == null
                ? null
                : NetworkImage(entry.avatarUrl!),
            child: entry.avatarUrl == null
                ? Text(
                    name.characters.first.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.tigerOrange,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: DesignTokens.foreground,
              ),
            ),
          ),
          Text(
            '${entry.xp} XP',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: DesignTokens.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLeaderboard extends StatelessWidget {
  const _EmptyLeaderboard({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
      child: Column(
        children: [
          Text(
            l10n.noWeeklyLeaderboard,
            style: const TextStyle(color: DesignTokens.mutedForeground),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
