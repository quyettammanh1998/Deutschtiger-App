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
    expect(find.byTooltip('Neuen Satz erstellen'), findsOneWidget);
    expect(find.text('12 Wörter'), findsOneWidget);
    expect(find.text('4/12 gelernt'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

final _deck = Deck(
  id: 'deck-1',
  name: 'Reisen',
  description: 'Wörter für unterwegs',
  wordCount: 12,
  learnedCount: 4,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);
