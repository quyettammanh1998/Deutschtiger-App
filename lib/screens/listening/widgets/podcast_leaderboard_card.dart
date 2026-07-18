import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Bảng xếp hạng Easy German Podcast (số tập hoàn thành). Web parity:
/// `components/listening/podcast-leaderboard.tsx`. Ring tiến độ đã hiển thị
/// riêng ở đầu trang podcast (stats strip) nên widget này chỉ còn phần bảng.
class PodcastLeaderboardCard extends ConsumerWidget {
  const PodcastLeaderboardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(podcastLeaderboardProvider);
    final userId = ref.watch(authServiceProvider).currentUser?.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(PhosphorIcons.trophy, size: 18, color: Color(0xFFEAB308)),
              const SizedBox(width: 6),
              Text(l10n.leaderboardTitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tokens.foreground)),
            ],
          ),
          Text(l10n.podcastLeaderboardSubtitle, style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
          const SizedBox(height: 10),
          entriesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, _) => Text(l10n.podcastLeaderboardLoadError, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
            data: (entries) {
              if (entries.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(l10n.grammarLeaderboardEmpty, style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
                  ),
                );
              }
              return Column(
                children: [
                  for (final e in entries)
                    _PodcastRankRow(
                      rank: e.rank,
                      displayName: e.displayName,
                      avatarUrl: e.avatarUrl,
                      completedCount: e.completedCount,
                      isCurrentUser: e.userId == userId,
                      tokens: tokens,
                    ),
                ],
              );
            },
          ),
          if (userId != null)
            Consumer(
              builder: (context, ref, _) {
                final rankAsync = ref.watch(podcastUserRankProvider);
                final entries = entriesAsync.valueOrNull ?? const [];
                final rank = rankAsync.valueOrNull;
                if (rank == null || entries.any((e) => e.userId == rank.userId)) {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9333EA).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF9333EA).withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    l10n.podcastYourRank(rank.rank, rank.completedCount),
                    style: TextStyle(fontSize: 12, color: tokens.foreground),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PodcastRankRow extends StatelessWidget {
  const _PodcastRankRow({
    required this.rank,
    required this.displayName,
    required this.avatarUrl,
    required this.completedCount,
    required this.isCurrentUser,
    required this.tokens,
  });

  final int rank;
  final String displayName;
  final String avatarUrl;
  final int completedCount;
  final bool isCurrentUser;
  final AppTokens tokens;

  static const _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final rankLabel = rank <= 3 ? _medals[rank - 1] : '$rank';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isCurrentUser ? const Color(0xFF9333EA).withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isCurrentUser ? Border.all(color: const Color(0xFF9333EA).withValues(alpha: 0.4)) : null,
        ),
        child: Row(
          children: [
            SizedBox(width: 22, child: Text(rankLabel, textAlign: TextAlign.center)),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFF9333EA).withValues(alpha: 0.1),
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(initial, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9333EA)))
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.normal, color: tokens.foreground),
              ),
            ),
            Text('$completedCount', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF9333EA))),
          ],
        ),
      ),
    );
  }
}
