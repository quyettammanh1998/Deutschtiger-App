import 'package:deutschtiger/data/home/dashboard_data.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/previews/preview_auth_service.dart';
import 'package:deutschtiger/screens/leaderboard/leaderboard_screen.dart';
import 'package:deutschtiger/screens/stats/stats_screen.dart';
import 'package:deutschtiger/screens/stats/widgets/stats_leaderboard_table.dart';
import 'package:deutschtiger/repositories/settings/learning_preferences_repository.dart';
import 'package:deutschtiger/view_models/home/home_provider.dart';
import 'package:deutschtiger/view_models/providers.dart' hide dashboardProvider;
import 'package:deutschtiger/view_models/settings/learning_preferences_provider.dart';
import 'package:deutschtiger/view_models/stats/error_patterns_provider.dart';
import 'package:deutschtiger/view_models/stats/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Overrides for every network-backed provider `StatsScreen` reads, so
/// widget tests never hit the real API client (no Supabase/env setup in
/// this harness).
List<Override> _liveDataOverrides({
  DashboardData dashboard = const DashboardData(
    gamification: Gamification(
      totalXp: 500,
      level: 3,
      currentStreak: 7,
      longestStreak: 12,
    ),
  ),
  ReviewStats reviewStats = const ReviewStats(totalReviews: 42, wordsLearned: 10),
  MasterySummary mastery = const MasterySummary(
    newCount: 1,
    learning: 2,
    young: 3,
    mature: 4,
    total: 10,
  ),
  List<ErrorPatternSummary> errorPatterns = const [],
}) => [
  authServiceProvider.overrideWithValue(PreviewAuthService()),
  dashboardProvider.overrideWith((ref) async => dashboard),
  reviewStatsProvider.overrideWith((ref) async => reviewStats),
  weeklyXpLogProvider.overrideWith((ref) async => const []),
  masteryProvider.overrideWith((ref) async => mastery),
  srsDailyStatsProvider.overrideWith((ref) async => const []),
  flashcardReviewStatsProvider.overrideWith(
    (ref) async => const FlashcardReviewStats(),
  ),
  flashcardCountStatsProvider.overrideWith(
    (ref) async => const FlashcardCountStats(),
  ),
  weeklyOnlineTimeProvider.overrideWith((ref) async => const []),
  errorPatternsSummaryProvider.overrideWith((ref) async => errorPatterns),
  leaderboardProvider(
    LeaderboardType.allTime,
  ).overrideWith((ref) async => const []),
  statsCurrentUserRankProvider.overrideWith((ref) async => null),
  learningPreferencesProvider.overrideWith(
    () => _FakeLearningPreferencesNotifier(),
  ),
];

class _FakeLearningPreferencesNotifier extends LearningPreferencesNotifier {
  @override
  LearningPreferencesState build() => const LearningPreferencesState(
    preferences: LearningPreferences(cefrLevel: 'A1'),
    isLoading: false,
  );
}

void main() {
  testWidgets('stats screen renders live overview + mastery + error patterns', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _liveDataOverrides(),
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: StatsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('7 ngày'), findsWidgets);
    expect(find.text('500'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stats screen shows empty states when data has no rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _liveDataOverrides(
          dashboard: const DashboardData(gamification: Gamification()),
          reviewStats: const ReviewStats(),
          mastery: const MasterySummary(),
        ),
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: StatsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có dữ liệu. Hãy ôn vài từ để bắt đầu theo dõi độ nhớ.'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Chưa có dữ liệu lỗi.'),
      find.byType(Scrollable).first,
      const Offset(0, -200),
    );
    expect(find.text('Chưa có dữ liệu lỗi.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stats screen shows error view + retry when dashboard fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(PreviewAuthService()),
          dashboardProvider.overrideWith((ref) async => throw Exception('boom')),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: StatsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được dữ liệu. Vui lòng thử lại.'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
