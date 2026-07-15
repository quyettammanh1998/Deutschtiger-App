import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

/// Dữ liệu màn Home — map từ `GET /api/v1/user/dashboard-init` (1 round-trip).
/// Chỉ lấy các field V1 cần; bỏ qua field không dùng (preferences, lookup...).
@freezed
abstract class DashboardData with _$DashboardData {
  const factory DashboardData({
    DashboardProfile? profile,
    Gamification? gamification,
    @Default(<Mission>[]) List<Mission> missions,
    @JsonKey(name: 'due_review_count') @Default(0) int dueReviewCount,
    @JsonKey(name: 'due_backlog_total') @Default(0) int dueBacklogTotal,
    @JsonKey(name: 'reviews_today') @Default(0) int reviewsToday,
    @JsonKey(name: 'words_learned') @Default(0) int wordsLearned,
    @JsonKey(name: 'lookup_count') @Default(0) int lookupCount,
    @JsonKey(name: 'flashcard_deck_count') @Default(0) int flashcardDeckCount,
    @JsonKey(name: 'online_time_today') @Default(0) int onlineTimeToday,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

@freezed
abstract class DashboardProfile with _$DashboardProfile {
  const factory DashboardProfile({
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? email,
  }) = _DashboardProfile;

  factory DashboardProfile.fromJson(Map<String, dynamic> json) =>
      _$DashboardProfileFromJson(json);
}

/// XP / level / streak / mục tiêu ngày.
@freezed
abstract class Gamification with _$Gamification {
  const factory Gamification({
    @JsonKey(name: 'total_xp') @Default(0) int totalXp,
    @Default(1) int level,
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @JsonKey(name: 'longest_streak') @Default(0) int longestStreak,
    @JsonKey(name: 'daily_xp_today') @Default(0) int dailyXpToday,
    @JsonKey(name: 'daily_goal') @Default(50) int dailyGoal,
  }) = _Gamification;

  factory Gamification.fromJson(Map<String, dynamic> json) =>
      _$GamificationFromJson(json);
}

/// Một nhiệm vụ hằng ngày. status: 'active' | 'completed'.
@freezed
abstract class Mission with _$Mission {
  const factory Mission({
    required String id,
    @JsonKey(name: 'target_count') @Default(1) int targetCount,
    @JsonKey(name: 'current_progress') @Default(0) int currentProgress,
    @JsonKey(name: 'xp_reward') @Default(0) int xpReward,
    @JsonKey(name: 'title_vi') @Default('') String titleVi,
    @JsonKey(name: 'description_vi') @Default('') String descriptionVi,
    @Default('') String icon,
    @Default('active') String status,
  }) = _Mission;

  const Mission._();

  bool get isCompleted => status == 'completed';

  double get progressRatio =>
      targetCount == 0 ? 0 : (currentProgress / targetCount).clamp(0, 1);

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}
