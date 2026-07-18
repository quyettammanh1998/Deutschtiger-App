import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import '../../../data/listening/easy_german_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Bảng "Top học tập" cho 1 bộ sưu tập video (Easy German level, Sprechen
/// B1/B2). Web parity: `components/listening/video-leaderboard-card.tsx`.
class VideoLeaderboardCard extends StatelessWidget {
  const VideoLeaderboardCard({
    super.key,
    required this.entries,
    this.currentUserId,
    this.isLoading = false,
    this.emptyHint,
  });

  final List<VideoCollectionLeaderboardEntry> entries;
  final String? currentUserId;
  final bool isLoading;
  final String? emptyHint;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(PhosphorIcons.trophy, size: 16, color: Colors.amber.shade700),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.videoCollectionLeaderboardTitle,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground),
                    ),
                    Text(
                      l10n.videoCollectionLeaderboardSubtitle,
                      style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)))
          else if (entries.isEmpty)
            Text(emptyHint ?? l10n.videoCollectionLeaderboardEmptyHint, style: TextStyle(fontSize: 12, color: tokens.mutedForeground))
          else
            ...entries.map((e) => _LeaderboardRow(entry: e, isCurrentUser: e.userId == currentUserId, tokens: tokens)),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry, required this.isCurrentUser, required this.tokens});

  final VideoCollectionLeaderboardEntry entry;
  final bool isCurrentUser;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initial = entry.displayName.isNotEmpty ? entry.displayName[0].toUpperCase() : '?';
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentUser ? tokens.primary.withValues(alpha: 0.06) : tokens.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser ? Border.all(color: tokens.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '${entry.rank}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: entry.rank <= 3 ? tokens.primary : tokens.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 14,
            backgroundColor: tokens.primary.withValues(alpha: 0.1),
            backgroundImage: entry.avatarUrl.isNotEmpty ? NetworkImage(entry.avatarUrl) : null,
            child: entry.avatarUrl.isEmpty
                ? Text(initial, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: tokens.primary))
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.normal,
                    color: tokens.foreground,
                  ),
                ),
                Text(
                  l10n.videoCollectionLeaderboardStats(entry.videosCompleted, entry.totalRewatch),
                  style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          Text(
            '${entry.score}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: tokens.primary),
          ),
        ],
      ),
    );
  }
}
