import 'dart:async';

import 'package:deutschtiger/data/decks/deck_models.dart';
import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/flashcard/review_repository.dart';
import 'package:deutschtiger/screens/decks/deck_detail_screen.dart' show deckWordsProvider;
import 'package:deutschtiger/screens/practice/practice_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/audio_service.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/flashcard/review_provider.dart';
import 'package:deutschtiger/view_models/providers.dart' show audioServiceProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpPractice(
    WidgetTester tester, {
    required AsyncValue<List<DeckWord>> words,
  }) async {
    // Mode selector is now a tall 2-col gradient grid (11 cards) — grow the
    // test surface so every card is on-screen without needing scroll
    // gymnastics (default 800x600 clips well past the first row).
    await tester.binding.setSurfaceSize(const Size(400, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deckWordsProvider('deck-1').overrideWith((ref) {
            switch (words) {
              case AsyncData(:final value):
                return Future.value(value);
              case AsyncError(:final error):
                return Future<List<DeckWord>>.error(error);
              default:
                return Completer<List<DeckWord>>().future;
            }
          }),
          reviewRepositoryProvider.overrideWithValue(_NoOpReviewRepository()),
          audioServiceProvider.overrideWithValue(_NoOpAudioService()),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const PracticeScreen(deckId: 'deck-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  DeckWord word({
    required String id,
    required String w,
    required String vi,
    String? example,
  }) {
    return DeckWord(
      id: id,
      wordId: 'learning-$id',
      word: w,
      translation: vi,
      example: example,
      addedAt: DateTime.utc(2026),
    );
  }

  testWidgets('shows empty state when the deck has no cards', (tester) async {
    await pumpPractice(tester, words: const AsyncData([]));

    expect(find.text('This deck does not have any cards yet.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a retry action when the deck fails to load', (tester) async {
    await pumpPractice(tester, words: AsyncError(Exception('network'), StackTrace.empty));

    expect(find.text('Retry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cloze mode: happy path fills the results screen', (tester) async {
    await pumpPractice(
      tester,
      words: AsyncData([
        word(id: 'c1', w: 'Haus', vi: 'the house', example: 'Das Haus ist groß.'),
      ]),
    );

    await tester.ensureVisible(find.text('Fill in the blank'));
    await tester.tap(find.text('Fill in the blank'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('practice_cloze_input')), 'Haus');
    await tester.tap(find.text('Check'));
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();

    expect(find.text('Session complete!'), findsOneWidget);
    expect(find.text('1/1 correct'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('writing mode: happy path fills the results screen', (tester) async {
    await pumpPractice(
      tester,
      words: AsyncData([word(id: 'w1', w: 'Buch', vi: 'the book')]),
    );

    await tester.ensureVisible(find.text('Writing'));
    await tester.tap(find.text('Writing'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('practice_writing_input')), 'Buch');
    await tester.tap(find.text('Check'));
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();

    expect(find.text('Session complete!'), findsOneWidget);
    expect(find.text('1/1 correct'), findsOneWidget);
  });

  testWidgets('listening mode: happy path fills the results screen', (tester) async {
    await pumpPractice(
      tester,
      words: AsyncData([word(id: 'l1', w: 'Wasser', vi: 'water')]),
    );

    await tester.ensureVisible(find.text('Listening'));
    await tester.tap(find.text('Listening'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('practice_listening_word')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('practice_listening_yes')));
    await tester.pumpAndSettle();

    expect(find.text('Session complete!'), findsOneWidget);
  });

  testWidgets('matching mode: happy path fills the results screen', (tester) async {
    await pumpPractice(
      tester,
      words: AsyncData([
        word(id: 'm1', w: 'Katze', vi: 'cat'),
        word(id: 'm2', w: 'Hund', vi: 'dog'),
      ]),
    );

    await tester.ensureVisible(find.text('Matching'));
    await tester.tap(find.text('Matching'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('practice_matching_de_m1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('practice_matching_vi_m1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('practice_matching_de_m2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('practice_matching_vi_m2')));
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pumpAndSettle();

    expect(find.text('Session complete!'), findsOneWidget);
  });
}

class _NoOpReviewRepository extends ReviewRepository {
  _NoOpReviewRepository()
    : super(ApiClient(baseUrl: 'https://example.test', tokenProvider: _NoTokenProvider()));

  @override
  Future<SrsReviewResult> rate(
    ReviewItem item,
    ReviewRating rating, {
    required Duration responseTime,
    required String mode,
  }) async {
    return SrsReviewResult(cardReviewId: '', nextDue: DateTime.now(), state: 0);
  }
}

class _NoOpAudioService extends AudioService {
  _NoOpAudioService()
    : super(ApiClient(baseUrl: 'https://example.test', tokenProvider: _NoTokenProvider()));

  @override
  Future<bool> play({String? audioUrl, required String text}) async => true;
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
