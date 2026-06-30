import '../../core/notifications/notification_contract.dart';

/// Preview notification service that returns success for all operations.
///
/// Use this for widget previews and storybook.
class PreviewNotificationService implements NotificationContract {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  }) async {}

  @override
  Future<void> cancelAll() async {}
}
