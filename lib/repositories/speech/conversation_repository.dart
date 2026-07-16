import 'package:deutschtiger/services/api_client.dart';

import '../../data/speech/conversation_models.dart';
import '../../data/speech/conversation_session_models.dart';

/// Core conversation-scenario repository — scenarios list/detail, opening
/// line, text-turn send, and the custom-topic pre-chat survey. Mirrors web
/// `lib/conversation/conversation-service.ts` + `survey-service.ts`.
class ConversationRepository {
  ConversationRepository(this._api);

  final ApiClient _api;

  /// `GET /user/conversation/scenarios` → hub tile list (id/title/level).
  Future<List<ScenarioMeta>> fetchScenarios() async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/conversation/scenarios',
    );
    final raw = json['scenarios'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => ScenarioMeta.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// `GET /user/conversation/scenario/{id}` → full scenario detail.
  Future<Scenario> fetchScenario(String id) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/conversation/scenario/${Uri.encodeComponent(id)}',
    );
    final scenario = json['scenario'];
    if (scenario is! Map) {
      throw ApiException('Không thể tải kịch bản.');
    }
    return Scenario.fromJson(Map<String, dynamic>.from(scenario));
  }

  /// `POST /user/conversation/opening` → the AI's opening German message.
  /// Callers should fall back to `scenario.starterPromptDe` on failure.
  Future<String> fetchOpening({
    required String scenarioId,
    CustomScenarioPayload? customScenario,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/conversation/opening',
      body: {
        'scenario_id': scenarioId,
        if (customScenario != null) 'custom_scenario': customScenario.toJson(),
      },
    );
    return (json['ai_message'] as String?) ?? '';
  }

  /// `POST /user/conversation/turn` → AI reply + session-done flag +
  /// per-required-point coverage.
  Future<TurnResponse> postTurn({
    required String scenarioId,
    required List<DialogMessage> history,
    required String userMessage,
    CustomScenarioPayload? customScenario,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/conversation/turn',
      body: {
        'scenario_id': scenarioId,
        'history': history.map((m) => m.toJson()).toList(),
        'user_message': userMessage,
        if (customScenario != null) 'custom_scenario': customScenario.toJson(),
      },
    );
    return TurnResponse.fromJson(json);
  }

  /// `POST /user/conversation/survey` → discussion-point picker categories
  /// for a custom topic (pre-chat survey gate).
  Future<ConversationSurvey> fetchSurvey({
    required String topic,
    required String level,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/conversation/survey',
      body: {'topic': topic, 'level': level},
    );
    return ConversationSurvey.fromJson(json);
  }
}
