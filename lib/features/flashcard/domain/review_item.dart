import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_item.freezed.dart';
part 'review_item.g.dart';

/// Một thẻ ôn tập đến hạn — map từ `GET /api/v1/user/word-reviews/due`.
@freezed
abstract class ReviewItem with _$ReviewItem {
  const factory ReviewItem({
    required String id,
    @JsonKey(name: 'learning_item_id') @Default('') String learningItemId,
    @JsonKey(name: 'flashcard_id') String? flashcardId,
    @JsonKey(name: 'content_de') @Default('') String contentDe,
    @JsonKey(name: 'content_vi') @Default('') String contentVi,
    @JsonKey(name: 'audio_url') String? audioUrl,
    String? level,
    @Default(<ReviewExample>[]) List<ReviewExample> examples,
  }) = _ReviewItem;

  factory ReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ReviewItemFromJson(json);
}

/// Câu ví dụ kèm theo thẻ.
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

/// Đánh giá khi ôn thẻ. Gửi string lên `word-reviews/rate`.
/// Web map: Quên/Khó/Tốt/Dễ. FSRS tính phía server.
enum ReviewRating {
  forgot('forgot', 'Quên'),
  hard('hard', 'Khó'),
  medium('medium', 'Tốt'),
  easy('easy', 'Dễ');

  const ReviewRating(this.apiValue, this.labelVi);

  /// Giá trị gửi lên backend (field `rating`).
  final String apiValue;

  /// Nhãn tiếng Việt hiển thị trên nút.
  final String labelVi;
}
