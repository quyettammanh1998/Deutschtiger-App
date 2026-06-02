// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  displayName: json['display_name'] as String? ?? '',
  avatarUrl: json['avatar_url'] as String?,
  cefrLevel: json['cefr_level'] as String?,
  isPremium: json['is_premium'] as bool? ?? false,
  level: (json['level'] as num?)?.toInt() ?? 0,
  totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
  currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
  wordsLearned: (json['words_learned'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'display_name': instance.displayName,
  'avatar_url': instance.avatarUrl,
  'cefr_level': instance.cefrLevel,
  'is_premium': instance.isPremium,
  'level': instance.level,
  'total_xp': instance.totalXp,
  'current_streak': instance.currentStreak,
  'longest_streak': instance.longestStreak,
  'words_learned': instance.wordsLearned,
};
