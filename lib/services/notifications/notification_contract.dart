/// Abstract interface for notification services.
///
/// Use this contract to enable dependency injection and testing with fakes.
abstract interface class NotificationContract {
  /// Initialize the notification service.
  /// Should be called once at app startup.
  Future<void> initialize();

  /// Check if notification permission has been granted.
  Future<bool> hasPermission();

  /// Request notification permission from the user.
  /// Returns true if permission was granted.
  Future<bool> requestPermission();

  /// Schedule a daily reminder notification.
  ///
  /// [hour] - Hour of day (0-23) for the reminder.
  /// [minute] - Minute of hour (0-59) for the reminder.
  /// [title] - Optional notification title.
  /// [body] - Optional notification body.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  });

  /// Cancel all scheduled notifications.
  Future<void> cancelAll();
}
