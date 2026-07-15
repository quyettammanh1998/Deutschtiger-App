import 'dart:typed_data';

import 'package:deutschtiger/features/exam/data/exam_service.dart';
import 'package:deutschtiger/features/exam/domain/exam_models.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('catalog keeps published Lesen/Hören sets and aggregates metadata', () async {
    final setup = _client([
      '[{"slug":"goethe-a1-01","title":"Goethe A1","provider":"goethe","level":"a1","parts":['
          '{"id":"listen","skill":"Hören","duration":20,"total_questions":15},'
          '{"id":"read","skill":"Lesen","duration":25,"total_questions":15},'
          '{"id":"write","skill":"Schreiben","duration":20,"total_questions":2}'
          ']},'
          '{"slug":"writing-only","title":"Writing","provider":"goethe","level":"b1","parts":['
          '{"id":"write","skill":"Schreiben","duration":30,"total_questions":2}'
          ']}]',
    ]);

    final items = await ExamService(setup.client).listExamSets();

    expect(items, hasLength(1));
    expect(items.single.slug, 'goethe-a1-01');
    expect(items.single.level, 'A1');
    expect(items.single.totalQuestions, 30);
    expect(items.single.durationMinutes, 45);
    expect(setup.adapter.requests.single.path, '/exams');
    expect(setup.adapter.requests.single.queryParameters['published'], 'true');
  });

  test('exam mapper preserves 0-based answers, images, audio and dropdowns', () async {
    final setup = _client([
      '{"slug":"goethe-a1-01","title":"Goethe A1","provider":"goethe","level":"a1","parts":['
          '{"id":"read","skill":"Lesen"},'
          '{"id":"grammar","skill":"grammar"},'
          '{"id":"listen","skill":"Hören"}'
          ']}',
      '{"duration":25,"sections":[{"items":['
          '{"entry_id":1,"type":"multiple_choice","title":"Bildfrage","options":["A","B"],"correct_answer":1,"image_url":"https://example.test/q.jpg"},'
          '{"entry_id":2,"type":"dropdown","title":"Lücke","options":["der","die"],"correct_answer":0}'
          ']}]}',
      '{"duration":15,"sections":[{"items":['
          '{"entry_id":4,"type":"dropdown","title":"Sprachbaustein","options":["mit","bei"],"correct_answer":1}'
          ']}]}',
      '{"duration":20,"sections":[{"max_plays":1,"items":['
          '{"entry_id":3,"type":"true_false","title":"Audiofrage","options":["Richtig","Falsch"],"correct_answer":0,"audio_url":"https://example.test/q.mp3"}'
          ']}]}',
    ]);

    final exam = await ExamService(setup.client).fetchExam('goethe-a1-01');

    expect(exam.sections, hasLength(2));
    expect(exam.sections.first.durationMinutes, 40);
    expect(exam.sections.first.questions, hasLength(3));
    final imageQuestion = exam.sections.first.questions[0];
    expect(imageQuestion.type, QuestionType.anzeigen);
    expect(imageQuestion.contentReference, 'read/0/1');
    expect(imageQuestion.correctOptionId, '1');
    expect(imageQuestion.imageUrl, 'https://example.test/q.jpg');
    final dropdown = exam.sections.first.questions[1];
    expect(dropdown.type, QuestionType.sprachbausteine);
    expect(dropdown.gapPositions, [0]);
    expect(dropdown.contentReference, 'read/0/2');
    final audio = exam.sections.last.questions.single;
    expect(audio.type, QuestionType.richtigFalsch);
    expect(audio.correctBoolean, isTrue);
    expect(audio.audioMaxPlays, 1);
    expect(audio.audioUrl, 'https://example.test/q.mp3');
    expect(audio.contentReference, 'listen/0/3');
  });

  test(
    'content references disambiguate repeated entry IDs across sections',
    () async {
      final setup = _client([
        '{"slug":"osd-b2","title":"ÖSD B2","provider":"osd","level":"b2","parts":[{"id":"read","skill":"Lesen"}]}',
        '{"duration":20,"sections":[{"items":[{"entry_id":1,"type":"multiple_choice","title":"Teil 1","options":["A"],"correct_answer":0}]},{"items":[{"entry_id":1,"type":"multiple_choice","title":"Teil 2","options":["A"],"correct_answer":0}]}]}',
      ]);

      final exam = await ExamService(setup.client).fetchExam('osd-b2');
      final questions = exam.sections.single.questions;

      expect(questions.map((q) => q.id), ['q1', 'q1']);
      expect(questions.map((q) => q.contentReference), [
        'read/0/1',
        'read/1/1',
      ]);
    },
  );
}

({ApiClient client, _QueueAdapter adapter}) _client(List<String> responses) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _QueueAdapter(responses);
  client.raw.httpClientAdapter = adapter;
  return (client: client, adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _QueueAdapter implements HttpClientAdapter {
  _QueueAdapter(this.responses);

  final List<String> responses;
  final List<RequestOptions> requests = [];
  var index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      responses[index++],
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
