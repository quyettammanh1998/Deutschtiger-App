import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/data/social/moment_models.dart';
import 'social_repository_providers.dart';

/// Moments feed AsyncNotifier — supports pull-to-refresh and an optimistic
/// like/unlike toggle (`POST`/`DELETE /user/moments/{id}/like`). Comment
/// list stays read-only via [momentCommentsProvider]; there is no compose UI
/// in this phase (public UGC write needs moderation first).
class MomentsFeedNotifier extends AutoDisposeAsyncNotifier<List<Moment>> {
  @override
  Future<List<Moment>> build() {
    return ref.watch(momentRepositoryProvider).getFeed();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Moment>>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(momentRepositoryProvider).getFeed(),
    );
  }

  Future<void> toggleLike(Moment moment) async {
    final repo = ref.read(momentRepositoryProvider);
    final optimistic = moment.copyWithLike(
      isLiked: !moment.isLiked,
      likeCount: moment.isLiked
          ? (moment.likeCount - 1).clamp(0, 1 << 31)
          : moment.likeCount + 1,
    );
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(
        current.map((m) => m.id == moment.id ? optimistic : m).toList(),
      );
    }
    try {
      if (optimistic.isLiked) {
        await repo.like(moment.id);
      } else {
        await repo.unlike(moment.id);
      }
    } catch (_) {
      // Revert on failure.
      final reverted = state.valueOrNull;
      if (reverted != null) {
        state = AsyncData(
          reverted.map((m) => m.id == moment.id ? moment : m).toList(),
        );
      }
      rethrow;
    }
  }
}

final momentsFeedProvider =
    AsyncNotifierProvider.autoDispose<MomentsFeedNotifier, List<Moment>>(
      MomentsFeedNotifier.new,
    );

/// Read-only comments for a moment (`GET /moments/{id}/comments`).
final momentCommentsProvider = FutureProvider.autoDispose
    .family<List<MomentComment>, String>((ref, momentId) async {
      return ref.watch(momentRepositoryProvider).getComments(momentId);
    });
