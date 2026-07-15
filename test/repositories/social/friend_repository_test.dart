import 'dart:typed_data';

import 'package:deutschtiger/repositories/social/friend_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getFriends parses the FriendProfile list contract', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/friends');
      return _jsonResponse('''
        [
          {"id":"u1","display_name":"Maria","avatar_url":"","level":5,
           "current_streak":10,"total_xp":500,"friendship_status":"accepted",
           "friendship_id":"f1","is_online":true}
        ]
      ''');
    });

    final friends = await FriendRepository(_client(adapter)).getFriends();

    expect(friends, hasLength(1));
    expect(friends[0].displayName, 'Maria');
    expect(friends[0].friendshipStatus, 'accepted');
    expect(friends[0].isOnline, isTrue);
  });

  test('getPendingRequests parses the requester sub-object', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/friends/pending');
      return _jsonResponse('''
        [
          {"id":"r1","requester_id":"u2","addressee_id":"u1","status":"pending",
           "created_at":"2026-07-15T10:00:00Z",
           "requester":{"id":"u2","display_name":"Hans","avatar_url":"","level":3,
             "current_streak":1,"total_xp":50}}
        ]
      ''');
    });

    final requests = await FriendRepository(_client(adapter)).getPendingRequests();

    expect(requests, hasLength(1));
    expect(requests[0].requester.displayName, 'Hans');
  });

  test('searchUsers returns empty without a network call for blank query', () async {
    final adapter = _ScriptedAdapter((options) async {
      fail('should not call the network for a blank query');
    });

    final results = await FriendRepository(_client(adapter)).searchUsers('   ');

    expect(results, isEmpty);
  });

  test('sendRequest POSTs addressee_id', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'POST');
      expect(options.path, '/user/friends/request');
      expect(options.data, {'addressee_id': 'u2'});
      return _jsonResponse('{"id":"r1"}');
    });

    await FriendRepository(_client(adapter)).sendRequest('u2');
  });

  test('acceptRequest calls PUT /user/friends/{id}/accept', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'PUT');
      expect(options.path, '/user/friends/r1/accept');
      return _jsonResponse('{"status":"ok"}');
    });

    await FriendRepository(_client(adapter)).acceptRequest('r1');
  });

  test('rejectRequest calls DELETE /user/friends/{id}/reject', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'DELETE');
      expect(options.path, '/user/friends/r1/reject');
      return _jsonResponse('{"status":"ok"}');
    });

    await FriendRepository(_client(adapter)).rejectRequest('r1');
  });

  test('removeFriend calls DELETE /user/friends/{friendshipId}', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'DELETE');
      expect(options.path, '/user/friends/f1');
      return _jsonResponse('{"status":"ok"}');
    });

    await FriendRepository(_client(adapter)).removeFriend('f1');
  });

  test('blockUser POSTs target_user_id', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'POST');
      expect(options.path, '/user/friends/block');
      expect(options.data, {'target_user_id': 'u2'});
      return _jsonResponse('{"status":"ok"}');
    });

    await FriendRepository(_client(adapter)).blockUser('u2');
  });

  test('getStatus parses friendship status', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/user/friends/status/u2');
      return _jsonResponse('{"status":"pending_sent","friendship_id":"f2"}');
    });

    final status = await FriendRepository(_client(adapter)).getStatus('u2');

    expect(status.status, 'pending_sent');
    expect(status.friendshipId, 'f2');
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
