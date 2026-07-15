import 'dart:typed_data';

import 'package:deutschtiger/core/translation/translation_service.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'translation uses the authenticated DeutschTiger API, never DeepL',
    () async {
      final adapter = _ResponseAdapter('''
      {"translations":["Guten Tag"],"sourceLang":"vi","targetLang":"de"}
    ''');
      final client = ApiClient(
        baseUrl: 'https://api.example.test/api/v1',
        tokenProvider: const _TokenProvider(),
      )..raw.httpClientAdapter = adapter;
      final service = TranslationService(client);

      final result = await service.translate(
        text: 'Xin chào',
        sourceLang: 'vi',
        targetLang: 'de',
      );

      expect(result.success, isTrue);
      expect(result.text, 'Guten Tag');
      expect(result.detectedSourceLang, 'VI');
      final request = adapter.request!;
      expect(
        request.uri.toString(),
        'https://api.example.test/api/v1/ai/translate-sentences',
      );
      expect(request.headers['Authorization'], 'Bearer test-token');
      expect(request.headers.containsKey('DeepL-Auth-Key'), isFalse);
      expect(request.data, {
        'sentences': ['Xin chào'],
        'sourceLang': 'vi',
        'targetLang': 'de',
      });
    },
  );

  test(
    'translation exposes a safe rate-limit error without provider details',
    () async {
      final client =
          ApiClient(
              baseUrl: 'https://api.example.test/api/v1',
              tokenProvider: const _TokenProvider(),
            )
            ..raw.httpClientAdapter = _ResponseAdapter(
              '{"error":"upstream key leaked"}',
              statusCode: 429,
            );
      final service = TranslationService(client);

      final result = await service.translate(text: 'Hallo', targetLang: 'vi');

      expect(result.success, isFalse);
      expect(result.error, contains('quá nhiều'));
      expect(result.error, isNot(contains('key')));
    },
  );
}

class _TokenProvider implements TokenProvider {
  const _TokenProvider();

  @override
  Future<String?> getAccessToken() async => 'test-token';

  @override
  Future<String?> refresh() async => null;
}

class _ResponseAdapter implements HttpClientAdapter {
  _ResponseAdapter(this.body, {this.statusCode = 200});

  final String body;
  final int statusCode;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options.copyWith(
      headers: Map<String, dynamic>.from(options.headers),
    );
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
