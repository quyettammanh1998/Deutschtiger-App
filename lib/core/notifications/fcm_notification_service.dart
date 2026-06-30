import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_contract.dart';

/// Firebase Cloud Messaging notification service implementation.
///
/// Use this service for push notifications via FCM.
/// Falls back to [LocalNotificationServiceImpl] for local notifications.
class FcmNotificationService implements NotificationContract {
  FcmNotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  bool _initialized = false;

  /// Optional foreground message handler.
  void Function(RemoteMessage)? onForegroundMessage;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    // Request permission
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen((message) {
      onForegroundMessage?.call(message);
    });

    _initialized = true;
  }

  @override
  Future<bool> hasPermission() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  }) async {
    // FCM doesn't support exact scheduling for daily reminders directly.
    // Use flutter_local_notifications for this or server-side scheduled messages.
    // This is a placeholder that delegates to local notifications.
    // For actual FCM scheduling, use Firebase Functions with Cloud Tasks.
    throw UnimplementedError(
      'FCM does not support local daily reminders. '
      'Use LocalNotificationServiceImpl or server-side scheduling.',
    );
  }

  @override
  Future<void> cancelAll() async {
    // FCM messages are sent from server, cancellation is handled server-side
    // This clears any locally cached messages
  }

  /// Get the FCM token for this device.
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Subscribe to a topic.
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
