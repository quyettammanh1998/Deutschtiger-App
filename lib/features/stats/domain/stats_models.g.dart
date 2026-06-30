// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ErrorPattern _$ErrorPatternFromJson(Map<String, dynamic> json) =>
    _ErrorPattern(
      id: json['id'] as String,
      odlId: json['odlId'] as String,
      grammarCategory: json['grammarCategory'] as String,
      grammarCategoryVi: json['grammarCategoryVi'] as String,
      errorCount: (json['errorCount'] as num).toInt(),
      totalAttempts: (json['totalAttempts'] as num).toInt(),
      errorRate: (json['errorRate'] as num?)?.toDouble() ?? 0.0,
      exampleErrors:
          (json['exampleErrors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      suggestions:
          (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      lastOccurredAt: json['lastOccurredAt'] == null
          ? null
          : DateTime.parse(json['lastOccurredAt'] as String),
    );

Map<String, dynamic> _$ErrorPatternToJson(_ErrorPattern instance) =>
    <String, dynamic>{
      'id': instance.id,
      'odlId': instance.odlId,
      'grammarCategory': instance.grammarCategory,
      'grammarCategoryVi': instance.grammarCategoryVi,
      'errorCount': instance.errorCount,
      'totalAttempts': instance.totalAttempts,
      'errorRate': instance.errorRate,
      'exampleErrors': instance.exampleErrors,
      'suggestions': instance.suggestions,
      'lastOccurredAt': instance.lastOccurredAt?.toIso8601String(),
    };

_SRSStats _$SRSStatsFromJson(Map<String, dynamic> json) => _SRSStats(
  odlId: json['odlId'] as String,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
  totalCorrect: (json['totalCorrect'] as num?)?.toInt() ?? 0,
  totalIncorrect: (json['totalIncorrect'] as num?)?.toInt() ?? 0,
  retentionRate: (json['retentionRate'] as num?)?.toDouble() ?? 0.0,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  totalActiveDays: (json['totalActiveDays'] as num?)?.toInt() ?? 0,
  cardsLearned: (json['cardsLearned'] as num?)?.toInt() ?? 0,
  cardsMature: (json['cardsMature'] as num?)?.toInt() ?? 0,
  cardsYoung: (json['cardsYoung'] as num?)?.toInt() ?? 0,
  cardsRelearning: (json['cardsRelearning'] as num?)?.toInt() ?? 0,
  reviewsByDay:
      (json['reviewsByDay'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  retentionByDay:
      (json['retentionByDay'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const <String, double>{},
  intervalDistribution:
      (json['intervalDistribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
);

Map<String, dynamic> _$SRSStatsToJson(_SRSStats instance) => <String, dynamic>{
  'odlId': instance.odlId,
  'totalReviews': instance.totalReviews,
  'totalCorrect': instance.totalCorrect,
  'totalIncorrect': instance.totalIncorrect,
  'retentionRate': instance.retentionRate,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'totalActiveDays': instance.totalActiveDays,
  'cardsLearned': instance.cardsLearned,
  'cardsMature': instance.cardsMature,
  'cardsYoung': instance.cardsYoung,
  'cardsRelearning': instance.cardsRelearning,
  'reviewsByDay': instance.reviewsByDay,
  'retentionByDay': instance.retentionByDay,
  'intervalDistribution': instance.intervalDistribution,
};

_NearAchievement _$NearAchievementFromJson(Map<String, dynamic> json) =>
    _NearAchievement(
      achievementId: json['achievementId'] as String,
      name: json['name'] as String,
      nameVi: json['nameVi'] as String,
      description: json['description'] as String,
      descriptionVi: json['descriptionVi'] as String,
      icon: json['icon'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
      targetValue: (json['targetValue'] as num?)?.toInt() ?? 0,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NearAchievementToJson(_NearAchievement instance) =>
    <String, dynamic>{
      'achievementId': instance.achievementId,
      'name': instance.name,
      'nameVi': instance.nameVi,
      'description': instance.description,
      'descriptionVi': instance.descriptionVi,
      'icon': instance.icon,
      'progress': instance.progress,
      'currentValue': instance.currentValue,
      'targetValue': instance.targetValue,
      'xpReward': instance.xpReward,
    };

_StreakInfo _$StreakInfoFromJson(Map<String, dynamic> json) => _StreakInfo(
  odlId: json['odlId'] as String,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  totalActiveDays: (json['totalActiveDays'] as num?)?.toInt() ?? 0,
  weeklyGoal: (json['weeklyGoal'] as num?)?.toInt() ?? 0,
  weeklyProgress: (json['weeklyProgress'] as num?)?.toInt() ?? 0,
  activeDays:
      (json['activeDays'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ??
      const <DateTime>[],
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
);

Map<String, dynamic> _$StreakInfoToJson(
  _StreakInfo instance,
) => <String, dynamic>{
  'odlId': instance.odlId,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'totalActiveDays': instance.totalActiveDays,
  'weeklyGoal': instance.weeklyGoal,
  'weeklyProgress': instance.weeklyProgress,
  'activeDays': instance.activeDays.map((e) => e.toIso8601String()).toList(),
  'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
};

_TimeStats _$TimeStatsFromJson(Map<String, dynamic> json) => _TimeStats(
  odlId: json['odlId'] as String,
  totalMinutes: (json['totalMinutes'] as num?)?.toInt() ?? 0,
  todayMinutes: (json['todayMinutes'] as num?)?.toInt() ?? 0,
  weekMinutes: (json['weekMinutes'] as num?)?.toInt() ?? 0,
  monthMinutes: (json['monthMinutes'] as num?)?.toInt() ?? 0,
  minutesByFeature:
      (json['minutesByFeature'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  minutesByDay:
      (json['minutesByDay'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  averageMinutesPerDay: (json['averageMinutesPerDay'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$TimeStatsToJson(_TimeStats instance) =>
    <String, dynamic>{
      'odlId': instance.odlId,
      'totalMinutes': instance.totalMinutes,
      'todayMinutes': instance.todayMinutes,
      'weekMinutes': instance.weekMinutes,
      'monthMinutes': instance.monthMinutes,
      'minutesByFeature': instance.minutesByFeature,
      'minutesByDay': instance.minutesByDay,
      'averageMinutesPerDay': instance.averageMinutesPerDay,
    };
