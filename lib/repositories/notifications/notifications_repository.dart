import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/notifications/notification_models.dart';

/// In-app notification center + notification preferences. Backend routes:
/// `GET/POST /user/notifications`, `GET /user/notifications/unread-count`,
/// `GET /user/unread-counts`, `PUT /user/notifications/{id}/read`,
/// `PUT /user/notifications/read-all`,
/// `GET/PUT /user/notification-preferences`.
///
/// Mobile has no FCM-backed push delivery yet — unread counts are refreshed
/// on app resume + pull-to-refresh only (no background polling).
class NotificationsRepository {
  NotificationsRepository(this._api);

  final ApiClient _api;

  /// `GET /user/notifications?limit=`.
  Future<List<AppNotification>> getNotifications({int limit = 20}) async {
    final list = await _api.get<List<dynamic>>(
      '/user/notifications',
      query: {'limit': limit},
    );
    return list
        .whereType<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
  }

  /// `GET /user/unread-counts`.
  Future<UnreadCounts> getUnreadCounts() async {
    final json = await _api.get<Map<String, dynamic>>('/user/unread-counts');
    return UnreadCounts.fromJson(json);
  }

  /// `PUT /user/notifications/{id}/read`.
  Future<void> markAsRead(String id) async {
    await _api.put<dynamic>('/user/notifications/$id/read');
  }

  /// `PUT /user/notifications/read-all`.
  Future<void> markAllAsRead() async {
    await _api.put<dynamic>('/user/notifications/read-all');
  }

  /// `GET /user/notification-preferences`.
  Future<NotificationPreferences> getPreferences() async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/notification-preferences',
    );
    return NotificationPreferences.fromJson(json);
  }

  /// `PUT /user/notification-preferences`.
  Future<NotificationPreferences> savePreferences(
    NotificationPreferences preferences,
  ) async {
    final json = await _api.put<Map<String, dynamic>>(
      '/user/notification-preferences',
      body: preferences.toJson(),
    );
    return NotificationPreferences.fromJson(json);
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(ref.watch(apiClientProvider));
});
