import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/api_client.dart';
import '../../../../view_models/providers.dart';
import '../../domain/sprint/sprint_types.dart';

/// Sprint v2 data access — web parity `use-sprint-data.ts` +
/// `use-sprint-grading.ts`. Reuses the same live `/goethe-b1-writing/teil/{n}`
/// endpoint W1/W2 already documented (full topic payload includes
/// `speedrun`), plus 2 endpoints new to this wave:
/// `GET /goethe-b1-writing/sprint-clusters` and `POST /sprint/grade-essay`
/// (both probed against `thamkhao/deutschtiger-backend` — see
/// `docs/flutter-api-contract-matrix.md`).
class SprintRepository {
  const SprintRepository(this._api);

  final ApiClient _api;

  /// `GET /goethe-b1-writing/sprint-clusters` — public, no auth. Static
  /// content (10 clusters covering ~73 speedrun-eligible topics).
  Future<List<SprintCluster>> fetchClusters() async {
    final data = await _api.get<Map<String, dynamic>>('/goethe-b1-writing/sprint-clusters');
    final raw = data['clusters'] as List?;
    return raw
            ?.whereType<Map>()
            .map((c) => SprintCluster.fromJson(Map<String, dynamic>.from(c)))
            .toList() ??
        const [];
  }

  /// Fetches all 3 Teil manifests (each embeds full topic content including
  /// `speedrun`) and returns only the topics whose slug is in [slugs] —
  /// mirrors web's `fetchTopics` (per-Teil `Promise.allSettled`, degrading
  /// individual Teil failures to an empty contribution instead of failing
  /// the whole sprint).
  Future<List<SprintTopicData>> fetchTopicsForSlugs(Set<String> slugs) async {
    final topics = <SprintTopicData>[];
    for (final teil in [1, 2, 3]) {
      try {
        final data = await _api.get<Map<String, dynamic>>('/goethe-b1-writing/teil/$teil');
        final raw = data['topics'] as List?;
        if (raw == null) continue;
        for (final t in raw.whereType<Map>()) {
          final parsed = SprintTopicData.fromJson(Map<String, dynamic>.from(t));
          if (slugs.contains(parsed.slug)) topics.add(parsed);
        }
      } catch (_) {
        // Degrade per-Teil — one Teil failing shouldn't blank the whole sprint.
      }
    }
    return topics;
  }
}

class SprintGradeRequest {
  const SprintGradeRequest({
    required this.teil,
    required this.taskPrompt,
    required this.points,
    required this.studentEssay,
    this.topicSlug,
  });

  final int teil;
  final String taskPrompt;
  final List<String> points;
  final String studentEssay;
  final String? topicSlug;

  Map<String, dynamic> toJson() => {
    'teil': teil,
    'taskPrompt': taskPrompt,
    'points': points,
    'studentEssay': studentEssay,
    if (topicSlug != null) 'topicSlug': topicSlug,
  };
}

/// AI essay grading for the sprint mini practice-exam — `POST /sprint/grade-essay`.
/// Auth required; backend rate-limits to 10 graded essays/hour/user.
class SprintGradingRepository {
  const SprintGradingRepository(this._api);

  final ApiClient _api;

  Future<SprintEssayResult> grade(SprintGradeRequest request) async {
    final data = await _api.post<Map<String, dynamic>>('/sprint/grade-essay', body: request.toJson());
    return SprintEssayResult(
      topicSlug: request.topicSlug ?? '',
      teil: request.teil,
      total: (data['total'] as num?)?.toInt() ?? 0,
      erfullung: (data['erfullung'] as num?)?.toInt() ?? 0,
      koharenz: (data['koharenz'] as num?)?.toInt() ?? 0,
      wortschatz: (data['wortschatz'] as num?)?.toInt() ?? 0,
      strukturen: (data['strukturen'] as num?)?.toInt() ?? 0,
      grade: data['grade']?.toString() ?? 'schwach',
      feedback: (data['feedback'] as Map?)?.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')) ??
          const {},
      errors: (data['errors'] as List?)
              ?.whereType<Map>()
              .map((e) => SprintEssayErrorItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      gradedAt: DateTime.now(),
    );
  }
}

final sprintRepositoryProvider = Provider<SprintRepository>((ref) {
  return SprintRepository(ref.watch(apiClientProvider));
});

final sprintGradingRepositoryProvider = Provider<SprintGradingRepository>((ref) {
  return SprintGradingRepository(ref.watch(apiClientProvider));
});

/// Sprint clusters — static content, cached for the app session.
final sprintClustersProvider = FutureProvider<List<SprintCluster>>((ref) {
  return ref.watch(sprintRepositoryProvider).fetchClusters();
});

/// Full sprint dataset (clusters + their topics with `speedrun` populated) —
/// web parity `useSprintData`. Depends on [sprintClustersProvider] to know
/// which slugs to fetch.
final sprintTopicsProvider = FutureProvider<List<SprintTopicData>>((ref) async {
  final clusters = await ref.watch(sprintClustersProvider.future);
  final slugs = <String>{for (final c in clusters) ...c.topicSlugs};
  if (slugs.isEmpty) return const [];
  return ref.watch(sprintRepositoryProvider).fetchTopicsForSlugs(slugs);
});
