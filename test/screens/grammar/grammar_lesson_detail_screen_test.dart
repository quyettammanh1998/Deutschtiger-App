import 'package:deutschtiger/data/grammar/grammar_models.dart';
import 'package:deutschtiger/features/grammar/presentation/grammar_lesson_detail_screen.dart';
import 'package:deutschtiger/features/grammar/presentation/grammar_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: child,
      ),
    );
  }

  const key = (level: 'A1', id: 'l1');
  final lesson = const GrammarLesson(
    id: 'l1',
    title: 'Akkusativ',
    level: 'A1',
    tags: ['Cases'],
    contents: [
      GrammarTextBlock('Hallo Welt'),
      GrammarListBlock(['punkt eins', 'punkt zwei']),
    ],
    related: [],
  );

  testWidgets('shows lesson content blocks and mark-complete CTA', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const GrammarLessonDetailScreen(level: 'A1', id: 'l1'),
        overrides: [
          grammarLessonProvider(
            key,
          ).overrideWith((ref) async => lesson),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          grammarLessonIndexProvider.overrideWith(
            (ref) async => <GrammarLessonSummary>[],
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Akkusativ'), findsOneWidget);
    expect(find.text('Hallo Welt'), findsOneWidget);
    expect(find.textContaining('punkt eins'), findsOneWidget);
    expect(find.text('Đánh dấu hoàn thành'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows already-completed state when lesson is done', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const GrammarLessonDetailScreen(level: 'A1', id: 'l1'),
        overrides: [
          grammarLessonProvider(
            key,
          ).overrideWith((ref) async => lesson),
          grammarCompletedIdsProvider.overrideWith((ref) async => ['l1']),
          grammarLessonIndexProvider.overrideWith(
            (ref) async => <GrammarLessonSummary>[],
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Bạn đã hoàn thành bài này trước đó.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows not-found error view when lesson fetch fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const GrammarLessonDetailScreen(level: 'A1', id: 'missing'),
        overrides: [
          grammarLessonProvider((
            level: 'A1',
            id: 'missing',
          )).overrideWith((ref) => Future<GrammarLesson>.error('404')),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy bài học.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
