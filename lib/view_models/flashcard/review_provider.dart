import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../repositories/flashcard/review_repository.dart';
import '../../data/flashcard/review_item.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(apiClientProvider));
});

/// Trạng thái một phiên ôn thẻ: danh sách thẻ + vị trí hiện tại + đã lật chưa.
class ReviewSessionState {
  const ReviewSessionState({
    this.items = const <ReviewItem>[],
    this.index = 0,
    this.revealed = false,
    this.ratedCount = 0,
    this.submitting = false,
  });

  /// Thẻ đến hạn nạp đầu phiên (không đổi trong suốt phiên).
  final List<ReviewItem> items;

  /// Vị trí thẻ đang ôn.
  final int index;

  /// Đã lật xem nghĩa hay chưa.
  final bool revealed;

  /// Số thẻ đã đánh giá xong (cho thanh tiến độ).
  final int ratedCount;

  /// Đang gửi rate lên server (khoá nút tránh double-tap).
  final bool submitting;

  bool get isFinished => items.isNotEmpty && index >= items.length;
  bool get isEmpty => items.isEmpty;
  int get total => items.length;

  /// Thẻ hiện tại, null nếu đã hết.
  ReviewItem? get current =>
      index >= 0 && index < items.length ? items[index] : null;

  ReviewSessionState copyWith({
    List<ReviewItem>? items,
    int? index,
    bool? revealed,
    int? ratedCount,
    bool? submitting,
  }) {
    return ReviewSessionState(
      items: items ?? this.items,
      index: index ?? this.index,
      revealed: revealed ?? this.revealed,
      ratedCount: ratedCount ?? this.ratedCount,
      submitting: submitting ?? this.submitting,
    );
  }
}

/// Điều phối phiên ôn: nạp thẻ đến hạn → lật → rate → thẻ kế tiếp.
/// FSRS tính phía server; client chỉ trượt qua danh sách đã nạp.
class ReviewSessionNotifier extends AutoDisposeAsyncNotifier<ReviewSessionState> {
  @override
  Future<ReviewSessionState> build() async {
    final items = await ref.watch(reviewRepositoryProvider).fetchDue();
    return ReviewSessionState(items: items);
  }

  /// Lật thẻ để xem nghĩa.
  void reveal() {
    final s = state.value;
    if (s == null || s.revealed) return;
    state = AsyncData(s.copyWith(revealed: true));
  }

  /// Đánh giá thẻ hiện tại rồi chuyển sang thẻ kế. Best-effort: nếu rate lỗi
  /// vẫn cho học tiếp (server không nhận thì lần sau thẻ vẫn đến hạn).
  Future<void> rateCurrent(ReviewRating rating) async {
    final s = state.value;
    if (s == null || s.submitting) return;
    final item = s.current;
    if (item == null) return;

    state = AsyncData(s.copyWith(submitting: true));
    try {
      await ref.read(reviewRepositoryProvider).rate(item.id, rating);
    } catch (_) {
      // nuốt lỗi: không chặn phiên học
    }
    state = AsyncData(
      s.copyWith(
        index: s.index + 1,
        revealed: false,
        ratedCount: s.ratedCount + 1,
        submitting: false,
      ),
    );
  }

  /// Nạp lại phiên mới (sau khi hoàn thành hoặc bấm thử lại).
  Future<void> restart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = await ref.read(reviewRepositoryProvider).fetchDue();
      return ReviewSessionState(items: items);
    });
  }
}

final reviewSessionProvider =
    AsyncNotifierProvider.autoDispose<
      ReviewSessionNotifier,
      ReviewSessionState
    >(ReviewSessionNotifier.new);
