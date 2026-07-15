import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../features/journey/domain/course_models.dart';

/// Repository cho DW course catalog + course/lesson progress + notes.
///
/// Course catalog/detail/lesson content are public (no auth); progress,
/// notes and "my courses" require a signed-in user and are gated server-side
/// behind the course premium module.
class JourneyRepository {
  JourneyRepository(this._apiClient);
  final ApiClient _apiClient;

  static const _levelOrder = ['a1', 'a2', 'b1', 'b2'];
  static const _levelLabels = {
    'a1': 'A1',
    'a2': 'A2',
    'b1': 'B1',
    'b2': 'B2',
  };

  /// Danh sach khoa hoc theo level.
  /// API: GET /api/v1/courses
  Future<List<CourseGroup>> getCourseCatalog() async {
    final data = await _apiClient.get<Map<String, dynamic>>('/courses');
    final levels = data['levels'] as Map<String, dynamic>? ?? const {};
    final groups = <CourseGroup>[];
    for (final levelKey in _levelOrder) {
      final levelJson = levels[levelKey] as Map<String, dynamic>?;
      if (levelJson == null) continue;
      final level = courseLevelFromString(levelKey);
      final coursesRaw = levelJson['courses'] as List<dynamic>? ?? const [];
      final courses = coursesRaw
          .whereType<Map<String, dynamic>>()
          .map((c) => Course.fromIndexJson(c, level))
          .toList();
      groups.add(CourseGroup(
        level: levelKey,
        label: levelJson['name'] as String? ?? _levelLabels[levelKey] ?? levelKey.toUpperCase(),
        nameVi: levelJson['nameVi'] as String? ?? levelJson['name'] as String? ?? levelKey.toUpperCase(),
        courses: courses,
      ));
    }
    return groups;
  }

  /// Chi tiet mot khoa hoc (danh sach bai hoc).
  /// API: GET /api/v1/courses/{slug}
  Future<DwCourseDetail> getCourseDetail(String slug) async {
    final data = await _apiClient.get<Map<String, dynamic>>('/courses/$slug');
    return DwCourseDetail.fromJson(data);
  }

  /// Noi dung mot bai hoc.
  /// API: GET /api/v1/courses/{slug}/lessons/{num}
  Future<DwLessonDetail> getLesson(String slug, int lessonNumber) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/courses/$slug/lessons/$lessonNumber',
    );
    return DwLessonDetail.fromJson(data);
  }

  /// Khoa hoc noi bat tren trang chu.
  /// API: GET /api/v1/featured-courses
  Future<List<FeaturedCourseConfig>> getFeaturedCourses() async {
    final data = await _apiClient.get<List<dynamic>>('/featured-courses');
    return data
        .whereType<Map<String, dynamic>>()
        .map(FeaturedCourseConfig.fromJson)
        .toList();
  }

  /// Khoa hoc nguoi dung da bat dau hoc. Tra ve rong khi chua dang nhap hoac
  /// chua co quyen truy cap module course (giong web `getMyCourseSlugs`).
  /// API: GET /api/v1/user/courses/my-courses
  Future<List<MyCourseEntry>> getMyCourses() async {
    try {
      final data = await _apiClient.get<List<dynamic>>('/user/courses/my-courses');
      return data.whereType<Map<String, dynamic>>().map(MyCourseEntry.fromJson).toList();
    } on ApiException {
      return const [];
    }
  }

  /// Tien do toan bo khoa hoc (theo bai hoc). Tra ve rong khi chua dang nhap.
  /// API: GET /api/v1/user/courses/{slug}/progress
  Future<List<CourseLessonProgress>> getCourseProgress(String slug) async {
    try {
      final data = await _apiClient.get<List<dynamic>>('/user/courses/$slug/progress');
      return data.whereType<Map<String, dynamic>>().map(CourseLessonProgress.fromJson).toList();
    } on ApiException {
      return const [];
    }
  }

  /// Tien do mot bai hoc cu the (null neu chua bat dau, chua dang nhap hoac
  /// chua co quyen — server tra ve JSON `null` khi chua co ban ghi, va co
  /// the tra loi 401/403 khi khong du quyen; ca hai deu coi la "chua bat dau"
  /// giong hanh vi web `courseProgressService.getLessonProgress`).
  /// API: GET /api/v1/user/courses/{slug}/lessons/{num}/progress
  Future<CourseLessonProgress?> getLessonProgress(String slug, int lessonNumber) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>?>(
        '/user/courses/$slug/lessons/$lessonNumber/progress',
      );
      if (data == null) return null;
      return CourseLessonProgress.fromJson(data);
    } on ApiException {
      return null;
    }
  }

  /// Luu tien do bai hoc (video hoan thanh, giay da xem, diem bai tap).
  /// API: PUT /api/v1/user/courses/{slug}/lessons/{num}/progress
  Future<CourseLessonProgress> upsertLessonProgress({
    required String slug,
    required int lessonNumber,
    required bool videoCompleted,
    int lastWatchedSeconds = 0,
    int scoreTotal = 0,
    int scoreCorrect = 0,
    int scorePercentage = 0,
  }) async {
    final data = await _apiClient.put<Map<String, dynamic>>(
      '/user/courses/$slug/lessons/$lessonNumber/progress',
      body: {
        'video_completed': videoCompleted,
        'last_watched_seconds': lastWatchedSeconds,
        'score_total': scoreTotal,
        'score_correct': scoreCorrect,
        'score_percentage': scorePercentage,
      },
    );
    return CourseLessonProgress.fromJson(data);
  }

  /// Lay ghi chu cua mot bai hoc (null neu chua co hoac chua dang nhap).
  /// API: GET /api/v1/user/courses/{slug}/lessons/{num}/notes
  Future<CourseLessonNote?> getLessonNote(String slug, int lessonNumber) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>?>(
        '/user/courses/$slug/lessons/$lessonNumber/notes',
      );
      if (data == null) return null;
      return CourseLessonNote.fromJson(data);
    } on ApiException {
      return null;
    }
  }

  /// Luu ghi chu cua mot bai hoc.
  /// API: PUT /api/v1/user/courses/{slug}/lessons/{num}/notes
  Future<CourseLessonNote> upsertLessonNote({
    required String slug,
    required int lessonNumber,
    required String content,
  }) async {
    final data = await _apiClient.put<Map<String, dynamic>>(
      '/user/courses/$slug/lessons/$lessonNumber/notes',
      body: {'content': content},
    );
    return CourseLessonNote.fromJson(data);
  }
}

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  return JourneyRepository(ref.watch(apiClientProvider));
});
