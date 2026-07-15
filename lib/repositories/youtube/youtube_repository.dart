import 'package:deutschtiger/services/api_client.dart';
import '../../data/youtube/youtube_video.dart';
import '../../data/youtube/video_library.dart';

/// Repository cho YouTube tracker cá nhân + "video library" (bộ sưu tập biên
/// tập sẵn). Cả hai dùng chung bảng `youtube_videos` ở backend — library chỉ
/// scoped thêm theo `library_slug`/`group_id`
/// (`internal/feature/content/video/youtube_library_handler.go`).
///
/// Lộ trình tĩnh của library (`libraries.json`, `{slug}/learning-path.json`)
/// nằm trên Supabase Storage bucket công khai `video-libraries` — KHÔNG qua
/// backend Go, nên fetch bằng absolute URL qua dio raw (giống
/// `InterviewRepository.fetchLearningPath`).
class YouTubeRepository {
  YouTubeRepository(this._api, {required String supabaseBaseUrl})
    : _librariesUrl =
          '$supabaseBaseUrl/storage/v1/object/public/video-libraries/libraries.json',
      _learningPathBaseUrl =
          '$supabaseBaseUrl/storage/v1/object/public/video-libraries';

  final ApiClient _api;
  final String _librariesUrl;
  final String _learningPathBaseUrl;

  // ---------------------------------------------------------------------
  // Tracker cá nhân (`/user/youtube/videos*`)
  // ---------------------------------------------------------------------

  Future<List<YouTubeVideo>> fetchPending() async {
    final list = await _api.get<List<dynamic>>('/user/youtube/videos/pending');
    return list.map((e) => YouTubeVideo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<YouTubeVideo>> fetchCompleted() async {
    final list = await _api.get<List<dynamic>>(
      '/user/youtube/videos/completed',
    );
    return list.map((e) => YouTubeVideo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<YouTubePopularVideo>> fetchPopular() async {
    final list = await _api.get<List<dynamic>>('/user/youtube/popular');
    return list
        .map((e) => YouTubePopularVideo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<YouTubeStats> fetchStats() async {
    final data = await _api.get<Map<String, dynamic>>('/user/youtube/stats');
    return YouTubeStats.fromJson(data);
  }

  Future<List<YouTubeContributionDay>> fetchContributions({
    int months = 6,
  }) async {
    final list = await _api.get<List<dynamic>>(
      '/user/youtube/contributions',
      query: {'months': months},
    );
    return list
        .map((e) => YouTubeContributionDay.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Thêm video mới bằng URL (POST). Backend tự trích `duration`/transcript.
  Future<YouTubeVideo> addVideo({
    required String youtubeUrl,
    required String videoId,
    String? title,
    String? thumbnailUrl,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/user/youtube/videos',
      body: {
        'youtube_url': youtubeUrl,
        'video_id': videoId,
        'title': title,
        'thumbnail_url': thumbnailUrl,
      },
    );
    return YouTubeVideo.fromJson(data);
  }

  Future<void> complete(String id) =>
      _api.put<dynamic>('/user/youtube/videos/$id/complete', body: const {});

  Future<YouTubeVideo> rewatch(String id) async {
    final data = await _api.put<Map<String, dynamic>>(
      '/user/youtube/videos/$id/rewatch',
      body: const {},
    );
    return YouTubeVideo.fromJson(data);
  }

  Future<void> deleteVideo(String id) =>
      _api.delete<dynamic>('/user/youtube/videos/$id');

  Future<bool> videoExists(String videoId) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/user/youtube/videos/exists/$videoId',
    );
    return data['exists'] as bool? ?? false;
  }

  // ---------------------------------------------------------------------
  // Video library (`/user/youtube/library/{slug}/...` + Supabase Storage)
  // ---------------------------------------------------------------------

  /// Danh sách thư viện đã đăng ký (`libraries.json`).
  Future<List<VideoLibraryConfig>> fetchLibraries() async {
    final res = await _api.raw.get<List<dynamic>>(_librariesUrl);
    final data = res.data ?? const <dynamic>[];
    return data
        .map((e) => VideoLibraryConfig.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Một thư viện theo slug, null nếu không tìm thấy.
  Future<VideoLibraryConfig?> fetchLibraryBySlug(String slug) async {
    final libs = await fetchLibraries();
    for (final l in libs) {
      if (l.slug == slug) return l;
    }
    return null;
  }

  /// Lộ trình tĩnh (nhóm + video) của một thư viện.
  Future<List<VideoLibraryGroup>> fetchLearningPath(String slug) async {
    final res = await _api.raw.get<Map<String, dynamic>>(
      '$_learningPathBaseUrl/$slug/learning-path.json',
    );
    final data = res.data ?? const <String, dynamic>{};
    final list = (data['learning_path'] as List<dynamic>?) ?? const [];
    return list
        .map((e) => VideoLibraryGroup.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LibraryVideo>> fetchGroupVideos(
    String slug,
    String groupId,
  ) async {
    final list = await _api.get<List<dynamic>>(
      '/user/youtube/library/$slug/groups/$groupId/videos',
    );
    return list.map((e) => LibraryVideo.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Seed metadata video vào DB (idempotent — `ON CONFLICT DO NOTHING`).
  Future<List<LibraryVideo>> addGroupVideos(
    String slug,
    String groupId,
    List<VideoLibraryPathVideo> videos,
  ) async {
    if (videos.isEmpty) return const [];
    final list = await _api.post<List<dynamic>>(
      '/user/youtube/library/$slug/groups/$groupId/videos',
      body: {
        'videos': [
          for (final v in videos)
            {
              'video_id': v.videoId,
              'title': v.title,
              'duration_seconds': v.durationSeconds,
            },
        ],
      },
    );
    return list.map((e) => LibraryVideo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<LibraryGroupProgress>> fetchGroupProgress(String slug) async {
    final list = await _api.get<List<dynamic>>(
      '/user/youtube/library/$slug/progress',
    );
    return list
        .map((e) => LibraryGroupProgress.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LibraryStats> fetchLibraryStats(String slug) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/user/youtube/library/$slug/stats',
    );
    return LibraryStats.fromJson(data);
  }
}
