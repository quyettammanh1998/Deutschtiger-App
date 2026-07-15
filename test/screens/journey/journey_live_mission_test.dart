import 'package:deutschtiger/features/mission/domain/mission_models.dart';
import 'package:deutschtiger/features/mission/presentation/mission_session_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/journey/journey_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('learn hub shows only the localized live mission at 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayMissionProvider.overrideWith(
            (ref) async => const DailyMission(
              id: 'today',
              words: [
                DailyMissionWord(
                  wordId: 'haus',
                  contentDe: 'Haus',
                  contentVi: 'ngôi nhà',
                  level: 'A1',
                ),
              ],
              rounds: [
                MissionRound(index: 0, gameType: 'review', wordIds: ['haus']),
              ],
              roundsPlanned: 1,
              roundsCompleted: 0,
              completionPct: 0,
              xpEarned: 0,
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const JourneyScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lernreise'), findsOneWidget);
    expect(find.text('Heutige Lerneinheit'), findsOneWidget);
    expect(find.text('1 Runden · 1 Wörter'), findsOneWidget);
    expect(find.text('Starten'), findsOneWidget);
    expect(find.text('Beginner A1'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
