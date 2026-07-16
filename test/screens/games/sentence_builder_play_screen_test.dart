import 'package:deutschtiger/data/games/sentence_builder_models.dart';
import 'package:deutschtiger/data/learn/learn_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/sentence_builder_repository.dart';
import 'package:deutschtiger/repositories/learn/learn_repository.dart';
import 'package:deutschtiger/screens/games/sentence_builder/sentence_builder_play_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/games/sentence_builder_provider.dart';
import 'package:deutschtiger/view_models/learn/learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(List<Override> overrides) => ProviderScope(
    overrides: overrides,
    child: const MaterialApp(
      locale: Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: SentenceBuilderPlayScreen(level: 'A1', topicId: 't1'),
    ),
  );

  testWidgets('play screen grades a sentence and reaches results', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        sentenceBuilderRepositoryProvider.overrideWithValue(
          _FakeSentenceBuilderRepository(_oneWordSession()),
        ),
        learnRepositoryProvider.overrideWithValue(
          _FakeLearnRepository(score: 90),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('essen'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('sentence-builder-input')),
      'Ich esse Brot.',
    );
    await tester.tap(find.text('Kiểm tra'));
    await tester.pumpAndSettle();

    expect(find.text('90/100'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sentence-builder-next')));
    await tester.pumpAndSettle();

    expect(find.text('🎉 Hoàn thành!'), findsOneWidget);
    expect(find.text('90%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('play screen shows grading error message on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        sentenceBuilderRepositoryProvider.overrideWithValue(
          _FakeSentenceBuilderRepository(_oneWordSession()),
        ),
        learnRepositoryProvider.overrideWithValue(_FailingLearnRepository()),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('sentence-builder-input')),
      'Ich esse Brot.',
    );
    await tester.tap(find.text('Kiểm tra'));
    await tester.pumpAndSettle();

    expect(find.text('Không thể chấm bài. Vui lòng thử lại.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

SentenceBuilderSession _oneWordSession() => const SentenceBuilderSession(
  sessionId: 's1',
  topic: SentenceBuilderSessionTopic(
    id: 't1',
    key: 'essen',
    label: 'Food',
    labelVi: 'Ăn uống',
  ),
  words: [
    SentenceBuilderSessionWord(
      id: 'w1',
      contentDe: 'essen',
      contentVi: 'ăn',
      wordType: 'verb',
    ),
  ],
);

class _FakeSentenceBuilderRepository extends SentenceBuilderRepository {
  _FakeSentenceBuilderRepository(this._session)
    : super(ApiClient(baseUrl: 'https://example.test', tokenProvider: _NoTokenProvider()));

  final SentenceBuilderSession _session;

  @override
  Future<SentenceBuilderSession> createSession({
    required String level,
    String? topicId,
    int sessionSize = 10,
    bool preferEssential = true,
  }) async => _session;

  @override
  Future<void> completeSession(
    String sessionId, {
    required int completedWords,
    required double averageScore,
  }) async {}
}

class _FakeLearnRepository extends LearnRepository {
  _FakeLearnRepository({required this.score})
    : super(ApiClient(baseUrl: 'https://example.test', tokenProvider: _NoTokenProvider()));

  final int score;

  @override
  Future<GradeSentenceResult> gradeSentence({
    required String promptWord,
    required String promptMeaning,
    required String userSentence,
    required String userLevel,
    required List<TargetBlockInput> targetBlocks,
  }) async => GradeSentenceResult(
    score: score,
    correctedSentence: '',
    summaryVi: 'Câu đúng ngữ pháp.',
  );
}

class _FailingLearnRepository extends LearnRepository {
  _FailingLearnRepository()
    : super(ApiClient(baseUrl: 'https://example.test', tokenProvider: _NoTokenProvider()));

  @override
  Future<GradeSentenceResult> gradeSentence({
    required String promptWord,
    required String promptMeaning,
    required String userSentence,
    required String userLevel,
    required List<TargetBlockInput> targetBlocks,
  }) async => throw ApiException('boom');
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
