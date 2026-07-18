import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/news/news_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repositories/news/news_repository.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Bảng xếp hạng tuần (số bài tin tức hoàn thành) — mirror `news-leaderboard.tsx`.
class NewsLeaderboardCard extends ConsumerWidget {
  const NewsLeaderboardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(_newsLeaderboardProvider);
    final userRankAsync = ref.watch(_newsUserRankProvider);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(PhosphorIcons.trophy, size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Text(
                l10n.newsLeaderboardTitleWeekly,
                style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            l10n.newsLeaderboardSubtitleWeekly,
            style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          entriesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (entries) => entries.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                    child: Center(
                      child: Text(
                        l10n.newsLeaderboardEmpty,
                        style: TextStyle(color: tokens.mutedForeground, fontSize: 13),
                      ),
                    ),
                  )
                : Column(children: [for (final e in entries) _NewsLeaderboardRow(entry: e)]),
          ),
          userRankAsync.when(
            data: (rank) {
              final entries = entriesAsync.valueOrNull ?? const [];
              if (rank == null || entries.any((e) => e.userId == rank.userId)) {
                return const SizedBox.shrink();
              }
              return Container(
                margin: const EdgeInsets.only(top: DesignTokens.spacingSm),
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingSm,
                  vertical: DesignTokens.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.orange500.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  border: Border.all(color: DesignTokens.orange500.withValues(alpha: 0.25)),
                ),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: tokens.foreground),
                    children: [
                      TextSpan(text: l10n.readingYourRankPrefix),
                      TextSpan(
                        text: '#${rank.rank}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: l10n.readingYourRankSuffix(rank.completedCount)),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _NewsLeaderboardRow extends StatelessWidget {
  const _NewsLeaderboardRow({required this.entry});
  final NewsLeaderboardEntry entry;

  static const _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final initial = entry.displayName.isNotEmpty ? entry.displayName[0].toUpperCase() : '?';
    return InkWell(
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      onTap: () => context.push('/social/profile/${entry.userId}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                entry.rank <= 3 ? _medals[entry.rank - 1] : '${entry.rank}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 14,
              backgroundColor: DesignTokens.orange500.withValues(alpha: 0.1),
              backgroundImage: entry.avatarUrl.isNotEmpty ? NetworkImage(entry.avatarUrl) : null,
              child: entry.avatarUrl.isEmpty
                  ? Text(initial, style: const TextStyle(fontSize: 12, color: DesignTokens.orange500))
                  : null,
            ),
            const SizedBox(width: DesignTokens.spacingSm),
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
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: DesignTokens.orange500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _newsLeaderboardProvider = FutureProvider.autoDispose<List<NewsLeaderboardEntry>>((ref) {
  return ref.watch(newsRepositoryProvider).fetchLeaderboard();
});

final _newsUserRankProvider = FutureProvider.autoDispose<NewsLeaderboardEntry?>((ref) {
  return ref.watch(newsRepositoryProvider).fetchUserRank();
});
