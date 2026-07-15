import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/config/app_config.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/youtube/youtube_video.dart';
import '../../data/youtube/video_library.dart';
import '../../repositories/youtube/youtube_repository.dart';

final youtubeRepositoryProvider = Provider<YouTubeRepository>((ref) {
  return YouTubeRepository(
    ref.watch(apiClientProvider),
    supabaseBaseUrl: AppConfig.supabaseUrl,
  );
});

/// Video "chưa xem" trong tracker cá nhân.
final pendingVideosProvider = FutureProvider<List<YouTubeVideo>>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(youtubeRepositoryProvider).fetchPending();
});

/// Video "đã xem" trong tracker cá nhân.
final completedVideosProvider = FutureProvider<List<YouTubeVideo>>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(youtubeRepositoryProvider).fetchCompleted();
});

/// Video được nhiều người dùng khác thêm — gợi ý nhanh.
final popularVideosProvider = FutureProvider<List<YouTubePopularVideo>>((
  ref,
) async {
  ref.watch(authStateProvider);
  try {
    return await ref.watch(youtubeRepositoryProvider).fetchPopular();
  } catch (_) {
    return const [];
  }
});

/// Thống kê tổng hợp (số video hoàn thành tuần/tháng/hôm nay...).
final youtubeStatsProvider = FutureProvider<YouTubeStats>((ref) async {
  ref.watch(authStateProvider);
  try {
    return await ref.watch(youtubeRepositoryProvider).fetchStats();
  } catch (_) {
    return const YouTubeStats();
  }
});

/// Video (pending + completed) theo videoId — dùng ở màn xem để biết đã
/// persist chưa (`id`) và trạng thái hiện tại.
final youtubeVideoByIdProvider = Provider.family<YouTubeVideo?, String>((
  ref,
  videoId,
) {
  final pending = ref.watch(pendingVideosProvider).value ?? const [];
  final completed = ref.watch(completedVideosProvider).value ?? const [];
  for (final v in [...pending, ...completed]) {
    if (v.videoId == videoId) return v;
  }
  return null;
});

// ---------------------------------------------------------------------
// Video library
// ---------------------------------------------------------------------

/// Cấu hình một thư viện theo slug (title/description).
final videoLibraryConfigProvider = FutureProvider.family<
  VideoLibraryConfig?,
  String
>((ref, slug) {
  return ref.watch(youtubeRepositoryProvider).fetchLibraryBySlug(slug);
});

/// Lộ trình tĩnh (nhóm + video) của một thư viện.
final videoLibraryLearningPathProvider =
    FutureProvider.family<List<VideoLibraryGroup>, String>((ref, slug) {
      return ref.watch(youtubeRepositoryProvider).fetchLearningPath(slug);
    });

/// Một nhóm theo group_id, null nếu không tìm thấy.
final videoLibraryGroupProvider =
    Provider.family<VideoLibraryGroup?, ({String slug, String groupId})>((
      ref,
      key,
    ) {
      final groups =
          ref.watch(videoLibraryLearningPathProvider(key.slug)).value ??
          const [];
      for (final g in groups) {
        if (g.groupId == key.groupId) return g;
      }
      return null;
    });

/// Tiến độ từng nhóm của một thư viện, map theo group_id.
final videoLibraryGroupProgressProvider =
    FutureProvider.family<Map<String, LibraryGroupProgress>, String>((
      ref,
      slug,
    ) async {
      ref.watch(authStateProvider);
      try {
        final list = await ref
            .watch(youtubeRepositoryProvider)
            .fetchGroupProgress(slug);
        return {for (final p in list) p.groupId: p};
      } catch (_) {
        return const {};
      }
    });

/// Video (kèm trạng thái DB) của một nhóm trong thư viện. Seed metadata vào
/// DB trước (idempotent) rồi fetch, giống pattern `videosByGroupProvider` của
/// interview — đảm bảo mỗi video có `id` để complete/rewatch.
final videoLibraryGroupVideosProvider =
    FutureProvider.family<List<LibraryVideo>, ({String slug, String groupId})>(
      (ref, key) async {
        ref.watch(authStateProvider);
        final repo = ref.watch(youtubeRepositoryProvider);
        final group = ref.watch(videoLibraryGroupProvider(key));
        if (group != null && group.videos.isNotEmpty) {
          await repo.addGroupVideos(key.slug, key.groupId, group.videos);
        }
        return repo.fetchGroupVideos(key.slug, key.groupId);
      },
    );

/// Thống kê tổng hợp của một thư viện.
final videoLibraryStatsProvider = FutureProvider.family<LibraryStats, String>((
  ref,
  slug,
) async {
  ref.watch(authStateProvider);
  try {
    return await ref.watch(youtubeRepositoryProvider).fetchLibraryStats(slug);
  } catch (_) {
    return const LibraryStats();
  }
});
