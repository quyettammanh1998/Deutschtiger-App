import 'package:deutschtiger/data/exam/exam_ecosystem_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/exam_readiness_screen.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the readiness band + skill breakdown when data exists', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examReadinessProvider.overrideWith(
            (ref) async => const ExamReadinessSnapshot(
              attemptCount: 5,
              avgScore: 62.5,
              recentAvgScore: 70,
              bestScore: 85,
              readinessLow: 60,
              readinessHigh: 75,
              dueReviewCount: 12,
              examFailPending: 3,
              topWeaknesses: [],
              weaknessDetails: [],
              scoreTrend: [],
              skillReadiness: [
                ExamSkillStat(skill: 'hoeren', accuracy: 66.5, attemptCount: 3),
              ],
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ExamReadinessScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('60–75%'), findsOneWidget);
    expect(find.text('85'), findsOneWidget);
    expect(find.text('hoeren'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the empty state when the learner has no attempts', (
    tester,
  ) async {
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
          home: ExamReadinessScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Chưa có dữ liệu — hãy làm ít nhất 1 đề thi để xem mức sẵn sàng.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the error view + retry button when the fetch fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examReadinessProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ExamReadinessScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Không tải được dữ liệu. Vui lòng thử lại.'),
      findsOneWidget,
    );
    expect(find.text('Thử lại'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
