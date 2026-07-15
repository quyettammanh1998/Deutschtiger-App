import 'package:deutschtiger/data/home/dashboard_data.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/stats/stats_screen.dart';
import 'package:deutschtiger/view_models/home/home_provider.dart';
import 'package:deutschtiger/view_models/stats/error_patterns_provider.dart';
import 'package:deutschtiger/view_models/stats/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stats screen renders live overview + mastery + error patterns', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardProvider.overrideWith(
            (ref) async => const DashboardData(
              gamification: Gamification(
                totalXp: 500,
                level: 3,
                currentStreak: 7,
                longestStreak: 12,
              ),
            ),
          ),
          reviewStatsProvider.overrideWith(
            (ref) async => const ReviewStats(totalReviews: 42, wordsLearned: 10),
          ),
          weeklyXpLogProvider.overrideWith((ref) async => const []),
          masteryProvider.overrideWith(
            (ref) async => const MasterySummary(
              newCount: 1,
              learning: 2,
              young: 3,
              mature: 4,
              total: 10,
            ),
          ),
          srsDailyStatsProvider.overrideWith((ref) async => const []),
          errorPatternsSummaryProvider.overrideWith((ref) async => const []),
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

    expect(find.text('7'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stats screen shows empty states when data has no rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardProvider.overrideWith(
            (ref) async => const DashboardData(),
          ),
          reviewStatsProvider.overrideWith((ref) async => const ReviewStats()),
          weeklyXpLogProvider.overrideWith((ref) async => const []),
          masteryProvider.overrideWith((ref) async => const MasterySummary()),
          srsDailyStatsProvider.overrideWith((ref) async => const []),
          errorPatternsSummaryProvider.overrideWith((ref) async => const []),
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

    expect(find.text('Chưa có dữ liệu. Hãy ôn vài từ để bắt đầu theo dõi độ nhớ.'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Chưa có dữ liệu lỗi.'),
      find.byType(Scrollable),
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
