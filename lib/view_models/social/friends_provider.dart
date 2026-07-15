import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/data/social/friend_models.dart';
import 'social_repository_providers.dart';

/// Accepted friends list (`GET /user/friends`).
final friendsProvider = FutureProvider.autoDispose<List<FriendProfile>>((
  ref,
) async {
  return ref.watch(friendRepositoryProvider).getFriends();
});

/// Pending incoming/outgoing friend requests (`GET /user/friends/pending`).
final pendingFriendRequestsProvider =
    FutureProvider.autoDispose<List<FriendRequest>>((ref) async {
      return ref.watch(friendRepositoryProvider).getPendingRequests();
    });

/// User search for the "add friend" flow (`GET /user/friends/search?q=`).
final friendSearchProvider = FutureProvider.autoDispose
    .family<List<FriendProfile>, String>((ref, query) async {
      return ref.watch(friendRepositoryProvider).searchUsers(query);
    });

/// Mutations (send/accept/reject/remove/block) that invalidate the read
/// providers above on success so lists stay consistent.
class FriendsActions {
  FriendsActions(this._ref);

  final Ref _ref;

  Future<void> sendRequest(String addresseeId) async {
    await _ref.read(friendRepositoryProvider).sendRequest(addresseeId);
    _ref.invalidate(pendingFriendRequestsProvider);
  }

  Future<void> acceptRequest(String requestId) async {
    await _ref.read(friendRepositoryProvider).acceptRequest(requestId);
    _ref.invalidate(pendingFriendRequestsProvider);
    _ref.invalidate(friendsProvider);
  }

  Future<void> rejectRequest(String requestId) async {
    await _ref.read(friendRepositoryProvider).rejectRequest(requestId);
    _ref.invalidate(pendingFriendRequestsProvider);
  }

  Future<void> removeFriend(String friendshipId) async {
    await _ref.read(friendRepositoryProvider).removeFriend(friendshipId);
    _ref.invalidate(friendsProvider);
  }

  /// Blocks a user. Removes them from friends/requests immediately — the
  /// backend has no unblock endpoint yet (see `docs/api-changelog.md`).
  Future<void> blockUser(String targetUserId) async {
    await _ref.read(friendRepositoryProvider).blockUser(targetUserId);
    _ref.invalidate(friendsProvider);
    _ref.invalidate(pendingFriendRequestsProvider);
  }
}

final friendsActionsProvider = Provider.autoDispose<FriendsActions>((ref) {
  return FriendsActions(ref);
});
