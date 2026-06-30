// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JourneyChapter _$JourneyChapterFromJson(Map<String, dynamic> json) =>
    _JourneyChapter(
      id: json['id'] as String,
      level: json['level'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      description: json['description'] as String? ?? '',
      descriptionVi: json['descriptionVi'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map((e) => JourneyLesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <JourneyLesson>[],
      isLocked: json['isLocked'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$JourneyChapterToJson(_JourneyChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'description': instance.description,
      'descriptionVi': instance.descriptionVi,
      'order': instance.order,
      'totalLessons': instance.totalLessons,
      'completedLessons': instance.completedLessons,
      'progressPercent': instance.progressPercent,
      'lessons': instance.lessons,
      'isLocked': instance.isLocked,
      'isCompleted': instance.isCompleted,
    };

_JourneyLesson _$JourneyLessonFromJson(Map<String, dynamic> json) =>
    _JourneyLesson(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      description: json['description'] as String? ?? '',
      descriptionVi: json['descriptionVi'] as String? ?? '',
      type: json['type'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
    );

Map<String, dynamic> _$JourneyLessonToJson(_JourneyLesson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'description': instance.description,
      'descriptionVi': instance.descriptionVi,
      'type': instance.type,
      'order': instance.order,
      'durationMinutes': instance.durationMinutes,
      'xpReward': instance.xpReward,
      'isCompleted': instance.isCompleted,
      'isLocked': instance.isLocked,
    };

_LearningItem _$LearningItemFromJson(
  Map<String, dynamic> json,
) => _LearningItem(
  id: json['id'] as String,
  word: json['word'] as String,
  translation: json['translation'] as String,
  pronunciation: json['pronunciation'] as String? ?? '',
  level: json['level'] as String? ?? '',
  category: json['category'] as String? ?? '',
  example: json['example'] as String? ?? '',
  exampleTranslation: json['exampleTranslation'] as String? ?? '',
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  antonyms:
      (json['antonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  isLearned: json['isLearned'] as bool? ?? false,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LearningItemToJson(_LearningItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'translation': instance.translation,
      'pronunciation': instance.pronunciation,
      'level': instance.level,
      'category': instance.category,
      'example': instance.example,
      'exampleTranslation': instance.exampleTranslation,
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
      'isLearned': instance.isLearned,
      'reviewCount': instance.reviewCount,
      'correctCount': instance.correctCount,
    };

_JourneyProgress _$JourneyProgressFromJson(
  Map<String, dynamic> json,
) => _JourneyProgress(
  odlId: json['odlId'] as String,
  currentLevel: json['currentLevel'] as String? ?? '',
  totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
  streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
  completedLessonIds:
      (json['completedLessonIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  bookmarkedLessonIds:
      (json['bookmarkedLessonIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  totalLessonsCompleted: (json['totalLessonsCompleted'] as num?)?.toInt() ?? 0,
  totalTimeSpentMinutes: (json['totalTimeSpentMinutes'] as num?)?.toInt() ?? 0,
  lastActivityAt: json['lastActivityAt'] == null
      ? null
      : DateTime.parse(json['lastActivityAt'] as String),
);

Map<String, dynamic> _$JourneyProgressToJson(_JourneyProgress instance) =>
    <String, dynamic>{
      'odlId': instance.odlId,
      'currentLevel': instance.currentLevel,
      'totalXp': instance.totalXp,
      'streakDays': instance.streakDays,
      'completedLessonIds': instance.completedLessonIds,
      'bookmarkedLessonIds': instance.bookmarkedLessonIds,
      'totalLessonsCompleted': instance.totalLessonsCompleted,
      'totalTimeSpentMinutes': instance.totalTimeSpentMinutes,
      'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
    };
