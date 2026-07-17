import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/api_client.dart';
import '../../../../view_models/providers.dart';
import '../../leaderboard/leaderboard_screen.dart';

/// `GET /user/leaderboard/weekly-rank` — the requesting user's own weekly
/// rank row, used to append a "···" divider row when the user sits outside
/// the visible top-3 (mirrors web `useUserWeeklyRank`). Returns null when
/// the user has no weekly score yet (backend `omitempty`/absent row).
final myWeeklyRankProvider = FutureProvider<LeaderboardEntry?>((ref) async {
  final api = ref.watch(apiClientProvider);
  try {
    // Backend responds with a JSON `null` body (not 404) when the user has
    // no weekly score yet — the API client treats an empty body as an
    // error, so that case is folded into `null` here rather than surfaced.
    final json = await api.get<Map<String, dynamic>>(
      '/user/leaderboard/weekly-rank',
    );
    final rank = json['rank'] as int? ?? 0;
    if (rank <= 0) return null;
    return LeaderboardEntry.fromJson(json, rank);
  } on ApiException {
    return null;
  }
});

/// "🏆 Tuần này" — top-3 weekly leaderboard + the user's own rank row when
/// outside the top 3. Mirrors web `weekly-leaderboard-compact.tsx`.
class WeeklyLeaderboardCompact extends ConsumerWidget {
  const WeeklyLeaderboardCompact({super.key, required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final leaderboard = ref.watch(leaderboardProvider(LeaderboardType.weekly));
    final currentUserId = ref.watch(authServiceProvider).currentUser?.id;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: tokens.card,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
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
              l10n: l10n,
              onRetry: () =>
                  ref.invalidate(leaderboardProvider(LeaderboardType.weekly)),
            ),
            data: (entries) {
              final top = entries.take(3).toList();
              if (top.isEmpty) return _EmptyLeaderboard(l10n: l10n);

              final userInTop3 =
                  currentUserId != null &&
                  top.any((e) => e.id == currentUserId);
              final myRankAsync = userInTop3
                  ? null
                  : ref.watch(myWeeklyRankProvider);

              return Column(
                children: [
                  const SizedBox(height: DesignTokens.spacingXs),
                  for (final entry in top)
                    _CompactRankRow(
                      entry: entry,
                      isCurrentUser:
                          currentUserId != null && entry.id == currentUserId,
                    ),
                  if (!userInTop3)
                    myRankAsync?.whenOrNull(
                          data: (myRank) => myRank == null
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    _RankDivider(),
                                    _CompactRankRow(
                                      entry: myRank,
                                      isCurrentUser: true,
                                    ),
                                  ],
                                ),
                        ) ??
                        const SizedBox.shrink(),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    userInTop3
                        ? l10n.weeklyLeaderboardInTop3
                        : l10n.learnMoreToRank,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: tokens.mutedForeground,
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

class _RankDivider extends StatelessWidget {
  const _RankDivider();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: DesignTokens.spacingXs,
        horizontal: DesignTokens.spacingSm,
      ),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: tokens.border)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingXs,
            ),
            child: Text(
              '···',
              style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
            ),
          ),
          Expanded(child: Container(height: 1, color: tokens.border)),
        ],
      ),
    );
  }
}

/// Rank medal — 🥇🥈🥉 for the top 3, plain "#N" otherwise (own-rank row).
String _rankMedal(int rank) => switch (rank) {
  1 => '🥇',
  2 => '🥈',
  3 => '🥉',
  _ => '$rank',
};

class _CompactRankRow extends StatelessWidget {
  const _CompactRankRow({required this.entry, required this.isCurrentUser});

  final LeaderboardEntry entry;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final name = entry.displayName.trim().isEmpty
        ? AppLocalizations.of(context).user
        : entry.displayName.trim();
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXs + 2,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser ? tokens.primary.withValues(alpha: 0.05) : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        border: isCurrentUser
            ? Border.all(color: tokens.primary.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              _rankMedal(entry.rank),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: tokens.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          CircleAvatar(
            radius: 16,
            backgroundColor: tokens.primary.withValues(alpha: 0.1),
            foregroundImage: entry.avatarUrl == null
                ? null
                : NetworkImage(entry.avatarUrl!),
            child: entry.avatarUrl == null
                ? Text(
                    name.characters.first.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tokens.primary,
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
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: tokens.foreground,
              ),
            ),
          ),
          Text(
            '${entry.xp}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: tokens.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLeaderboard extends StatelessWidget {
  const _EmptyLeaderboard({required this.l10n, this.onRetry});

  final AppLocalizations l10n;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
      child: Column(
        children: [
          Text(
            l10n.noWeeklyLeaderboard,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: tokens.foreground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            l10n.noWeeklyLeaderboardSubtitle,
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
