import 'dart:typed_data';

import 'package:deutschtiger/repositories/exam/community_exam_repository.dart';
import 'package:deutschtiger/repositories/exam/de_thi_repository.dart';
import 'package:deutschtiger/repositories/exam/exam_dictation_repository.dart';
import 'package:deutschtiger/repositories/exam/exam_readiness_repository.dart';
import 'package:deutschtiger/repositories/exam/exam_registration_repository.dart';
import 'package:deutschtiger/data/exam/exam_ecosystem_models.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExamReadinessRepository', () {
    test('getReadiness parses the full snapshot', () async {
      final fixture = '''{
        "attempt_count": 5, "avg_score": 62.5, "recent_avg_score": 70,
        "best_score": 85, "readiness_low": 60, "readiness_high": 75,
        "due_review_count": 12, "exam_fail_pending": 3,
        "top_weaknesses": [{"error_type":"case_akkdat","count":4}],
        "weakness_details": [{"error_type":"case_akkdat","count":4,
          "last_example_original":"Ich sehe der Mann",
          "last_example_corrected":"Ich sehe den Mann",
          "last_example_explanation":"Akkusativ nach sehen"}],
        "score_trend": [{"score":70,"submitted_at":"2026-07-01T00:00:00Z"}],
        "skill_readiness": [{"skill":"hoeren","accuracy":66.5,"attempt_count":3}]
      }''';
      final setup = _readinessRepo([fixture]);
      final snap = await setup.repository.getReadiness();

      expect(snap.attemptCount, 5);
      expect(snap.readinessLow, 60);
      expect(snap.readinessHigh, 75);
      expect(snap.topWeaknesses.single.errorType, 'case_akkdat');
      expect(snap.weaknessDetails.single.corrected, 'Ich sehe den Mann');
      expect(snap.scoreTrend.single.score, 70);
      expect(snap.skillReadiness.single.skill, 'hoeren');
      expect(setup.adapter.requests.single.path, '/exam-readiness');
    });
  });

  group('ExamRegistrationRepository', () {
    test('listMine parses registrations envelope', () async {
      final fixture = '''{"registrations":[{
        "id":"r1","exam_level":"B1","exam_type":"goethe","exam_date":"2026-08-01",
        "skills":["lesen","hoeren"],"location":"Hà Nội"
      }]}''';
      final setup = _registrationRepo([fixture]);
      final regs = await setup.repository.listMine();

      expect(regs.single.id, 'r1');
      expect(regs.single.skills, ['lesen', 'hoeren']);
      expect(setup.adapter.requests.single.path, '/user/exam-registrations');
    });

    test('create posts payload and parses created registration', () async {
      final fixture = '''{"registration":{
        "id":"r2","exam_level":"B2","exam_type":"telc","exam_date":"2026-09-01",
        "skills":["schreiben"]
      }}''';
      final setup = _registrationRepo([fixture]);
      final created = await setup.repository.create(
        const ExamRegistration(
          id: '',
          examLevel: 'B2',
          examType: 'telc',
          examDate: '2026-09-01',
          skills: ['schreiben'],
        ),
      );

      expect(created.id, 'r2');
      final request = setup.adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/user/exam-registrations');
    });

    test('listBuddies parses the public directory array', () async {
      final fixture = '''[{
        "id":"b1","display_name":"An","avatar_url":"","exam_level":"B1",
        "exam_type":"goethe","exam_date":"2026-08-01","location":"HCM",
        "skills":["lesen"],"days_until":10
      }]''';
      final setup = _registrationRepo([fixture]);
      final buddies = await setup.repository.listBuddies();

      expect(buddies.single.displayName, 'An');
      expect(buddies.single.daysUntil, 10);
      expect(setup.adapter.requests.single.path, '/exam-buddies');
    });
  });

  group('CommunityExamRepository', () {
    test('list applies filter query params', () async {
      final fixture = '''[{
        "id":"t1","provider":"goethe","level":"b1","skill":"schreiben","teil":2,
        "title_de":"Meine Familie","contributor_name":"Bình",
        "contributor_avatar":"","vote_count":3,"version_count":1,
        "is_verified":true,"created_at":"2026-07-01T00:00:00Z"
      }]''';
      final setup = _communityRepo([fixture]);
      final topics = await setup.repository.list(
        provider: 'goethe',
        level: 'b1',
        skill: 'schreiben',
      );

      expect(topics.single.titleDe, 'Meine Familie');
      expect(topics.single.isVerified, isTrue);
      final request = setup.adapter.requests.single;
      expect(request.path, '/user/community/exams/');
      expect(request.queryParameters, containsPair('provider', 'goethe'));
      expect(request.queryParameters, containsPair('skill', 'schreiben'));
    });

    test('getById fetches a single topic by id', () async {
      final fixture = '''{
        "id":"t2","provider":"telc","level":"b1","skill":"lesen","teil":0,
        "title_de":"Wohnen","contributor_name":"","contributor_avatar":"",
        "vote_count":0,"version_count":0,"is_verified":false,
        "created_at":"2026-07-01T00:00:00Z"
      }''';
      final setup = _communityRepo([fixture]);
      final topic = await setup.repository.getById('t2');

      expect(topic.id, 't2');
      expect(setup.adapter.requests.single.path, '/user/community/exams/t2');
    });
  });

  group('ExamDictationRepository', () {
    test('getTranscript routes telc to the b1 endpoint', () async {
      final fixture = '''{
        "audios":[{"file":"a1.mp3","audio_url":"/data/media/a1.mp3",
          "duration":12.5,"teil":"TEIL 1","sentences":[{
            "text":"Ich lerne Deutsch.","text_vi":"Tôi học tiếng Đức.",
            "start":0,"end":2,"words":[{"word":"lerne","clean":"lerne","start":0.5,"end":0.9}]
          }]}],
        "words":[{"word":"lerne","clean":"lerne","text_vi":"học"}]
      }''';
      final setup = _dictationRepo([fixture]);
      final transcript = await setup.repository.getTranscript(
        provider: 'telc',
        level: 'b1',
        slug: 'ex-01',
      );

      expect(transcript.audios.single.sentences.single.words.single.clean, 'lerne');
      expect(transcript.words.single.textVi, 'học');
      expect(
        setup.adapter.requests.single.path,
        '/exams/telc/b1/ex-01/word-transcript',
      );
    });

    test('getTranscript routes goethe to the level-scoped endpoint', () async {
      final setup = _dictationRepo(['{"audios":[],"words":[]}']);
      await setup.repository.getTranscript(
        provider: 'goethe',
        level: 'b2',
        slug: 'ex-02',
      );

      expect(
        setup.adapter.requests.single.path,
        '/exams/goethe/b2/ex-02/word-transcript',
      );
    });
  });

  group('DeThiRepository', () {
    test('listRegistry + findEntry surface the static registry', () {
      final setup = _deThiRepo(['{}']);
      final all = setup.repository.listRegistry();
      expect(all, isNotEmpty);
      final entry = setup.repository.findEntry(all.first.code);
      expect(entry, isNotNull);
      expect(setup.repository.findEntry('does-not-exist'), isNull);
    });

    test('fetchExam requests the absolute static-host URL', () async {
      final fixture = '''{
        "exam_code":"1525","level":"B1","title":"Đề 1525","passages":[{
          "id":"p1","title":"Passage 1","text_de":"...","text_vi":"...",
          "questions":[{"no":1,"question_de":"?","question_vi":"?",
            "options_de":{"A":"a"},"options_vi":{"A":"a"},"answer":"A","explanation_vi":""}]
        }]
      }''';
      final setup = _deThiRepo([fixture]);
      final exam = await setup.repository.fetchExam('/data/de-thi/exam-1525.json');

      expect(exam.examCode, '1525');
      expect(exam.passages.single.questions.single.answer, 'A');
      expect(
        setup.adapter.requests.single.path,
        'https://static.example.test/data/de-thi/exam-1525.json',
      );
    });
  });
}

({ExamReadinessRepository repository, _QueueAdapter adapter}) _readinessRepo(
  List<String> responses,
) {
  final client = _client(responses);
  return (
    repository: ExamReadinessRepository(client.client),
    adapter: client.adapter,
  );
}

({ExamRegistrationRepository repository, _QueueAdapter adapter})
_registrationRepo(List<String> responses) {
  final client = _client(responses);
  return (
    repository: ExamRegistrationRepository(client.client),
    adapter: client.adapter,
  );
}

({CommunityExamRepository repository, _QueueAdapter adapter}) _communityRepo(
  List<String> responses,
) {
  final client = _client(responses);
  return (
    repository: CommunityExamRepository(client.client),
    adapter: client.adapter,
  );
}

({ExamDictationRepository repository, _QueueAdapter adapter}) _dictationRepo(
  List<String> responses,
) {
  final client = _client(responses);
  return (
    repository: ExamDictationRepository(client.client),
    adapter: client.adapter,
  );
}

({DeThiRepository repository, _QueueAdapter adapter}) _deThiRepo(
  List<String> responses,
) {
  final client = _client(responses);
  return (
    repository: DeThiRepository(client.client, 'https://static.example.test'),
    adapter: client.adapter,
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
  _QueueAdapter(this._responses);

  final List<String> _responses;
  final List<RequestOptions> requests = [];
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      _responses[_index++],
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
