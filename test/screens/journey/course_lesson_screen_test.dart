import 'package:deutschtiger/features/journey/domain/course_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/journey/course_lesson_screen.dart';
import 'package:deutschtiger/view_models/journey/journey_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const slug = 'nicos-weg-a1';
  const key = LessonKey(slug, 1);

  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
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
    video: DwLessonVideo(title: 'Guten Tag', mp4: 'https://cdn.test/video.mp4'),
    vocabularies: [
      DwVocabularyItem(german: 'Hallo', vietnamese: 'Xin chào'),
    ],
    exerciseCount: 3,
  );

  testWidgets('shows video placeholder, vocabulary and mark-complete (happy path)', (
    tester,
  ) async {
    await tester.pumpWidget(wrap([
      lessonContentProvider(key).overrideWith((ref) async => lesson),
      lessonProgressProvider(key).overrideWith((ref) async => null),
      lessonNoteProvider(key).overrideWith((ref) async => null),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Xin chào'), findsWidgets);
    expect(find.text('Đánh dấu hoàn thành'), findsOneWidget);
    expect(find.textContaining('3 bài tập'), findsOneWidget);

    // Vocabulary/notes sections render below the fold — scroll to reveal them.
    await tester.scrollUntilVisible(find.text('Hallo'), 300);
    expect(find.text('Hallo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tolerates a lesson with no video/vocab/exercises (empty)', (
    tester,
  ) async {
    await tester.pumpWidget(wrap([
      lessonContentProvider(key).overrideWith(
        (ref) async => const DwLessonDetail(number: 1, name: 'Guten Tag'),
      ),
      lessonProgressProvider(key).overrideWith((ref) async => null),
      lessonNoteProvider(key).overrideWith((ref) async => null),
    ]));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
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
