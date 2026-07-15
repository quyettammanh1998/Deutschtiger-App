import '../../data/games/learning_item_models.dart';
import '../../services/api_client.dart';

/// Repository dùng chung cho Artikel/Wortstellung/Fill-blank — mirrors web
/// `fetchBalancedLearningItems` (`src/lib/learning/learning-item-service.ts`),
/// gọi `GET /user/learning-items/balanced` (backend
/// `internal/feature/learning/learning/learning_handler.go#GetBalanced`).
/// Trả về pool cân bằng theo level (50/50 level hiện tại vs thấp hơn, ưu tiên
/// từ chưa ôn) — không cá nhân hoá sâu như Cases/Konjugation nhưng vẫn là dữ
/// liệu thật từ corpus `learning_items`.
class LearningItemRepository {
  LearningItemRepository(this._api);

  final ApiClient _api;

  /// [type] optional: `word` | `sentence` | `chunk` | `passage`.
  Future<List<LearningItem>> fetchBalanced({
    required String userLevel,
    String? type,
    int limit = 60,
  }) async {
    final query = <String, dynamic>{'user_level': userLevel, 'limit': limit};
    if (type != null) query['type'] = type;

    final json = await _api.get<List<dynamic>>(
      '/user/learning-items/balanced',
      query: query,
    );
    return json
        .whereType<Map<String, dynamic>>()
        .map(LearningItem.fromJson)
        .toList(growable: false);
  }
}
