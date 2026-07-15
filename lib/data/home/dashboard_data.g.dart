// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    _DashboardData(
      profile: json['profile'] == null
          ? null
          : DashboardProfile.fromJson(json['profile'] as Map<String, dynamic>),
      gamification: json['gamification'] == null
          ? null
          : Gamification.fromJson(json['gamification'] as Map<String, dynamic>),
      missions:
          (json['missions'] as List<dynamic>?)
              ?.map((e) => Mission.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Mission>[],
      dueReviewCount: (json['due_review_count'] as num?)?.toInt() ?? 0,
      dueBacklogTotal: (json['due_backlog_total'] as num?)?.toInt() ?? 0,
      reviewsToday: (json['reviews_today'] as num?)?.toInt() ?? 0,
      wordsLearned: (json['words_learned'] as num?)?.toInt() ?? 0,
      lookupCount: (json['lookup_count'] as num?)?.toInt() ?? 0,
      flashcardDeckCount: (json['flashcard_deck_count'] as num?)?.toInt() ?? 0,
      onlineTimeToday: (json['online_time_today'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardDataToJson(_DashboardData instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'gamification': instance.gamification,
      'missions': instance.missions,
      'due_review_count': instance.dueReviewCount,
      'due_backlog_total': instance.dueBacklogTotal,
      'reviews_today': instance.reviewsToday,
      'words_learned': instance.wordsLearned,
      'lookup_count': instance.lookupCount,
      'flashcard_deck_count': instance.flashcardDeckCount,
      'online_time_today': instance.onlineTimeToday,
    };

_DashboardProfile _$DashboardProfileFromJson(Map<String, dynamic> json) =>
    _DashboardProfile(
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$DashboardProfileToJson(_DashboardProfile instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
    };

_Gamification _$GamificationFromJson(Map<String, dynamic> json) =>
    _Gamification(
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
      dailyXpToday: (json['daily_xp_today'] as num?)?.toInt() ?? 0,
      dailyGoal: (json['daily_goal'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$GamificationToJson(_Gamification instance) =>
    <String, dynamic>{
      'total_xp': instance.totalXp,
      'level': instance.level,
      'current_streak': instance.currentStreak,
      'longest_streak': instance.longestStreak,
      'daily_xp_today': instance.dailyXpToday,
      'daily_goal': instance.dailyGoal,
    };

_Mission _$MissionFromJson(Map<String, dynamic> json) => _Mission(
  id: json['id'] as String,
  targetCount: (json['target_count'] as num?)?.toInt() ?? 1,
  currentProgress: (json['current_progress'] as num?)?.toInt() ?? 0,
  xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
  titleVi: json['title_vi'] as String? ?? '',
  descriptionVi: json['description_vi'] as String? ?? '',
  icon: json['icon'] as String? ?? '',
  status: json['status'] as String? ?? 'active',
);

Map<String, dynamic> _$MissionToJson(_Mission instance) => <String, dynamic>{
  'id': instance.id,
  'target_count': instance.targetCount,
  'current_progress': instance.currentProgress,
  'xp_reward': instance.xpReward,
  'title_vi': instance.titleVi,
  'description_vi': instance.descriptionVi,
  'icon': instance.icon,
  'status': instance.status,
};
