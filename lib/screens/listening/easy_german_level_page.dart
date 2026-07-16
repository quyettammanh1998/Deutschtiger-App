import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/listening/easy_german_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'widgets/video_collection_layout.dart';
import 'widgets/video_collection_models.dart';
import 'widgets/video_leaderboard_card.dart';

const Map<String, ({String label, String subtitle, Color color})> _levelMeta = {
  'a1': (label: 'A1', subtitle: 'For Absolute Beginners', color: Color(0xFF16A34A)),
  'a2': (label: 'A2', subtitle: 'For Advanced Beginners', color: Color(0xFF0D9488)),
  'b1': (label: 'B1', subtitle: 'For Intermediate Learners', color: Color(0xFF2563EB)),
  'b2': (label: 'B2', subtitle: 'For Upper Intermediate Learners', color: Color(0xFFEA580C)),
  'c1': (label: 'C1', subtitle: 'For Advanced Learners', color: Color(0xFFDC2626)),
};

String _formatSegmentCount(AppLocalizations l10n, int count) {
  if (count < 50) return l10n.easyGermanSegmentCountShort;
  if (count < 150) return l10n.easyGermanSegmentCountMedium;
  return l10n.easyGermanSegmentCountLong;
}

/// `/listening/easy-german/:level` — danh sách video Easy German theo level.
/// Web parity: `easy-german-page.tsx` + `VideoCollectionLayout`.
class EasyGermanLevelPage extends ConsumerWidget {
  const EasyGermanLevelPage({super.key, required this.level});

  final String level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final normalized = level.toLowerCase();
    final meta = _levelMeta[normalized] ?? _levelMeta['a1']!;
    final indexAsync = ref.watch(easyGermanIndexProvider(normalized));
    ref.watch(authStateProvider);
    final userId = ref.watch(authServiceProvider).currentUser?.id;
    final pending = ref.watch(pendingVideosProvider).valueOrNull ?? const [];
    final completed = ref.watch(completedVideosProvider).valueOrNull ?? const [];

    return indexAsync.when(
      loading: () => VideoCollectionLayout(
        breadcrumbLabel: 'Easy German ${meta.label}',
        headerIcon: AppPhosphorIcons.play,
        headerTitle: 'Easy German ${meta.label}',
        headerSubtitle: meta.subtitle,
        headerAccentColor: meta.color,
        onVideoTap: (_) {},
        loading: true,
      ),
      error: (_, _) => VideoCollectionLayout(
        breadcrumbLabel: 'Easy German ${meta.label}',
        headerIcon: AppPhosphorIcons.play,
        headerTitle: 'Easy German ${meta.label}',
        headerSubtitle: meta.subtitle,
        headerAccentColor: meta.color,
        onVideoTap: (_) {},
        errorText: l10n.easyGermanLoadError,
      ),
      data: (videos) {
        final videoIds = videos.map((v) => v.videoId).toSet();
        final trackedPending = pending.where((v) => videoIds.contains(v.videoId)).toList();
        final trackedCompleted = completed.where((v) => videoIds.contains(v.videoId)).toList();
        final totalRewatch = trackedCompleted.fold<int>(0, (sum, v) => sum + v.watchCount);
        final pendingSet = trackedPending.map((v) => v.videoId).toSet();
        final completedSet = trackedCompleted.map((v) => v.videoId).toSet();

        VideoWatchStatus statusOf(String videoId) {
          if (completedSet.contains(videoId)) return VideoWatchStatus.completed;
          if (pendingSet.contains(videoId)) return VideoWatchStatus.pending;
          return VideoWatchStatus.newVideo;
        }

        final leaderboardAsync = ref.watch(
          videoCollectionLeaderboardProvider(videos.map((v) => v.videoId).join(',')),
        );

        return VideoCollectionLayout(
          breadcrumbLabel: 'Easy German ${meta.label}',
          headerIcon: AppPhosphorIcons.play,
          headerTitle: 'Easy German ${meta.label}',
          headerSubtitle: '${meta.subtitle} · ${videos.length} video',
          headerAccentColor: meta.color,
          videos: [
            for (final v in videos)
              VideoCollectionItem(
                videoId: v.videoId,
                title: v.title,
                badge: _formatSegmentCount(l10n, v.segments),
                subtitle: l10n.easyGermanSentenceCount(v.segments),
              ),
          ],
          searchHint: l10n.easyGermanSearchHint,
          statusOf: userId != null ? statusOf : null,
          progress: userId != null
              ? (
                  completedCount: trackedCompleted.length,
                  totalVideos: videos.length,
                  pendingCount: trackedPending.length,
                  totalRewatch: totalRewatch,
                )
              : null,
          onVideoTap: (item) => context.push(
            '/listening/youtube/watch',
            extra: (videoId: item.videoId, title: item.title),
          ),
          sidebar: userId != null
              ? leaderboardAsync.when(
                  data: (entries) => VideoLeaderboardCard(
                    entries: entries,
                    currentUserId: userId,
                    emptyHint: l10n.easyGermanLeaderboardEmptyHint,
                  ),
                  loading: () => const VideoLeaderboardCard(entries: [], isLoading: true),
                  error: (_, _) => const VideoLeaderboardCard(entries: []),
                )
              : null,
        );
      },
    );
  }
}
