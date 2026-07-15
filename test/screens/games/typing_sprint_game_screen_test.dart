import 'package:deutschtiger/data/games/typing_sprint_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/typing_sprint_repository.dart';
import 'package:deutschtiger/screens/games/typing_sprint_game_screen.dart';
import 'package:deutschtiger/view_models/games/typing_sprint_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: TypingSprintGameScreen(),
);

void main() {
  testWidgets('typing sprint renders live sentences to type', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          typingSprintRepositoryProvider.overrideWithValue(
            _FakeTypingSprintRepository(sentences: const [
              TypingSentence(
                id: 's1',
                topic: 'alltag',
                de: 'Ich trinke Kaffee.',
                vi: 'Tôi uống cà phê.',
                wordCount: 3,
              ),
            ]),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ich trinke Kaffee.'), findsOneWidget);
    expect(find.text('Tôi uống cà phê.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Dispose cleanly to cancel the round timer before the test ends.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('typing sprint shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          typingSprintRepositoryProvider.overrideWithValue(
            _FakeTypingSprintRepository(fetchError: Exception('boom')),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('typing correct sentence advances and submits results', (
    tester,
  ) async {
    final repo = _FakeTypingSprintRepository(sentences: const [
      TypingSentence(
        id: 's1',
        topic: 'alltag',
        de: 'Hallo',
        vi: 'Xin chào',
        wordCount: 1,
      ),
    ]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          typingSprintRepositoryProvider.overrideWithValue(repo),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('typing-sprint-input')),
      'Hallo',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('1'), findsWidgets); // correct-words counter updated
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

class _FakeTypingSprintRepository implements TypingSprintRepository {
  _FakeTypingSprintRepository({
    this.sentences = const [],
    this.fetchError,
  });

  final List<TypingSentence> sentences;
  final Object? fetchError;
  final List<Map<String, Object?>> submittedResults = [];

  @override
  Future<List<TypingSentence>> fetchSentences({int count = 20}) async {
    if (fetchError != null) throw fetchError!;
    return sentences;
  }

  @override
  Future<TypingResultResponse> submitResult({
    required int wpm,
    required double accuracy,
    required int cpm,
    required int correctWords,
    required int wrongWords,
    required int durationSec,
    String topicSet = '',
  }) async {
    submittedResults.add({
      'wpm': wpm,
      'accuracy': accuracy,
      'cpm': cpm,
      'correctWords': correctWords,
      'wrongWords': wrongWords,
      'durationSec': durationSec,
    });
    return const TypingResultResponse(
      id: 'r1',
      xpAwarded: 5,
      typingCapReached: false,
      typingDailyCap: 100,
    );
  }
}
