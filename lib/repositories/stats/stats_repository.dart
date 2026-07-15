import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/stats/stats_models.dart';

/// Thống kê học tập nguồn FSRS + XP. Streak/level/tổng XP KHÔNG nằm ở đây —
/// dùng `dashboardProvider` (đã có sẵn qua `GET /user/dashboard-init`) để
/// tránh gọi trùng lặp.
class StatsRepository {
  StatsRepository(this._api);

  final ApiClient _api;

  /// Tổng lượt ôn FSRS + số từ đã học. `GET /user/review-stats`.
  Future<ReviewStats> getReviewStats() async {
    final json = await _api.get<Map<String, dynamic>>('/user/review-stats');
    return ReviewStats.fromJson(json);
  }

  /// XP theo ngày, mặc định 7 ngày gần nhất. `GET /user/xp-daily-log`.
  Future<List<XpDailyLogEntry>> getXpDailyLog({int days = 7}) async {
    final list = await _api.get<List<dynamic>>(
      '/user/xp-daily-log',
      query: {'days': days},
    );
    return list
        .map((e) => XpDailyLogEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Phân bố độ nhớ FSRS (mới/đang học/đang nhớ/thuộc lòng). `GET /user/srs/mastery`.
  Future<MasterySummary> getMastery() async {
    final json = await _api.get<Map<String, dynamic>>('/user/srs/mastery');
    return MasterySummary.fromJson(json);
  }

  /// Xu hướng ôn tập N ngày gần nhất (cron đêm — rỗng cho tới lần chạy đầu
  /// tiên). `GET /user/srs/stats/daily`.
  Future<List<SrsDailyStat>> getDailySrsStats({int days = 30}) async {
    final list = await _api.get<List<dynamic>>(
      '/user/srs/stats/daily',
      query: {'days': days},
    );
    return list
        .map((e) => SrsDailyStat.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(apiClientProvider));
});
