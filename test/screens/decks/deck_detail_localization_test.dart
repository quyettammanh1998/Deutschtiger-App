import 'package:deutschtiger/data/decks/deck_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/decks/deck_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('deck detail localizes live-data chrome at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deckWordsProvider('deck-1').overrideWith(
            (ref) async => [
              DeckWord(
                id: 'card-1',
                wordId: 'word-1',
                word: 'Haus',
                translation: 'ngôi nhà',
                addedAt: DateTime.utc(2026),
              ),
            ],
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const DeckDetailScreen(deckId: 'deck-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Karteikartensätze'), findsOneWidget);
    expect(find.text('Fällige Karten wiederholen'), findsOneWidget);
    expect(find.text('Haus'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('deck detail localizes its empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deckWordsProvider('deck-1').overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const DeckDetailScreen(deckId: 'deck-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dieser Satz enthält noch keine Karten.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
