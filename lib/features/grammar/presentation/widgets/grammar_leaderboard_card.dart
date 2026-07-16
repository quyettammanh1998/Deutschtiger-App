import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/grammar/grammar_models.dart';
import '../grammar_provider.dart';

/// Web parity `grammar-leaderboard.tsx`: progress-ring card + top-10 list,
/// "Hạng của bạn" row khi user ngoài top N. `level == null` = bảng xếp hạng
/// tổng (toàn bộ level).
class GrammarLeaderboardCard extends ConsumerWidget {
  const GrammarLeaderboardCard({
    super.key,
    this.level,
    required this.totalLessons,
    required this.completedCount,
  });

  final String? level;
  final int totalLessons;
  final int completedCount;

  Color _ringColor(AppTokens tokens) {
    if (totalLessons == 0) return tokens.mutedForeground;
    final p = completedCount / totalLessons;
    if (p >= 1) return tokens.success;
    if (p < 0.5) return tokens.warning;
    return tokens.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final leaderboardAsync = ref.watch(grammarLeaderboardProvider(level));
    final userRankAsync = ref.watch(grammarUserRankProvider(level));
    final progress = totalLessons > 0
        ? (completedCount / totalLessons).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress ring card.
        DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 5,
                        color: tokens.border,
                      ),
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 5,
                        color: _ringColor(tokens),
                        backgroundColor: Colors.transparent,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$completedCount',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color:
                                  completedCount >= totalLessons &&
                                      totalLessons > 0
                                  ? tokens.success
                                  : tokens.foreground,
                            ),
                          ),
                          Text(
                            '/$totalLessons',
                            style: TextStyle(
                              fontSize: 9,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        level != null
                            ? l10n.grammarProgressLabelLevel(level!)
                            : l10n.grammarProgressLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: tokens.foreground,
                        ),
                      ),
                      Text(
                        l10n.grammarCompletedOfTotal(
                          completedCount,
                          totalLessons,
                        ),
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
        ),
        const SizedBox(height: 10),
        // Leaderboard list card.
        DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      level != null
                          ? l10n.grammarLeaderboardTitleLevel(level!)
                          : l10n.grammarLeaderboardTitleAll,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: tokens.foreground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                leaderboardAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (entries) => entries.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              l10n.grammarLeaderboardEmpty,
                              style: TextStyle(
                                fontSize: 12,
                                color: tokens.mutedForeground,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            for (final entry in entries)
                              _LeaderboardRow(entry: entry),
                          ],
                        ),
                ),
                userRankAsync.when(
                  data: (rank) {
                    final entries = leaderboardAsync.valueOrNull ?? const [];
                    if (rank == null ||
                        entries.any((e) => e.userId == rank.userId)) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: tokens.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: tokens.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Text(
                            l10n.grammarYourRank(
                              rank.rank,
                              rank.completedCount,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: tokens.foreground,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});
  final GrammarLeaderboardEntry entry;

  String get _rankEmoji => switch (entry.rank) {
    1 => '🥇',
    2 => '🥈',
    3 => '🥉',
    _ => '${entry.rank}',
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final initial = entry.displayName.isNotEmpty
        ? entry.displayName[0].toUpperCase()
        : '?';
    // Note: web links each row to the public profile route
    // (`ROUTE_PATHS.profile(userId)`). Flutter has no `/u/:id`-equivalent
    // route yet (owned by the social/profile phase) — row stays
    // non-interactive until that route exists.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              _rankEmoji,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: entry.rank <= 3 ? null : tokens.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 14,
            backgroundColor: tokens.primary.withValues(alpha: 0.1),
            backgroundImage: entry.avatarUrl.isNotEmpty
                ? NetworkImage(entry.avatarUrl)
                : null,
            child: entry.avatarUrl.isEmpty
                ? Text(
                    initial,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tokens.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              entry.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: tokens.foreground),
            ),
          ),
          Text(
            '${entry.completedCount}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: tokens.primary,
            ),
          ),
        ],
      ),
    );
  }
}
