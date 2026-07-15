import 'package:deutschtiger/features/mission/domain/mission_models.dart';
import 'package:deutschtiger/features/mission/presentation/mission_session_page.dart';
import 'package:deutschtiger/features/mission/presentation/mission_session_provider.dart';
import 'package:deutschtiger/features/mission/presentation/widgets/practice_view.dart';
import 'package:deutschtiger/features/mission/presentation/widgets/result_view.dart';
import 'package:deutschtiger/features/mission/presentation/widgets/word_intro_view.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/shared/widgets/game_completion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const word = DailyMissionWord(
    wordId: 'haus',
    contentDe: 'Haus',
    contentVi: 'ngôi nhà',
    level: 'A1',
  );

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

  testWidgets('mission session chrome localizes at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        WordIntroView(word: word, position: 1, total: 2, onContinue: () {}),
      ),
    );

    expect(find.text('Übung beginnen'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      localized(
        PracticeView(word: word, position: 1, total: 2, onAnswer: (_) {}),
      ),
    );
    await tester.tap(find.text('Bedeutung anzeigen'));
    await tester.pump();

    expect(find.text('Üben · 1 / 2'), findsOneWidget);
    expect(find.text('Nicht erinnert'), findsOneWidget);
    expect(find.text('Richtig erinnert'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      localized(const ResultView(correct: false, onContinue: _noop)),
    );

    expect(find.text('Noch nicht ganz – weiter so!'), findsOneWidget);
    expect(find.text('Weiter'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      localized(
        GameCompletionScreen(
          score: 1,
          total: 2,
          onPlayAgain: _noop,
          onGoHome: _noop,
        ),
      ),
    );

    expect(find.text('Punkte'), findsOneWidget);
    expect(find.text('Genauigkeit'), findsOneWidget);
    expect(find.text('Nochmal spielen'), findsOneWidget);
    expect(find.text('Zurück zur Startseite'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
