import 'package:deutschtiger/services/api_client.dart';

import '../../data/speech/sprechen_models.dart';

/// Repository for the Sprechen catalog surface (live API, public/no-auth).
///
/// Source: `GET /sprechen/{teil}/topics`, `GET /sprechen/{teil}/tags`,
/// `GET /exams/official/sprechen-content?id=`.
class SprechenRepository {
  SprechenRepository(this._apiClient);
  final ApiClient _apiClient;

  /// Topic list for a teil (e.g. `goethe-teil1`). Public — premium topics
  /// come back unfiltered; client must gate `isPremium` behind entitlement.
  Future<List<SprechenTopic>> fetchTopics(String teil) async {
    final data = await _apiClient.get<dynamic>('/sprechen/$teil/topics');
    final list = data as List<dynamic>? ?? const [];
    return list
        .map((e) => SprechenTopic.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Tag/group list for a teil. Empty array (not 404) when the teil has no
  /// `tags.json` — caller should render a flat list in that case.
  Future<List<SprechenTag>> fetchTags(String teil) async {
    final data = await _apiClient.get<dynamic>('/sprechen/$teil/tags');
    final list = data as List<dynamic>? ?? const [];
    return list
        .map((e) => SprechenTag.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Study/practice markdown content for a topic by its exam-question uuid.
  /// `locked: true` is a valid render state (premium gate), not an error.
  Future<SprechenContent> fetchContent(String id) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/exams/official/sprechen-content',
      query: {'id': id},
    );
    return SprechenContent.fromJson(data);
  }
}
