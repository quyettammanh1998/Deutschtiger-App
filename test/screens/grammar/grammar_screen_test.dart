import 'package:deutschtiger/data/grammar/grammar_models.dart';
import 'package:deutschtiger/features/grammar/presentation/grammar_provider.dart';
import 'package:deutschtiger/features/grammar/presentation/grammar_screen.dart';
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

  testWidgets('grammar list shows level cards with live lesson data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      wrap(
        const GrammarScreen(),
        overrides: [
          grammarLessonIndexProvider.overrideWith(
            (ref) async => [
              const GrammarLessonSummary(
                id: 'l1',
                title: 'Akkusativ',
                level: 'A1',
                tags: ['Cases'],
              ),
            ],
          ),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A1'), findsOneWidget);
    expect(find.text('C1'), findsOneWidget);
    expect(find.textContaining('Akkusativ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('grammar level detail shows empty state when no lessons', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const GrammarScreen(initialLevel: 'A1'),
        overrides: [
          grammarLessonIndexProvider.overrideWith((ref) async => <GrammarLessonSummary>[]),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          grammarArticleIndexProvider.overrideWith(
            (ref) async => <String, List<GrammarArticleMeta>>{},
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0/0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('grammar list shows retry button on load error', (tester) async {
    await tester.pumpWidget(
      wrap(
        const GrammarScreen(),
        overrides: [
          grammarLessonIndexProvider.overrideWith(
            (ref) => Future<List<GrammarLessonSummary>>.error('network error'),
          ),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
