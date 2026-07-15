/// Plain Dart DTOs for the in-app notification center. Hand-written
/// `fromJson`/`toJson` (no build_runner) — keeps this domain buildable
/// independently while other agents run codegen for their own domains.
library;

/// One notification row, as returned by `GET /user/notifications`
/// (`database.Notification`).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String type;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AppNotification(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      data: rawData is Map<String, dynamic> ? rawData : const {},
      isRead: json['read'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    type: type,
    data: data,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );
}

/// `GET /user/unread-counts` — messages + notifications unread counts.
class UnreadCounts {
  const UnreadCounts({this.messages = 0, this.notifications = 0});

  final int messages;
  final int notifications;

  factory UnreadCounts.fromJson(Map<String, dynamic> json) => UnreadCounts(
    messages: (json['messages'] as num?)?.toInt() ?? 0,
    notifications: (json['notifications'] as num?)?.toInt() ?? 0,
  );
}

/// `GET`/`PUT /user/notification-preferences`
/// (`database.NotificationPreferences`).
class NotificationPreferences {
  const NotificationPreferences({
    this.enabled = false,
    this.preferredTime = '07:00',
    this.timezone = '',
    this.contentMode = 'mix',
  });

  final bool enabled;
  final String preferredTime;
  final String timezone;
  final String contentMode; // "word" | "reminder" | "mix"

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    // BE returns notify_hour/notify_minute_bucket rather than a HH:mm
    // string; derive one for the time-picker UI.
    final hour = (json['notify_hour'] as num?)?.toInt();
    final minuteBucket = (json['notify_minute_bucket'] as num?)?.toInt();
    final preferredTime = json['preferred_time'] as String? ?? _fromHourMinute(hour, minuteBucket);
    return NotificationPreferences(
      enabled: json['enabled'] as bool? ?? false,
      preferredTime: preferredTime,
      timezone: json['timezone'] as String? ?? '',
      contentMode: json['content_mode'] as String? ?? 'mix',
    );
  }

  static String _fromHourMinute(int? hour, int? minuteBucket) {
    if (hour == null) return '07:00';
    final h = hour.clamp(0, 23).toString().padLeft(2, '0');
    final m = (minuteBucket ?? 0).clamp(0, 59).toString().padLeft(2, '0');
    return '$h:$m';
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'preferred_time': preferredTime,
    'timezone': timezone,
    'content_mode': contentMode,
  };

  NotificationPreferences copyWith({
    bool? enabled,
    String? preferredTime,
    String? timezone,
    String? contentMode,
  }) => NotificationPreferences(
    enabled: enabled ?? this.enabled,
    preferredTime: preferredTime ?? this.preferredTime,
    timezone: timezone ?? this.timezone,
    contentMode: contentMode ?? this.contentMode,
  );
}
