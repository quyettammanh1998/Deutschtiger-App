import 'package:deutschtiger/features/my_words/domain/my_word.dart';
import 'package:deutschtiger/features/my_words/presentation/my_words_screen.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const page = MyWordsPage(
    words: [
      MyWord(
        learningItemId: 'haus',
        contentDe: 'Haus',
        contentVi: 'ngôi nhà',
        status: 'saved',
        level: 'A1',
      ),
    ],
    total: 1,
    limit: 100,
    offset: 0,
  );

  const empty = MyWordsPage(words: [], total: 0, limit: 100, offset: 0);

  testWidgets('my words localizes group headings and live-data chrome at 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myWordsProvider(
            MyWordsFilter.saved,
          ).overrideWith((ref) async => page),
          myWordsProvider(
            MyWordsFilter.reviewing,
          ).overrideWith((ref) async => empty),
          myWordsProvider(
            MyWordsFilter.seen,
          ).overrideWith((ref) async => empty),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const MyWordsScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Web parity: the SegmentedButton filter toggle is gone; saved/seen/
    // reviewing are emoji-headed groups, and only non-empty ones render.
    expect(find.text('Meine Wörter'), findsOneWidget);
    expect(find.text('Im Notizbuch'), findsOneWidget);
    expect(find.text('In Wiederholung'), findsNothing);
    expect(find.text('Gesehen'), findsNothing);
    expect(find.text('Haus'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('my words does not expose a raw provider error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myWordsProvider(
            MyWordsFilter.saved,
          ).overrideWith((ref) => Future<MyWordsPage>.error('private detail')),
          myWordsProvider(
            MyWordsFilter.reviewing,
          ).overrideWith((ref) => Future<MyWordsPage>.error('private detail')),
          myWordsProvider(
            MyWordsFilter.seen,
          ).overrideWith((ref) => Future<MyWordsPage>.error('private detail')),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const MyWordsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Deine Wörter konnten nicht geladen werden. Bitte versuche es erneut.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('private detail'), findsNothing);
    expect(find.text('Erneut versuchen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
