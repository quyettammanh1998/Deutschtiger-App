import 'dart:typed_data';

import 'package:deutschtiger/repositories/settings/device_session_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses the backend devices envelope', () {
    final devices = parseDeviceSessions({
      'devices': [
        {
          'session_id': 'session-1',
          'is_current': true,
          'first_seen': '2026-07-10T10:00:00Z',
          'last_seen': '2026-07-14T10:00:00Z',
          'user_agent': 'DeutschTiger Android',
          'ip': null,
        },
      ],
    });

    expect(devices, hasLength(1));
    expect(devices.single.sessionId, 'session-1');
    expect(devices.single.isCurrent, isTrue);
    expect(devices.single.ip, isNull);
  });

  test('returns an empty list for an envelope without devices', () {
    expect(parseDeviceSessions(<String, dynamic>{}), isEmpty);
  });

  test('revoke other devices keeps the current session', () async {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    final adapter = _DeviceAdapter();
    client.raw.httpClientAdapter = adapter;

    await DeviceSessionRepository(client).revokeOtherDevices();

    expect(
      adapter.requests.map((request) => '${request.method} ${request.path}'),
      ['GET /user/devices', 'DELETE /user/devices/other-session'],
    );
  });
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _DeviceAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = options.method == 'GET'
        ? '{"devices":['
              '{"session_id":"current-session","is_current":true},'
              '{"session_id":"other-session","is_current":false}'
              ']}'
        : '{}';
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
