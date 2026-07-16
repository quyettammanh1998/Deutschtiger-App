import 'package:deutschtiger/services/api_client.dart';
import '../../data/listening/easy_german_models.dart';

/// Repository cho Easy German level pages + video-collection leaderboard
/// (dùng chung cho Sprechen B1/B2 — endpoint chỉ phụ thuộc bộ `video_ids`).
///
/// Index là file JSON tĩnh NGOÀI `/api/v1`, fetch qua [_staticBaseUrl] — cùng
/// lộ trình với `PodcastRepository`.
class EasyGermanRepository {
  EasyGermanRepository(this._api, this._staticBaseUrl);

  final ApiClient _api;
  final String _staticBaseUrl;

  static const int _maxLeaderboardVideoIds = 500;

  /// File tĩnh `index.json` theo level (`a1`..`c1`) — danh sách video.
  Future<List<EasyGermanVideo>> fetchIndex(String level) async {
    final tag = 'EasyGerman-${level.toUpperCase()}';
    final res = await _api.raw.get<List<dynamic>>(
      '$_staticBaseUrl/data/listening/$tag/index.json',
    );
    final data = res.data ?? const <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(EasyGermanVideo.fromJson)
        .toList();
  }

  /// `POST /listening/easy-german/leaderboard` — bảng xếp hạng theo bộ
  /// video_id (dùng chung cho mọi bộ sưu tập: Easy German level, Sprechen
  /// B1/B2). Lỗi mạng/không đăng nhập → trả rỗng, UI ẩn phần xếp hạng.
  Future<List<VideoCollectionLeaderboardEntry>> fetchLeaderboard(
    List<String> videoIds, {
    int limit = 8,
  }) async {
    final sanitized = _sanitizeIds(videoIds);
    if (sanitized.isEmpty) return const [];
    try {
      final data = await _api.post<List<dynamic>>(
        '/listening/easy-german/leaderboard',
        body: {'video_ids': sanitized, 'limit': limit},
      );
      return data
          .whereType<Map<String, dynamic>>()
          .map(VideoCollectionLeaderboardEntry.fromJson)
          .toList();
    } on ApiException {
      return const [];
    }
  }

  List<String> _sanitizeIds(List<String> videoIds) {
    final seen = <String>{};
    final result = <String>[];
    for (final raw in videoIds) {
      final id = raw.trim();
      if (id.isEmpty || seen.contains(id)) continue;
      seen.add(id);
      result.add(id);
      if (result.length >= _maxLeaderboardVideoIds) break;
    }
    return result;
  }
}
