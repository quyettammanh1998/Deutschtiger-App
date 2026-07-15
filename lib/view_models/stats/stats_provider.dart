import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/stats/stats_models.dart';
import '../../repositories/stats/stats_repository.dart';

/// Tổng lượt ôn FSRS + số từ đã học. `GET /user/review-stats`.
final reviewStatsProvider = FutureProvider<ReviewStats>((ref) async {
  return ref.watch(statsRepositoryProvider).getReviewStats();
});

/// XP 7 ngày gần nhất cho biểu đồ tuần. `GET /user/xp-daily-log?days=7`.
final weeklyXpLogProvider = FutureProvider<List<XpDailyLogEntry>>((ref) async {
  return ref.watch(statsRepositoryProvider).getXpDailyLog(days: 7);
});

/// Phân bố độ nhớ FSRS. `GET /user/srs/mastery`.
final masteryProvider = FutureProvider<MasterySummary>((ref) async {
  return ref.watch(statsRepositoryProvider).getMastery();
});

/// Xu hướng ôn tập 30 ngày qua (cron đêm). `GET /user/srs/stats/daily?days=30`.
final srsDailyStatsProvider = FutureProvider<List<SrsDailyStat>>((ref) async {
  return ref.watch(statsRepositoryProvider).getDailySrsStats(days: 30);
});
