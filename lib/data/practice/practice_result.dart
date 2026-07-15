/// Kết quả một câu trả lời trong phiên luyện tập theo deck (cloze/listening/
/// matching/writing). Không map trực tiếp từ JSON — được build client-side
/// từ tương tác người dùng rồi (best-effort) đồng bộ lên `/user/srs/review`
/// qua [ReviewRepository] với `source_flashcard_id` = [cardId].
class PracticeResultEntry {
  const PracticeResultEntry({
    required this.cardId,
    required this.correct,
    this.userAnswer = '',
    this.correctAnswer = '',
  });

  /// ID thẻ trong deck (`DeckWord.id`), dùng làm `source_flashcard_id` khi
  /// đồng bộ FSRS.
  final String cardId;
  final bool correct;
  final String userAnswer;
  final String correctAnswer;
}

/// 4 chế độ luyện tập theo deck — tương ứng web `practice-page.tsx`
/// (`cloze` | `flashcards`(listening) | `matching` | `writing`).
enum PracticeMode { cloze, listening, matching, writing }
