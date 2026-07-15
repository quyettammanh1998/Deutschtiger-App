import 'dart:typed_data';

import 'package:deutschtiger/repositories/learn/learn_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('capability map repository uses GET contract + query goal', () async {
    final setup = _setup([
      '{"goal":"comm_a1_a2","progress_pct":40,"mastered":2,"total":5,'
          '"can_dos":[{"id":"c1","label_vi":"Chào hỏi","label_de":"Begrüßen",'
          '"cefr":"A1","status":"in_progress","spoken":false,'
          '"almost_unlocked":true,"members":[{"kind":"vocab","key":"Hallo",'
          '"ref":"item-1","label":"Hallo","rung":1}],"laggards":["Hallo"]}],'
          '"next_route":"/learn"}',
    ]);
    final repository = LearnRepository(setup.client);

    final map = await repository.fetchCapabilityMap();

    expect(map.progressPct, 40);
    expect(map.canDos.single.labelVi, 'Chào hỏi');
    expect(map.canDos.single.members.single.rung, 1);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/user/learn/capability-map');
    expect(setup.adapter.requests.single.queryParameters['goal'], 'comm_a1_a2');
  });

  test('focus session repository uses GET contract + query due/fails/subs', () async {
    final setup = _setup([
      '{"due_words":[{"id":"r1","content_de":"Hund","content_vi":"chó"}],'
          '"exam_fail_words":[],"subtitle_words":[],"weaknesses":[]}',
    ]);
    final repository = LearnRepository(setup.client);

    final data = await repository.fetchFocusSession(due: 5, fails: 3, subs: 2);

    expect(data.dueWords.single.contentDe, 'Hund');
    expect(data.totalActionable, 1);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/focus-session');
    expect(setup.adapter.requests.single.queryParameters, {
      'due': 5,
      'fails': 3,
      'subs': 2,
    });
  });

  test('learner model repository uses GET contract + weak_limit query', () async {
    final setup = _setup([
      '{"total_cards":100,"mature_cards":30,"mature_pct":30,"due_now":4,'
          '"weak_total":2,"coverage_by_level":[{"level":"A1","total":50,'
          '"mature":20}],"weak_words":[{"learning_item_id":"w1",'
          '"content_de":"laufen","content_vi":"chạy","level":"A1",'
          '"lapses":3}],"grammar_weaknesses":[],'
          '"readiness":{"pct":55,"low":40,"high":70,"has_data":true}}',
    ]);
    final repository = LearnRepository(setup.client);

    final model = await repository.fetchLearnerModel(weakLimit: 15);

    expect(model.maturePct, 30);
    expect(model.weakWords.single.contentDe, 'laufen');
    expect(model.readiness.pct, 55);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/user/learner-model');
    expect(setup.adapter.requests.single.queryParameters['weak_limit'], 15);
  });

  test('preferences repository uses GET + sparse PUT priority_topics contract', () async {
    final setup = _setup([
      '{"learning_goals":["goethe"],"priority_topics":["essen"]}',
      '{"learning_goals":["goethe"],"priority_topics":["essen","reisen"]}',
    ]);
    final repository = LearnRepository(setup.client);

    final current = await repository.fetchPreferences();
    final updated = await repository.updatePriorityTopics(['essen', 'reisen']);

    expect(current.priorityTopics, ['essen']);
    expect(updated.priorityTopics, ['essen', 'reisen']);
    expect(
      setup.adapter.requests.map((r) => '${r.method} ${r.path}'),
      ['GET /user/preferences', 'PUT /user/preferences'],
    );
    expect(setup.adapter.requests.last.data, {
      'priority_topics': ['essen', 'reisen'],
    });
  });

  test('grade sentence repository uses POST contract with target_blocks', () async {
    final setup = _setup([
      '{"score":85,"contains_word":true,"grammar_ok":true,"natural":true,'
          '"corrected_sentence":"Ich gehe nach Hause.",'
          '"corrections":[],"better_alternative":"",'
          '"summary_vi":"Câu đúng ngữ pháp."}',
    ]);
    final repository = LearnRepository(setup.client);

    final result = await repository.gradeSentence(
      promptWord: 'gehen',
      promptMeaning: 'to go',
      userSentence: 'Ich gehe nach Hause.',
      userLevel: 'A1',
      targetBlocks: const [
        TargetBlockInput(
          kind: 'vocab',
          ref: 'item-1',
          label: 'gehen',
          lemma: 'gehen',
        ),
      ],
    );

    expect(result.score, 85);
    expect(result.isCorrect, isTrue);
    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/ai/grade-sentence');
    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    expect(body['prompt_word'], 'gehen');
    expect(body['target_blocks'], [
      {'kind': 'vocab', 'ref': 'item-1', 'label': 'gehen', 'lemma': 'gehen'},
    ]);
  });
}

({ApiClient client, _QueueAdapter adapter}) _setup(List<String> responses) {
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
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      responses[_index++],
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
