import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/data/social/friend_models.dart';

/// Friends domain — `internal/feature/social/friend/friend_handler.go`,
/// mounted under `/user/friends*`.
class FriendRepository {
  FriendRepository(this._api);

  final ApiClient _api;

  Future<List<FriendProfile>> getFriends() async {
    final json = await _api.get<List<dynamic>>('/user/friends');
    return json
        .map((e) => FriendProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FriendRequest>> getPendingRequests() async {
    final json = await _api.get<List<dynamic>>('/user/friends/pending');
    return json
        .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FriendProfile>> searchUsers(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];
    final json = await _api.get<List<dynamic>>(
      '/user/friends/search',
      query: {'q': trimmed},
    );
    return json
        .map((e) => FriendProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FriendshipStatus> getStatus(String otherUserId) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/friends/status/$otherUserId',
    );
    return FriendshipStatus.fromJson(json);
  }

  Future<void> sendRequest(String addresseeId) async {
    await _api.post<Map<String, dynamic>>(
      '/user/friends/request',
      body: {'addressee_id': addresseeId},
    );
  }

  Future<void> acceptRequest(String requestId) async {
    await _api.put<Map<String, dynamic>>('/user/friends/$requestId/accept');
  }

  /// Reject a pending friend request (`DELETE /user/friends/{id}/reject`).
  Future<void> rejectRequest(String requestId) async {
    await _api.delete<Map<String, dynamic>>(
      '/user/friends/$requestId/reject',
    );
  }

  /// Remove an accepted friendship (`DELETE /user/friends/{friendshipId}`).
  Future<void> removeFriend(String friendshipId) async {
    await _api.delete<Map<String, dynamic>>('/user/friends/$friendshipId');
  }

  /// Blocks a user site-wide. Backend has no unblock/list-blocked endpoint
  /// yet — see `docs/api-changelog.md` gap entry.
  Future<void> blockUser(String targetUserId) async {
    await _api.post<Map<String, dynamic>>(
      '/user/friends/block',
      body: {'target_user_id': targetUserId},
    );
  }
}
