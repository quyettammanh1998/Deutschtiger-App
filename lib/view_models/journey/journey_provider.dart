import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/release/release_feature_flags.dart';
import '../../features/journey/domain/course_models.dart';
import '../../features/premium/domain/premium_providers.dart';
import '../../repositories/journey/journey_repository.dart';

/// Whether the user can access premium-gated courses/lessons beyond the free
/// limit. Mirrors web `isPremium || hasModule('course')`, gated by
/// [ReleaseFeatureFlags.premium] (default off): matching the app-wide
/// precedent (`PremiumBanner`) of hiding all premium chrome — including lock
/// badges the backend would otherwise 403 on — while the flag stays off.
final courseCanAccessAllProvider = FutureProvider<bool>((ref) async {
  if (!ReleaseFeatureFlags.premium) return true;
  return ref.watch(premiumProvider.future);
});

/// Toan bo catalog khoa hoc DW theo level (A1-B2).
final courseCatalogProvider = FutureProvider<List<CourseGroup>>((ref) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getCourseCatalog();
});

/// Danh sach khoa hoc phang (khong nhom theo level) — dung cho featured/my-courses lookup.
final _flatCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final groups = await ref.watch(courseCatalogProvider.future);
  return groups.expand((g) => g.courses).toList();
});

/// Mot khoa hoc theo slug (tim trong catalog da tai).
final courseBySlugProvider = FutureProvider.family<Course?, String>((ref, slug) async {
  final courses = await ref.watch(_flatCoursesProvider.future);
  for (final c in courses) {
    if (c.slug == slug) return c;
  }
  return null;
});

/// Khoa hoc noi bat (featured) tren trang hub — map slug -> Course object.
final featuredCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repo = ref.watch(journeyRepositoryProvider);
  final featured = await repo.getFeaturedCourses();
  final courses = await ref.watch(_flatCoursesProvider.future);
  final bySlug = {for (final c in courses) c.slug: c};
  final sorted = [...featured]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return sorted
      .map((f) => bySlug[f.courseSlug])
      .whereType<Course>()
      .toList();
});

/// Khoa hoc nguoi dung da bat dau hoc (yeu cau dang nhap).
final myCoursesProvider = FutureProvider<List<MyCourseEntry>>((ref) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getMyCourses();
});

/// Chi tiet khoa hoc (danh sach bai hoc) theo slug.
final courseDetailProvider = FutureProvider.family<DwCourseDetail, String>((ref, slug) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getCourseDetail(slug);
});

/// Tien do toan bo cac bai hoc trong mot khoa hoc, dang map theo so bai.
final courseProgressProvider = FutureProvider.family<Map<int, CourseLessonProgress>, String>((ref, slug) async {
  final repo = ref.watch(journeyRepositoryProvider);
  final progress = await repo.getCourseProgress(slug);
  return {for (final p in progress) p.lessonNumber: p};
});

/// Tham so cho lesson provider: slug khoa hoc + so thu tu bai hoc.
class LessonKey {
  const LessonKey(this.slug, this.lessonNumber);
  final String slug;
  final int lessonNumber;

  @override
  bool operator ==(Object other) =>
      other is LessonKey && other.slug == slug && other.lessonNumber == lessonNumber;

  @override
  int get hashCode => Object.hash(slug, lessonNumber);
}

/// Noi dung mot bai hoc cu the.
final lessonContentProvider = FutureProvider.family<DwLessonDetail, LessonKey>((ref, key) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getLesson(key.slug, key.lessonNumber);
});

/// Tien do rieng cua mot bai hoc (null neu chua bat dau).
final lessonProgressProvider = FutureProvider.family<CourseLessonProgress?, LessonKey>((ref, key) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getLessonProgress(key.slug, key.lessonNumber);
});

/// Ghi chu rieng cua mot bai hoc (null neu chua co).
final lessonNoteProvider = FutureProvider.family<CourseLessonNote?, LessonKey>((ref, key) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getLessonNote(key.slug, key.lessonNumber);
});
