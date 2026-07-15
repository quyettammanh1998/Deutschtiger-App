import 'dart:typed_data';

import 'package:deutschtiger/repositories/games/word_writing_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('gradeWord uses POST contract with all fields, parses result', () async {
    final setup = _setup([
      '{"correct":true,"hint":"Tốt lắm!","suggestion":"die Mutter"}',
    ]);
    final repository = WordWritingRepository(setup.client);

    final result = await repository.gradeWord(
      userInput: 'mutter',
      targetWord: 'Mutter',
      targetVi: 'mẹ',
      level: 'A1',
    );

    expect(result.correct, isTrue);
    expect(result.hint, 'Tốt lắm!');
    expect(result.suggestion, 'die Mutter');
    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/ai/grade-word-writing');
    final body = setup.adapter.requests.single.data as Map<String, dynamic>;
    expect(body['user_input'], 'mutter');
    expect(body['target_word'], 'Mutter');
    expect(body['target_vi'], 'mẹ');
    expect(body['level'], 'A1');
  });

  test('gradeWord parses an incorrect result', () async {
    final setup = _setup([
      '{"correct":false,"hint":"Chưa đúng.","suggestion":"das Haus"}',
    ]);
    final repository = WordWritingRepository(setup.client);

    final result = await repository.gradeWord(
      userInput: 'haus1',
      targetWord: 'Haus',
      targetVi: 'nhà',
      level: 'A1',
    );

    expect(result.correct, isFalse);
    expect(result.suggestion, 'das Haus');
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
