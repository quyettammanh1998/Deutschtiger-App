/// Plain Dart models cho Typing Sprint game — mirrors backend
/// `internal/feature/gamify/game/typing_handler.go` (`Sentence`,
/// `submitResultRequest`). Không dùng freezed/json_serializable để tránh
/// race build_runner với các domain khác đang chạy song song.
library;

/// Một câu để gõ — `GET /user/typing/sentences`. Có thể là câu tĩnh (bộ
/// B1 sentences bundled ở backend) hoặc câu cá nhân hoá rút từ
/// `learning_items` của user (khi đó [learningItemId] non-null).
class TypingSentence {
  const TypingSentence({
    required this.id,
    required this.topic,
    required this.de,
    required this.vi,
    required this.wordCount,
    this.learningItemId,
  });

  final String id;
  final String topic;
  final String de;
  final String vi;
  final int wordCount;
  final String? learningItemId;

  factory TypingSentence.fromJson(Map<String, dynamic> json) {
    return TypingSentence(
      id: json['id'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      de: json['de'] as String? ?? '',
      vi: json['vi'] as String? ?? '',
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
      learningItemId: json['learning_item_id'] as String?,
    );
  }
}

/// Kết quả `POST /user/typing/results` sau khi backend tính XP + kiểm tra
/// daily cap (100 XP/ngày, tối đa 50 XP/phiên).
class TypingResultResponse {
  const TypingResultResponse({
    required this.id,
    required this.xpAwarded,
    required this.typingCapReached,
    required this.typingDailyCap,
  });

  final String id;
  final int xpAwarded;
  final bool typingCapReached;
  final int typingDailyCap;

  factory TypingResultResponse.fromJson(Map<String, dynamic> json) {
    return TypingResultResponse(
      id: json['id'] as String? ?? '',
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
      typingCapReached: json['typingCapReached'] as bool? ?? false,
      typingDailyCap: (json['typingDailyCap'] as num?)?.toInt() ?? 0,
    );
  }
}
