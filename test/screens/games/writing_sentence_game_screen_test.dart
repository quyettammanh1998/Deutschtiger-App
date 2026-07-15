import 'package:deutschtiger/data/learn/learn_models.dart';
import 'package:deutschtiger/data/vocab/vocab_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/learn/learn_repository.dart';
import 'package:deutschtiger/screens/games/writing_sentence_game_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/games/word_writing_provider.dart';
import 'package:deutschtiger/view_models/learn/learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: WritingSentenceGameScreen(),
);

const _words = [
  VocabWord(id: '1', word: 'Haus', translation: 'Nhà'),
];

void main() {
  testWidgets('writing sentence game renders the prompt word for a learned word', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          writingWordWordsProvider.overrideWith((ref) async => _words),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Haus (Nhà)'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('writing sentence game grades a sentence and shows feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          writingWordWordsProvider.overrideWith((ref) async => _words),
          learnRepositoryProvider.overrideWithValue(
            _FakeLearnRepository(
              const GradeSentenceResult(
                score: 90,
                correctedSentence: 'Das ist mein Haus.',
                summaryVi: 'Câu đúng ngữ pháp.',
              ),
            ),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Das ist mein Haus.');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Điểm: 90%'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('writing sentence game shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          writingWordWordsProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeLearnRepository extends LearnRepository {
  _FakeLearnRepository(this._result)
    : super(
        ApiClient(
          baseUrl: 'https://example.test/api/v1',
          tokenProvider: _NoTokenProvider(),
        ),
      );

  final GradeSentenceResult _result;

  @override
  Future<GradeSentenceResult> gradeSentence({
    required String promptWord,
    required String promptMeaning,
    required String userSentence,
    required String userLevel,
    required List<TargetBlockInput> targetBlocks,
  }) async => _result;
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
