import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/leaderboard/leaderboard_screen.dart';
import 'package:deutschtiger/screens/leaderboard/widgets/leaderboard_tile.dart';
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

  testWidgets('Leaderboard tile localizes fallback user and streak at 200%', (
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
            body: LeaderboardTile(
              entry: const LeaderboardEntry(
                rank: 4,
                id: 'entry-4',
                displayName: '',
                xp: 120,
                streak: 3,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Nutzer:in'), findsOneWidget);
    expect(find.text('3 Tage'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
