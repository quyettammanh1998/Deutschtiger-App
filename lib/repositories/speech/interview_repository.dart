import 'package:deutschtiger/services/api_client.dart';

import '../../data/speech/conversation_models.dart';
import '../../data/speech/conversation_session_models.dart';

/// Premium "luyện phỏng vấn từ tài liệu" repository: paste a doc → AI drafts
/// a scenario → user edits → save/reopen/delete. Mirrors web
/// `lib/conversation/interview-service.ts`. All routes are premium-gated
/// server-side (403 on free accounts) — Review status per contract matrix,
/// so callers must handle 403/502 explicitly rather than assume shape.
class InterviewRepository {
  InterviewRepository(this._api);

  final ApiClient _api;

  /// `POST /user/conversation/interview/extract` — large LLM call, allow a
  /// generous client timeout budget (handled by [ApiClient]'s shared
  /// timeouts; this call may legitimately take longer than typical requests).
  Future<Scenario> extractInterview({
    required String markdown,
    required String level,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/conversation/interview/extract',
      body: {'markdown': markdown, 'level': level},
    );
    final scenario = json['scenario'];
    if (scenario is! Map) {
      throw ApiException('Không trích xuất được, vui lòng thử lại.');
    }
    return Scenario.fromJson(Map<String, dynamic>.from(scenario));
  }

  /// `POST /user/conversation/interview/scenarios` — persists an edited
  /// draft. Returns the new scenario's bare UUID (for the play route).
  Future<String> saveInterviewScenario({
    required String title,
    required String level,
    required Scenario scenario,
    String? sourceMarkdown,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/conversation/interview/scenarios',
      body: {
        'title': title,
        'level': level,
        'scenario': _scenarioToJson(scenario),
        'source_markdown': ?sourceMarkdown,
      },
    );
    return (json['id'] as String?) ?? '';
  }

  /// `GET /user/conversation/interview/scenarios` — saved library, newest
  /// updated first.
  Future<List<InterviewScenarioSummary>> listInterviewScenarios() async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/conversation/interview/scenarios',
    );
    final raw = json['scenarios'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (e) =>
              InterviewScenarioSummary.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  /// `GET /user/conversation/interview/scenarios/{id}` — the returned
  /// `scenario.id` carries the routable `interview:<uuid>` form, ready to
  /// send straight into the turn loop.
  Future<Scenario> getInterviewScenario(String id) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/conversation/interview/scenarios/${Uri.encodeComponent(id)}',
    );
    final scenario = json['scenario'];
    if (scenario is! Map) {
      throw ApiException('Không thể tải buổi phỏng vấn đã lưu.');
    }
    return Scenario.fromJson(Map<String, dynamic>.from(scenario));
  }

  /// `PUT /user/conversation/interview/scenarios/{id}`.
  Future<void> updateInterviewScenario({
    required String id,
    required String title,
    required String level,
    required Scenario scenario,
  }) => _api.put<void>(
    '/user/conversation/interview/scenarios/${Uri.encodeComponent(id)}',
    body: {
      'title': title,
      'level': level,
      'scenario': _scenarioToJson(scenario),
    },
  );

  /// `DELETE /user/conversation/interview/scenarios/{id}`.
  Future<void> deleteInterviewScenario(String id) => _api.delete<void>(
    '/user/conversation/interview/scenarios/${Uri.encodeComponent(id)}',
  );

  Map<String, dynamic> _scenarioToJson(Scenario s) => {
    'id': s.id,
    'title_de': s.titleDe,
    'title_vi': s.titleVi,
    'level': s.level,
    'ai_role': s.aiRole,
    'user_role': s.userRole,
    'context_de': s.contextDe,
    'context_vi': s.contextVi,
    'vocab': s.vocab.map((v) => v.toJson()).toList(),
    'sample_phrases': s.samplePhrases.map((v) => v.toJson()).toList(),
    'required_points': s.requiredPoints.map((v) => v.toJson()).toList(),
    'starter_prompt_de': s.starterPromptDe,
    'gradient_from': s.gradientFrom,
    'gradient_to': s.gradientTo,
    'icon': s.icon,
  };
}
