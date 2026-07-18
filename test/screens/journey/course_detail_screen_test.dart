import 'package:deutschtiger/features/journey/domain/course_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/journey/course_detail_screen.dart';
import 'package:deutschtiger/view_models/journey/journey_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const slug = 'nicos-weg-a1';

  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const CourseDetailScreen(slug: slug),
      ),
    );
  }

  const detail = DwCourseDetail(
    id: 1,
    slug: slug,
    name: 'Nicos Weg A1',
    nameVi: 'Nicos Weg A1',
    level: CourseLevel.a1,
    totalLessons: 2,
    lessons: [
      DwCourseLessonSummary(
        id: 1,
        number: 1,
        name: 'Lektion 1',
        nameVi: 'Chào hỏi',
      ),
      DwCourseLessonSummary(
        id: 2,
        number: 2,
        name: 'Lektion 2',
        nameVi: 'Số đếm',
      ),
    ],
  );

  testWidgets('shows lesson list with completed progress (happy path)', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        courseDetailProvider(slug).overrideWith((ref) async => detail),
        courseProgressProvider(slug).overrideWith(
          (ref) async => {
            1: const CourseLessonProgress(
              lessonNumber: 1,
              videoCompleted: true,
            ),
          },
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nicos Weg A1'), findsOneWidget);
    expect(find.text('Chào hỏi'), findsOneWidget);
    expect(find.text('Số đếm'), findsOneWidget);
    expect(find.text('Hoàn thành'), findsOneWidget);
    expect(find.text('Chưa học'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty state when the course has no lessons yet', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        courseDetailProvider(slug).overrideWith(
          (ref) async => const DwCourseDetail(
            id: 1,
            slug: slug,
            name: 'Nicos Weg A1',
            level: CourseLevel.a1,
          ),
        ),
        courseProgressProvider(slug).overrideWith((ref) async => const {}),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Khoá học này chưa có bài học.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows retry button when the course fails to load', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        courseDetailProvider(
          slug,
        ).overrideWith((ref) async => Future<DwCourseDetail>.error('boom')),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
