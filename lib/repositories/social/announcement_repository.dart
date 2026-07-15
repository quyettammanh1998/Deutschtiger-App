import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/data/social/announcement_model.dart';

/// Public announcements — `GET /api/v1/announcements?page=&public_only=`
/// (`internal/feature/social/announcement/announcement_handler.go`).
/// Read-only; admin CRUD is intentionally not wired in the app.
class AnnouncementRepository {
  AnnouncementRepository(this._api);

  final ApiClient _api;

  Future<List<Announcement>> getActive({String? page}) async {
    final query = <String, dynamic>{'public_only': 'true'};
    if (page != null) query['page'] = page;
    final json = await _api.get<List<dynamic>>(
      '/announcements',
      query: query,
    );
    return json
        .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
