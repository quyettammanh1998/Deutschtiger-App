/// `GET /user/unread-counts` — messages + notifications badge counts
/// (`internal/shared/notification/notification_handler.go` `GetUnreadCounts`).
class SocialUnreadCounts {
  const SocialUnreadCounts({required this.messages, required this.notifications});

  final int messages;
  final int notifications;

  static const zero = SocialUnreadCounts(messages: 0, notifications: 0);

  factory SocialUnreadCounts.fromJson(Map<String, dynamic> json) =>
      SocialUnreadCounts(
        messages: (json['messages'] as num?)?.toInt() ?? 0,
        notifications: (json['notifications'] as num?)?.toInt() ?? 0,
      );
}
