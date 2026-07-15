import 'package:deutschtiger/data/games/word_writing_models.dart';
import 'package:deutschtiger/data/vocab/vocab_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/word_writing_repository.dart';
import 'package:deutschtiger/screens/games/writing_word_game_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/games/word_writing_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: WritingWordGameScreen(),
);

const _words = [
  VocabWord(id: '1', word: 'Haus', translation: 'Nhà'),
];

void main() {
  testWidgets('writing word game renders the meaning prompt for a learned word', (
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

    expect(find.text('Nhà'), findsOneWidget);
    expect(find.text('Viết từ tiếng Đức:'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('writing word game grades an answer via AI and shows feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          writingWordWordsProvider.overrideWith((ref) async => _words),
          wordWritingRepositoryProvider.overrideWithValue(
            _FakeWordWritingRepository(
              const WordGradeResult(
                correct: true,
                hint: 'Tốt lắm!',
                suggestion: 'das Haus',
              ),
            ),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Haus');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Đúng rồi!'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Let the scheduled "next word" delay elapse before disposing, so the
    // pending Future.delayed timer doesn't trip the test-framework invariant.
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('writing word game shows error view + retry on fetch failure', (
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

class _FakeWordWritingRepository extends WordWritingRepository {
  _FakeWordWritingRepository(this._result)
    : super(
        ApiClient(
          baseUrl: 'https://example.test/api/v1',
          tokenProvider: _NoTokenProvider(),
        ),
      );

  final WordGradeResult _result;

  @override
  Future<WordGradeResult> gradeWord({
    required String userInput,
    required String targetWord,
    required String targetVi,
    required String level,
  }) async => _result;
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
