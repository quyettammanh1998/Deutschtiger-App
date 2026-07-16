import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../domain/official_writing_topic.dart';

/// Generic official writing topics for a provider/level — web parity
/// `officialTopicService.listPublic` (`src/lib/exam-content/
/// official-topic-service.ts`). Backend: `GET /exams/official`
/// (`internal/feature/exam/exam/official_exam_handler.go`), auth required.
/// Degrades to `[]` on any error (404/network/signed-out) so the
/// writing-level-topics screen still renders its empty state instead of
/// crashing — matches W2's precedent for optional-content endpoints.
class OfficialWritingTopicRepository {
  const OfficialWritingTopicRepository(this._api);

  final ApiClient _api;

  Future<List<OfficialWritingTopic>> listWritingTopics({
    required String provider,
    required String level,
  }) async {
    try {
      final data = await _api.get<List<dynamic>>(
        '/exams/official',
        query: {'provider': provider, 'level': level, 'skill': 'writing'},
      );
      return data
          .whereType<Map>()
          .map((e) => OfficialWritingTopic.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}

final officialWritingTopicRepositoryProvider =
    Provider<OfficialWritingTopicRepository>((ref) {
  return OfficialWritingTopicRepository(ref.watch(apiClientProvider));
});

/// `(provider, level)` scoped list of official writing topics.
final officialWritingTopicsProvider = FutureProvider.autoDispose
    .family<List<OfficialWritingTopic>, ({String provider, String level})>(
  (ref, scope) {
    final repo = ref.watch(officialWritingTopicRepositoryProvider);
    return repo.listWritingTopics(provider: scope.provider, level: scope.level);
  },
);
