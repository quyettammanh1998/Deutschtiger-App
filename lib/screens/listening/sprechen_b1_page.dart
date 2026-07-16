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

/// `/listening/sprechen-b1` — 145 video Goethe B1 mündlich (Teil 1/Teil 2),
/// nghe chép chính tả. Web parity: `sprechen-b1-page.tsx`.
class SprechenB1Page extends ConsumerWidget {
  const SprechenB1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.watch(authStateProvider);
    final userId = ref.watch(authServiceProvider).currentUser?.id;
    final pending = ref.watch(pendingVideosProvider).valueOrNull ?? const [];
    final completed = ref.watch(completedVideosProvider).valueOrNull ?? const [];

    final allVideos = [...sprechenB1Teil1, ...sprechenB1Teil2];
    final allIds = allVideos.map((v) => v.id).toSet();
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

    VideoCollectionTab toTab(String key, String label, String subtitle, List<SprechenVideo> videos) {
      return VideoCollectionTab(
        key: key,
        label: label,
        subtitle: subtitle,
        videos: [
          for (final v in videos)
            VideoCollectionItem(videoId: v.id, title: v.title, badge: _formatDuration(v.duration), subtitle: 'B1'),
        ],
      );
    }

    final leaderboardAsync = ref.watch(
      videoCollectionLeaderboardProvider(allVideos.map((v) => v.id).join(',')),
    );

    return VideoCollectionLayout(
      breadcrumbLabel: 'Sprechen B1',
      headerIcon: AppPhosphorIcons.chatCircle,
      headerTitle: 'Sprechen B1',
      headerSubtitle: l10n.listeningSprechenHeaderSubtitle(allVideos.length),
      headerAccentColor: const Color(0xFFEA580C),
      tabs: [
        toTab('teil1', 'Teil 1', 'Gemeinsam etwas planen', sprechenB1Teil1),
        toTab('teil2', 'Teil 2', 'Ein Thema präsentieren', sprechenB1Teil2),
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
