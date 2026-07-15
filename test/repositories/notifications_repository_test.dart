import 'dart:typed_data';

import 'package:deutschtiger/data/notifications/notification_models.dart';
import 'package:deutschtiger/repositories/notifications/notifications_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getNotifications parses the backend list contract', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/notifications');
      expect(options.queryParameters['limit'], 20);
      return _jsonResponse('''
        [
          {"id":"n1","type":"friend_request","data":{"requester_name":"Maria"},"read":false,"created_at":"2026-07-15T10:00:00Z"},
          {"id":"n2","type":"daily_review","data":{},"read":true,"created_at":"2026-07-14T10:00:00Z"}
        ]
      ''');
    });

    final repo = NotificationsRepository(_client(adapter));
    final items = await repo.getNotifications();

    expect(items, hasLength(2));
    expect(items[0].id, 'n1');
    expect(items[0].type, 'friend_request');
    expect(items[0].data['requester_name'], 'Maria');
    expect(items[0].isRead, isFalse);
    expect(items[1].isRead, isTrue);
  });

  test('getUnreadCounts parses messages + notifications', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/unread-counts');
      return _jsonResponse('{"messages":2,"notifications":5}');
    });

    final counts = await NotificationsRepository(_client(adapter)).getUnreadCounts();

    expect(counts.messages, 2);
    expect(counts.notifications, 5);
  });

  test('markAsRead calls PUT /user/notifications/{id}/read', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'PUT');
      expect(options.path, '/user/notifications/n1/read');
      return _jsonResponse('{"status":"ok"}');
    });

    await NotificationsRepository(_client(adapter)).markAsRead('n1');
  });

  test('markAllAsRead calls PUT /user/notifications/read-all', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'PUT');
      expect(options.path, '/user/notifications/read-all');
      return _jsonResponse('{"status":"ok"}');
    });

    await NotificationsRepository(_client(adapter)).markAllAsRead();
  });

  test('getPreferences derives preferred_time from notify_hour/bucket when absent', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/notification-preferences');
      return _jsonResponse('''
        {"enabled":true,"notify_hour":7,"notify_minute_bucket":30,"timezone":"Asia/Ho_Chi_Minh","content_mode":"word"}
      ''');
    });

    final prefs = await NotificationsRepository(_client(adapter)).getPreferences();

    expect(prefs.enabled, isTrue);
    expect(prefs.preferredTime, '07:30');
    expect(prefs.contentMode, 'word');
  });

  test('savePreferences PUTs the preference payload and parses the response', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'PUT');
      expect(options.path, '/user/notification-preferences');
      expect(options.data, {
        'enabled': true,
        'preferred_time': '08:00',
        'timezone': 'Asia/Ho_Chi_Minh',
        'content_mode': 'mix',
      });
      return _jsonResponse('''
        {"enabled":true,"preferred_time":"08:00","timezone":"Asia/Ho_Chi_Minh","content_mode":"mix"}
      ''');
    });

    final saved = await NotificationsRepository(_client(adapter)).savePreferences(
      const NotificationPreferences(
        enabled: true,
        preferredTime: '08:00',
        timezone: 'Asia/Ho_Chi_Minh',
        contentMode: 'mix',
      ),
    );

    expect(saved.preferredTime, '08:00');
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
