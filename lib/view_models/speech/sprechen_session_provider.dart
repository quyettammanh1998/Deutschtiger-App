import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../data/speech/sprechen_session_models.dart';
import '../../repositories/speech/sprechen_session_repository.dart';

final sprechenSessionRepositoryProvider =
    Provider<SprechenSessionRepository>((ref) {
      return SprechenSessionRepository(ref.watch(apiClientProvider));
    });

/// Saved results for the current user; empty when logged out or on error so
/// a secondary API never blocks the primary catalog UI (same pattern as
/// `ReadingRepository.fetchCompletedIds`).
final sprechenResultsProvider = FutureProvider<List<SprechenResult>>((
  ref,
) async {
  ref.watch(authStateProvider);
  try {
    return await ref.watch(sprechenSessionRepositoryProvider).fetchResults();
  } catch (_) {
    return const [];
  }
});

/// Public leaderboard shown under each teil's topic list.
final sprechenLeaderboardProvider =
    FutureProvider<List<SprechenLeaderboardEntry>>((ref) async {
      try {
        return await ref
            .watch(sprechenSessionRepositoryProvider)
            .fetchLeaderboard();
      } catch (_) {
        return const [];
      }
    });
