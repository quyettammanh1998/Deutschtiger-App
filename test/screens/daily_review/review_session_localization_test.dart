import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/daily_review/widgets/review_session_view.dart';
import 'package:deutschtiger/screens/daily_review/widgets/start_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('daily review start chrome localizes at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        child: const SingleChildScrollView(
          child: Column(
            children: [
              StreakCard(streakDays: 3),
              TodayStatsCard(dueCount: 7, reviewedToday: 2, xpToday: 15),
              StartReviewButton(onStart: _noop),
            ],
          ),
        ),
      ),
    );

    expect(find.text('3 Tage in Folge! 🔥'), findsOneWidget);
    expect(find.text('Fällig'), findsOneWidget);
    expect(find.text('Wiederholt'), findsOneWidget);
    expect(find.text('Wiederholung starten'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('FSRS answers localize and reflow at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        child: ReviewSessionView(
          position: 1,
          total: 5,
          item: const ReviewItem(
            learningItemId: 'haus',
            contentDe: 'Haus',
            contentVi: 'nhà',
          ),
          onAnswer: (_) {},
          errorMessage: 'unsafe provider detail',
        ),
      ),
    );

    expect(find.text('Bedeutung anzeigen'), findsOneWidget);
    await tester.tap(find.text('Bedeutung anzeigen'));
    await tester.pump();

    expect(find.text('Nochmals'), findsOneWidget);
    expect(find.text('Schwer'), findsWidgets);
    expect(find.text('Gut'), findsOneWidget);
    expect(find.text('Leicht'), findsWidgets);
    expect(
      find.text(
        'Deine Wiederholung konnte nicht gespeichert werden. Bitte versuche es erneut.',
      ),
      findsOneWidget,
    );
    expect(find.text('unsafe provider detail'), findsNothing);
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
