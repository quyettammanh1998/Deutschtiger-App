import 'package:deutschtiger/services/api_client.dart';
import '../../data/listening/podcast_models.dart';

/// Repository cho Easy German Podcast (listening surface).
///
/// Index + nội dung tập là file JSON tĩnh NGOÀI `/api/v1`, fetch bằng dio raw
/// qua [_staticBaseUrl] — cùng lộ trình với `GrammarRepository` (xem
/// `lib/repositories/grammar/grammar_repository.dart`). Progress + audio +
/// leaderboard đi qua Go API (`/api/v1/...`).
class PodcastRepository {
  PodcastRepository(this._api, this._staticBaseUrl);

  final ApiClient _api;
  final String _staticBaseUrl;

  static const _staticBasePath = '/data/listening/podcast/easy_german';

  /// File tĩnh `index.json` — toàn bộ danh sách tập (không có transcript).
  Future<List<PodcastEpisode>> fetchIndex() async {
    final res = await _api.raw.get<List<dynamic>>(
      '$_staticBaseUrl$_staticBasePath/index.json',
    );
    final data = res.data ?? const <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(PodcastEpisode.fromJson)
        .toList();
  }

  /// File tĩnh `{slug}.json` — 1 tập đầy đủ (mp3 url + transcript có timestamp).
  Future<PodcastEpisodeDetail> fetchEpisode(String slug) async {
    final res = await _api.raw.get<Map<String, dynamic>>(
      '$_staticBaseUrl$_staticBasePath/${Uri.encodeComponent(slug)}.json',
    );
    return PodcastEpisodeDetail.fromJson(res.data ?? const <String, dynamic>{});
  }

  /// URL audio (public, không cần JWT) —
  /// `GET /api/v1/listening/podcast/easy_german/audio/{slug}`.
  String audioUrl(String slug) =>
      '${_api.raw.options.baseUrl}/listening/podcast/easy_german/audio/'
      '${Uri.encodeComponent(slug)}';

  /// `GET /user/podcast-progress` — danh sách slug đã nghe xong.
  /// Chưa đăng nhập / lỗi mạng → trả rỗng, UI vẫn hiển thị danh sách bình thường.
  Future<List<String>> fetchCompletedEpisodeIds() async {
    try {
      final data = await _api.get<Map<String, dynamic>>(
        '/user/podcast-progress',
      );
      return (data['episode_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [];
    } on ApiException {
      return const [];
    }
  }

  /// `POST /user/podcast-progress` — đánh dấu 1 tập đã nghe xong.
  Future<void> markComplete(String episodeSlug) {
    return _api.post<dynamic>(
      '/user/podcast-progress',
      body: {'episode_id': episodeSlug},
    );
  }

  /// `GET /podcast-leaderboard?limit=` — bảng xếp hạng công khai.
  Future<List<PodcastLeaderboardEntry>> fetchLeaderboard({int limit = 10}) async {
    final data = await _api.get<List<dynamic>>(
      '/podcast-leaderboard',
      query: {'limit': limit},
    );
    return data
        .whereType<Map<String, dynamic>>()
        .map(PodcastLeaderboardEntry.fromJson)
        .toList();
  }

  /// `GET /user/podcast-rank` — vị trí của user hiện tại.
  /// Chưa đăng nhập / lỗi mạng → trả `null`, UI ẩn phần rank cá nhân.
  Future<PodcastLeaderboardEntry?> fetchUserRank() async {
    try {
      final data = await _api.get<Map<String, dynamic>>('/user/podcast-rank');
      if (data.isEmpty) return null;
      return PodcastLeaderboardEntry.fromJson(data);
    } on ApiException {
      return null;
    }
  }
}
