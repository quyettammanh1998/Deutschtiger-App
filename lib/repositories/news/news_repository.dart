import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/news/news_models.dart';

/// Repository cho News surface (live API).
///
/// Nguồn:
///  - `GET /api/v1/news/list?page=&pageSize=&topic=&level=` — kho tin tức phân trang.
///  - `GET /api/v1/news/story-by-slug/{slug}` — tất cả level của 1 bài theo slug.
///  - `GET /api/v1/news/topics` — chủ đề + số lượng bài.
///  - `GET /api/v1/user/news-progress` + `POST` — bài đã hoàn thành (quiz ≥60%).
///  - `GET /api/v1/user/news-week-stats` — tiến độ tuần cá nhân.
///
/// Leaderboard/rank (`GET /news-leaderboard`, `GET /user/news-rank`) nằm ngoài
/// phạm vi wave này (spec chỉ yêu cầu list + detail + progress + week stats).
class NewsRepository {
  NewsRepository(this._apiClient);
  final ApiClient _apiClient;

  /// Trang kho tin tức; [topic]/[level] lọc phía server khi không rỗng.
  Future<NewsListResult> fetchList({
    int page = 1,
    int pageSize = 10,
    String? topic,
    String? level,
  }) async {
    final query = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (topic != null && topic.isNotEmpty) query['topic'] = topic;
    if (level != null && level.isNotEmpty) query['level'] = level;

    final data = await _apiClient.get<Map<String, dynamic>>(
      '/news/list',
      query: query,
    );
    return NewsListResult.fromJson(data);
  }

  /// Tên chủ đề → số bài đã xuất bản.
  Future<Map<String, int>> fetchTopics() async {
    final data = await _apiClient.get<Map<String, dynamic>>('/news/topics');
    final topics = data['topics'] as Map<String, dynamic>? ?? {};
    return topics.map((key, value) => MapEntry(key, (value as num).toInt()));
  }

  /// Tất cả level của bài sở hữu [slug] (level switcher payload).
  Future<List<NewsLevelArticle>> fetchStoryBySlug(String slug) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/news/story-by-slug/${Uri.encodeComponent(slug)}',
    );
    final levels = data['levels'] as List<dynamic>? ?? [];
    return levels
        .map((e) => NewsLevelArticle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Id nhóm bài (story_group_id) user đã hoàn thành; nuốt lỗi (trả `[]`) để
  /// một API phụ không chặn hiển thị nội dung chính — giống
  /// `ReadingRepository.fetchCompletedIds`.
  Future<List<String>> fetchCompletedIds() async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/user/news-progress',
      );
      return (data['story_group_ids'] as List<dynamic>?)?.cast<String>() ??
          [];
    } catch (_) {
      return [];
    }
  }

  /// Đánh dấu 1 nhóm bài đã hoàn thành (quiz đạt ≥60%, backend tự chặn dưới
  /// ngưỡng). Best-effort: nuốt lỗi cho viewer ẩn danh / lỗi mạng tạm thời —
  /// giống `news-service.ts markNewsComplete`.
  Future<void> markComplete({
    required String storyGroupId,
    required int scorePct,
  }) async {
    try {
      await _apiClient.post<Map<String, dynamic>>(
        '/user/news-progress',
        body: {'story_group_id': storyGroupId, 'score_pct': scorePct},
      );
    } catch (_) {
      // Người dùng ẩn danh hoặc lỗi mạng tạm thời — theo dõi hoàn thành không
      // phải luồng chặn chính.
    }
  }

  /// Tiến độ tuần cá nhân; trả `null` khi chưa đăng nhập / lỗi mạng (ring ẩn).
  Future<NewsWeekStats?> fetchWeekStats() async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/user/news-week-stats',
      );
      return NewsWeekStats.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(ref.watch(apiClientProvider));
});
