import 'package:deutschtiger/features/exam/domain/exam_models.dart';
import 'package:deutschtiger/features/exam/presentation/widgets/question_renderer.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final fixture in _fixtures) {
    testWidgets(
      '${fixture.question.type.name} renders review state on mobile',
      (tester) async {
        tester.view.physicalSize = const Size(340, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: IgnorePointer(
                    child: QuestionRenderer(
                      question: fixture.question,
                      questionNumber: 1,
                      sectionLabel: 'Lesen · Đọc hiểu',
                      answer: fixture.answer,
                      onChange: (_) {},
                      showCorrectness: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.textContaining(fixture.question.prompt), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('matching ignores a corrupt saved pair instead of crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: QuestionRenderer(
              question: _matching,
              questionNumber: 1,
              sectionLabel: 'Lesen',
              answer: 'bad:value,0:99',
              onChange: (_) {},
              showCorrectness: true,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}

class _Fixture {
  const _Fixture(this.question, this.answer);
  final ExamQuestion question;
  final String answer;
}

const _options = [
  ExamOption(id: '0', text: 'Antwort A'),
  ExamOption(id: '1', text: 'Antwort B'),
];

const _matching = ExamQuestion(
  id: 'matching',
  type: QuestionType.matching,
  prompt: 'Ordnen Sie zu',
  matchLeft: ['Situation eins', 'Situation zwei'],
  matchRight: ['Antwort A', 'Antwort B'],
  correctMatches: {0: 0, 1: 1},
);

const _fixtures = [
  _Fixture(
    ExamQuestion(
      id: 'mc',
      type: QuestionType.mc,
      prompt: 'Wählen Sie die richtige Antwort',
      options: _options,
      correctOptionId: '1',
    ),
    '0',
  ),
  _Fixture(_matching, '0:0,1:1'),
  _Fixture(
    ExamQuestion(
      id: 'rf',
      type: QuestionType.richtigFalsch,
      prompt: 'Ist die Aussage richtig?',
      correctBoolean: true,
    ),
    'false',
  ),
  _Fixture(
    ExamQuestion(
      id: 'dropdown',
      type: QuestionType.sprachbausteine,
      prompt: 'Ergänzen Sie die Lücke',
      options: _options,
      gapPositions: [1],
    ),
    '0',
  ),
  _Fixture(
    ExamQuestion(
      id: 'anzeigen',
      type: QuestionType.anzeigen,
      prompt: 'Welche Anzeige passt?',
      options: _options,
      correctOptionId: '0',
    ),
    '1',
  ),
];
