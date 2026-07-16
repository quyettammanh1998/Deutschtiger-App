import 'package:deutschtiger/services/api_client.dart';

import '../../data/speech/sprechen_chat_models.dart';

/// Repository for the live sprechen AI partner chat / grading calls
/// (text-only; microphone + Azure pronunciation assessment are out of scope
/// for this phase, see `ReleaseFeatureFlags.speaking`).
///
/// Source: `routes_ai.go` → `aiHandler.SprechenPartner/SprechenFeedback/
/// SprechenSuggestions/GradeSprechen` (rate-limited 30/min/user). Response
/// shape is `Review` status per `docs/flutter-api-contract-matrix.md` —
/// request bodies below match the documented contract; responses are parsed
/// defensively.
class SprechenAiRepository {
  SprechenAiRepository(this._apiClient);
  final ApiClient _apiClient;

  /// Sends the running conversation + latest user turn, gets the partner's
  /// next line back.
  Future<String> partnerReply({
    required String teil,
    required String topic,
    required List<Map<String, String>> history,
    required String userMessage,
  }) async {
    final data = await _apiClient.post<Map<String, dynamic>>(
      '/ai/sprechen-partner',
      body: {
        'teil': teil,
        'topic': topic,
        'history': history,
        'user_message': userMessage,
      },
    );
    return data['ai_message'] as String? ?? data['message'] as String? ?? '';
  }

  /// Per-turn feedback (score /5 + short comment) shown under a user bubble.
  Future<({int score, String comment})> turnFeedback({
    required String teil,
    required String userMessage,
  }) async {
    final data = await _apiClient.post<Map<String, dynamic>>(
      '/ai/sprechen-feedback',
      body: {'teil': teil, 'message': userMessage},
    );
    return (
      score: (data['score'] as num?)?.toInt() ?? 0,
      comment: data['comment'] as String? ?? '',
    );
  }

  /// Suggestion chips for the input area's bulb toggle.
  Future<List<String>> suggestions({
    required String teil,
    required String topic,
    required List<Map<String, String>> history,
  }) async {
    final data = await _apiClient.post<Map<String, dynamic>>(
      '/ai/sprechen-suggestions',
      body: {'teil': teil, 'topic': topic, 'history': history},
    );
    return (data['suggestions'] as List<dynamic>?)?.cast<String>() ??
        const [];
  }

  /// Final grading (Bewertung panel) — full transcript in, per-category
  /// scores + main errors out.
  Future<SprechenGrading> gradeSprechen({
    required String teil,
    required String topic,
    required List<Map<String, String>> history,
  }) async {
    final data = await _apiClient.post<Map<String, dynamic>>(
      '/ai/grade-sprechen',
      body: {'teil': teil, 'topic': topic, 'history': history},
    );
    return SprechenGrading.fromJson(data);
  }
}
