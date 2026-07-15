import '../../services/api_client.dart';

/// Kết quả 1 câu trả lời — dùng để submit lên
/// `POST /user/grammar-drill/results` sau khi kết thúc phiên.
class GrammarDrillResultInput {
  const GrammarDrillResultInput({
    required this.key,
    required this.correct,
    this.learningItemId,
  });

  final String key;
  final bool correct;

  /// Chỉ set cho konjugation khi câu hỏi lấy từ vốn từ cá nhân — backend
  /// dùng field này để ghi thêm 1 FSRS review vào `card_reviews`.
  final String? learningItemId;

  Map<String, dynamic> toJson() => {
        'key': key,
        'correct': correct,
        if (learningItemId != null) 'learning_item_id': learningItemId,
      };
}

/// Repository dùng chung cho mọi game "Cases Mastery" (akk-dat/adjektiv/
/// wechselprep/verb-case) và Konjugation — mirrors backend
/// `internal/feature/learning/grammar/grammar_drill_handler.go`. Ghi Leitner
/// progress; fire-and-forget ở tầng gọi (không chặn màn kết quả nếu lỗi).
class GrammarDrillRepository {
  GrammarDrillRepository(this._api);

  final ApiClient _api;

  static const validGames = {
    'akk-dat',
    'konjugation',
    'adjektiv',
    'wechselprep',
    'verb-case',
  };

  /// `POST /user/grammar-drill/results` — trả 204 khi thành công.
  Future<void> submitResults(
    String game,
    List<GrammarDrillResultInput> results,
  ) async {
    assert(
      validGames.contains(game),
      'game must be one of: ${validGames.join(', ')}',
    );
    if (results.isEmpty) return;
    await _api.post<void>(
      '/user/grammar-drill/results',
      body: {
        'game': game,
        'results': results.map((r) => r.toJson()).toList(growable: false),
      },
    );
  }
}
