import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/daily_review/widgets/daily_review_done.dart';
import 'package:deutschtiger/screens/daily_review/widgets/daily_review_round_cards.dart';
import 'package:deutschtiger/screens/daily_review/widgets/daily_review_rounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('daily review round intro/summary localize at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DailyReviewRoundIntroCard(
                gameType: DailyReviewGameType.matching,
                roundIndex: 0,
                totalRounds: 3,
                wordCount: 6,
                onStart: _noop,
              ),
              DailyReviewRoundSummaryCard(
                gameType: DailyReviewGameType.cloze,
                correct: 5,
                total: 6,
                xpEarned: 50,
                isLastRound: false,
                totalWordsReviewed: 6,
                totalWords: 18,
                onContinue: _noop,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Runde 1/3'), findsOneWidget);
    expect(find.text('Zuordnen'), findsOneWidget);
    expect(find.text('Starten'), findsOneWidget);
    expect(find.text('Weiter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('daily review done screen localizes at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        child: DailyReviewDoneScreen(
          result: const DailyReviewResult(
            totalCount: 10,
            correctCount: 8,
            xpEarned: 40,
            weakWords: [
              DailyReviewWeakWord(contentDe: 'Haus', contentVi: 'nhà'),
            ],
            hasMore: true,
          ),
          onGoHome: _noop,
          onContinueLearning: _noop,
          onRetryWeakWords: _noop,
          onContinue: _noop,
        ),
      ),
    );

    expect(find.text('Fertig!'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('1 schwache Wörter üben'), findsOneWidget);
    expect(find.text('Zurück zur Startseite'), findsOneWidget);
    expect(find.text('Haus'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('daily review done screen empty state localizes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        child: DailyReviewDoneScreen(
          result: const DailyReviewResult.empty(),
          onGoHome: _noop,
          onContinueLearning: _noop,
        ),
      ),
    );

    expect(find.text('Keine Wörter zu wiederholen!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _localizedApp({required Widget child}) => MaterialApp(
  locale: const Locale('de'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: MediaQuery(
    data: const MediaQueryData(
      size: Size(360, 800),
      textScaler: TextScaler.linear(2),
    ),
    child: Scaffold(body: child),
  ),
);

void _noop() {}
