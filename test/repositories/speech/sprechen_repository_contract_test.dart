import 'dart:typed_data';

import 'package:deutschtiger/repositories/speech/sprechen_repository.dart';
import 'package:deutschtiger/repositories/speech/sprechen_session_repository.dart';
import 'package:deutschtiger/data/speech/sprechen_session_models.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchTopics uses GET /sprechen/{teil}/topics and parses the array', () async {
    final setup = _setup([
      '[{"slug":"beruf","is_premium":false,"order":1,"tag":"alltag"}]',
    ]);
    final repo = SprechenRepository(setup.client);

    final topics = await repo.fetchTopics('goethe-teil1');

    expect(topics.single.slug, 'beruf');
    expect(topics.single.isPremium, isFalse);
    expect(topics.single.tag, 'alltag');
    expect(setup.adapter.requests.single.path, '/sprechen/goethe-teil1/topics');
  });

  test('fetchTags uses GET /sprechen/{teil}/tags and tolerates empty array', () async {
    final setup = _setup(['[]']);
    final repo = SprechenRepository(setup.client);

    final tags = await repo.fetchTags('goethe-teil3');

    expect(tags, isEmpty);
    expect(setup.adapter.requests.single.path, '/sprechen/goethe-teil3/tags');
  });

  test('fetchContent uses GET /exams/official/sprechen-content?id= and renders lock state', () async {
    final setup = _setup(['{"locked":true,"markdown":""}']);
    final repo = SprechenRepository(setup.client);

    final content = await repo.fetchContent('question-uuid');

    expect(content.locked, isTrue);
    expect(content.markdown, isEmpty);
    expect(
      setup.adapter.requests.single.path,
      '/exams/official/sprechen-content',
    );
    expect(
      setup.adapter.requests.single.queryParameters['id'],
      'question-uuid',
    );
  });

  test('submitResult posts the documented request shape', () async {
    final setup = _setup(['{"status":"ok"}']);
    final repo = SprechenSessionRepository(setup.client);

    await repo.submitResult(
      const SprechenResult(
        teil: 'goethe-teil1',
        topicSlug: 'beruf',
        score: 22,
        grade: 'pass',
      ),
    );

    final request = setup.adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/user/sprechen-results');
    expect(request.data, {
      'teil': 'goethe-teil1',
      'topic_slug': 'beruf',
      'score': 22,
      'grade': 'pass',
    });
  });

  test('fetchResults accepts either a bare array or {results:[...]} envelope', () async {
    final setup = _setup([
      '{"results":[{"teil":"goethe-teil1","topic_slug":"beruf","score":20,"grade":"pass"}]}',
    ]);
    final repo = SprechenSessionRepository(setup.client);

    final results = await repo.fetchResults();

    expect(results.single.topicSlug, 'beruf');
    expect(results.single.score, 20);
  });

  test('fetchLeaderboard returns typed accessors over the raw passthrough map', () async {
    final setup = _setup([
      '[{"display_name":"Anna","total_score":150,"rank":1}]',
    ]);
    final repo = SprechenSessionRepository(setup.client);

    final leaderboard = await repo.fetchLeaderboard();

    expect(leaderboard.single.displayName, 'Anna');
    expect(leaderboard.single.totalScore, 150);
    expect(leaderboard.single.rank, 1);
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
