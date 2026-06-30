import 'package:deutschtiger/services/notifications/notification_contract.dart';

/// Fake notification service for unit testing.
///
/// Tracks method calls and allows controlled test behavior.
class FakeNotificationService implements NotificationContract {
  bool permissionGranted;
  bool requestResult;
  int initializeCount = 0;
  int requestCount = 0;
  int scheduleCount = 0;
  int cancelCount = 0;
  int? lastHour;
  int? lastMinute;
  String? lastTitle;
  String? lastBody;
  bool throwOnInitialize = false;
  bool throwOnRequest = false;
  bool throwOnSchedule = false;
  bool throwOnCancel = false;

  FakeNotificationService({
    this.permissionGranted = false,
    bool? requestResult,
  }) : requestResult = requestResult ?? permissionGranted;

  @override
  Future<void> initialize() async {
    initializeCount++;
    if (throwOnInitialize) {
      throw StateError('initialize failed');
    }
  }

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<bool> requestPermission() async {
    requestCount++;
    if (throwOnRequest) {
      throw StateError('request failed');
    }

    permissionGranted = requestResult;
    return requestResult;
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  }) async {
    if (throwOnSchedule) {
      throw StateError('schedule failed');
    }

    scheduleCount++;
    lastHour = hour;
    lastMinute = minute;
    lastTitle = title;
    lastBody = body;
  }

  @override
  Future<void> cancelAll() async {
    if (throwOnCancel) {
      throw StateError('cancel failed');
    }
    cancelCount++;
  }

  /// Reset all counters and state.
  void reset() {
    initializeCount = 0;
    requestCount = 0;
    scheduleCount = 0;
    cancelCount = 0;
    lastHour = null;
    lastMinute = null;
    lastTitle = null;
    lastBody = null;
    throwOnInitialize = false;
    throwOnRequest = false;
    throwOnSchedule = false;
    throwOnCancel = false;
  }
}
