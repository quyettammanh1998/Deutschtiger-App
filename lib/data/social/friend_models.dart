/// Friend/friendship DTOs matching the Go backend contract
/// (`internal/infra/database/friend_repo.go`, routes under
/// `GET/POST/PUT/DELETE /user/friends*`). Plain Dart, no codegen.
class FriendProfile {
  const FriendProfile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.level,
    required this.currentStreak,
    required this.totalXp,
    required this.friendshipStatus,
    this.friendshipId,
    this.mutualFriendsCount = 0,
    this.isOnline,
    this.lastSeenAt,
  });

  final String id;
  final String displayName;
  final String avatarUrl;
  final int level;
  final int currentStreak;
  final int totalXp;

  /// One of `none|pending_sent|pending_received|accepted|blocked` per backend.
  final String friendshipStatus;
  final String? friendshipId;
  final int mutualFriendsCount;
  final bool? isOnline;
  final String? lastSeenAt;

  factory FriendProfile.fromJson(Map<String, dynamic> json) => FriendProfile(
    id: json['id'] as String? ?? '',
    displayName: json['display_name'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String? ?? '',
    level: (json['level'] as num?)?.toInt() ?? 1,
    currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
    totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
    friendshipStatus: json['friendship_status'] as String? ?? 'none',
    friendshipId: json['friendship_id'] as String?,
    mutualFriendsCount: (json['mutual_friends_count'] as num?)?.toInt() ?? 0,
    isOnline: json['is_online'] as bool?,
    lastSeenAt: json['last_seen_at'] as String?,
  );
}

/// Nested requester profile inside a [FriendRequest].
class FriendRequestProfile {
  const FriendRequestProfile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.level,
    required this.currentStreak,
    required this.totalXp,
  });

  final String id;
  final String displayName;
  final String avatarUrl;
  final int level;
  final int currentStreak;
  final int totalXp;

  factory FriendRequestProfile.fromJson(Map<String, dynamic> json) =>
      FriendRequestProfile(
        id: json['id'] as String? ?? '',
        displayName: json['display_name'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String? ?? '',
        level: (json['level'] as num?)?.toInt() ?? 1,
        currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
        totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      );
}

class FriendRequest {
  const FriendRequest({
    required this.id,
    required this.requesterId,
    required this.addresseeId,
    required this.status,
    required this.createdAt,
    required this.requester,
  });

  final String id;
  final String requesterId;
  final String addresseeId;
  final String status;
  final DateTime createdAt;
  final FriendRequestProfile requester;

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
    id: json['id'] as String? ?? '',
    requesterId: json['requester_id'] as String? ?? '',
    addresseeId: json['addressee_id'] as String? ?? '',
    status: json['status'] as String? ?? 'pending',
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
    requester: FriendRequestProfile.fromJson(
      (json['requester'] as Map<String, dynamic>?) ?? const {},
    ),
  );
}

class FriendshipStatus {
  const FriendshipStatus({required this.status, this.friendshipId});

  final String status;
  final String? friendshipId;

  factory FriendshipStatus.fromJson(Map<String, dynamic> json) =>
      FriendshipStatus(
        status: json['status'] as String? ?? 'none',
        friendshipId: json['friendship_id'] as String?,
      );
}
