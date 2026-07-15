import 'package:deutschtiger/services/api_client.dart';
import '../../data/games/word_writing_models.dart';

/// Chấm từ viết ra cho Writing Word game — `POST /ai/grade-word-writing`
/// (đã live, dùng chung với thẻ viết từ trong bài học từ vựng — xem
/// `word_writing_grading_handler.go`). Rate-limited 30/h phía server; cache
/// theo (user_input, target_word) nên lỗi chính tả phổ biến trả nhanh.
class WordWritingRepository {
  WordWritingRepository(this._api);

  final ApiClient _api;

  Future<WordGradeResult> gradeWord({
    required String userInput,
    required String targetWord,
    required String targetVi,
    required String level,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/ai/grade-word-writing',
      body: {
        'user_input': userInput,
        'target_word': targetWord,
        'target_vi': targetVi,
        'level': level,
      },
    );
    return WordGradeResult.fromJson(json);
  }
}
