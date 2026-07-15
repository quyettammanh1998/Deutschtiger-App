import 'dart:convert';
import 'dart:typed_data';

import 'package:deutschtiger/data/ai/ai_chat_live_models.dart';
import 'package:deutschtiger/repositories/ai/ai_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AIRepository.sendMessage (POST /ai/chat SSE)', () {
    test('streams content tokens then done, and reports the session id', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          'data: {"content":"Hallo"}\n\n'
          'data: {"content":" Welt"}\n\n'
          'data: [DONE]\n\n',
          200,
          headers: {
            Headers.contentTypeHeader: ['text/event-stream'],
            'x-session-id': ['session-abc'],
          },
        );
      });
      final repo = AIRepository(_client(adapter));

      String? seenSessionId;
      final events = await repo
          .sendMessage(content: 'Hallo', onSessionId: (id) => seenSessionId = id)
          .toList();

      expect(events, [
        isA<AiChatContentEvent>().having((e) => e.text, 'text', 'Hallo'),
        isA<AiChatContentEvent>().having((e) => e.text, 'text', ' Welt'),
        isA<AiChatDoneEvent>(),
      ]);
      expect(seenSessionId, 'session-abc');
      expect(adapter.lastOptions?.method, 'POST');
      expect(adapter.lastOptions?.path, '/ai/chat');
      expect(
        (adapter.lastOptions?.data as Map)['payload_mode'],
        'session',
      );
    });

    test('surfaces an in-band error event without aborting the stream', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          'data: {"content":"partial"}\n\n'
          'data: {"error":"AI đang quá tải, vui lòng thử lại sau."}\n\n'
          'data: [DONE]\n\n',
          200,
          headers: {
            Headers.contentTypeHeader: ['text/event-stream'],
          },
        );
      });
      final repo = AIRepository(_client(adapter));

      final events = await repo.sendMessage(content: 'Hallo').toList();

      expect(events, [
        isA<AiChatContentEvent>(),
        isA<AiChatErrorEvent>().having(
          (e) => e.message,
          'message',
          contains('quá tải'),
        ),
        isA<AiChatDoneEvent>(),
      ]);
    });

    test('maps a pre-stream daily-quota rejection to AiChatRequestException', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          jsonEncode({
            'error': 'free_limit_reached',
            'message': 'Bạn đã dùng hết 7 lượt chat miễn phí hôm nay.',
            'limit': 7,
            'used': 7,
          }),
          429,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });
      final repo = AIRepository(_client(adapter));

      await expectLater(
        repo.sendMessage(content: 'Hallo').toList(),
        throwsA(
          isA<AiChatRequestException>()
              .having((e) => e.isQuotaExceeded, 'isQuotaExceeded', true)
              .having((e) => e.limit, 'limit', 7)
              .having((e) => e.used, 'used', 7),
        ),
      );
    });

    test('maps a session-forbidden rejection to a plain AiChatRequestException', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          jsonEncode({'error': 'Phiên trò chuyện không tồn tại hoặc bạn không có quyền truy cập'}),
          403,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });
      final repo = AIRepository(_client(adapter));

      await expectLater(
        repo.sendMessage(content: 'Hallo', sessionId: 'not-mine').toList(),
        throwsA(
          isA<AiChatRequestException>()
              .having((e) => e.code, 'code', isNull)
              .having((e) => e.message, 'message', contains('không có quyền')),
        ),
      );
    });
  });

  group('AIRepository session/memory/profile JSON contracts', () {
    test('getSessions parses the list contract', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          jsonEncode([
            {'id': 's1', 'title': 'Grammatik', 'messageCount': 4},
          ]),
          200,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });
      final repo = AIRepository(_client(adapter));

      final sessions = await repo.getSessions();

      expect(sessions, hasLength(1));
      expect(sessions.single.id, 's1');
      expect(adapter.lastOptions?.method, 'GET');
      expect(adapter.lastOptions?.path, '/ai/sessions');
    });

    test('getMemory parses the facts contract', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          jsonEncode({
            'facts': [
              {'id': 'f1', 'factKey': 'german_level', 'factValue': 'B1'},
            ],
          }),
          200,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });
      final repo = AIRepository(_client(adapter));

      final facts = await repo.getMemory();

      expect(facts.single.factKey, 'german_level');
    });

    test('updateProfile PUTs fields+notes and parses the response', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          jsonEncode({
            'fields': {'name': 'Minh'},
            'fieldsDe': {'name': 'Minh'},
            'notes': [
              {'raw': 'thích đọc sách', 'de': 'liest gern Bücher'},
            ],
          }),
          200,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });
      final repo = AIRepository(_client(adapter));

      final profile = await repo.updateProfile(
        fields: {'name': 'Minh'},
        notes: ['thích đọc sách'],
      );

      expect(adapter.lastOptions?.method, 'PUT');
      expect(adapter.lastOptions?.path, '/ai/profile');
      expect(profile.fields['name'], 'Minh');
      expect(profile.notes.single.de, 'liest gern Bücher');
    });
  });
}

ApiClient _client(HttpClientAdapter adapter) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  client.raw.httpClientAdapter = adapter;
  return client;
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

/// Minimal scripted [HttpClientAdapter] — the handler decides the response
/// (or throws), so each test controls status/body directly instead of
/// hitting the network. Matches the pattern in `phase_1_contract_test.dart`,
/// extended with header support for the SSE `X-Session-Id` contract.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._handler);
  final Future<ResponseBody> Function(RequestOptions options) _handler;
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastOptions = options;
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}
