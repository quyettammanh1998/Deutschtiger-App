import 'dart:typed_data';

import 'package:deutschtiger/repositories/games/learning_item_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fetchBalanced uses GET /user/learning-items/balanced with user_level/'
    'type/limit query, parses gender + examples',
    () async {
      final setup = _setup([
        '[{"id":"i1","type":"word","content_de":"der Hund","content_vi":'
            '"con chó","category":"animals","level":"A1","gender":"m",'
            '"examples":[{"de":"Der Hund läuft schnell.","vi":"Con chó chạy '
            'nhanh.","cloze":null}]}]',
      ]);
      final repository = LearningItemRepository(setup.client);

      final items = await repository.fetchBalanced(
        userLevel: 'A1',
        type: 'word',
        limit: 60,
      );

      expect(items.single.id, 'i1');
      expect(items.single.contentDe, 'der Hund');
      expect(items.single.gender, 'm');
      expect(items.single.examples.single.de, 'Der Hund läuft schnell.');
      expect(setup.adapter.requests.single.method, 'GET');
      expect(
        setup.adapter.requests.single.path,
        '/user/learning-items/balanced',
      );
      expect(
        setup.adapter.requests.single.queryParameters['user_level'],
        'A1',
      );
      expect(setup.adapter.requests.single.queryParameters['type'], 'word');
      expect(setup.adapter.requests.single.queryParameters['limit'], 60);
    },
  );

  test('fetchBalanced omits type query param when not provided', () async {
    final setup = _setup(['[]']);
    final repository = LearningItemRepository(setup.client);

    await repository.fetchBalanced(userLevel: 'B1');

    expect(
      setup.adapter.requests.single.queryParameters.containsKey('type'),
      isFalse,
    );
  });

  test('fetchBalanced returns empty list for empty response', () async {
    final setup = _setup(['[]']);
    final repository = LearningItemRepository(setup.client);

    final items = await repository.fetchBalanced(userLevel: 'A2');

    expect(items, isEmpty);
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
