import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_models.freezed.dart';
part 'stats_models.g.dart';

/// Error pattern analysis
@freezed
abstract class ErrorPattern with _$ErrorPattern {
  const factory ErrorPattern({
    required String id,
    required String odlId,
    required String grammarCategory,
    required String grammarCategoryVi,
    required int errorCount,
    required int totalAttempts,
    @Default(0.0) double errorRate,
    @Default(<String>[]) List<String> exampleErrors,
    @Default(<String>[]) List<String> suggestions,
    DateTime? lastOccurredAt,
  }) = _ErrorPattern;

  factory ErrorPattern.fromJson(Map<String, dynamic> json) =>
      _$ErrorPatternFromJson(json);
}

/// SRS detailed stats
@freezed
abstract class SRSStats with _$SRSStats {
  const factory SRSStats({
    required String odlId,
    @Default(0) int totalReviews,
    @Default(0) int totalCorrect,
    @Default(0) int totalIncorrect,
    @Default(0.0) double retentionRate,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int totalActiveDays,
    @Default(0) int cardsLearned,
    @Default(0) int cardsMature,
    @Default(0) int cardsYoung,
    @Default(0) int cardsRelearning,
    @Default(<String, int>{}) Map<String, int> reviewsByDay,
    @Default(<String, double>{}) Map<String, double> retentionByDay,
    @Default(<String, int>{}) Map<String, int> intervalDistribution,
  }) = _SRSStats;

  factory SRSStats.fromJson(Map<String, dynamic> json) =>
      _$SRSStatsFromJson(json);
}

/// Near achievement
@freezed
abstract class NearAchievement with _$NearAchievement {
  const factory NearAchievement({
    required String achievementId,
    required String name,
    required String nameVi,
    required String description,
    required String descriptionVi,
    @Default('') String icon,
    @Default(0.0) double progress,
    @Default(0) int currentValue,
    @Default(0) int targetValue,
    @Default(0) int xpReward,
  }) = _NearAchievement;

  factory NearAchievement.fromJson(Map<String, dynamic> json) =>
      _$NearAchievementFromJson(json);
}

/// Learning streak info
@freezed
abstract class StreakInfo with _$StreakInfo {
  const factory StreakInfo({
    required String odlId,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int totalActiveDays,
    @Default(0) int weeklyGoal,
    @Default(0) int weeklyProgress,
    @Default(<DateTime>[]) List<DateTime> activeDays,
    DateTime? lastActiveAt,
  }) = _StreakInfo;

  factory StreakInfo.fromJson(Map<String, dynamic> json) =>
      _$StreakInfoFromJson(json);
}

/// Time spent statistics
@freezed
abstract class TimeStats with _$TimeStats {
  const factory TimeStats({
    required String odlId,
    @Default(0) int totalMinutes,
    @Default(0) int todayMinutes,
    @Default(0) int weekMinutes,
    @Default(0) int monthMinutes,
    @Default(<String, int>{}) Map<String, int> minutesByFeature,
    @Default(<String, int>{}) Map<String, int> minutesByDay,
    @Default(0) double averageMinutesPerDay,
  }) = _TimeStats;

  factory TimeStats.fromJson(Map<String, dynamic> json) =>
      _$TimeStatsFromJson(json);
}
