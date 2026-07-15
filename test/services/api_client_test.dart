import 'dart:typed_data';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'device-kicked 401 invokes handler without refreshing the token',
    () async {
      final tokenProvider = _FakeTokenProvider();
      final client = ApiClient(
        baseUrl: 'https://example.test/api/v1',
        tokenProvider: tokenProvider,
      );
      client.raw.httpClientAdapter = _QueueAdapter([
        _ResponseSpec(
          401,
          '{"code":"device_kicked"}',
          headers: {
            'x-device-kicked': ['true'],
          },
        ),
      ]);
      var kickedCount = 0;
      client.onDeviceKicked = () async => kickedCount++;

      await expectLater(
        client.get<Map<String, dynamic>>('/user/profile'),
        throwsA(isA<ApiException>()),
      );

      expect(kickedCount, 1);
      expect(tokenProvider.refreshCount, 0);
    },
  );

  test('device-kicked error field is parsed by the client', () async {
    final tokenProvider = _FakeTokenProvider();
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: tokenProvider,
    );
    client.raw.httpClientAdapter = _QueueAdapter([
      const _ResponseSpec(401, '{"error":"device_kicked"}'),
    ]);
    var kickedCount = 0;
    client.onDeviceKicked = () async => kickedCount++;

    await expectLater(
      client.get<Map<String, dynamic>>('/user/profile'),
      throwsA(isA<ApiException>()),
    );

    expect(kickedCount, 1);
    expect(tokenProvider.refreshCount, 0);
  });

  test('regular 401 refreshes once and retries with the new token', () async {
    final tokenProvider = _FakeTokenProvider(refreshedToken: 'fresh-token');
    final adapter = _QueueAdapter([
      const _ResponseSpec(401, '{"message":"expired"}'),
      const _ResponseSpec(200, '{"ok":true}'),
    ]);
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: tokenProvider,
    );
    client.raw.httpClientAdapter = adapter;

    final result = await client.get<Map<String, dynamic>>('/user/profile');

    expect(result['ok'], isTrue);
    expect(tokenProvider.refreshCount, 1);
    expect(
      adapter.requests.last.headers['Authorization'],
      'Bearer fresh-token',
    );
  });
}

class _FakeTokenProvider implements TokenProvider {
  _FakeTokenProvider({this.refreshedToken});

  final String? refreshedToken;
  int refreshCount = 0;
  String _currentToken = 'old-token';

  @override
  Future<String?> getAccessToken() async => _currentToken;

  @override
  Future<String?> refresh() async {
    refreshCount++;
    if (refreshedToken != null) _currentToken = refreshedToken!;
    return refreshedToken;
  }
}

class _ResponseSpec {
  const _ResponseSpec(this.statusCode, this.body, {this.headers = const {}});

  final int statusCode;
  final String body;
  final Map<String, List<String>> headers;
}

class _QueueAdapter implements HttpClientAdapter {
  _QueueAdapter(this._responses);

  final List<_ResponseSpec> _responses;
  final List<RequestOptions> requests = [];
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(
      options.copyWith(headers: Map<String, dynamic>.from(options.headers)),
    );
    final response = _responses[_index++];
    return ResponseBody.fromString(
      response.body,
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
        ...response.headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
