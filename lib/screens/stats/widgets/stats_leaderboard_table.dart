import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../../leaderboard/leaderboard_screen.dart';

/// `GET /gamification/user-rank` — `{rank, entry}` for the current user on
/// the all-time XP leaderboard. Used to pin a "Bạn" row below the visible
/// top-5 when the user isn't already in it. Mirror web `useCurrentUserRank`.
final statsCurrentUserRankProvider = FutureProvider<LeaderboardEntry?>((
  ref,
) async {
  final api = ref.watch(apiClientProvider);
  try {
    final json = await api.get<Map<String, dynamic>>('/gamification/user-rank');
    final rank = (json['rank'] as num?)?.toInt() ?? 0;
    final entry = json['entry'] as Map<String, dynamic>?;
    if (rank <= 0 || entry == null) return null;
    return LeaderboardEntry.fromJson(entry, rank);
  } on ApiException {
    return null;
  }
});

/// "Bảng xếp hạng" — all-time XP table (top 5) + own row if outside top 5.
/// Mirror web `stats-leaderboard-table.tsx`.
class StatsLeaderboardTable extends ConsumerWidget {
  const StatsLeaderboardTable({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(leaderboardProvider(LeaderboardType.allTime));
    final myRank = ref.watch(statsCurrentUserRankProvider);
    return async.maybeWhen(
      data: (entries) => entries.isEmpty
          ? const SizedBox.shrink()
          : _Table(
              entries: entries,
              currentUserId: currentUserId,
              myRank: myRank.valueOrNull,
            ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.entries, required this.currentUserId, this.myRank});

  final List<LeaderboardEntry> entries;
  final String currentUserId;
  final LeaderboardEntry? myRank;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final userInTop = entries.any((e) => e.id == currentUserId);
    final showOwnRow = !userInTop && myRank != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.statsLeaderboardTableTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: tokens.foreground,
              ),
            ),
            Text(
              l10n.statsLeaderboardTop(entries.length),
              style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tokens.border.withValues(alpha: 0.7)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < entries.length; i++)
                _TableRow(
                  entry: entries[i],
                  rank: i + 1,
                  isCurrentUser: entries[i].id == currentUserId,
                  l10n: l10n,
                ),
              if (showOwnRow) ...[
                Container(height: 1, color: tokens.border),
                _TableRow(
                  entry: myRank!,
                  rank: myRank!.rank,
                  isCurrentUser: true,
                  l10n: l10n,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.entry,
    required this.rank,
    required this.isCurrentUser,
    required this.l10n,
  });

  final LeaderboardEntry entry;
  final int rank;
  final bool isCurrentUser;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final medal = switch (rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => '$rank',
    };
    return Container(
      color: isCurrentUser ? tokens.primary.withValues(alpha: 0.08) : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              medal,
              style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.displayName.trim().isEmpty
                        ? l10n.user
                        : entry.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: tokens.foreground,
                    ),
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l10n.statsLeaderboardYou,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: tokens.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${entry.level}',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w500, color: tokens.foreground),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${entry.xp}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFD97706),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${entry.streak}d',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFFEA580C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
