import 'dart:typed_data';

import 'package:deutschtiger/repositories/games/typing_sprint_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchSentences uses GET contract + count query, parses sentences', () async {
    final setup = _setup([
      '{"sentences":[{"id":"s1","topic":"alltag","de":"Ich trinke Kaffee.",'
          '"vi":"Tôi uống cà phê.","wordCount":4}],"total":40}',
    ]);
    final repository = TypingSprintRepository(setup.client);

    final sentences = await repository.fetchSentences(count: 20);

    expect(sentences.single.de, 'Ich trinke Kaffee.');
    expect(sentences.single.vi, 'Tôi uống cà phê.');
    expect(sentences.single.wordCount, 4);
    expect(sentences.single.learningItemId, isNull);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/user/typing/sentences');
    expect(setup.adapter.requests.single.queryParameters['count'], 20);
  });

  test('fetchSentences parses learning_item_id when personalized', () async {
    final setup = _setup([
      '{"sentences":[{"id":"li-1","topic":"","de":"Er geht zur Schule.",'
          '"vi":"Anh ấy đi học.","wordCount":4,"learning_item_id":"li-1"}],'
          '"total":15}',
    ]);
    final repository = TypingSprintRepository(setup.client);

    final sentences = await repository.fetchSentences();

    expect(sentences.single.learningItemId, 'li-1');
  });

  test('submitResult uses POST contract with all fields', () async {
    final setup = _setup([
      '{"id":"r1","xpAwarded":12,"typingCapReached":false,'
          '"dailyTypingCapReached":false,"typingDailyCap":100}',
    ]);
    final repository = TypingSprintRepository(setup.client);

    final result = await repository.submitResult(
      wpm: 30,
      accuracy: 92.5,
      cpm: 150,
      correctWords: 20,
      wrongWords: 2,
      durationSec: 60,
      topicSet: 'b1',
    );

    expect(result.id, 'r1');
    expect(result.xpAwarded, 12);
    expect(result.typingCapReached, isFalse);
    expect(result.typingDailyCap, 100);
    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/user/typing/results');
    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    expect(body['wpm'], 30);
    expect(body['accuracy'], 92.5);
    expect(body['cpm'], 150);
    expect(body['correctWords'], 20);
    expect(body['wrongWords'], 2);
    expect(body['durationSec'], 60);
    expect(body['topicSet'], 'b1');
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
