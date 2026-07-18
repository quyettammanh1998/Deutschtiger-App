import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../domain/goethe_b1_writing_leaderboard_entry.dart';
import '../domain/goethe_b1_writing_manifest.dart';
import '../domain/goethe_b1_writing_topic.dart';
import '../domain/goethe_b1_writing_topic_summary.dart';

/// Goethe B1 writing content index — web parity
/// `use-goethe-b1-writing-data.ts` (`useManifest`/`useTeil`/`useTopic`) +
/// `use-goethe-b1-writing-results.ts` (`useAllGoetheB1WritingResults`/
/// `useGoetheB1WritingResults`/`useGoetheB1WritingLeaderboard`) +
/// `goethe-b1-writing-result-service.ts` (`saveResult`). W2 adds the
/// `teil(n)`/`topic(n, slug)`/`upsertResult`/`fetchLeaderboard` reads on top
/// of W1's manifest/results foundation.
class GoetheB1WritingRepository {
  const GoetheB1WritingRepository(this._api);

  final ApiClient _api;

  /// `GET /goethe-b1-writing/manifest` — public, no auth required.
  Future<GoetheB1WritingManifest> fetchManifest() async {
    final data = await _api.get<Map<String, dynamic>>(
      '/goethe-b1-writing/manifest',
    );
    return GoetheB1WritingManifest.fromJson(data);
  }

  /// `GET /goethe-b1-writing/teil/{n}` — public. Full per-Teil topic list
  /// (feeds the topic-list page's rows/search/grouping).
  Future<GoetheB1WritingTeilData> fetchTeil(int teil) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/goethe-b1-writing/teil/$teil',
    );
    return GoetheB1WritingTeilData.fromJson(data);
  }

  /// `GET /goethe-b1-writing/topic/{n}/{slug}` — public. Full topic detail
  /// (feeds the reader page).
  Future<GoetheB1WritingTopic> fetchTopic(int teil, String slug) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/goethe-b1-writing/topic/$teil/$slug',
    );
    return GoetheB1WritingTopic.fromJson(data);
  }

  /// `GET /user/goethe-b1-writing-results` — every saved result for the
  /// current user, across all 3 Teil. Requires auth; caller decides how to
  /// degrade (teil-pick page shows 0/N when unauthenticated/unavailable).
  Future<List<GoetheB1WritingResult>> fetchAllResults() async {
    final data = await _api.get<List<dynamic>>(
      '/user/goethe-b1-writing-results',
    );
    return data
        .whereType<Map>()
        .map(
          (e) => GoetheB1WritingResult.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  /// `GET /user/goethe-b1-writing-results?teil=` — results scoped to one
  /// Teil (topic-list page's completed-checkmark set).
  Future<List<GoetheB1WritingResult>> fetchResultsForTeil(int teil) async {
    final data = await _api.get<List<dynamic>>(
      '/user/goethe-b1-writing-results',
      query: {'teil': teil},
    );
    return data
        .whereType<Map>()
        .map(
          (e) => GoetheB1WritingResult.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  /// `POST /user/goethe-b1-writing-results` — marks a topic as completed
  /// (detail page's "Đánh dấu hoàn thành" CTA). `topic_slug` (snake_case) is
  /// the Go request field name, not `slug`.
  Future<void> upsertResult({
    required int teil,
    required String slug,
    int? score,
    String? grade,
  }) async {
    await _api.post<Map<String, dynamic>>(
      '/user/goethe-b1-writing-results',
      body: {
        'teil': teil,
        'topic_slug': slug,
        'score': ?score,
        'grade': ?grade,
      },
    );
  }

  /// `GET /user/goethe-b1-writing-leaderboard?teil=` — top-10 + current-user
  /// row for the topic-list page's sidebar leaderboard.
  Future<List<GoetheB1WritingLeaderboardEntry>> fetchLeaderboard(
    int teil,
  ) async {
    final data = await _api.get<List<dynamic>>(
      '/user/goethe-b1-writing-leaderboard',
      query: {'teil': teil},
    );
    return data
        .whereType<Map>()
        .map(
          (e) => GoetheB1WritingLeaderboardEntry.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }
}

final goetheB1WritingRepositoryProvider = Provider<GoetheB1WritingRepository>((
  ref,
) {
  return GoetheB1WritingRepository(ref.watch(apiClientProvider));
});

/// Manifest is static content — cache for the app session (web:
/// `staleTime: Infinity`).
final goetheB1WritingManifestProvider = FutureProvider<GoetheB1WritingManifest>(
  (ref) {
    return ref.watch(goetheB1WritingRepositoryProvider).fetchManifest();
  },
);

/// Results refetch whenever auth state changes; degrades to `[]` so the
/// teil-pick page still renders (0/N) for a signed-out/errored user instead
/// of crashing.
final goetheB1WritingAllResultsProvider =
    FutureProvider<List<GoetheB1WritingResult>>((ref) async {
      ref.watch(authStateProvider);
      try {
        return await ref
            .watch(goetheB1WritingRepositoryProvider)
            .fetchAllResults();
      } catch (_) {
        return const [];
      }
    });

/// Full per-Teil topic list — static content, cached per session per Teil.
final goetheB1WritingTeilProvider =
    FutureProvider.family<GoetheB1WritingTeilData, int>((ref, teil) {
      return ref.watch(goetheB1WritingRepositoryProvider).fetchTeil(teil);
    });

/// Full topic detail, keyed by `(teil, slug)`.
final goetheB1WritingTopicProvider =
    FutureProvider.family<GoetheB1WritingTopic, ({int teil, String slug})>((
      ref,
      key,
    ) {
      return ref
          .watch(goetheB1WritingRepositoryProvider)
          .fetchTopic(key.teil, key.slug);
    });

/// Completed slugs for one Teil — degrades to `[]` signed-out/errored.
final goetheB1WritingTeilResultsProvider =
    FutureProvider.family<List<GoetheB1WritingResult>, int>((ref, teil) async {
      ref.watch(authStateProvider);
      try {
        return await ref
            .watch(goetheB1WritingRepositoryProvider)
            .fetchResultsForTeil(teil);
      } catch (_) {
        return const [];
      }
    });

/// Leaderboard rows for one Teil — degrades to `[]` on any error so the
/// sidebar renders an empty state instead of crashing the topic-list page.
final goetheB1WritingLeaderboardProvider =
    FutureProvider.family<List<GoetheB1WritingLeaderboardEntry>, int>((
      ref,
      teil,
    ) async {
      try {
        return await ref
            .watch(goetheB1WritingRepositoryProvider)
            .fetchLeaderboard(teil);
      } catch (_) {
        return const [];
      }
    });
