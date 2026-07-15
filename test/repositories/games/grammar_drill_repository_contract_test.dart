import 'dart:typed_data';

import 'package:deutschtiger/repositories/games/grammar_drill_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('submitResults POSTs /user/grammar-drill/results with game + results body', () async {
    final setup = _setup([204]);
    final repository = GrammarDrillRepository(setup.client);

    await repository.submitResults('akk-dat', const [
      GrammarDrillResultInput(key: 'e1', correct: true),
      GrammarDrillResultInput(key: 'e2', correct: false),
    ]);

    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/user/grammar-drill/results');
    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    expect(body['game'], 'akk-dat');
    final results = body['results'] as List<dynamic>;
    expect(results, hasLength(2));
    expect(results[0]['key'], 'e1');
    expect(results[0]['correct'], isTrue);
    expect(results[0].containsKey('learning_item_id'), isFalse);
  });

  test('submitResults includes learning_item_id when present (konjugation)', () async {
    final setup = _setup([204]);
    final repository = GrammarDrillRepository(setup.client);

    await repository.submitResults('konjugation', const [
      GrammarDrillResultInput(
        key: 'haben:Präsens:ich',
        correct: true,
        learningItemId: 'li-1',
      ),
    ]);

    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>;
    expect(results.single['learning_item_id'], 'li-1');
  });

  test('submitResults is a no-op for empty results (no request sent)', () async {
    final setup = _setup([204]);
    final repository = GrammarDrillRepository(setup.client);

    await repository.submitResults('verb-case', const []);

    expect(setup.adapter.requests, isEmpty);
  });
}

({ApiClient client, _QueueAdapter adapter}) _setup(List<int> statusCodes) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _QueueAdapter(statusCodes);
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
  _QueueAdapter(this.statusCodes);

  final List<int> statusCodes;
  final List<RequestOptions> requests = [];
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString('', statusCodes[_index++]);
  }

  @override
  void close({bool force = false}) {}
}
