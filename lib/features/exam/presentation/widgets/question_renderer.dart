// ignore_for_file: prefer_initializing_formals
//
// Dispatcher: chọn renderer theo [ExamQuestion.type]. 1 widget duy nhất cho
// player dùng → giảm if/else lặp trong page chính.

import 'package:flutter/material.dart';

import '../../domain/exam_models.dart';
import 'question_anzeigen.dart';
import 'question_matching.dart';
import 'question_mc.dart';
import 'question_richtig_falsch.dart';
import 'question_sprachbausteine.dart';

class QuestionRenderer extends StatelessWidget {
  const QuestionRenderer({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.sectionLabel,
    required this.answer,
    required this.onChange,
    this.showCorrectness = false,
  });

  final ExamQuestion question;
  final int questionNumber;
  final String sectionLabel;
  final String? answer;
  final ValueChanged<String> onChange;
  final bool showCorrectness;

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.mc:
        return QuestionMc(
          question: question,
          questionNumber: questionNumber,
          sectionLabel: sectionLabel,
          selectedOptionId: answer,
          onSelect: onChange,
          showCorrectness: showCorrectness,
        );
      case QuestionType.anzeigen:
        return QuestionAnzeigen(
          question: question,
          questionNumber: questionNumber,
          sectionLabel: sectionLabel,
          selectedOptionId: answer,
          onSelect: onChange,
          showCorrectness: showCorrectness,
        );
      case QuestionType.richtigFalsch:
        return QuestionRichtigFalsch(
          question: question,
          questionNumber: questionNumber,
          sectionLabel: sectionLabel,
          answer: answer,
          onSelect: onChange,
          showCorrectness: showCorrectness,
        );
      case QuestionType.matching:
        return QuestionMatching(
          question: question,
          questionNumber: questionNumber,
          sectionLabel: sectionLabel,
          answer: answer,
          onChange: onChange,
          showCorrectness: showCorrectness,
        );
      case QuestionType.sprachbausteine:
        return QuestionSprachbausteine(
          question: question,
          questionNumber: questionNumber,
          sectionLabel: sectionLabel,
          answer: answer,
          onChange: onChange,
          showCorrectness: showCorrectness,
        );
    }
  }
}
