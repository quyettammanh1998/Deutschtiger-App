import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/data/social/public_profile_model.dart';

/// Public profile aggregate — `GET /api/v1/profiles/{userId}`
/// (`internal/feature/user/profile/profile_handler.go` `GetPublicProfile`).
/// Backs the `/social/profile/:userId` surface (web `/u/:id` equivalent).
class PublicProfileRepository {
  PublicProfileRepository(this._api);

  final ApiClient _api;

  Future<SocialPublicProfile> getProfile(String userId) async {
    final json = await _api.get<Map<String, dynamic>>('/profiles/$userId');
    return SocialPublicProfile.fromJson(json);
  }
}
