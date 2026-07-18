import 'package:deutschtiger/data/grammar/grammar_models.dart';
import 'package:deutschtiger/features/grammar/presentation/grammar_lesson_detail_screen.dart';
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
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2.0)),
          child: child!,
        ),
        home: child,
      ),
    );
  }

  testWidgets('grammar list at DE 200% does not overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
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
                title: 'Sehr sehr sehr langer Titel fuer den Test',
                level: 'A1',
                tags: ['Verben'],
              ),
            ],
          ),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('grammar lesson detail at DE 200% does not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const key = (level: 'A1', id: 'l1');
    const lesson = GrammarLesson(
      id: 'l1',
      title: 'Akkusativ',
      level: 'A1',
      tags: ['Cases'],
      contents: [GrammarTextBlock('Hallo Welt')],
      related: [],
    );
    await tester.pumpWidget(
      wrap(
        const GrammarLessonDetailScreen(level: 'A1', id: 'l1'),
        overrides: [
          grammarLessonProvider(key).overrideWith((ref) async => lesson),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          grammarLessonIndexProvider.overrideWith(
            (ref) async => <GrammarLessonSummary>[],
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
