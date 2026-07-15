import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/config/app_config.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/listening/podcast_models.dart';
import '../../repositories/listening/podcast_repository.dart';

final podcastRepositoryProvider = Provider<PodcastRepository>((ref) {
  return PodcastRepository(ref.watch(apiClientProvider), AppConfig.webviewBaseUrl);
});

/// Toàn bộ index Easy German Podcast (file tĩnh, không có transcript).
final podcastIndexProvider = FutureProvider<List<PodcastEpisode>>((ref) {
  return ref.watch(podcastRepositoryProvider).fetchIndex();
});

/// 1 tập đầy đủ theo slug (mp3 url + transcript).
final podcastEpisodeProvider =
    FutureProvider.family<PodcastEpisodeDetail, String>((ref, slug) {
  return ref.watch(podcastRepositoryProvider).fetchEpisode(slug);
});

/// Danh sách slug đã nghe xong. Rỗng khi chưa đăng nhập hoặc lỗi mạng — UI
/// vẫn hiển thị danh sách tập bình thường, chỉ ẩn trạng thái tiến độ.
final podcastCompletedIdsProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(authStateProvider);
  return ref.watch(podcastRepositoryProvider).fetchCompletedEpisodeIds();
});

/// Bảng xếp hạng podcast công khai (top N).
final podcastLeaderboardProvider =
    FutureProvider<List<PodcastLeaderboardEntry>>((ref) {
  return ref.watch(podcastRepositoryProvider).fetchLeaderboard();
});

/// Vị trí của user hiện tại. `null` khi chưa đăng nhập hoặc chưa có dữ liệu.
final podcastUserRankProvider = FutureProvider<PodcastLeaderboardEntry?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(podcastRepositoryProvider).fetchUserRank();
});

/// Đánh dấu hoàn thành + invalidate progress/leaderboard để UI cập nhật ngay.
Future<void> markPodcastEpisodeComplete(WidgetRef ref, String slug) async {
  await ref.read(podcastRepositoryProvider).markComplete(slug);
  ref.invalidate(podcastCompletedIdsProvider);
  ref.invalidate(podcastLeaderboardProvider);
  ref.invalidate(podcastUserRankProvider);
}
