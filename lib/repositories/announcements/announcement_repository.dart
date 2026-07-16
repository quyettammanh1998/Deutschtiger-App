import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';

/// One row from `GET /api/v1/announcements` (`database.Announcement`,
/// public — no auth required). Web parity:
/// `lib/announcement/announcement-service.ts` `Announcement`.
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final String content;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    content: json['content'] as String? ?? '',
  );
}

/// `GET /announcements?page=&public_only=` — public endpoint (verified via
/// `internal/feature/social/announcement/announcement_handler.go`
/// `GetActive` + live probe, recorded in
/// `docs/flutter-api-contract-matrix.md`).
class AnnouncementRepository {
  AnnouncementRepository(this._api);

  final ApiClient _api;

  Future<List<Announcement>> getActive(String page, {bool publicOnly = false}) async {
    final list = await _api.get<List<dynamic>>(
      '/announcements',
      query: {'page': page, 'public_only': publicOnly},
    );
    return list.whereType<Map<String, dynamic>>().map(Announcement.fromJson).toList();
  }
}

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepository(ref.watch(apiClientProvider));
});
