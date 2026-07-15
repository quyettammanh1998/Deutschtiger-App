import 'package:deutschtiger/data/decks/deck_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/decks/deck_repository.dart';
import 'package:deutschtiger/repositories/flashcard/flashcard_quick_save_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/shared/widgets/save_card_button.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('deck picker saves the selected deck and opens its route', (
    tester,
  ) async {
    final deckRepository = _FakeDeckRepository();
    final saveRepository = _FakeQuickSaveRepository();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: SaveCardButton(
              wordDe: 'Haus',
              wordVi: 'nhà',
              exampleSentence: 'Das ist mein Haus.',
            ),
          ),
        ),
        GoRoute(
          path: '/decks/:deckId',
          builder: (_, state) =>
              Scaffold(body: Text('Deck ${state.pathParameters['deckId']}')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deckRepositoryProvider.overrideWithValue(deckRepository),
          flashcardQuickSaveRepositoryProvider.overrideWithValue(
            saveRepository,
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 800),
              textScaler: TextScaler.linear(2),
            ),
            child: child!,
          ),
        ),
      ),
    );

    await tester.tap(find.text('In Stapel speichern'));
    await tester.pumpAndSettle();
    expect(find.text('Stapel auswählen'), findsOneWidget);

    await tester.ensureVisible(find.text('A1 cơ bản'));
    await tester.tap(find.text('A1 cơ bản'));
    await tester.pumpAndSettle();

    expect(saveRepository.calls, hasLength(1));
    expect(saveRepository.calls.single, {
      'wordDe': 'Haus',
      'wordVi': 'nhà',
      'exampleSentence': 'Das ist mein Haus.',
      'deckId': 'deck-1',
    });
    expect(find.text('Stapel öffnen'), findsOneWidget);

    await tester.tap(find.text('Stapel öffnen'));
    await tester.pumpAndSettle();
    expect(find.text('Deck deck-1'), findsOneWidget);
  });

  testWidgets('compact and star variants quick-save without a deck', (
    tester,
  ) async {
    final saveRepository = _FakeQuickSaveRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          flashcardQuickSaveRepositoryProvider.overrideWithValue(
            saveRepository,
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 800),
              textScaler: TextScaler.linear(2),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: const Column(
              children: [
                SaveCardButton(wordDe: 'Haus', compact: true),
                SaveCardButton(
                  wordDe: 'lernen',
                  variant: SaveCardButtonVariant.star,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Speichern'));
    await tester.pump();
    await tester.tap(find.byTooltip('Speichern'));
    await tester.pump();

    expect(saveRepository.calls, hasLength(2));
    expect(saveRepository.calls.every((call) => call['deckId'] == null), true);
  });
}

class _FakeDeckRepository extends DeckRepository {
  _FakeDeckRepository() : super(_dummyClient());

  @override
  Future<List<Deck>> getDecks() async => [
    Deck(
      id: 'deck-1',
      name: 'A1 cơ bản',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
  ];
}

class _FakeQuickSaveRepository extends FlashcardQuickSaveRepository {
  _FakeQuickSaveRepository() : super(_dummyClient());

  final List<Map<String, String?>> calls = [];

  @override
  Future<QuickSaveResult> save({
    required String wordDe,
    String wordVi = '',
    String? exampleSentence,
    String? deckId,
  }) async {
    calls.add({
      'wordDe': wordDe,
      'wordVi': wordVi,
      'exampleSentence': exampleSentence,
      'deckId': deckId,
    });
    return QuickSaveResult.saved;
  }
}

ApiClient _dummyClient() => ApiClient(
  baseUrl: 'https://example.test/api/v1',
  tokenProvider: _NoTokenProvider(),
);

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
