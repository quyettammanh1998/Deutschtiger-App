/// Public profile aggregate (`GET /api/v1/profiles/{userId}`) —
/// `internal/feature/user/profile/profile_handler.go` `PublicProfileResponse`.
/// Used for the `/social/profile/:userId` surface (web `/u/:id` equivalent).
class SocialPublicProfile {
  const SocialPublicProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.activeTitle,
    required this.isOnline,
    this.lastSeen,
    required this.level,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    this.cefrLevel,
    required this.friendsCount,
    required this.wordsLearned,
    required this.totalReviews,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;
  final String? activeTitle;
  final bool isOnline;
  final String? lastSeen;
  final int level;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final String? cefrLevel;
  final int friendsCount;
  final int wordsLearned;
  final int totalReviews;

  factory SocialPublicProfile.fromJson(Map<String, dynamic> json) =>
      SocialPublicProfile(
        id: json['id'] as String? ?? '',
        displayName: json['display_name'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String?,
        activeTitle: json['active_title'] as String?,
        isOnline: json['is_online'] as bool? ?? false,
        lastSeen: json['last_seen'] as String?,
        level: (json['level'] as num?)?.toInt() ?? 1,
        totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
        currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
        longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
        cefrLevel: json['cefr_level'] as String?,
        friendsCount: (json['friends_count'] as num?)?.toInt() ?? 0,
        wordsLearned: (json['words_learned'] as num?)?.toInt() ?? 0,
        totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      );
}
