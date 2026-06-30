import 'package:deutschtiger/data/home/dashboard_data.dart';
import 'package:deutschtiger/screens/home/widgets/daily_goal_card.dart';
import 'package:deutschtiger/screens/home/widgets/mission_list.dart';
import 'package:deutschtiger/screens/home/widgets/quick_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

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

  testWidgets('DailyGoalCard hiện tên + streak + mục tiêu', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const DailyGoalCard(
          displayName: 'Cường',
          gamification: Gamification(
            currentStreak: 5,
            dailyGoal: 50,
            dailyXpToday: 20,
          ),
        ),
      ),
    );
    expect(find.textContaining('Cường'), findsOneWidget);
    expect(find.textContaining('5'), findsWidgets); // streak
    expect(find.textContaining('20 / 50 XP'), findsOneWidget);
  });

  testWidgets('MissionList render từng mission', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const MissionList(
          missions: [
            Mission(
              id: 'm1',
              titleVi: 'Ôn 10 từ',
              targetCount: 10,
              xpReward: 20,
            ),
            Mission(
              id: 'm2',
              titleVi: 'Đọc 1 bài',
              targetCount: 1,
              status: 'completed',
            ),
          ],
        ),
      ),
    );
    expect(find.text('Nhiệm vụ hôm nay'), findsOneWidget);
    expect(find.text('Ôn 10 từ'), findsOneWidget);
    expect(find.text('Đọc 1 bài'), findsOneWidget);
  });

  testWidgets('QuickStatsRow hiện 3 ô thống kê', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const QuickStatsRow(
          wordsLearned: 150,
          dueReviewCount: 8,
          onlineMinutes: 12,
        ),
      ),
    );
    expect(find.text('Từ đã học'), findsOneWidget);
    expect(find.text('Cần ôn'), findsOneWidget);
    expect(find.text('Phút hôm nay'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
  });
}
