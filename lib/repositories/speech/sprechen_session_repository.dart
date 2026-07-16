import 'package:deutschtiger/services/api_client.dart';

import '../../data/speech/sprechen_session_models.dart';

/// Repository for sprechen results / sessions / leaderboard (authenticated).
///
/// Source: `routes_user_exam.go` → `sprechenResultHandler`,
/// `sprechenSessionHandler`. Response shape is `Review` status per
/// `docs/flutter-api-contract-matrix.md` — request bodies match the
/// documented contract; response parsing stays defensive via
/// `Map<String,dynamic>` passthrough (see `raw` on the DTOs).
class SprechenSessionRepository {
  SprechenSessionRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<void> submitResult(SprechenResult result) async {
    await _apiClient.post<dynamic>(
      '/user/sprechen-results',
      body: result.toRequestJson(),
    );
  }

  Future<List<SprechenResult>> fetchResults() async {
    final data = await _apiClient.get<dynamic>('/user/sprechen-results');
    final list = _asList(data, key: 'results');
    return list
        .map((e) => SprechenResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteResult({
    required String teil,
    required String topicSlug,
  }) async {
    await _apiClient.delete<dynamic>('/user/sprechen-results/$teil/$topicSlug');
  }

  Future<List<SprechenLeaderboardEntry>> fetchLeaderboard() async {
    final data = await _apiClient.get<dynamic>('/user/sprechen-leaderboard');
    final list = _asList(data, key: 'leaderboard');
    return list
        .map(
          (e) => SprechenLeaderboardEntry.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<SprechenSession> createSession({
    required String teil,
    required String topic,
  }) async {
    final data = await _apiClient.post<Map<String, dynamic>>(
      '/user/sprechen-sessions',
      body: {'teil': teil, 'topic': topic},
    );
    return SprechenSession.fromJson(data);
  }

  Future<void> attachAiSession({
    required String sessionId,
    required String aiSessionId,
  }) async {
    await _apiClient.patch<dynamic>(
      '/user/sprechen-sessions/$sessionId',
      body: {'ai_session_id': aiSessionId},
    );
  }

  Future<List<SprechenSession>> fetchSessions() async {
    final data = await _apiClient.get<dynamic>('/user/sprechen-sessions');
    final list = _asList(data, key: 'sessions');
    return list
        .map((e) => SprechenSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SprechenSessionMessage>> fetchSessionMessages(
    String sessionId,
  ) async {
    final data = await _apiClient.get<dynamic>(
      '/user/sprechen-sessions/$sessionId/messages',
    );
    final list = _asList(data, key: 'messages');
    return list
        .map(
          (e) => SprechenSessionMessage.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  /// Response shape (bare array vs `{key: [...]}` envelope) is unverified
  /// (Review status) — accept either so a shape change on either side
  /// doesn't silently drop data.
  List<dynamic> _asList(dynamic data, {required String key}) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final value = data[key];
      if (value is List) return value;
    }
    return const [];
  }
}
