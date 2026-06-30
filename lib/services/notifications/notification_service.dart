import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_contract.dart';
import 'local_notification_service.dart';

/// Wrapper service that delegates to the underlying implementation.
class NotificationServiceWrapper {
  NotificationServiceWrapper({NotificationContract? implementation})
      : _implementation = implementation ?? LocalNotificationServiceImpl();

  final NotificationContract _implementation;

  Future<void> init() => _implementation.initialize();
  Future<bool> hasPermission() => _implementation.hasPermission();
  Future<bool> requestPermission() => _implementation.requestPermission();
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  }) =>
      _implementation.scheduleDailyReminder(
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
  Future<void> cancelAll() => _implementation.cancelAll();
}

final notificationServiceProvider = Provider<NotificationContract>((ref) {
  return LocalNotificationServiceImpl();
});

final notificationServiceWrapperProvider = Provider<NotificationServiceWrapper>((ref) {
  return NotificationServiceWrapper();
});

class NotificationEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setEnabled(bool enabled) => state = enabled;
}

final notificationEnabledProvider = NotifierProvider<NotificationEnabledNotifier, bool>(
  NotificationEnabledNotifier.new,
);
