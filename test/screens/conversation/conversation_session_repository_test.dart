import 'dart:convert';
import 'dart:typed_data';

import 'package:deutschtiger/data/speech/conversation_models.dart';
import 'package:deutschtiger/repositories/speech/conversation_session_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchDailyQuota parses the quota payload', () async {
    final setup = _setup('{"sessions_used":2,"max_sessions":4,"unlimited":false}');

    final quota = await setup.repository.fetchDailyQuota();

    expect(quota, isNotNull);
    expect(quota!.sessionsUsed, 2);
    expect(quota.maxSessions, 4);
    expect(quota.isWalled, isFalse);
    expect(setup.adapter.request!.path, '/user/conversation/daily-quota');
  });

  test('fetchDailyQuota returns null on API failure instead of throwing', () async {
    final client = ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider());
    client.raw.httpClientAdapter = _FailingAdapter();
    final repository = ConversationSessionRepository(client);

    final quota = await repository.fetchDailyQuota();

    expect(quota, isNull);
  });

  test('fetchSessions parses the session summaries list', () async {
    final setup = _setup('{"sessions":[{"id":"s1","scenario_id":"restaurant","title":"Im Restaurant","level":"A2","user_turns":3,"has_verdict":true,"created_at":"2026-07-01T10:00:00Z"}]}');

    final sessions = await setup.repository.fetchSessions();

    expect(sessions, hasLength(1));
    expect(sessions.first.hasVerdict, isTrue);
    expect(sessions.first.userTurns, 3);
  });

  test('saveSession sends the transcript payload and returns the new id', () async {
    final setup = _setup('{"id":"new-session-id"}');

    final id = await setup.repository.saveSession(
      scenarioId: 'restaurant',
      title: 'Im Restaurant',
      level: 'A2',
      userTurns: 1,
      messages: const [DialogMessage(role: 'user', text: 'Ich hätte gern...')],
    );

    expect(id, 'new-session-id');
    final body = setup.adapter.request!.data as Map;
    expect(body['scenario_id'], 'restaurant');
    expect(body['user_turns'], 1);
    expect(body['messages'], [
      {'role': 'user', 'text': 'Ich hätte gern...'},
    ]);
  });
}

({ConversationSessionRepository repository, _Adapter adapter}) _setup(String response) {
  final client = ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider());
  final adapter = _Adapter(response);
  client.raw.httpClientAdapter = adapter;
  return (repository: ConversationSessionRepository(client), adapter: adapter);
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
      data: options.data is String ? jsonDecode(options.data as String) : options.data,
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

class _FailingAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(requestOptions: options, error: 'boom');
  }

  @override
  void close({bool force = false}) {}
}
