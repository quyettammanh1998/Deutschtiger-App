import 'package:deutschtiger/features/journey/domain/course_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/journey/course_lesson_screen.dart';
import 'package:deutschtiger/view_models/journey/journey_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE: lessons use `video: null` in these widget tests — self-hosted mp4
// playback goes through `webview_flutter`, which asserts on
// `WebViewPlatform.instance` (only registered on-device, not under plain
// `flutter test`). Video rendering is exercised manually/on-device instead;
// see the P11 W3 report.
void main() {
  const slug = 'nicos-weg-a1';
  const key = LessonKey(slug, 1);

  const detail = DwCourseDetail(
    id: 1,
    slug: slug,
    name: 'Nicos Weg A1',
    level: CourseLevel.a1,
    totalLessons: 1,
    lessons: [DwCourseLessonSummary(id: 1, number: 1, name: 'Guten Tag')],
  );

  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: [
        courseDetailProvider(slug).overrideWith((ref) async => detail),
        ...overrides,
      ],
      child: MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const CourseLessonScreen(slug: slug, lessonNumber: 1),
      ),
    );
  }

  const lesson = DwLessonDetail(
    number: 1,
    name: 'Guten Tag',
    nameVi: 'Xin chào',
    vocabularies: [
      DwVocabularyItem(german: 'Hallo', vietnamese: 'Xin chào'),
    ],
  );

  testWidgets('shows lesson heading, vocabulary and notes (happy path)', (tester) async {
    await tester.pumpWidget(wrap([
      lessonContentProvider(key).overrideWith((ref) async => lesson),
      lessonProgressProvider(key).overrideWith((ref) async => null),
      lessonNoteProvider(key).overrideWith((ref) async => null),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Bài 01: Guten Tag'), findsOneWidget);
    expect(find.textContaining('Từ vựng'), findsOneWidget);
    expect(find.text('Hallo'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tolerates a lesson with no video/vocab (empty)', (tester) async {
    await tester.pumpWidget(wrap([
      lessonContentProvider(key).overrideWith(
        (ref) async => const DwLessonDetail(number: 1, name: 'Guten Tag'),
      ),
      lessonProgressProvider(key).overrideWith((ref) async => null),
      lessonNoteProvider(key).overrideWith((ref) async => null),
    ]));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows retry button when the lesson fails to load', (tester) async {
    await tester.pumpWidget(wrap([
      lessonContentProvider(key).overrideWith(
        (ref) async => Future<DwLessonDetail>.error('boom'),
      ),
    ]));
    await tester.pumpAndSettle();

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
