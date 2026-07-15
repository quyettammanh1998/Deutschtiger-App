import 'dart:typed_data';

import 'package:deutschtiger/repositories/vocab/subtitle_words_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getWords calls GET /subtitle-words with level/min_seen/limit query', () async {
    final setup = _setup([
      '[{"learning_item_id":"li-1","content_de":"Haus","content_vi":"nhà","ipa":null,'
          '"level":"A1","word_type":"noun","audio_url":null,"seen_count":3}]',
    ]);
    final repo = SubtitleWordsRepository(setup.client);

    final words = await repo.getWords(levels: const ['A1', 'A2'], minSeen: 2, limit: 50);

    expect(words, hasLength(1));
    expect(words.single.learningItemId, 'li-1');
    expect(words.single.contentDe, 'Haus');
    expect(words.single.seenCount, 3);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/subtitle-words');
    expect(setup.adapter.requests.single.queryParameters, {
      'levels': 'A1,A2',
      'min_seen': 2,
      'limit': 50,
    });
  });

  test('getCounts calls GET /subtitle-words/counts', () async {
    final setup = _setup(['{"A1":4,"unknown":1}']);
    final repo = SubtitleWordsRepository(setup.client);

    final counts = await repo.getCounts(minSeen: 2);

    expect(counts, {'A1': 4, 'unknown': 1});
    expect(setup.adapter.requests.single.path, '/subtitle-words/counts');
  });

  test('addWords posts learning_item_ids and returns the added count', () async {
    final setup = _setup(['{"added":2}']);
    final repo = SubtitleWordsRepository(setup.client);

    final result = await repo.addWords(['li-1', 'li-2']);

    expect(result.added, 2);
    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/subtitle-words/add');
    expect(setup.adapter.requests.single.data, {
      'learning_item_ids': ['li-1', 'li-2'],
    });
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
