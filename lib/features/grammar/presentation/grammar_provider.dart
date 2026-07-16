import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/config/app_config.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../../repositories/grammar/grammar_repository.dart';

const grammarLevels = ['A1', 'A2', 'B1', 'B2', 'C1'];

final grammarRepositoryProvider = Provider<GrammarRepository>((ref) {
  return GrammarRepository(
    ref.watch(apiClientProvider),
    AppConfig.webviewBaseUrl,
  );
});

/// Toàn bộ bài học (index nhẹ, không `contents`) — dùng cho màn danh sách.
/// Cache theo vòng đời provider, giống `getAllLessons()` bên web.
final grammarLessonIndexProvider = FutureProvider<List<GrammarLessonSummary>>((
  ref,
) {
  return ref.watch(grammarRepositoryProvider).fetchLessonIndex();
});

/// 1 bài học đầy đủ theo `level:id`.
final grammarLessonProvider =
    FutureProvider.family<GrammarLesson, ({String level, String id})>((
      ref,
      key,
    ) {
      return ref
          .watch(grammarRepositoryProvider)
          .fetchLesson(key.level, key.id);
    });

/// Danh sách `lesson_id` đã hoàn thành. Rỗng khi chưa đăng nhập hoặc lỗi mạng
/// — màn vẫn hiển thị bình thường, chỉ ẩn trạng thái tiến độ.
final grammarCompletedIdsProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(authStateProvider);
  return ref.watch(grammarRepositoryProvider).fetchCompletedLessonIds();
});

/// Mục lục bài đọc (article), map theo level thường (a1, a2, ...).
final grammarArticleIndexProvider =
    FutureProvider<Map<String, List<GrammarArticleMeta>>>((ref) {
      return ref.watch(grammarRepositoryProvider).fetchArticleIndex();
    });

/// 1 bài đọc đầy đủ theo `level:slug`.
final grammarArticleProvider =
    FutureProvider.family<GrammarArticle?, ({String level, String slug})>((
      ref,
      key,
    ) {
      return ref
          .watch(grammarRepositoryProvider)
          .fetchArticle(key.level, key.slug);
    });

/// Bảng xếp hạng ngữ pháp (toàn bộ hoặc theo level) — `level: null` = tổng.
final grammarLeaderboardProvider =
    FutureProvider.family<List<GrammarLeaderboardEntry>, String?>((ref, level) {
      ref.watch(authStateProvider);
      return ref
          .watch(grammarRepositoryProvider)
          .fetchLeaderboard(level: level);
    });

/// Hạng của user hiện tại (kể cả ngoài top N hiển thị).
final grammarUserRankProvider =
    FutureProvider.family<GrammarLeaderboardEntry?, String?>((ref, level) {
      ref.watch(authStateProvider);
      return ref.watch(grammarRepositoryProvider).fetchUserRank(level: level);
    });

/// Đánh dấu hoàn thành + invalidate progress để UI cập nhật ngay.
Future<void> markGrammarComplete(
  WidgetRef ref, {
  required String lessonId,
  required String level,
}) async {
  await ref
      .read(grammarRepositoryProvider)
      .markComplete(lessonId: lessonId, level: level);
  ref.invalidate(grammarCompletedIdsProvider);
  ref.invalidate(grammarLeaderboardProvider);
  ref.invalidate(grammarUserRankProvider);
}
