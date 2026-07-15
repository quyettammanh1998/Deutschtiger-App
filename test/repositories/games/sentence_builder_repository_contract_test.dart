import 'dart:typed_data';

import 'package:deutschtiger/repositories/games/sentence_builder_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchTopics uses GET contract + query level', () async {
    final setup = _setup([
      '{"topics":[{"id":"t1","key":"essen","label":"Essen",'
          '"labelVi":"Ăn uống","icon":"book","color":"#fff",'
          '"wordCount":12,"essentialWordCount":5}]}',
    ]);
    final repository = SentenceBuilderRepository(setup.client);

    final topics = await repository.fetchTopics(level: 'A2');

    expect(topics.single.labelVi, 'Ăn uống');
    expect(topics.single.wordCount, 12);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/sentence-builder/topics');
    expect(setup.adapter.requests.single.queryParameters['level'], 'A2');
  });

  test('fetchTopics parses userProgress when present', () async {
    final setup = _setup([
      '{"topics":[{"id":"t1","key":"essen","label":"Essen",'
          '"labelVi":"Ăn uống","icon":"book","wordCount":12,'
          '"essentialWordCount":5,"userProgress":{"wordsPracticed":3,'
          '"wordsMastered":1}}]}',
    ]);
    final repository = SentenceBuilderRepository(setup.client);

    final topics = await repository.fetchTopics();

    expect(topics.single.userProgress?.wordsPracticed, 3);
    expect(topics.single.userProgress?.wordsMastered, 1);
  });

  test('createSession uses POST contract with topicId + defaults', () async {
    final setup = _setup([
      '{"sessionId":"s1","topic":{"id":"t1","key":"essen","label":"Essen",'
          '"labelVi":"Ăn uống"},"words":[{"id":"w1","contentDe":"essen",'
          '"contentVi":"ăn","wordType":"verb"}]}',
    ]);
    final repository = SentenceBuilderRepository(setup.client);

    final session = await repository.createSession(
      level: 'A1',
      topicId: 't1',
    );

    expect(session.sessionId, 's1');
    expect(session.topic.labelVi, 'Ăn uống');
    expect(session.words.single.contentDe, 'essen');
    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/sentence-builder/session');
    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    expect(body['level'], 'A1');
    expect(body['topicId'], 't1');
    expect(body['sessionSize'], 10);
    expect(body['preferEssential'], true);
  });

  test('createSession omits topicId when random topic requested', () async {
    final setup = _setup([
      '{"sessionId":"s2","topic":{"id":"t2","key":"reisen","label":"Reisen",'
          '"labelVi":"Du lịch"},"words":[]}',
    ]);
    final repository = SentenceBuilderRepository(setup.client);

    await repository.createSession(level: 'A1');

    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    expect(body.containsKey('topicId'), isFalse);
  });

  test('completeSession uses POST contract to session complete path', () async {
    final setup = _setup(['{"status":"completed"}']);
    final repository = SentenceBuilderRepository(setup.client);

    await repository.completeSession(
      's1',
      completedWords: 8,
      averageScore: 76.5,
    );

    expect(setup.adapter.requests.single.method, 'POST');
    expect(
      setup.adapter.requests.single.path,
      '/sentence-builder/session/s1/complete',
    );
    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    expect(body['completedWords'], 8);
    expect(body['averageScore'], 76.5);
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
