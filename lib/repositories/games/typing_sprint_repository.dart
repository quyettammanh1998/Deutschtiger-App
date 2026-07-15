import '../../data/games/typing_sprint_models.dart';
import '../../services/api_client.dart';

/// Repository cho Typing Sprint game — mirrors backend
/// `internal/feature/gamify/game/typing_handler.go`. Server ưu tiên câu
/// cá nhân hoá (SRS-prioritized từ `learning_items`) khi user có đủ dữ liệu,
/// fallback về bộ câu B1 tĩnh — client không cần biết nguồn nào được chọn.
class TypingSprintRepository {
  TypingSprintRepository(this._api);

  final ApiClient _api;

  /// `GET /user/typing/sentences?count=` — [count] phải trong khoảng
  /// 10-80 (giới hạn phía backend); mặc định 20 câu/phiên.
  Future<List<TypingSentence>> fetchSentences({int count = 20}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/typing/sentences',
      query: {'count': count},
    );
    final sentences = json['sentences'] as List<dynamic>? ?? const [];
    return sentences
        .whereType<Map<String, dynamic>>()
        .map(TypingSentence.fromJson)
        .toList(growable: false);
  }

  /// `POST /user/typing/results` — ghi nhận kết quả phiên chơi, backend tính
  /// XP (`floor(wpm * accuracy/100 * 0.5)`, cap 50/phiên, 100/ngày).
  Future<TypingResultResponse> submitResult({
    required int wpm,
    required double accuracy,
    required int cpm,
    required int correctWords,
    required int wrongWords,
    required int durationSec,
    String topicSet = '',
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/typing/results',
      body: {
        'wpm': wpm,
        'accuracy': accuracy,
        'cpm': cpm,
        'correctWords': correctWords,
        'wrongWords': wrongWords,
        'durationSec': durationSec,
        'topicSet': topicSet,
      },
    );
    return TypingResultResponse.fromJson(json);
  }
}
