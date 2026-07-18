import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/reading/reading_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repositories/reading/reading_repository.dart';
import 'reading_level_theme.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Bảng xếp hạng theo level + ring tiến trình — mirror `reading-leaderboard.tsx`.
/// Ring dùng `completed`/`total` của chính level đang xem (đã tải sẵn ở màn cha).
class ReadingLeaderboardCard extends ConsumerWidget {
  const ReadingLeaderboardCard({
    super.key,
    required this.level,
    required this.completed,
    required this.total,
  });

  final String level;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final leaderboardAsync = ref.watch(_readingLeaderboardProvider(level));
    final userRankAsync = ref.watch(_readingUserRankProvider(level));
    final theme = readingLevelTheme(level);
    final progress = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(DesignTokens.radius),
            border: Border.all(color: tokens.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: tokens.border,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.ring),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$completed',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: tokens.foreground,
                          ),
                        ),
                        Text(
                          '/$total',
                          style: TextStyle(fontSize: 9, color: tokens.mutedForeground),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.readingLeaderboardProgressTitle(level),
                      style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground),
                    ),
                    Text(
                      l10n.readingCompletedCountOfTotal(completed, total),
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Container(
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
                    l10n.readingLeaderboardTitleLevel(level),
                    style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                l10n.readingLeaderboardSubtitleLevel(level),
                style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              leaderboardAsync.when(
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
                            l10n.grammarLeaderboardEmpty,
                            style: TextStyle(color: tokens.mutedForeground, fontSize: 13),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          for (final entry in entries) _LeaderboardRow(entry: entry),
                        ],
                      ),
              ),
              userRankAsync.when(
                data: (rank) {
                  final entries = leaderboardAsync.valueOrNull ?? const [];
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
                      color: tokens.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                      border: Border.all(color: tokens.primary.withValues(alpha: 0.25)),
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
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});
  final ReadingLeaderboardEntry entry;

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
              backgroundColor: tokens.primary.withValues(alpha: 0.1),
              backgroundImage: entry.avatarUrl.isNotEmpty ? NetworkImage(entry.avatarUrl) : null,
              child: entry.avatarUrl.isEmpty
                  ? Text(initial, style: TextStyle(fontSize: 12, color: tokens.primary))
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
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: tokens.primary),
            ),
          ],
        ),
      ),
    );
  }
}

final _readingLeaderboardProvider = FutureProvider.autoDispose
    .family<List<ReadingLeaderboardEntry>, String>((ref, level) {
      return ref.watch(readingRepositoryProvider).fetchLeaderboard(level: level);
    });

final _readingUserRankProvider = FutureProvider.autoDispose
    .family<ReadingLeaderboardEntry?, String>((ref, level) {
      return ref.watch(readingRepositoryProvider).fetchUserRank(level);
    });
