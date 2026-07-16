import '../../services/api_client.dart';

/// Request payload cho `POST /user/ai/explain-grammar` — giải thích sâu 1
/// câu trả lời sai bằng AI. Mirrors web `ExplainGrammarReq`.
class GrammarExplainRequest {
  const GrammarExplainRequest({
    required this.game,
    required this.exerciseKey,
    required this.sentence,
    required this.options,
    required this.correctAnswer,
    required this.userAnswer,
    required this.caseType,
    this.vi = '',
    this.reason = '',
  });

  final String game;
  final String exerciseKey;
  final String sentence;
  final List<String> options;
  final String correctAnswer;
  final String userAnswer;
  final String caseType;
  final String vi;
  final String reason;

  Map<String, dynamic> toJson() => {
    'game': game,
    'exerciseKey': exerciseKey,
    'sentence': sentence,
    'options': options,
    'correctAnswer': correctAnswer,
    'userAnswer': userAnswer,
    'case': caseType,
    'vi': vi,
    'reason': reason,
  };
}

/// `ok: false` means the caller should fall back to the static [reason] —
/// this is a normal degraded-mode response (HTTP 200), not an exception.
class GrammarExplainResult {
  const GrammarExplainResult({
    required this.explanation,
    required this.ok,
    required this.cached,
  });

  final String explanation;
  final bool ok;
  final bool cached;

  factory GrammarExplainResult.fromJson(Map<String, dynamic> json) =>
      GrammarExplainResult(
        explanation: json['explanation'] as String? ?? '',
        ok: json['ok'] as bool? ?? false,
        cached: json['cached'] as bool? ?? false,
      );
}

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

  /// `POST /ai/explain-grammar` — giải thích AI theo yêu cầu (on-demand,
  /// người dùng bấm nút) cho 1 câu trả lời sai. Backend cache theo
  /// `(game, exerciseKey, wrongAnswer)` và không bao giờ trả lỗi 5xx cho
  /// thất bại LLM (degrade còn `ok:false`) — repo giữ nguyên hành vi đó,
  /// KHÔNG throw khi `ok:false`.
  Future<GrammarExplainResult> explainGrammar(
    GrammarExplainRequest request,
  ) async {
    assert(
      validGames.contains(request.game),
      'game must be one of: ${validGames.join(', ')}',
    );
    final json = await _api.post<Map<String, dynamic>>(
      '/ai/explain-grammar',
      body: request.toJson(),
    );
    return GrammarExplainResult.fromJson(json);
  }
}
