import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/data/listening/sprechen_videos.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/listening/easy_german_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'widgets/video_collection_layout.dart';
import 'widgets/video_collection_models.dart';
import 'widgets/video_leaderboard_card.dart';

String _formatDuration(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// `/listening/sprechen-b2` — 79 video Goethe B2 mündlich (Vortrag halten),
/// nghe chép chính tả. Web parity: `sprechen-b2-page.tsx`.
class SprechenB2Page extends ConsumerWidget {
  const SprechenB2Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.watch(authStateProvider);
    final userId = ref.watch(authServiceProvider).currentUser?.id;
    final pending = ref.watch(pendingVideosProvider).valueOrNull ?? const [];
    final completed = ref.watch(completedVideosProvider).valueOrNull ?? const [];

    final allIds = sprechenB2Videos.map((v) => v.id).toSet();
    final pendingSet = pending.where((v) => allIds.contains(v.videoId)).map((v) => v.videoId).toSet();
    final completedSet =
        completed.where((v) => allIds.contains(v.videoId)).map((v) => v.videoId).toSet();
    final totalRewatch = completed
        .where((v) => allIds.contains(v.videoId))
        .fold<int>(0, (sum, v) => sum + v.watchCount);

    VideoWatchStatus statusOf(String videoId) {
      if (completedSet.contains(videoId)) return VideoWatchStatus.completed;
      if (pendingSet.contains(videoId)) return VideoWatchStatus.pending;
      return VideoWatchStatus.newVideo;
    }

    final leaderboardAsync = ref.watch(
      videoCollectionLeaderboardProvider(sprechenB2Videos.map((v) => v.id).join(',')),
    );

    return VideoCollectionLayout(
      breadcrumbLabel: 'Sprechen B2',
      headerIcon: AppPhosphorIcons.chatCircle,
      headerTitle: 'Sprechen B2 — Vortrag halten',
      headerSubtitle: l10n.listeningSprechenHeaderSubtitle(sprechenB2Videos.length),
      headerAccentColor: const Color(0xFF7C3AED),
      videos: [
        for (final v in sprechenB2Videos)
          VideoCollectionItem(
            videoId: v.id,
            title: v.title,
            badge: _formatDuration(v.duration),
            subtitle: 'Vortrag halten · B2',
          ),
      ],
      statusOf: userId != null ? statusOf : null,
      progress: userId != null
          ? (
              completedCount: completedSet.length,
              totalVideos: allIds.length,
              pendingCount: pendingSet.length,
              totalRewatch: totalRewatch,
            )
          : null,
      onVideoTap: (item) => context.push(
        '/listening/youtube/watch',
        extra: (videoId: item.videoId, title: item.title),
      ),
      sidebar: userId != null
          ? leaderboardAsync.when(
              data: (entries) => VideoLeaderboardCard(entries: entries, currentUserId: userId),
              loading: () => const VideoLeaderboardCard(entries: [], isLoading: true),
              error: (_, _) => const VideoLeaderboardCard(entries: []),
            )
          : null,
    );
  }
}
