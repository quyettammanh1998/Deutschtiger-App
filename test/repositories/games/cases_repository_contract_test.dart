import 'dart:typed_data';

import 'package:deutschtiger/repositories/games/cases_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchAkkDat uses GET /user/cases/akk-dat + level/limit query, parses mastery', () async {
    final setup = _setup([
      '{"exercises":[{"id":"e1","level":"A2","sentence":"Ich sehe ___ Mann.",'
          '"options":["der","den","dem"],"answer":"den","case":"Akkusativ",'
          '"reason":"sehen + Akk","vi":"Tôi thấy người đàn ông."}],'
          '"mastery":{"byCase":{"Akkusativ":50},"mastered":5,"total":10}}',
    ]);
    final repository = CasesRepository(setup.client);

    final response = await repository.fetchAkkDat(level: 'A2', limit: 30);

    expect(response.exercises.single.answer, 'den');
    expect(response.exercises.single.caseType, 'Akkusativ');
    expect(response.mastery!.byCase['Akkusativ'], 50);
    expect(response.mastery!.mastered, 5);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/user/cases/akk-dat');
    expect(setup.adapter.requests.single.queryParameters['level'], 'A2');
    expect(setup.adapter.requests.single.queryParameters['limit'], 30);
  });

  test('fetchAdjektiv hits /user/cases/adjektiv', () async {
    final setup = _setup(['{"exercises":[]}']);
    final repository = CasesRepository(setup.client);

    await repository.fetchAdjektiv(level: 'B1');

    expect(setup.adapter.requests.single.path, '/user/cases/adjektiv');
  });

  test('fetchWechselprep hits /user/cases/wechselprep', () async {
    final setup = _setup(['{"exercises":[]}']);
    final repository = CasesRepository(setup.client);

    await repository.fetchWechselprep(level: 'B1');

    expect(setup.adapter.requests.single.path, '/user/cases/wechselprep');
  });

  test('fetchVerbCase parses items + mastery from /user/cases/verb-case', () async {
    final setup = _setup([
      '{"items":[{"id":"v1","level":"A2","verb":"helfen","case":"Dativ",'
          '"example":"Ich helfe dem Mann.","vi_example":"Tôi giúp người đàn ông.",'
          '"vi_verb":"giúp đỡ"}],"mastery":{"byCase":{"Dativ":30},"mastered":3,"total":10}}',
    ]);
    final repository = CasesRepository(setup.client);

    final response = await repository.fetchVerbCase(level: 'A2', limit: 15);

    expect(response.items.single.verb, 'helfen');
    expect(response.items.single.caseType, 'Dativ');
    expect(response.mastery!.total, 10);
    expect(setup.adapter.requests.single.path, '/user/cases/verb-case');
    expect(setup.adapter.requests.single.queryParameters['limit'], 15);
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
