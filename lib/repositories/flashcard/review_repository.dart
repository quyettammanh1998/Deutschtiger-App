import 'package:deutschtiger/services/api_client.dart';
import '../domain/review_item.dart';

/// Lấy thẻ đến hạn + gửi đánh giá. FSRS tính phía server.
class ReviewRepository {
  ReviewRepository(this._api);

  final ApiClient _api;

  /// Thẻ đến hạn hôm nay (`GET /user/word-reviews/due`).
  Future<List<ReviewItem>> fetchDue({int limit = 20}) async {
    final list = await _api.get<List<dynamic>>(
      '/user/word-reviews/due',
      query: {'limit': limit},
    );
    return list
        .map((e) => ReviewItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Số thẻ đến hạn (`GET /user/word-reviews/due-count`).
  Future<int> fetchDueCount() async {
    final res = await _api.get<Map<String, dynamic>>(
      '/user/word-reviews/due-count',
    );
    return (res['count'] as num?)?.toInt() ?? 0;
  }

  /// Gửi đánh giá một thẻ (`POST /user/word-reviews/rate`).
  /// Body: { review_id, rating } — rating ∈ forgot|hard|medium|easy.
  Future<void> rate(String reviewId, ReviewRating rating) async {
    await _api.post<dynamic>(
      '/user/word-reviews/rate',
      body: {'review_id': reviewId, 'rating': rating.apiValue},
    );
  }
}
