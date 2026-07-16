import 'package:deutschtiger/features/exam/domain/exam_models.dart';
import 'package:deutschtiger/features/exam/presentation/exam_player_provider.dart';
import 'package:deutschtiger/features/exam/presentation/exam_result_page.dart';
import 'package:deutschtiger/features/exam/presentation/widgets/mobile_player/exam_comment_section.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The comment composer `TextField` has a blinking cursor (endless
  // animation) that would otherwise make `pumpAndSettle` time out.
  setUp(() => EditableText.debugDeterministicCursor = true);
  tearDown(() => EditableText.debugDeterministicCursor = false);

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
    correctAnswers: 1,
    sectionCorrect: const {'lesen': 1},
  );

  // Comments/history hit a real `apiClientProvider` HTTP call — override both
  // with immediate resolved futures so the widget tree settles instantly
  // instead of hanging on a real network round-trip (which timed out
  // `pumpAndSettle` before this override was added).
  List<Override> baseOverrides() => [
    examCommentsProvider(examId).overrideWith((ref) async => const []),
    examAttemptHistoryProvider(examId).overrideWith((ref) async => const []),
  ];

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
        ...baseOverrides(),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Goethe B1 Lesen'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Bestanden!'), findsOneWidget);
    expect(find.text('Prüfung ansehen'), findsOneWidget);
    expect(find.text('Erneut versuchen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('result page hides provider error detail', (tester) async {
    await tester.pumpWidget(
      localized([
        examByIdProvider(
          examId,
        ).overrideWith((ref) => Future.error(StateError('private detail'))),
        ...baseOverrides(),
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
