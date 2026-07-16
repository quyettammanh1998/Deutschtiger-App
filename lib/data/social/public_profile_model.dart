/// Public profile aggregate (`GET /api/v1/profiles/{userId}`) —
/// `internal/feature/user/profile/profile_handler.go` `PublicProfileResponse`.
/// Used for the `/social/profile/:userId` surface (web `/u/:id` equivalent).
class SocialPublicProfile {
  const SocialPublicProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.activeTitle,
    required this.createdAt,
    required this.isPremium,
    required this.isOnline,
    this.lastSeen,
    this.currentActivity,
    required this.level,
    required this.totalXp,
    required this.weeklyXp,
    required this.currentStreak,
    required this.longestStreak,
    this.cefrLevel,
    required this.friendsCount,
    required this.totalFlashcards,
    required this.wordsLearned,
    required this.totalReviews,
    required this.weeklyRank,
    required this.recentActivities,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;
  final String? activeTitle;
  final String createdAt;
  final bool isPremium;
  final bool isOnline;
  final String? lastSeen;
  final String? currentActivity;
  final int level;
  final int totalXp;
  final int weeklyXp;
  final int currentStreak;
  final int longestStreak;
  final String? cefrLevel;
  final int friendsCount;
  final int totalFlashcards;
  final int wordsLearned;
  final int totalReviews;
  final int? weeklyRank;
  final List<SocialProfileActivity> recentActivities;

  factory SocialPublicProfile.fromJson(Map<String, dynamic> json) =>
      SocialPublicProfile(
        id: json['id'] as String? ?? '',
        displayName: json['display_name'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String?,
        activeTitle: json['active_title'] as String?,
        createdAt: json['created_at'] as String? ?? '',
        isPremium: json['is_premium'] as bool? ?? false,
        isOnline: json['is_online'] as bool? ?? false,
        lastSeen: json['last_seen'] as String?,
        currentActivity: json['current_activity'] as String?,
        level: (json['level'] as num?)?.toInt() ?? 1,
        totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
        weeklyXp: (json['weekly_xp'] as num?)?.toInt() ?? 0,
        currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
        longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
        cefrLevel: json['cefr_level'] as String?,
        friendsCount: (json['friends_count'] as num?)?.toInt() ?? 0,
        totalFlashcards: (json['total_flashcards'] as num?)?.toInt() ?? 0,
        wordsLearned: (json['words_learned'] as num?)?.toInt() ?? 0,
        totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
        weeklyRank: (json['weekly_rank'] as num?)?.toInt(),
        recentActivities: (json['recent_activities'] as List<dynamic>? ?? [])
            .map((e) => SocialProfileActivity.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// One row of `recent_activities` on the public profile — activity-feed
/// event (`database.RecentActivity`).
class SocialProfileActivity {
  const SocialProfileActivity({
    required this.id,
    required this.eventType,
    required this.eventData,
    required this.createdAt,
  });

  final String id;
  final String eventType;
  final Map<String, dynamic> eventData;
  final String createdAt;

  factory SocialProfileActivity.fromJson(Map<String, dynamic> json) =>
      SocialProfileActivity(
        id: json['id'] as String? ?? '',
        eventType: json['event_type'] as String? ?? '',
        eventData: (json['event_data'] as Map<String, dynamic>?) ?? const {},
        createdAt: json['created_at'] as String? ?? '',
      );
}
