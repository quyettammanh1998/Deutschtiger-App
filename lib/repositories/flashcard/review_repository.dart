import 'package:deutschtiger/services/api_client.dart';
import '../../data/flashcard/review_item.dart';

/// Kết quả trả về từ `POST /user/srs/review` — server tính FSRS xong, client
/// chỉ hiển thị lại due/state mới nếu cần.
class SrsReviewResult {
  const SrsReviewResult({
    required this.cardReviewId,
    required this.nextDue,
    required this.state,
  });

  final String cardReviewId;
  final DateTime nextDue;
  final int state;

  factory SrsReviewResult.fromJson(Map<String, dynamic> json) {
    return SrsReviewResult(
      cardReviewId: json['card_review_id'] as String? ?? '',
      nextDue:
          DateTime.tryParse(json['next_due'] as String? ?? '') ??
          DateTime.now(),
      state: (json['state'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Lấy thẻ đến hạn + gửi đánh giá. FSRS tính toàn bộ phía server
/// (KHÔNG tính toán FSRS client-side).
class ReviewRepository {
  ReviewRepository(this._api);

  final ApiClient _api;

  /// Thẻ đến hạn hôm nay (`GET /user/srs/queue`). Khi [deckId] được truyền,
  /// backend chỉ trả các thẻ thuộc deck đang luyện và tự kiểm tra ownership.
  Future<List<ReviewItem>> fetchDue({int limit = 50, String? deckId}) async {
    final list = await _api.get<List<dynamic>>(
      '/user/srs/queue',
      query: {
        'limit': limit,
        if (deckId != null && deckId.isNotEmpty) 'deck_id': deckId,
      },
    );
    return list
        .map((e) => ReviewItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Gửi đánh giá một thẻ (`POST /user/srs/review`).
  ///
  /// [item] cần đúng 1 trong 2 field `learningItemId`/`sourceFlashcardId`
  /// non-null (theo hợp đồng API) — được truyền lại nguyên trạng cho server.
  /// [mode] gắn nguồn luyện tập ('flashcard' | 'daily_review') để backend
  /// ghi nhận provenance.
  Future<SrsReviewResult> rate(
    ReviewItem item,
    ReviewRating rating, {
    required Duration responseTime,
    required String mode,
  }) async {
    final learningItemId = item.learningItemId;
    final sourceFlashcardId = item.sourceFlashcardId;
    final hasLearningItem = learningItemId != null && learningItemId.isNotEmpty;
    final hasSourceFlashcard =
        sourceFlashcardId != null && sourceFlashcardId.isNotEmpty;
    if (hasLearningItem == hasSourceFlashcard) {
      throw ArgumentError.value(
        item,
        'item',
        'must contain exactly one learning_item_id or source_flashcard_id',
      );
    }

    final json = await _api.post<Map<String, dynamic>>(
      '/user/srs/review',
      body: {
        if (hasLearningItem) 'learning_item_id': learningItemId,
        if (hasSourceFlashcard) 'source_flashcard_id': sourceFlashcardId,
        'rating': rating.apiRating,
        'response_time_ms': responseTime.inMilliseconds,
        'mode': mode,
      },
    );
    return SrsReviewResult.fromJson(json);
  }
}
