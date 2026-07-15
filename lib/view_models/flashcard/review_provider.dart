import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../repositories/flashcard/review_repository.dart';
import '../../data/flashcard/review_item.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(apiClientProvider));
});

enum ReviewSessionError { ratingNotSaved }

/// Định danh một queue review. [deckId] chỉ được dùng cho luyện deck; backend
/// vẫn áp dụng ownership và không để Flutter tự lọc queue toàn cục.
class ReviewSessionScope {
  const ReviewSessionScope({required this.mode, this.deckId});

  final String mode;
  final String? deckId;

  @override
  bool operator ==(Object other) =>
      other is ReviewSessionScope &&
      other.mode == mode &&
      other.deckId == deckId;

  @override
  int get hashCode => Object.hash(mode, deckId);
}

/// Trạng thái một phiên ôn thẻ: danh sách thẻ + vị trí hiện tại + đã lật chưa.
class ReviewSessionState {
  const ReviewSessionState({
    this.items = const <ReviewItem>[],
    this.index = 0,
    this.revealed = false,
    this.ratedCount = 0,
    this.correctCount = 0,
    this.submitting = false,
    this.error,
  });

  /// Thẻ đến hạn nạp đầu phiên (không đổi trong suốt phiên).
  final List<ReviewItem> items;

  /// Vị trí thẻ đang ôn.
  final int index;

  /// Đã lật xem nghĩa hay chưa.
  final bool revealed;

  /// Số thẻ đã đánh giá xong (cho thanh tiến độ).
  final int ratedCount;

  /// Số thẻ được đánh giá "nhớ đúng" (rating >= Tốt) — dùng cho màn kết quả.
  final int correctCount;

  /// Đang gửi rate lên server (khoá nút tránh double-tap).
  final bool submitting;
  final ReviewSessionError? error;

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
    int? correctCount,
    bool? submitting,
    ReviewSessionError? error,
    bool clearError = false,
  }) {
    return ReviewSessionState(
      items: items ?? this.items,
      index: index ?? this.index,
      revealed: revealed ?? this.revealed,
      ratedCount: ratedCount ?? this.ratedCount,
      correctCount: correctCount ?? this.correctCount,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Điều phối phiên ôn: nạp thẻ đến hạn → lật → rate → thẻ kế tiếp.
/// FSRS tính phía server; client chỉ trượt qua danh sách đã nạp.
///
/// Family key = mode + optional deck ID — mỗi scope có phiên riêng độc lập
/// (mỗi màn tự fetch queue khi mở, không share state).
class ReviewSessionNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<ReviewSessionState, ReviewSessionScope> {
  DateTime? _cardShownAt;

  @override
  Future<ReviewSessionState> build(ReviewSessionScope scope) async {
    final items = await ref
        .watch(reviewRepositoryProvider)
        .fetchDue(deckId: scope.deckId);
    _cardShownAt = DateTime.now();
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
  Future<bool> rateCurrent(ReviewRating rating) async {
    final s = state.value;
    if (s == null || s.submitting) return false;
    final item = s.current;
    if (item == null) return false;

    final responseTime = _cardShownAt != null
        ? DateTime.now().difference(_cardShownAt!)
        : Duration.zero;

    state = AsyncData(s.copyWith(submitting: true, clearError: true));
    try {
      await ref
          .read(reviewRepositoryProvider)
          .rate(item, rating, responseTime: responseTime, mode: arg.mode);
    } catch (_) {
      state = AsyncData(
        s.copyWith(submitting: false, error: ReviewSessionError.ratingNotSaved),
      );
      return false;
    }
    _cardShownAt = DateTime.now();
    state = AsyncData(
      s.copyWith(
        index: s.index + 1,
        revealed: false,
        ratedCount: s.ratedCount + 1,
        correctCount: s.correctCount + (rating.isCorrect ? 1 : 0),
        submitting: false,
        clearError: true,
      ),
    );
    return true;
  }

  /// Nạp lại phiên mới (sau khi hoàn thành hoặc bấm thử lại).
  Future<void> restart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = await ref
          .read(reviewRepositoryProvider)
          .fetchDue(deckId: arg.deckId);
      _cardShownAt = DateTime.now();
      return ReviewSessionState(items: items);
    });
  }
}

final reviewSessionProvider = AsyncNotifierProvider.autoDispose
    .family<ReviewSessionNotifier, ReviewSessionState, ReviewSessionScope>(
      ReviewSessionNotifier.new,
    );
