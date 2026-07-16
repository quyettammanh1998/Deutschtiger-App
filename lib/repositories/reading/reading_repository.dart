import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/reading/reading_models.dart';

/// Repository cho Reading surface (live API).
///
/// Nguồn:
///  - `GET /api/v1/reading/articles?level=&limit=` — danh sách bài đọc theo level.
///  - `GET /api/v1/reading/articles/{level}/{slug}` — chi tiết bài đọc.
///  - `GET /api/v1/reading-feed?levels=&limit=` — feed cá nhân hoá theo coverage.
///  - `GET /api/v1/user/reading-progress` + `POST` — bài đã đọc / đánh dấu đã đọc.
class ReadingRepository {
  ReadingRepository(this._apiClient);
  final ApiClient _apiClient;

  /// Mỗi level có tối đa ~59 bài nên lấy hết trong 1 request (giống web
  /// `fetchReadingArticlesByLevel`); `level` rỗng nghĩa là lấy tất cả level.
  Future<List<ReadingArticleSummary>> fetchArticlesByLevel({
    String level = '',
  }) async {
    final query = <String, dynamic>{'limit': 300};
    if (level.isNotEmpty) query['level'] = level;

    final data = await _apiClient.get<Map<String, dynamic>>(
      '/reading/articles',
      query: query,
    );
    final articles = data['articles'] as List<dynamic>? ?? [];
    return articles
        .map((e) => ReadingArticleSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Chi tiết bài đọc theo level + slug.
  Future<ReadingArticle> fetchArticle({
    required String level,
    required String slug,
  }) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/reading/articles/$level/$slug',
    );
    return ReadingArticle.fromJson(data['article'] as Map<String, dynamic>);
  }

  /// Feed cá nhân hoá theo coverage từ vựng đã biết. [levels] là chuỗi
  /// comma-separated (vd `'A1,A2'`); rỗng nghĩa là không lọc level — đây
  /// cũng là dạng gửi thẳng lên query `levels=` nên giữ nguyên kiểu `String`
  /// để làm family key equatable-by-value cho provider (`List` không có
  /// value equality mặc định, sẽ phá cache/override theo tham số).
  Future<ReadingFeedResult> fetchFeed({
    String levels = '',
    int limit = 20,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (levels.isNotEmpty) query['levels'] = levels;

    final data = await _apiClient.get<dynamic>('/reading-feed', query: query);
    return ReadingFeedResult.fromJson(data);
  }

  /// Danh sách id bài đã đọc; nuốt lỗi (trả `[]`) để một API phụ không chặn
  /// hiển thị nội dung chính — giống `GrammarRepository.fetchCompletedLessonIds`.
  Future<List<String>> fetchCompletedIds() async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/user/reading-progress',
      );
      return (data['article_ids'] as List<dynamic>?)?.cast<String>() ?? [];
    } catch (_) {
      return [];
    }
  }

  /// Đánh dấu bài đọc đã hoàn thành. `score` là điểm quiz (0..100) nếu bài có
  /// bài tập; bỏ trống cho luồng "đánh dấu đã đọc" thủ công.
  Future<void> markComplete({
    required String articleId,
    required String level,
    int? score,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/user/reading-progress',
      body: {
        'article_id': articleId,
        'level': level,
        'score': ?score,
      },
    );
  }

  /// Top learners theo số bài đọc hoàn thành trong [level] (rỗng = tất cả
  /// level), nguồn `GET /reading-leaderboard?limit=&level=`.
  Future<List<ReadingLeaderboardEntry>> fetchLeaderboard({
    required String level,
    int limit = 10,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (level.isNotEmpty) query['level'] = level;
    final data = await _apiClient.get<List<dynamic>>(
      '/reading-leaderboard',
      query: query,
    );
    return data
        .map((e) => ReadingLeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Hạng của user hiện tại trong [level] (`null` khi chưa hoàn thành bài
  /// nào), nguồn `GET /user/reading-rank?level=`.
  Future<ReadingLeaderboardEntry?> fetchUserRank(String level) async {
    try {
      final query = <String, dynamic>{};
      if (level.isNotEmpty) query['level'] = level;
      final data = await _apiClient.get<Map<String, dynamic>?>(
        '/user/reading-rank',
        query: query,
      );
      if (data == null) return null;
      return ReadingLeaderboardEntry.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Lưu hàng loạt từ vựng (theo `learning_item_id`, đã match sẵn ở
  /// glossary/vocab của bài) vào hàng đợi ôn tập — nguồn
  /// `POST /user/word-reviews/add-batch`. Dùng chung cho reading + news
  /// (tương đương `srsService.addWordsBatch` của web, vốn gọi endpoint
  /// `/user/srs/add-batch` không tồn tại trên backend hiện tại — xem báo cáo
  /// P11 W4 §Deviations).
  Future<void> saveWordsBatch(List<String> learningItemIds, String source) async {
    if (learningItemIds.isEmpty) return;
    await _apiClient.post<Map<String, dynamic>>(
      '/user/word-reviews/add-batch',
      body: [
        for (final id in learningItemIds) {'learning_item_id': id, 'source': source},
      ],
    );
  }

  /// Ghép `audioUrl` (đường dẫn tương đối do backend trả, vd
  /// `/api/v1/reading/audio/A1/x.mp3`) với host gốc suy ra từ base URL của
  /// [ApiClient] (vốn đã có hậu tố `/api/v1`).
  String? resolveAudioUrl(String? audioUrl) {
    final path = audioUrl?.trim();
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;

    final base = Uri.parse(_apiClient.raw.options.baseUrl);
    final origin = Uri(scheme: base.scheme, host: base.host, port: base.port);
    return origin.resolve(path).toString();
  }
}

final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return ReadingRepository(ref.watch(apiClientProvider));
});
