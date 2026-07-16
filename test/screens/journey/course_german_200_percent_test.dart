import 'package:deutschtiger/features/journey/domain/course_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/journey/course_detail_screen.dart';
import 'package:deutschtiger/screens/journey/course_lesson_screen.dart';
import 'package:deutschtiger/screens/journey/courses_hub_screen.dart';
import 'package:deutschtiger/view_models/journey/journey_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// German 200% text-scale reflow smoke test — plan protocol requires new UI
/// to not overflow at German 200%. Lesson-page uses `video: null` (see
/// `course_lesson_screen_test.dart` note on `webview_flutter` platform
/// limits under plain `flutter test`).
void main() {
  const slug = 'nicos-weg-a1';

  const course = Course(
    id: 1,
    slug: slug,
    name: 'Nicos Weg — Deutsch für Anfänger und Anfängerinnen A1',
    nameVi: 'Nicos Weg — Tiếng Đức cho người mới bắt đầu A1',
    totalLessons: 77,
    level: CourseLevel.a1,
  );
  const group = CourseGroup(level: 'a1', label: 'A1', nameVi: 'A1', courses: [course]);

  const detail = DwCourseDetail(
    id: 1,
    slug: slug,
    name: 'Nicos Weg — Deutsch für Anfänger und Anfängerinnen A1',
    nameVi: 'Nicos Weg — Tiếng Đức cho người mới bắt đầu A1',
    level: CourseLevel.a1,
    totalLessons: 2,
    lessons: [
      DwCourseLessonSummary(id: 1, number: 1, name: 'Ein Anruf bei der Bank in Berlin'),
      DwCourseLessonSummary(id: 2, number: 2, name: 'Zweite Lektion'),
    ],
  );

  Widget wrap(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 844),
            textScaler: TextScaler.linear(2),
          ),
          child: child,
        ),
      ),
    );
  }

  testWidgets('course hub reflows at German 200% without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap(const CoursesHubScreen(), [
      courseCatalogProvider.overrideWith((ref) async => const [group]),
      featuredCoursesProvider.overrideWith((ref) async => const [course]),
      myCoursesProvider.overrideWith((ref) async => const []),
    ]));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('course detail reflows at German 200% without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap(const CourseDetailScreen(slug: slug), [
      courseDetailProvider(slug).overrideWith((ref) async => detail),
      courseProgressProvider(slug).overrideWith((ref) async => const {}),
    ]));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('course lesson reflows at German 200% without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const key = LessonKey(slug, 1);
    const lesson = DwLessonDetail(
      number: 1,
      name: 'Ein Anruf bei der Bank in Berlin',
      description: 'Nico braucht ein Konto und geht zur Bank in Berlin-Kreuzberg.',
      vocabularies: [
        DwVocabularyItem(german: 'die Bank', vietnamese: 'ngân hàng'),
      ],
    );

    await tester.pumpWidget(wrap(const CourseLessonScreen(slug: slug, lessonNumber: 1), [
      courseDetailProvider(slug).overrideWith((ref) async => detail),
      lessonContentProvider(key).overrideWith((ref) async => lesson),
      lessonProgressProvider(key).overrideWith((ref) async => null),
      lessonNoteProvider(key).overrideWith((ref) async => null),
    ]));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
