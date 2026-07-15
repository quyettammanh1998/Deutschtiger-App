import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_models.freezed.dart';
part 'stats_models.g.dart';

/// Tổng lượt ôn FSRS + số từ đã học (reps > 0). `GET /user/review-stats`.
/// Streak/level/XP hôm nay KHÔNG nằm ở đây — dùng `dashboardProvider`
/// (đã có sẵn qua `GET /user/dashboard-init`).
@freezed
abstract class ReviewStats with _$ReviewStats {
  const factory ReviewStats({
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'words_learned') @Default(0) int wordsLearned,
  }) = _ReviewStats;

  factory ReviewStats.fromJson(Map<String, dynamic> json) =>
      _$ReviewStatsFromJson(json);
}

/// Một điểm XP theo ngày cho biểu đồ tuần. `GET /user/xp-daily-log?days=`.
@freezed
abstract class XpDailyLogEntry with _$XpDailyLogEntry {
  const factory XpDailyLogEntry({
    @JsonKey(name: 'log_date') required DateTime logDate,
    @JsonKey(name: 'xp_earned') @Default(0) int xpEarned,
  }) = _XpDailyLogEntry;

  factory XpDailyLogEntry.fromJson(Map<String, dynamic> json) =>
      _$XpDailyLogEntryFromJson(json);
}

/// Phân bố độ nhớ FSRS (mới/đang học/đang nhớ/thuộc lòng). `GET /user/srs/mastery`.
@freezed
abstract class MasterySummary with _$MasterySummary {
  const factory MasterySummary({
    @JsonKey(name: 'new') @Default(0) int newCount,
    @Default(0) int learning,
    @Default(0) int young,
    @Default(0) int mature,
    @Default(0) int total,
  }) = _MasterySummary;

  factory MasterySummary.fromJson(Map<String, dynamic> json) =>
      _$MasterySummaryFromJson(json);
}

/// Một ngày ôn tập từ cron `srs_daily_stats` (rỗng cho tới lần chạy đầu tiên).
/// `GET /user/srs/stats/daily?days=`.
@freezed
abstract class SrsDailyStat with _$SrsDailyStat {
  const factory SrsDailyStat({
    required String date,
    @JsonKey(name: 'reviews_count') @Default(0) int reviewsCount,
    @JsonKey(name: 'retention_rate') double? retentionRate,
    @Default(0) int lapses,
    @JsonKey(name: 'new_cards_added') @Default(0) int newCardsAdded,
  }) = _SrsDailyStat;

  factory SrsDailyStat.fromJson(Map<String, dynamic> json) =>
      _$SrsDailyStatFromJson(json);
}

/// Tổng hợp lỗi ngữ pháp theo loại, gộp từ nhiều nguồn (viết/nói/sentence
/// builder). `GET /user/error-patterns/summary`.
@freezed
abstract class ErrorPatternSummary with _$ErrorPatternSummary {
  const factory ErrorPatternSummary({
    @JsonKey(name: 'error_type') required String errorType,
    @JsonKey(name: 'total_count') @Default(0) int totalCount,
    @JsonKey(name: 'last_seen') DateTime? lastSeen,
    @JsonKey(name: 'example_original') String? exampleOriginal,
    @JsonKey(name: 'example_corrected') String? exampleCorrected,
    @Default(<String>[]) List<String> sources,
  }) = _ErrorPatternSummary;

  factory ErrorPatternSummary.fromJson(Map<String, dynamic> json) =>
      _$ErrorPatternSummaryFromJson(json);
}
