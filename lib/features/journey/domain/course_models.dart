/// Course models (DW course catalog + lessons + progress/notes).
///
/// Simplified without Freezed — nested exercise/inquiry shapes vary a lot
/// between DW lessons, so manual `fromJson` keeps parsing forgiving of
/// missing/loose fields (mirrors `course-service.ts` on web).
library;

enum CourseLevel { a1, a2, b1, b2 }

enum CourseKind { dw, interview }

CourseLevel courseLevelFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'a2':
      return CourseLevel.a2;
    case 'b1':
      return CourseLevel.b1;
    case 'b2':
      return CourseLevel.b2;
    default:
      return CourseLevel.a1;
  }
}

/// A single course in the catalog (index.json entry).
class Course {
  const Course({
    required this.id,
    required this.slug,
    required this.name,
    this.nameVi,
    this.totalLessons = 0,
    this.poster,
    this.level = CourseLevel.a1,
    this.kind = CourseKind.dw,
  });

  final int id;
  final String slug;
  final String name;
  final String? nameVi;
  final int totalLessons;
  final String? poster;
  final CourseLevel level;
  final CourseKind kind;

  factory Course.fromIndexJson(Map<String, dynamic> json, CourseLevel level) {
    return Course(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameVi: json['nameVi'] as String?,
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      poster: json['poster'] as String?,
      level: level,
    );
  }
}

/// A level group ("a1", "a2", ...) in the course catalog.
class CourseGroup {
  const CourseGroup({
    required this.level,
    required this.label,
    required this.nameVi,
    this.courses = const [],
  });

  final String level;
  final String label;
  final String nameVi;
  final List<Course> courses;
}

/// Lesson summary as listed inside a course detail payload.
class DwCourseLessonSummary {
  const DwCourseLessonSummary({
    required this.id,
    required this.number,
    required this.name,
    this.nameVi,
    this.poster,
  });

  final int id;
  final int number;
  final String name;
  final String? nameVi;
  final String? poster;

  factory DwCourseLessonSummary.fromJson(Map<String, dynamic> json) {
    return DwCourseLessonSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      number: (json['number'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      nameVi: json['nameVi'] as String?,
      poster: json['poster'] as String?,
    );
  }
}

/// Full course detail (GET /api/v1/courses/{slug}).
class DwCourseDetail {
  const DwCourseDetail({
    required this.id,
    required this.slug,
    required this.name,
    required this.level,
    this.nameVi,
    this.totalLessons = 0,
    this.lessons = const [],
  });

  final int id;
  final String slug;
  final String name;
  final String? nameVi;
  final CourseLevel level;
  final int totalLessons;
  final List<DwCourseLessonSummary> lessons;

  factory DwCourseDetail.fromJson(Map<String, dynamic> json) {
    final lessonsRaw = json['lessons'] as List<dynamic>? ?? const [];
    final lessons = lessonsRaw
        .whereType<Map<String, dynamic>>()
        .map(DwCourseLessonSummary.fromJson)
        .toList();
    return DwCourseDetail(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameVi: json['nameVi'] as String?,
      level: courseLevelFromString(json['level'] as String?),
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? lessons.length,
      lessons: lessons,
    );
  }
}

/// One transcript line of a DW lesson video.
class CourseTranscriptSegment {
  const CourseTranscriptSegment({
    required this.start,
    required this.end,
    required this.text,
    this.textVi,
  });

  final String start;
  final String end;
  final String text;
  final String? textVi;

  factory CourseTranscriptSegment.fromJson(Map<String, dynamic> json) {
    return CourseTranscriptSegment(
      start: json['start']?.toString() ?? '',
      end: json['end']?.toString() ?? '',
      text: json['text'] as String? ?? '',
      textVi: (json['text_vi'] ?? json['textVi']) as String?,
    );
  }
}

/// Video attached to a DW lesson — either self-hosted (`mp4`) or a YouTube
/// reference (`youtubeId`). Never both actively rendered on this surface.
class DwLessonVideo {
  const DwLessonVideo({
    required this.title,
    this.titleVi,
    this.poster,
    this.mp4,
    this.youtubeId,
    this.duration = 0,
    this.transcript = const [],
  });

  final String title;
  final String? titleVi;
  final String? poster;
  final String? mp4;
  final String? youtubeId;
  final int duration;
  final List<CourseTranscriptSegment> transcript;

  bool get isSelfHosted => mp4 != null && mp4!.isNotEmpty;
  bool get isYoutube => youtubeId != null && youtubeId!.isNotEmpty;

  factory DwLessonVideo.fromJson(Map<String, dynamic> json) {
    final transcriptRaw = json['transcript'] as List<dynamic>? ?? const [];
    return DwLessonVideo(
      title: json['title'] as String? ?? '',
      titleVi: json['titleVi'] as String?,
      poster: json['poster'] as String?,
      mp4: json['mp4'] as String?,
      youtubeId: json['youtubeId'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      transcript: transcriptRaw
          .whereType<Map<String, dynamic>>()
          .map(CourseTranscriptSegment.fromJson)
          .toList(),
    );
  }
}

/// Vocabulary item taught inside a DW lesson.
class DwVocabularyItem {
  const DwVocabularyItem({
    required this.german,
    this.english,
    this.vietnamese,
    this.audioUrl,
  });

  final String german;
  final String? english;
  final String? vietnamese;
  final String? audioUrl;

  factory DwVocabularyItem.fromJson(Map<String, dynamic> json) {
    return DwVocabularyItem(
      german: json['german'] as String? ?? '',
      english: json['english'] as String?,
      vietnamese: json['vietnamese'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }
}

/// Lesson content (GET /api/v1/courses/{slug}/lessons/{num}).
///
/// Interactive exercises (`inquiries`/cloze/dictation) exist on the backend
/// but are not rendered here — that engine belongs to the web-parity
/// exercise surface, not this Courses/Journey phase. We only surface the
/// exercise count so users know more practice exists.
class DwLessonDetail {
  const DwLessonDetail({
    required this.number,
    required this.name,
    this.nameVi,
    this.description,
    this.descriptionVi,
    this.video,
    this.vocabularies = const [],
    this.exerciseCount = 0,
  });

  final int number;
  final String name;
  final String? nameVi;
  final String? description;
  final String? descriptionVi;
  final DwLessonVideo? video;
  final List<DwVocabularyItem> vocabularies;
  final int exerciseCount;

  factory DwLessonDetail.fromJson(Map<String, dynamic> json) {
    final vocabRaw = json['vocabularies'] as List<dynamic>? ?? const [];
    final exercisesRaw = json['exercises'] as List<dynamic>? ?? const [];
    final videoRaw = json['video'] as Map<String, dynamic>?;
    return DwLessonDetail(
      number: (json['number'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? json['title']) as String? ?? '',
      nameVi: (json['nameVi'] ?? json['titleVi']) as String?,
      description: json['description'] as String?,
      descriptionVi: json['descriptionVi'] as String?,
      video: videoRaw == null ? null : DwLessonVideo.fromJson(videoRaw),
      vocabularies: vocabRaw
          .whereType<Map<String, dynamic>>()
          .map(DwVocabularyItem.fromJson)
          .toList(),
      exerciseCount: exercisesRaw.length,
    );
  }
}

/// A slug DeutschTiger currently promotes on the course hub
/// (GET /api/v1/featured-courses).
class FeaturedCourseConfig {
  const FeaturedCourseConfig({required this.courseSlug, this.sortOrder = 0});

  final String courseSlug;
  final int sortOrder;

  factory FeaturedCourseConfig.fromJson(Map<String, dynamic> json) {
    return FeaturedCourseConfig(
      courseSlug: json['course_slug'] as String? ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// A course the signed-in user has started
/// (GET /api/v1/user/courses/my-courses).
class MyCourseEntry {
  const MyCourseEntry({
    required this.courseSlug,
    this.lastActive,
    this.lessonsStarted = 0,
  });

  final String courseSlug;
  final DateTime? lastActive;
  final int lessonsStarted;

  factory MyCourseEntry.fromJson(Map<String, dynamic> json) {
    return MyCourseEntry(
      courseSlug: json['course_slug'] as String? ?? '',
      lastActive: json['last_active'] == null
          ? null
          : DateTime.tryParse(json['last_active'] as String),
      lessonsStarted: (json['lessons_started'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Progress for one lesson within a course
/// (`/api/v1/user/courses/{slug}/lessons/{num}/progress`).
class CourseLessonProgress {
  const CourseLessonProgress({
    required this.lessonNumber,
    this.videoCompleted = false,
    this.lastWatchedSeconds = 0,
    this.scoreTotal = 0,
    this.scoreCorrect = 0,
    this.scorePercentage = 0,
    this.completedAt,
  });

  final int lessonNumber;
  final bool videoCompleted;
  final int lastWatchedSeconds;
  final int scoreTotal;
  final int scoreCorrect;
  final int scorePercentage;
  final DateTime? completedAt;

  factory CourseLessonProgress.fromJson(Map<String, dynamic> json) {
    return CourseLessonProgress(
      lessonNumber: (json['lesson_number'] as num?)?.toInt() ?? 0,
      videoCompleted: json['video_completed'] as bool? ?? false,
      lastWatchedSeconds: (json['last_watched_seconds'] as num?)?.toInt() ?? 0,
      scoreTotal: (json['score_total'] as num?)?.toInt() ?? 0,
      scoreCorrect: (json['score_correct'] as num?)?.toInt() ?? 0,
      scorePercentage: (json['score_percentage'] as num?)?.toInt() ?? 0,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.tryParse(json['completed_at'] as String),
    );
  }
}

/// Free-text note saved against a course lesson
/// (`/api/v1/user/courses/{slug}/lessons/{num}/notes`).
class CourseLessonNote {
  const CourseLessonNote({required this.content, this.updatedAt});

  final String content;
  final DateTime? updatedAt;

  factory CourseLessonNote.fromJson(Map<String, dynamic> json) {
    return CourseLessonNote(
      content: json['content'] as String? ?? '',
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}
