/// Read-only announcement (`GET /api/v1/announcements?page=&public_only=`) —
/// `internal/feature/social/announcement/announcement_handler.go`.
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.page,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final String page;
  final DateTime createdAt;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    content: json['content'] as String? ?? '',
    page: json['page'] as String? ?? '',
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
  );
}
