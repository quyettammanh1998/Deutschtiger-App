import 'package:deutschtiger/data/exam/exam_ecosystem_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/goethe_b1_hub_page.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the 3 Vietnamese rows and readiness band — no legacy English sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examReadinessProvider.overrideWith(
            (ref) async => const ExamReadinessSnapshot(
              attemptCount: 4,
              avgScore: 70,
              recentAvgScore: 72,
              bestScore: 88,
              readinessLow: 65,
              readinessHigh: 80,
              dueReviewCount: 2,
              examFailPending: 0,
              topWeaknesses: [],
              weaknessDetails: [],
              scoreTrend: [],
              skillReadiness: [],
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1HubPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Goethe-Zertifikat B1'), findsOneWidget);
    expect(find.text('Bộ đề thi chính thức'), findsOneWidget);
    expect(find.text('Bộ đề viết thực tế'), findsOneWidget);
    expect(find.text('Luyện nói (Sprechen)'), findsOneWidget);
    expect(find.text('65–80%'), findsOneWidget);

    // The old DIVERGENT body (English section labels) must not survive.
    expect(find.text('Lesen'), findsNothing);
    expect(find.text('Hören'), findsNothing);
    expect(find.text('Writing Topics'), findsNothing);
    expect(find.text('Past Exams'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the empty-readiness card when the learner has no attempts', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examReadinessProvider.overrideWith(
            (ref) async => const ExamReadinessSnapshot(
              attemptCount: 0,
              avgScore: 0,
              recentAvgScore: 0,
              bestScore: 0,
              readinessLow: 0,
              readinessHigh: 0,
              dueReviewCount: 0,
              examFailPending: 0,
              topWeaknesses: [],
              weaknessDetails: [],
              scoreTrend: [],
              skillReadiness: [],
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1HubPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bộ đề viết thực tế'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
