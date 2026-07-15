import 'dart:typed_data';

import 'package:deutschtiger/repositories/games/conjugation_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchExercises uses GET /user/conjugation/exercise + type/level/limit query', () async {
    final setup = _setup([
      '{"exercises":[{"id":"c1","verb":"haben","infinitive":"haben",'
          '"type":"irregular","level":"A1","tense":"Präsens","person":"ich",'
          '"expected":"habe","alternatives":[],"vi_verb":"có",'
          '"prompt":"ich (haben, Präsens)","key":"haben:Präsens:ich"}]}',
    ]);
    final repository = ConjugationRepository(setup.client);

    final exercises = await repository.fetchExercises(level: 'A1', limit: 30);

    expect(exercises.single.expected, 'habe');
    expect(exercises.single.key, 'haben:Präsens:ich');
    expect(exercises.single.learningItemId, isNull);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/user/conjugation/exercise');
    expect(setup.adapter.requests.single.queryParameters['type'], 'all');
    expect(setup.adapter.requests.single.queryParameters['level'], 'A1');
    expect(setup.adapter.requests.single.queryParameters['limit'], 30);
  });

  test('fetchExercises parses learning_item_id when personalized', () async {
    final setup = _setup([
      '{"exercises":[{"id":"conj-p-x","verb":"spielen","infinitive":"spielen",'
          '"type":"regular","level":"A2","tense":"Präsens","person":"ich",'
          '"expected":"spiele","alternatives":["spiel"],"vi_verb":"chơi",'
          '"prompt":"ich (spielen, Präsens)","key":"spielen:Präsens:ich",'
          '"learning_item_id":"li-9"}]}',
    ]);
    final repository = ConjugationRepository(setup.client);

    final exercises = await repository.fetchExercises(level: 'A2');

    expect(exercises.single.learningItemId, 'li-9');
    expect(exercises.single.alternatives, ['spiel']);
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
