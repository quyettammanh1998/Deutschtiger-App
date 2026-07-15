import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_item.freezed.dart';
part 'review_item.g.dart';

/// Một thẻ ôn tập đến hạn — map từ `GET /api/v1/user/srs/queue`.
///
/// Backend FSRS pool hợp nhất 2 nguồn thẻ: học từ `learning_items` (qua
/// [learningItemId]) hoặc từ flashcard tự thêm (qua [sourceFlashcardId]).
/// Đúng 1 trong 2 field non-null trên mỗi thẻ — khi gửi đánh giá lên
/// `/user/srs/review`, client PHẢI gửi lại đúng field non-null đó.
@freezed
abstract class ReviewItem with _$ReviewItem {
  const factory ReviewItem({
    @JsonKey(name: 'card_review_id') String? cardReviewId,
    @JsonKey(name: 'learning_item_id') String? learningItemId,
    @JsonKey(name: 'source_flashcard_id') String? sourceFlashcardId,
    @Default(0) int state,
    DateTime? due,
    @JsonKey(name: 'content_de') String? contentDe,
    @JsonKey(name: 'content_vi') String? contentVi,
    @JsonKey(name: 'audio_url') String? audioUrl,
    String? level,
    @JsonKey(name: 'word_de') String? wordDe,
    @JsonKey(name: 'word_vi') String? wordVi,
    @JsonKey(name: 'flashcard_audio_url') String? flashcardAudioUrl,
    @Default(<ReviewExample>[]) List<ReviewExample> examples,
  }) = _ReviewItem;

  const ReviewItem._();

  /// ID ổn định cho `ValueKey` trong UI — ưu tiên card_review_id, fallback
  /// về 1 trong 2 id nguồn (đúng 1 cái non-null theo hợp đồng API).
  String get id =>
      cardReviewId ?? learningItemId ?? sourceFlashcardId ?? '';

  /// Mặt trước thẻ: learning_item content trước, flashcard content sau.
  String get displayDe => (contentDe?.isNotEmpty ?? false) ? contentDe! : (wordDe ?? '');

  /// Mặt sau thẻ (nghĩa tiếng Việt).
  String get displayVi => (contentVi?.isNotEmpty ?? false) ? contentVi! : (wordVi ?? '');

  /// Audio ưu tiên learning_item, fallback flashcard riêng.
  String? get displayAudioUrl => audioUrl ?? flashcardAudioUrl;

  factory ReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ReviewItemFromJson(json);
}

/// Câu ví dụ kèm theo thẻ (từ `learning_items.examples`, best-effort — có thể
/// rỗng nếu thẻ không có ví dụ hoặc backend chưa gán).
@freezed
abstract class ReviewExample with _$ReviewExample {
  const factory ReviewExample({
    @Default('') String de,
    @Default('') String vi,
    @JsonKey(name: 'audio_url') String? audioUrl,
  }) = _ReviewExample;

  factory ReviewExample.fromJson(Map<String, dynamic> json) =>
      _$ReviewExampleFromJson(json);
}

/// Đánh giá khi ôn thẻ, gửi lên `POST /user/srs/review` (field `rating`,
/// 1–4 theo go-fsrs: Again/Hard/Good/Easy). FSRS tính toàn bộ phía server.
enum ReviewRating {
  forgot(1, 'Quên'),
  hard(2, 'Khó'),
  medium(3, 'Tốt'),
  easy(4, 'Dễ');

  const ReviewRating(this.apiRating, this.labelVi);

  /// Giá trị int gửi lên backend (field `rating`, 1–4).
  final int apiRating;

  /// Nhãn tiếng Việt hiển thị trên nút.
  final String labelVi;

  /// >= medium (Tốt) được tính là "nhớ đúng" cho thống kê độ chính xác.
  bool get isCorrect => apiRating >= ReviewRating.medium.apiRating;
}
