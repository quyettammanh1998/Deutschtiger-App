import 'package:deutschtiger/features/mission/domain/mission_models.dart';
import 'package:deutschtiger/features/mission/presentation/mission_session_page.dart';
import 'package:deutschtiger/features/mission/presentation/mission_session_provider.dart';
import 'package:deutschtiger/features/mission/presentation/widgets/mission_complete_overlay.dart';
import 'package:deutschtiger/features/mission/presentation/widgets/resume_pre_step_view.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget localized(Widget child) => MaterialApp(
    locale: const Locale('de'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: child,
    ),
  );

  test('mission persistence errors resolve through the active locale', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('de'));

    expect(
      missionSessionErrorMessage(l10n, MissionSessionError.roundNotSaved),
      'Diese Lernrunde konnte nicht gespeichert werden. Bitte versuche es erneut.',
    );
    expect(
      missionSessionErrorMessage(l10n, MissionSessionError.missionNotCompleted),
      'Diese Aufgabe konnte nicht abgeschlossen werden. Bitte versuche es erneut.',
    );
  });

  testWidgets('resume pre-step chrome localizes at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        Scaffold(
          body: ResumePreStepView(
            items: const [
              MissionResumeTarget(
                kind: 'exam',
                ref: 'goethe-a1',
                title: 'Goethe A1',
                subtitle: 'Lesen · 40%',
                route: '/exam/goethe-a1',
                progressPct: 40,
              ),
            ],
            onContinue: () {},
          ),
        ),
      ),
    );

    expect(find.text('Unerledigtes fortsetzen'), findsOneWidget);
    expect(find.text('Zur Vokabelrunde'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mission complete overlay localizes at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        Scaffold(
          body: MissionCompleteOverlay(
            xpEarned: 20,
            streakUpdated: true,
            climbed: const [
              MissionClimbedEntry(
                label: 'Haus',
                isStructure: false,
                fromRung: 1,
                toRung: 2,
              ),
            ],
            onDone: () {},
          ),
        ),
      ),
    );

    expect(find.text('Geschafft!'), findsOneWidget);
    expect(find.text('+20 XP'), findsOneWidget);
    expect(find.text('Nächster Schritt →'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
