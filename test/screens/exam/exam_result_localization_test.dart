import 'package:deutschtiger/features/exam/domain/exam_models.dart';
import 'package:deutschtiger/features/exam/presentation/exam_player_provider.dart';
import 'package:deutschtiger/features/exam/presentation/exam_result_page.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const examId = 'goethe-b1-1';
  const exam = Exam(
    id: examId,
    title: 'Goethe B1 Lesen',
    level: 'b1',
    provider: 'goethe',
    sections: [
      ExamSection(
        kind: ExamSectionKind.lesen,
        durationMinutes: 1,
        questions: [
          ExamQuestion(id: 'q1', type: QuestionType.mc, prompt: 'Frage'),
        ],
      ),
    ],
  );
  final attempt = ExamAttempt(
    examId: examId,
    mode: ExamMode.test,
    answers: const {'q1': 'a'},
    elapsedSeconds: 65,
    startedAt: DateTime(2026, 7, 15),
    score: 1,
    maxScore: 1,
    passed: true,
    sectionCorrect: const {'lesen': 1},
  );

  Widget localized(List<Override> overrides) => ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: const Locale('de'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: ExamResultPage(examId: examId),
      ),
    ),
  );

  testWidgets('result page localizes its chrome at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized([
        examByIdProvider(examId).overrideWith((ref) async => exam),
        examResultProvider(examId).overrideWith((ref) async => attempt),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ergebnis'), findsOneWidget);
    expect(find.text('BESTANDEN'), findsOneWidget);
    expect(find.text('1/1 Fragen'), findsOneWidget);
    expect(find.text('Auswertung nach Teilen'), findsOneWidget);
    expect(find.text('1/1 richtig · 1 Min.'), findsOneWidget);
    expect(find.text('Prüfung ansehen'), findsOneWidget);
    expect(find.text('Erneut versuchen'), findsOneWidget);
  });

  testWidgets('result page hides provider error detail', (tester) async {
    await tester.pumpWidget(
      localized([
        examByIdProvider(
          examId,
        ).overrideWith((ref) => Future.error(StateError('private detail'))),
      ]),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Das Prüfungsergebnis konnte nicht geladen werden. Bitte versuche es erneut.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('private detail'), findsNothing);
  });
}
