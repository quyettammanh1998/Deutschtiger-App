// Standalone preview app that renders the real Home dashboard blocks with
// fixture data — no backend/auth — so the actual fonts, Material icons, emoji,
// images and colors can be screenshotted in a real browser and compared to the
// web mobile design. Run: flutter run -d chrome --target=lib/previews/home_preview_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_tokens.dart';
import '../data/learn/learn_goal.dart';
import '../features/daily_path/domain/daily_path.dart';
import '../l10n/app_localizations.dart';
import '../screens/home/widgets/community_links.dart';
import '../screens/home/widgets/dashboard_sections.dart';
import '../screens/home/widgets/exam_corner_card.dart';
import '../screens/home/widgets/pinned_shortcuts.dart';
import '../screens/home/widgets/resume_section.dart';
import '../screens/home/widgets/weekly_leaderboard_compact.dart';
import '../screens/leaderboard/leaderboard_screen.dart';
import '../view_models/providers.dart';
import '../widgets/dashboard/mobile_dashboard_header.dart';
import 'preview_auth_service.dart';

const _pad = EdgeInsets.symmetric(
  horizontal: DesignTokens.screenHorizontalPadding,
);

final _path = DailyPath(
  doneCount: 1,
  totalCount: 4,
  estimatedMinutesRemaining: 18,
  daysToExam: 21,
  examLabel: 'Goethe B1',
  steps: const [
    DailyPathStep(key: 'r', skill: 'wiederholung', title: 'Ôn 12 từ đến hạn', description: 'Ôn tập SRS', route: '/daily-review', estimatedMinutes: 6, done: true, premium: false),
    DailyPathStep(key: 'v', skill: 'wortschatz', title: 'Học 8 từ mới', description: 'Chủ đề: Gia đình', route: '/learn', estimatedMinutes: 7, done: false, premium: false),
    DailyPathStep(key: 'h', skill: 'hoeren', title: 'Luyện nghe', description: 'Video A2', route: '/listening', estimatedMinutes: 5, done: false, premium: false),
    DailyPathStep(key: 'p', skill: 'pruefung', title: 'Làm đề B1', description: 'Lesen Teil 1', route: '/exam', estimatedMinutes: 10, done: false, premium: true),
  ],
);

final _missions = <DashboardMission>[
  const DashboardMission(title: 'Học 10 từ mới', icon: Icons.school_rounded, xpReward: 20, currentProgress: 6, targetCount: 10),
  const DashboardMission(title: 'Ôn tập 15 phút', icon: Icons.autorenew_rounded, xpReward: 15, currentProgress: 15, targetCount: 15, isCompleted: true),
  const DashboardMission(title: 'Nghe 1 video', icon: Icons.volume_up_rounded, xpReward: 10, currentProgress: 0, targetCount: 1),
];

final _leaderboard = <LeaderboardEntry>[
  const LeaderboardEntry(rank: 1, id: 'a', displayName: 'Anna Schmidt', xp: 1240, streak: 30),
  const LeaderboardEntry(rank: 2, id: 'b', displayName: 'Minh Nguyễn', xp: 980, streak: 12),
  const LeaderboardEntry(rank: 3, id: 'c', displayName: 'Lukas Weber', xp: 870, streak: 8),
];

void main() {
  runApp(
    ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(PreviewAuthService(isAuthenticated: true)),
        learnGoalProvider.overrideWith((ref) => LearnGoal(targetLevel: 'B1', targetProvider: 'goethe', targetDate: DateTime.now().add(const Duration(days: 21)), isDefault: false)),
        leaderboardProvider(LeaderboardType.weekly).overrideWith((ref) async => _leaderboard),
        myWeeklyRankProvider.overrideWith((ref) async => null),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: DesignTokens.background),
        home: Scaffold(
          backgroundColor: DesignTokens.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  MobileDashboardHeader(displayName: 'Minh', streak: 12, onSettingsTap: () {}, onProfileTap: () {}, onMessagesTap: () {}, unreadNotificationCount: 3),
                  Padding(padding: _pad, child: DashboardSearchBar(onTap: () {})),
                  const SizedBox(height: 12),
                  Padding(padding: _pad, child: ResumeLearningCard(path: _path, dailyXp: 40, dailyGoal: 60, streak: 12, onTap: () {})),
                  const SizedBox(height: 12),
                  const ExamCornerCard(),
                  const SizedBox(height: 12),
                  const Padding(padding: _pad, child: PinnedShortcuts()),
                  const SizedBox(height: 12),
                  Padding(padding: _pad, child: DashboardMissionsSection(missions: _missions)),
                  const SizedBox(height: 12),
                  Padding(padding: _pad, child: WeeklyLeaderboardCompact(onShowAll: () {})),
                  const SizedBox(height: 12),
                  const Padding(padding: _pad, child: CommunityLinks()),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
