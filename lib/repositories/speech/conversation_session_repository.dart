import 'package:deutschtiger/services/api_client.dart';

import '../../data/speech/conversation_models.dart';
import '../../data/speech/conversation_session_models.dart';

/// Saved-session history + daily-quota repository. Mirrors web
/// `lib/conversation/session-service.ts`.
class ConversationSessionRepository {
  ConversationSessionRepository(this._api);

  final ApiClient _api;

  /// `GET /user/conversation/daily-quota`. Returns null on failure so
  /// callers can treat "unknown" distinctly from "walled" (web falls back to
  /// a try/catch returning null too).
  Future<ConversationDailyQuota?> fetchDailyQuota() async {
    try {
      final json = await _api.get<Map<String, dynamic>>(
        '/user/conversation/daily-quota',
      );
      return ConversationDailyQuota.fromJson(json);
    } on ApiException {
      return null;
    }
  }

  /// `GET /user/conversation/sessions?limit=&offset=` — newest first.
  Future<List<ConversationSessionSummary>> fetchSessions({
    int limit = 30,
    int offset = 0,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/conversation/sessions',
      query: {'limit': limit, 'offset': offset},
    );
    final raw = json['sessions'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (e) =>
              ConversationSessionSummary.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  /// `GET /user/conversation/sessions/{id}` — full transcript + feedback.
  Future<ConversationSessionDetail> fetchSession(String id) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/conversation/sessions/${Uri.encodeComponent(id)}',
    );
    final session = json['session'];
    if (session is! Map) {
      throw ApiException('Không tải được bài hội thoại đã lưu.');
    }
    return ConversationSessionDetail.fromJson(Map<String, dynamic>.from(session));
  }

  /// `POST /user/conversation/sessions` — persists a finished session
  /// (transcript + feedback + verdict, no audio). Returns the new session id.
  Future<String> saveSession({
    required String scenarioId,
    required String title,
    required String level,
    required int userTurns,
    required List<DialogMessage> messages,
    Map<String, dynamic>? feedback,
    Map<String, dynamic>? verdict,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/conversation/sessions',
      body: {
        'scenario_id': scenarioId,
        'title': title,
        'level': level,
        'user_turns': userTurns,
        'messages': messages.map((m) => m.toJson()).toList(),
        'feedback': feedback ?? const {},
        'verdict': verdict,
      },
    );
    return (json['id'] as String?) ?? '';
  }

  /// `DELETE /user/conversation/sessions/{id}`.
  Future<void> deleteSession(String id) => _api.delete<void>(
    '/user/conversation/sessions/${Uri.encodeComponent(id)}',
  );
}
