/// Kết quả chấm 1 từ viết ra từ `POST /ai/grade-word-writing` — AI so sánh
/// [correct] (đáp án đúng hay không), kèm gợi ý/tip ngắn bằng tiếng Việt.
/// Nguồn: `internal/shared/aihttp/word_writing_grading_handler.go`.
class WordGradeResult {
  const WordGradeResult({
    required this.correct,
    required this.hint,
    required this.suggestion,
  });

  final bool correct;
  final String hint;
  final String suggestion;

  factory WordGradeResult.fromJson(Map<String, dynamic> json) {
    return WordGradeResult(
      correct: json['correct'] as bool? ?? false,
      hint: json['hint'] as String? ?? '',
      suggestion: json['suggestion'] as String? ?? '',
    );
  }
}
