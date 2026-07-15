import 'dart:convert';
import 'dart:typed_data';

import 'package:deutschtiger/repositories/flashcard/flashcard_quick_save_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'quick save sends the backend payload and parses saved result',
    () async {
      final setup = _setup('{"result":"saved"}');

      final result = await setup.repository.save(
        wordDe: ' machen ',
        wordVi: ' làm ',
        exampleSentence: ' Ich mache das. ',
      );

      expect(result, QuickSaveResult.saved);
      final request = setup.adapter.request!;
      expect(request.path, '/user/flashcards/quick-save');
      expect(request.method, 'POST');
      expect(request.data, {
        'word_de': 'machen',
        'word_vi': 'làm',
        'example_sentence': 'Ich mache das.',
      });
    },
  );

  test('quick save exposes duplicate as a successful state', () async {
    final setup = _setup('{"result":"duplicate"}');

    final result = await setup.repository.save(wordDe: 'machen');

    expect(result, QuickSaveResult.duplicate);
  });
}

({FlashcardQuickSaveRepository repository, _Adapter adapter}) _setup(
  String response,
) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _Adapter(response);
  client.raw.httpClientAdapter = adapter;
  return (repository: FlashcardQuickSaveRepository(client), adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.response);

  final String response;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options.copyWith(
      data: options.data is String
          ? jsonDecode(options.data as String)
          : options.data,
    );
    return ResponseBody.fromString(
      response,
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
