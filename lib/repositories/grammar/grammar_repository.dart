import 'package:dio/dio.dart';

import 'package:deutschtiger/services/api_client.dart';
import '../../data/grammar/grammar_models.dart';

/// Repository cho Grammar surface.
///
/// Lesson index + lesson content đi qua Go API (public, không cần JWT):
/// `GET /grammar` và `GET /grammar/{level}/{id}`. Article (markdown tĩnh)
/// nằm NGOÀI `/api/v1`, giống lộ trình phỏng vấn — fetch bằng dio raw qua
/// [staticBaseUrl] (xem `InterviewRepository`). Progress đi qua API có JWT.
class GrammarRepository {
  GrammarRepository(this._api, this._staticBaseUrl);

  final ApiClient _api;
  final String _staticBaseUrl;

  /// `GET /grammar?level=&tag=` — tóm tắt toàn bộ bài học (không có `contents`).
  Future<List<GrammarLessonSummary>> fetchLessonIndex({
    String? level,
    String? tag,
  }) async {
    final data = await _api.get<List<dynamic>>(
      '/grammar',
      query: {
        // The suggested `?key: value` form treats the map *key* as
        // nullable, which triggers a real analyzer warning here (the key
        // is a string literal, never null) — keep the explicit `if`.
        if (level != null) 'level': level, // ignore: use_null_aware_elements
        if (tag != null) 'tag': tag, // ignore: use_null_aware_elements
      },
    );
    return data
        .whereType<Map<String, dynamic>>()
        .map(GrammarLessonSummary.fromJson)
        .toList();
  }

  /// `GET /grammar/{level}/{id}` — 1 bài học đầy đủ.
  Future<GrammarLesson> fetchLesson(String level, String id) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/grammar/${level.toLowerCase()}/$id',
    );
    return GrammarLesson.fromJson(data);
  }

  /// File tĩnh `data/grammar/articles/index.json` — map level → danh sách bài đọc.
  Future<Map<String, List<GrammarArticleMeta>>> fetchArticleIndex() async {
    final res = await _api.raw.get<Map<String, dynamic>>(
      '$_staticBaseUrl/data/grammar/articles/index.json',
    );
    final data = res.data ?? const <String, dynamic>{};
    final result = <String, List<GrammarArticleMeta>>{};
    for (final entry in data.entries) {
      final list = entry.value;
      if (list is! List) continue;
      result[entry.key] = list
          .whereType<Map<String, dynamic>>()
          .where((item) => item['missing'] != true)
          .map(GrammarArticleMeta.fromJson)
          .toList();
    }
    return result;
  }

  /// File tĩnh `.md` + frontmatter YAML đơn giản. Trả `null` khi không tìm
  /// thấy hoặc nội dung là trang 404 (parity với web).
  Future<GrammarArticle?> fetchArticle(String level, String slug) async {
    try {
      final res = await _api.raw.get<String>(
        '$_staticBaseUrl/data/grammar/articles/${level.toLowerCase()}/$slug.md',
        options: Options(responseType: ResponseType.plain),
      );
      final raw = res.data;
      if (raw == null || raw.isEmpty) return null;

      final parsed = _parseFrontmatter(raw);
      if (parsed.meta['title'] == '404' || parsed.body.length < 50) {
        return null;
      }

      return GrammarArticle(
        title: parsed.meta['title'] ?? slug,
        level: parsed.meta['level'] ?? level.toUpperCase(),
        slug: parsed.meta['slug'] ?? slug,
        source: parsed.meta['source'],
        markdown: parsed.body,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  ({Map<String, String> meta, String body}) _parseFrontmatter(String raw) {
    if (!raw.startsWith('---')) return (meta: const {}, body: raw);

    final end = raw.indexOf('\n---', 3);
    if (end == -1) return (meta: const {}, body: raw);

    final frontmatter = raw.substring(3, end).trim();
    final body = raw.substring(end + 4).trim();

    final meta = <String, String>{};
    for (final line in frontmatter.split('\n')) {
      final colonIdx = line.indexOf(':');
      if (colonIdx == -1) continue;
      final key = line.substring(0, colonIdx).trim();
      var value = line.substring(colonIdx + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }
      meta[key] = value;
    }
    return (meta: meta, body: body);
  }

  /// `GET /user/grammar-progress` — danh sách lesson_id đã hoàn thành.
  /// Chưa đăng nhập / lỗi mạng → trả rỗng, UI vẫn hiển thị bài học bình thường.
  Future<List<String>> fetchCompletedLessonIds() async {
    try {
      final data = await _api.get<Map<String, dynamic>>(
        '/user/grammar-progress',
      );
      return (data['lesson_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [];
    } on ApiException {
      return const [];
    }
  }

  /// `POST /user/grammar-progress` — đánh dấu 1 bài (lesson hoặc article,
  /// dùng `progressId` làm `lesson_id`) đã hoàn thành.
  Future<void> markComplete({required String lessonId, required String level}) {
    return _api.post<dynamic>(
      '/user/grammar-progress',
      body: {'lesson_id': lessonId, 'level': level},
    );
  }
}
