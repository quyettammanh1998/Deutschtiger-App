import 'dart:convert';
import 'dart:typed_data';

import 'package:deutschtiger/features/exam/data/exam_attempt_store.dart';
import 'package:deutschtiger/features/exam/domain/exam_models.dart';
import 'package:deutschtiger/features/exam/presentation/exam_player_provider.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('progress snapshot round-trips answers, audio and position', () async {
    final setup = _client();
    final store = ExamAttemptStore(setup.client);
    final startedAt = DateTime.utc(2026, 7, 14, 10);
    final snapshot = ExamProgressSnapshot(
      answers: const {'q1': '0'},
      audioPlays: const {'q2': 1},
      currentSection: 1,
      currentQuestion: 2,
      elapsedSeconds: 90,
      startedAt: startedAt,
    );

    await store.saveProgress('exam-1', snapshot);
    final restored = await store.loadProgress('exam-1');

    expect(restored?.answers, {'q1': '0'});
    expect(restored?.audioPlays, {'q2': 1});
    expect(restored?.currentSection, 1);
    expect(restored?.currentQuestion, 2);
    expect(restored?.elapsedSeconds, 90);
    expect(restored?.startedAt, startedAt);
  });

  test(
    'submit scores correct answers and sends production contracts',
    () async {
      final setup = _client();
      final store = ExamAttemptStore(setup.client);
      final notifier = ExamPlayerNotifier(
        exam: _exam,
        mode: ExamMode.test,
        timed: false,
        attemptStore: store,
      );
      addTearDown(notifier.dispose);

      notifier.setAnswer('q1', '0');
      notifier.setAnswer('q2', '0');
      final attempt = await notifier.submit();

      expect(attempt.correctAnswers, 1);
      expect(attempt.score, 1);
      expect(attempt.maxScore, 2);
      expect(attempt.passed, isFalse);
      expect(setup.adapter.requests.map((r) => r.path), [
        '/user/exam-attempts',
        '/user/exam-results',
      ]);
      final attemptBody = setup.adapter.requests.first.data as Map;
      expect(attemptBody['exam_id'], 'exam-1');
      expect(attemptBody['total_questions'], 2);
      expect(attemptBody['correct_answers'], 1);
      expect(attemptBody['wrong_answers'], 1);
      expect(attemptBody['unanswered'], 0);
      expect(attemptBody['score'], 50);
      expect(attemptBody['mode'], 'test');
      expect(attemptBody.containsKey('examId'), isFalse);

      final saved = await store.loadResult('exam-1');
      expect(saved?.correctAnswers, 1);
      expect(await store.loadProgress('exam-1'), isNull);
    },
  );

  test(
    'result falls back to latest server attempt when local cache is empty',
    () async {
      final setup = _client(
        response:
            '[{"exam_id":"exam-1","mode":"test","correct_answers":8,'
            '"score":80,"time_taken":300,"answers":{"q1":"0"},'
            '"submitted_at":"2026-07-14T10:00:00Z"}]',
      );

      final result = await ExamAttemptStore(setup.client).loadResult('exam-1');

      expect(result?.score, 80);
      expect(result?.maxScore, 100);
      expect(result?.correctAnswers, 8);
      expect(result?.answers, {'q1': '0'});
      expect(setup.adapter.requests.single.path, '/user/exam-attempts');
      expect(
        setup.adapter.requests.single.queryParameters,
        containsPair('exam_id', 'exam-1'),
      );
    },
  );

  test('audio play count enforces max plays', () {
    final setup = _client();
    final notifier = ExamPlayerNotifier(
      exam: _exam,
      mode: ExamMode.test,
      timed: false,
      attemptStore: ExamAttemptStore(setup.client),
    );
    addTearDown(notifier.dispose);

    expect(notifier.registerAudioPlay('q2'), isTrue);
    expect(notifier.registerAudioPlay('q2'), isFalse);
    expect(notifier.playsFor('q2'), 1);
  });

  test(
    'legacy progress maps only unambiguous display ids to canonical keys',
    () async {
      SharedPreferences.setMockInitialValues({
        'exam-progress-exam-canonical': jsonEncode({
          'answers': {'legacy-unique': '0', 'legacy-duplicate': '1'},
          'audio_plays': {'legacy-unique': 1, 'legacy-duplicate': 1},
          'current_section': 0,
          'current_question': 0,
          'elapsed_seconds': 12,
          'started_at': '2026-07-15T10:00:00Z',
        }),
      });
      final setup = _client();
      final restored = await ExamAttemptStore(
        setup.client,
      ).loadProgress('exam-canonical', exam: _canonicalExam);

      expect(restored?.answers, {'read/0/1': '0'});
      expect(restored?.audioPlays, {'read/0/1': 1});
    },
  );

  test('a failed server draft submit remains retryable', () async {
    final setup = _client(statusCode: 500);
    final notifier = ExamPlayerNotifier(
      exam: _exam,
      mode: ExamMode.test,
      timed: false,
      attemptStore: ExamAttemptStore(setup.client),
      progress: ExamProgressSnapshot(
        answers: const {},
        audioPlays: const {},
        currentSection: 0,
        currentQuestion: 0,
        elapsedSeconds: 1,
        startedAt: DateTime.utc(2026, 7, 15, 10),
        draftId: 'c4a98680-7760-4c70-8075-7748f8c3b361',
        draftVersion: 1,
      ),
    );
    addTearDown(notifier.dispose);

    await notifier.submit();
    expect(notifier.state.submitted, isFalse);
    expect(notifier.state.syncError, isTrue);

    await notifier.submit();
    expect(setup.adapter.requests, hasLength(2));
  });

  test(
    'server draft progress carries version through the PATCH contract',
    () async {
      final setup = _client(
        response:
            '{"id":"c4a98680-7760-4c70-8075-7748f8c3b361","version":2,'
            '"answers":{"read/0/1":"0"},"audio_plays":{},'
            '"current_section":0,"current_question":0,"elapsed_seconds":10,'
            '"started_at":"2026-07-15T10:00:00Z"}',
      );
      final store = ExamAttemptStore(setup.client);
      final saved = await store.saveProgress(
        'exam-1',
        ExamProgressSnapshot(
          answers: const {'read/0/1': '0'},
          audioPlays: const {},
          currentSection: 0,
          currentQuestion: 0,
          elapsedSeconds: 10,
          startedAt: DateTime.utc(2026, 7, 15, 10),
          draftId: 'c4a98680-7760-4c70-8075-7748f8c3b361',
          draftVersion: 1,
        ),
      );

      expect(saved.draftVersion, 2);
      expect(setup.adapter.requests.single.method, 'PATCH');
      expect(setup.adapter.requests.single.path, contains('/exam-drafts/'));
      final body = setup.adapter.requests.single.data as Map;
      expect(body['answers'], {'read/0/1': '0'});
      expect(body['mutation_id'], isA<String>());
    },
  );

  test('server draft submit never sends client score fields', () async {
    final setup = _client(
      response:
          '{"attempt_id":7,"exam_id":"exam-1","mode":"test",'
          '"total_questions":2,"correct_answers":2,"wrong_answers":0,'
          '"unanswered":0,"score":100,"time_taken":20,'
          '"answers":{"read/0/1":"0"},"submitted_at":"2026-07-15T10:00:00Z",'
          '"passed":true}',
    );
    final outcome = await ExamAttemptStore(setup.client).submit(
      _exam,
      ExamAttempt(
        examId: 'exam-1',
        mode: ExamMode.test,
        answers: {'read/0/1': '0'},
        elapsedSeconds: 20,
        startedAt: DateTime.utc(2026, 7, 15, 9),
      ),
      draftId: 'c4a98680-7760-4c70-8075-7748f8c3b361',
      draftVersion: 3,
    );

    expect(outcome.synced, isTrue);
    expect(outcome.attempt.score, 100);
    final request = setup.adapter.requests.single;
    expect(request.path, contains('/submit'));
    final body = request.data as Map;
    expect(body.keys, containsAll(['version', 'mutation_id']));
    expect(body.containsKey('score'), isFalse);
    expect(body.containsKey('answers'), isFalse);
  });

  test('timed mode auto-submits when the limit expires', () async {
    final setup = _client();
    final notifier = ExamPlayerNotifier(
      exam: _exam,
      mode: ExamMode.test,
      timed: true,
      attemptStore: ExamAttemptStore(setup.client),
      tickInterval: const Duration(milliseconds: 5),
      timeLimitSeconds: 2,
    );
    addTearDown(notifier.dispose);

    for (var i = 0; i < 30 && !notifier.state.submitted; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    expect(notifier.state.elapsedSeconds, 2);
    expect(notifier.state.submitted, isTrue);
    expect(setup.adapter.requests, hasLength(2));
  });
}

const _exam = Exam(
  id: 'exam-1',
  title: 'Test',
  level: 'b1',
  provider: 'telc',
  sections: [
    ExamSection(
      kind: ExamSectionKind.lesen,
      durationMinutes: 1,
      questions: [
        ExamQuestion(
          id: 'q1',
          type: QuestionType.mc,
          prompt: 'Q1',
          options: [
            ExamOption(id: '0', text: 'A'),
            ExamOption(id: '1', text: 'B'),
          ],
          correctOptionId: '0',
        ),
        ExamQuestion(
          id: 'q2',
          type: QuestionType.mc,
          prompt: 'Q2',
          options: [
            ExamOption(id: '0', text: 'A'),
            ExamOption(id: '1', text: 'B'),
          ],
          correctOptionId: '1',
          audioUrl: 'https://example.test/q2.mp3',
          audioMaxPlays: 1,
        ),
      ],
    ),
  ],
);

const _canonicalExam = Exam(
  id: 'exam-canonical',
  title: 'Canonical',
  level: 'b1',
  provider: 'goethe',
  sections: [
    ExamSection(
      kind: ExamSectionKind.lesen,
      durationMinutes: 1,
      questions: [
        ExamQuestion(
          id: 'legacy-unique',
          contentReference: 'read/0/1',
          type: QuestionType.mc,
          prompt: 'Unique',
        ),
        ExamQuestion(
          id: 'legacy-duplicate',
          contentReference: 'read/0/2',
          type: QuestionType.mc,
          prompt: 'Duplicate one',
        ),
        ExamQuestion(
          id: 'legacy-duplicate',
          contentReference: 'read/1/2',
          type: QuestionType.mc,
          prompt: 'Duplicate two',
        ),
      ],
    ),
  ],
);

({ApiClient client, _Adapter adapter}) _client({
  String response = '{"status":"ok"}',
  int statusCode = 200,
}) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _Adapter(response, statusCode: statusCode);
  client.raw.httpClientAdapter = adapter;
  return (client: client, adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.response, {this.statusCode = 200});

  final String response;
  final int statusCode;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      response,
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
