import 'dart:typed_data';

import 'package:deutschtiger/repositories/social/moment_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getFeed passes limit/offset and parses the moment-with-meta contract', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/moments/feed');
      expect(options.queryParameters['limit'], 20);
      expect(options.queryParameters['offset'], 0);
      return _jsonResponse('''
        [
          {"id":"m1","user_id":"u2","content":"Hallo Welt","tags":[],
           "created_at":"2026-07-15T10:00:00Z","display_name":"Maria",
           "avatar_url":"","like_count":3,"comment_count":1,"is_liked":false}
        ]
      ''');
    });

    final feed = await MomentRepository(_client(adapter)).getFeed();

    expect(feed, hasLength(1));
    expect(feed[0].displayName, 'Maria');
    expect(feed[0].likeCount, 3);
    expect(feed[0].isLiked, isFalse);
  });

  test('getComments parses the read-only comment list', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.path, '/moments/m1/comments');
      return _jsonResponse('''
        [
          {"id":"c1","moment_id":"m1","user_id":"u3","content":"Nice!",
           "display_name":"Hans","avatar_url":"","created_at":"2026-07-15T10:05:00Z"}
        ]
      ''');
    });

    final comments = await MomentRepository(_client(adapter)).getComments('m1');

    expect(comments, hasLength(1));
    expect(comments[0].content, 'Nice!');
  });

  test('like POSTs /user/moments/{id}/like', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'POST');
      expect(options.path, '/user/moments/m1/like');
      return _jsonResponse('{"status":"ok"}');
    });

    await MomentRepository(_client(adapter)).like('m1');
  });

  test('unlike DELETEs /user/moments/{id}/like', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'DELETE');
      expect(options.path, '/user/moments/m1/like');
      return _jsonResponse('{"status":"ok"}');
    });

    await MomentRepository(_client(adapter)).unlike('m1');
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
