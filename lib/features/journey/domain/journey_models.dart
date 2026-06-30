import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_models.freezed.dart';
part 'journey_models.g.dart';

/// Journey chapter (A1, A2, B1, B2, C1, C2)
@freezed
abstract class JourneyChapter with _$JourneyChapter {
  const factory JourneyChapter({
    required String id,
    required String level,
    required String title,
    required String titleVi,
    @Default('') String description,
    @Default('') String descriptionVi,
    @Default(0) int order,
    @Default(0) int totalLessons,
    @Default(0) int completedLessons,
    @Default(0.0) double progressPercent,
    @Default(<JourneyLesson>[]) List<JourneyLesson> lessons,
    @Default(false) bool isLocked,
    @Default(false) bool isCompleted,
  }) = _JourneyChapter;

  factory JourneyChapter.fromJson(Map<String, dynamic> json) =>
      _$JourneyChapterFromJson(json);
}

/// Journey lesson within a chapter
@freezed
abstract class JourneyLesson with _$JourneyLesson {
  const factory JourneyLesson({
    required String id,
    required String chapterId,
    required String title,
    required String titleVi,
    @Default('') String description,
    @Default('') String descriptionVi,
    @Default('') String type,
    @Default(0) int order,
    @Default(0) int durationMinutes,
    @Default(0) int xpReward,
    @Default(false) bool isCompleted,
    @Default(false) bool isLocked,
  }) = _JourneyLesson;

  factory JourneyLesson.fromJson(Map<String, dynamic> json) =>
      _$JourneyLessonFromJson(json);
}

/// Learning item (vocabulary/grammar point)
@freezed
abstract class LearningItem with _$LearningItem {
  const factory LearningItem({
    required String id,
    required String word,
    required String translation,
    @Default('') String pronunciation,
    @Default('') String level,
    @Default('') String category,
    @Default('') String example,
    @Default('') String exampleTranslation,
    @Default(<String>[]) List<String> synonyms,
    @Default(<String>[]) List<String> antonyms,
    @Default(false) bool isLearned,
    @Default(0) int reviewCount,
    @Default(0) int correctCount,
  }) = _LearningItem;

  factory LearningItem.fromJson(Map<String, dynamic> json) =>
      _$LearningItemFromJson(json);
}

/// User's journey progress
@freezed
abstract class JourneyProgress with _$JourneyProgress {
  const factory JourneyProgress({
    required String odlId,
    @Default('') String currentLevel,
    @Default(0) int totalXp,
    @Default(0) int streakDays,
    @Default(<String>[]) List<String> completedLessonIds,
    @Default(<String>[]) List<String> bookmarkedLessonIds,
    @Default(0) int totalLessonsCompleted,
    @Default(0) int totalTimeSpentMinutes,
    DateTime? lastActivityAt,
  }) = _JourneyProgress;

  factory JourneyProgress.fromJson(Map<String, dynamic> json) =>
      _$JourneyProgressFromJson(json);
}
