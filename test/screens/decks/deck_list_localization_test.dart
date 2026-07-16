import 'package:deutschtiger/data/decks/deck_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/decks/deck_list_screen.dart';
import 'package:deutschtiger/view_models/decks/deck_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('deck list localizes its live-data chrome at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          decksProvider.overrideWith((ref) async => [_deck]),
          deckFoldersProvider.overrideWith((ref) async => const []),
          starredCardsProvider.overrideWith((ref) async => const []),
          defaultDeckIdProvider.overrideWith((ref) async => _deck.id),
          deckSummaryProvider.overrideWith(
            (ref) async => {
              _deck.id: const DeckSummaryRow(
                deckId: 'deck-1',
                total: 12,
                newCount: 4,
                learning: 4,
                known: 3,
                mastered: 1,
              ),
            },
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const DeckListScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Meine Karteikartensätze'), findsOneWidget);
    expect(find.text('Reisen'), findsOneWidget);
    expect(find.text('Standard'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

final _deck = Deck(
  id: 'deck-1',
  name: 'Reisen',
  description: 'Wörter für unterwegs',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);
