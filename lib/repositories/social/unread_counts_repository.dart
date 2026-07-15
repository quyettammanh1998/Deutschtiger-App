import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/data/social/unread_counts_model.dart';

/// `GET /user/unread-counts` — combined messages + notifications badge
/// counts (`internal/shared/notification/notification_handler.go`).
class UnreadCountsRepository {
  UnreadCountsRepository(this._api);

  final ApiClient _api;

  Future<SocialUnreadCounts> getUnreadCounts() async {
    final json = await _api.get<Map<String, dynamic>>('/user/unread-counts');
    return SocialUnreadCounts.fromJson(json);
  }
}
