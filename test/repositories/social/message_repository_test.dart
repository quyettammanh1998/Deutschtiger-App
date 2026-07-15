import 'dart:typed_data';

import 'package:deutschtiger/repositories/social/message_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getConversations parses the conversation summary contract', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/messages/conversations');
      return _jsonResponse('''
        [
          {"friend_id":"u2","display_name":"Maria","avatar_url":"",
           "last_message_content":"Hallo!","last_message_at":"2026-07-15T10:00:00Z",
           "unread_count":2,"is_sender":false,"is_online":true}
        ]
      ''');
    });

    final convos = await MessageRepository(_client(adapter)).getConversations();

    expect(convos, hasLength(1));
    expect(convos[0].friendId, 'u2');
    expect(convos[0].unreadCount, 2);
    expect(convos[0].isOnline, isTrue);
  });

  test('getMessages passes the limit query param and parses messages', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/messages/u2');
      expect(options.queryParameters['limit'], 40);
      return _jsonResponse('''
        [
          {"id":"m1","sender_id":"u2","receiver_id":"u1","content":"Hi",
           "created_at":"2026-07-15T10:00:00Z","reactions":[]}
        ]
      ''');
    });

    final messages = await MessageRepository(_client(adapter)).getMessages('u2');

    expect(messages, hasLength(1));
    expect(messages[0].content, 'Hi');
    expect(messages[0].readAt, isNull);
  });

  test('sendMessage POSTs receiver_id + content and parses the created message', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'POST');
      expect(options.path, '/user/messages');
      expect(options.data, {'receiver_id': 'u2', 'content': 'Hallo!'});
      return ResponseBody.fromString(
        '{"id":"m2","sender_id":"u1","receiver_id":"u2","content":"Hallo!","created_at":"2026-07-15T10:01:00Z","reactions":[]}',
        201,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    });

    final message = await MessageRepository(_client(adapter)).sendMessage('u2', 'Hallo!');

    expect(message.id, 'm2');
    expect(message.content, 'Hallo!');
  });

  test('markAsRead calls PUT /user/messages/{senderId}/read', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'PUT');
      expect(options.path, '/user/messages/u2/read');
      return _jsonResponse('{"status":"ok"}');
    });

    await MessageRepository(_client(adapter)).markAsRead('u2');
  });

  test('getUnreadCount parses the count field', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/messages/unread-count');
      return _jsonResponse('{"count":3}');
    });

    final count = await MessageRepository(_client(adapter)).getUnreadCount();

    expect(count, 3);
  });
}

ResponseBody _jsonResponse(String body) => ResponseBody.fromString(
  body,
  200,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

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

class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._handler);
  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => _handler(options);

  @override
  void close({bool force = false}) {}
}
