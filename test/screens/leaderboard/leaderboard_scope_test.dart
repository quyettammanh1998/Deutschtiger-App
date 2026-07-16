import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/leaderboard/leaderboard_screen.dart';
import 'package:deutschtiger/screens/leaderboard/widgets/leaderboard_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Leaderboard only offers periods backed by distinct scopes', () {
    expect(LeaderboardType.values, const [
      LeaderboardType.weekly,
      LeaderboardType.allTime,
    ]);
    expect(leaderboardPathFor(LeaderboardType.weekly), '/leaderboard/weekly');
    expect(
      leaderboardPathFor(LeaderboardType.allTime),
      '/gamification/leaderboard',
    );
  });

  test('LeaderboardEntry prefers composite weekly_score over raw weekly_xp', () {
    final withScore = LeaderboardEntry.fromJson(const {
      'user_id': 'u1',
      'display_name': 'Alice',
      'weekly_xp': 100,
      'weekly_score': 180,
    }, 1);
    expect(withScore.xp, 180);
    expect(withScore.weeklyXp, 100);

    final xpOnly = LeaderboardEntry.fromJson(const {
      'user_id': 'u2',
      'display_name': 'Bob',
      'weekly_xp': 42,
    }, 2);
    expect(xpOnly.xp, 42);

    final allTime = LeaderboardEntry.fromJson(const {
      'user_id': 'u3',
      'display_name': 'Carl',
      'total_xp': 999,
      'level': 5,
    }, 3);
    expect(allTime.xp, 999);
    expect(allTime.level, 5);
  });

  testWidgets('Leaderboard row localizes fallback user and streak at 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: LeaderboardRow(
              entry: const LeaderboardEntry(
                rank: 4,
                id: 'entry-4',
                displayName: '',
                xp: 120,
                streak: 3,
              ),
              displayRank: 4,
              onShowDetails: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Nutzer:in'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
