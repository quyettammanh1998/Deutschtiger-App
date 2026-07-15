import 'package:deutschtiger/features/journey/domain/course_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/journey/courses_hub_screen.dart';
import 'package:deutschtiger/view_models/journey/journey_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const CoursesHubScreen(),
      ),
    );
  }

  const course = Course(
    id: 1,
    slug: 'nicos-weg-a1',
    name: 'Nicos Weg A1',
    nameVi: 'Nicos Weg A1',
    totalLessons: 77,
    level: CourseLevel.a1,
  );
  const group = CourseGroup(
    level: 'a1',
    label: 'A1',
    nameVi: 'A1',
    courses: [course],
  );

  testWidgets('shows catalog + featured course (happy path)', (tester) async {
    await tester.pumpWidget(wrap([
      courseCatalogProvider.overrideWith((ref) async => const [group]),
      featuredCoursesProvider.overrideWith((ref) async => const [course]),
      myCoursesProvider.overrideWith((ref) async => const []),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Nicos Weg A1'), findsWidgets);
    expect(find.text('A1'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty state when the catalog has no courses', (tester) async {
    await tester.pumpWidget(wrap([
      courseCatalogProvider.overrideWith((ref) async => const []),
      featuredCoursesProvider.overrideWith((ref) async => const []),
      myCoursesProvider.overrideWith((ref) async => const []),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có khoá học nào.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows retry button when the catalog fails to load', (tester) async {
    await tester.pumpWidget(wrap([
      courseCatalogProvider.overrideWith((ref) async => Future<List<CourseGroup>>.error('boom')),
      featuredCoursesProvider.overrideWith((ref) async => const []),
      myCoursesProvider.overrideWith((ref) async => const []),
    ]));
    await tester.pumpAndSettle();

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
