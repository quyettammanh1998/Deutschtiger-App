import 'package:deutschtiger/data/home/dashboard_data.dart';
import 'package:flutter_test/flutter_test.dart';

// `DailyGoalCard`/`MissionList`/`QuickStatsRow` widget tests were removed in
// the P12 wave-B deletion sweep along with the widgets themselves — Flutter
// -only orphans never rendered by `home_screen.dart` (superseded by
// `DashboardMissionsSection`/`PinnedShortcuts`/`stats_screen.dart` blocks).
// `DashboardData.fromJson` is still the live dashboard-init response parser
// and keeps its coverage here.

void main() {
  group('DashboardData.fromJson', () {
    test('parse đúng response dashboard-init', () {
      final data = DashboardData.fromJson({
        'gamification': {
          'total_xp': 1200,
          'level': 5,
          'current_streak': 3,
          'daily_xp_today': 30,
          'daily_goal': 50,
        },
        'missions': [
          {
            'id': 'm1',
            'target_count': 10,
            'current_progress': 4,
            'xp_reward': 20,
            'title_vi': 'Ôn 10 từ',
            'status': 'active',
          },
        ],
        'due_review_count': 8,
        'words_learned': 150,
        'online_time_today': 12,
      });
      expect(data.gamification?.level, 5);
      expect(data.gamification?.currentStreak, 3);
      expect(data.dueReviewCount, 8);
      expect(data.missions.length, 1);
      expect(data.missions.first.progressRatio, 0.4);
      expect(data.missions.first.isCompleted, false);
    });

    test('field thiếu → dùng default an toàn', () {
      final data = DashboardData.fromJson({});
      expect(data.gamification, isNull);
      expect(data.missions, isEmpty);
      expect(data.dueReviewCount, 0);
    });
  });
}
