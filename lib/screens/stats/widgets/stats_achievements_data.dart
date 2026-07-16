import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/home/dashboard_data.dart';
import '../../../view_models/home/home_provider.dart';
import '../../../view_models/stats/stats_provider.dart';

/// Client-computed achievement — mirrors web `gamificationService
/// .getAchievements()`: thresholds are evaluated against live gamification
/// + flashcard-count data (`/user/dashboard-init`, `/user/flashcards/stats`),
/// same as the web implementation; nothing here is invented/static test data.
class StatsAchievement {
  const StatsAchievement(this.id, this.name, this.description, this.earned, this.icon);
  final String id;
  final String name;
  final String description;
  final bool earned;
  final String icon;
}

List<StatsAchievement> _computeAchievements(
  Gamification g,
  int totalCards,
  int totalReviews,
) {
  return [
    StatsAchievement('first-practice', 'Bước đầu', 'Hoàn thành bài tập đầu tiên', totalReviews > 0, '🎯'),
    StatsAchievement('streak-3', '3 ngày liên tiếp', 'Duy trì streak 3 ngày', g.longestStreak >= 3, '🔥'),
    StatsAchievement('streak-7', 'Tuần hoàn hảo', 'Duy trì streak 7 ngày', g.longestStreak >= 7, '⭐'),
    StatsAchievement('streak-30', 'Tháng kỷ luật', 'Duy trì streak 30 ngày', g.longestStreak >= 30, '👑'),
    StatsAchievement('cards-10', '10 từ vựng', 'Tạo 10 flashcard', totalCards >= 10, '📚'),
    StatsAchievement('cards-50', '50 từ vựng', 'Tạo 50 flashcard', totalCards >= 50, '📖'),
    StatsAchievement('cards-100', '100 từ vựng', 'Tạo 100 flashcard', totalCards >= 100, '🏆'),
    StatsAchievement('xp-500', 'Cày 500 XP', 'Đạt 500 XP tổng', g.totalXp >= 500, '💪'),
    StatsAchievement('xp-1000', 'Nghìn XP', 'Đạt 1000 XP tổng', g.totalXp >= 1000, '🚀'),
    StatsAchievement('xp-5000', 'Cao thủ', 'Đạt 5000 XP tổng', g.totalXp >= 5000, '🌟'),
    StatsAchievement('level-5', 'Level 5', 'Đạt Level 5', g.level >= 5, '🎖️'),
    StatsAchievement('level-10', 'Level 10', 'Đạt Level 10', g.level >= 10, '🏅'),
    StatsAchievement('reviews-100', '100 lần ôn', 'Ôn tập 100 lần', totalReviews >= 100, '📝'),
  ];
}

/// Full achievement list — earned + not-yet-earned, in fixed threshold order.
final statsAchievementsProvider = FutureProvider<List<StatsAchievement>>((
  ref,
) async {
  final dashboard = await ref.watch(dashboardProvider.future);
  final gamification = dashboard.gamification;
  if (gamification == null) return const [];
  final counts = await ref.watch(flashcardCountStatsProvider.future);
  return _computeAchievements(
    gamification,
    counts.totalCards,
    counts.totalReviews,
  );
});

/// First 3 not-yet-earned achievements — "Thành tựu sắp đạt".
final statsNearAchievementsProvider = Provider<List<StatsAchievement>>((ref) {
  final list = ref.watch(statsAchievementsProvider).valueOrNull ?? const [];
  return list.where((a) => !a.earned).take(3).toList();
});
