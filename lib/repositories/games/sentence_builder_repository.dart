import '../../data/games/sentence_builder_models.dart';
import '../../services/api_client.dart';

/// Repository cho Sentence Builder game — mirrors web
/// `src/lib/api/sentence-builder.ts`. Chấm câu (grading) TÁI DÙNG
/// `LearnRepository.gradeSentence` (endpoint `/ai/grade-sentence` dùng
/// chung, `target_blocks` optional) thay vì gọi lại HTTP client trực tiếp ở
/// đây — tránh trùng lặp logic parse response.
class SentenceBuilderRepository {
  SentenceBuilderRepository(this._api);

  final ApiClient _api;

  /// `GET /sentence-builder/topics?level=` — danh sách chủ đề + số từ mỗi
  /// chủ đề (dùng làm "preview" ngay trên màn chọn chủ đề, không cần màn
  /// riêng để xem trước từng từ).
  Future<List<SentenceBuilderTopic>> fetchTopics({String level = 'A1'}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/sentence-builder/topics',
      query: {'level': level},
    );
    final topics = json['topics'] as List<dynamic>? ?? const [];
    return topics
        .whereType<Map<String, dynamic>>()
        .map(SentenceBuilderTopic.fromJson)
        .toList(growable: false);
  }

  /// `POST /sentence-builder/session` — tạo phiên chơi mới. `topicId` null
  /// nghĩa là chủ đề ngẫu nhiên (backend tự chọn qua `get_random_topic_for_level`).
  Future<SentenceBuilderSession> createSession({
    required String level,
    String? topicId,
    int sessionSize = 10,
    bool preferEssential = true,
  }) async {
    final body = <String, dynamic>{
      'level': level,
      'sessionSize': sessionSize,
      'preferEssential': preferEssential,
    };
    if (topicId != null && topicId.isNotEmpty) body['topicId'] = topicId;

    final json = await _api.post<Map<String, dynamic>>(
      '/sentence-builder/session',
      body: body,
    );
    return SentenceBuilderSession.fromJson(json);
  }

  /// `POST /sentence-builder/session/:id/complete` — ghi nhận kết quả phiên.
  /// Fire-and-forget ở tầng gọi (UI không chặn màn kết quả nếu call này lỗi).
  Future<void> completeSession(
    String sessionId, {
    required int completedWords,
    required double averageScore,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/sentence-builder/session/$sessionId/complete',
      body: {'completedWords': completedWords, 'averageScore': averageScore},
    );
  }
}
