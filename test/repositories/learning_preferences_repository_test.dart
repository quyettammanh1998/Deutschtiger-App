import 'dart:typed_data';

import 'package:deutschtiger/repositories/settings/learning_preferences_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('get() parses the backend preferences contract', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'GET');
      expect(options.path, '/user/preferences');
      return _jsonResponse('''
        {"cefr_level":"B1","daily_minutes":30,"daily_xp_goal":100}
      ''');
    });

    final prefs = await LearningPreferencesRepository(_client(adapter)).get();

    expect(prefs.cefrLevel, 'B1');
    expect(prefs.dailyMinutes, 30);
    expect(prefs.dailyXpGoal, 100);
  });

  test('save() PUTs the updated fields and parses the response', () async {
    final adapter = _ScriptedAdapter((options) async {
      expect(options.method, 'PUT');
      expect(options.path, '/user/preferences');
      expect(options.data, {
        'cefr_level': 'A2',
        'daily_minutes': 20,
        'daily_xp_goal': 80,
      });
      return _jsonResponse('''
        {"cefr_level":"A2","daily_minutes":20,"daily_xp_goal":80}
      ''');
    });

    final saved = await LearningPreferencesRepository(_client(adapter)).save(
      const LearningPreferences(cefrLevel: 'A2', dailyMinutes: 20, dailyXpGoal: 80),
    );

    expect(saved.cefrLevel, 'A2');
    expect(saved.dailyMinutes, 20);
  });

  test('fromJson falls back to defaults for missing fields', () {
    final prefs = LearningPreferences.fromJson(const {});

    expect(prefs.cefrLevel, 'A1');
    expect(prefs.dailyMinutes, 15);
    expect(prefs.dailyXpGoal, 50);
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
