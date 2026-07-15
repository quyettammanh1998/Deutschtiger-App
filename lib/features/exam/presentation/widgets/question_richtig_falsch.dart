// ignore_for_file: prefer_initializing_formals
//
// Richtig / Falsch renderer — 2 nút lớn, đáp án lưu dạng "true"/"false".

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../domain/exam_models.dart';
import 'question_card_frame.dart';

class QuestionRichtigFalsch extends StatelessWidget {
  const QuestionRichtigFalsch({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.sectionLabel,
    required this.answer,
    required this.onSelect,
    this.showCorrectness = false,
  });

  final ExamQuestion question;
  final int questionNumber;
  final String sectionLabel;
  final String? answer; // "true" | "false" | null
  final ValueChanged<String> onSelect;
  final bool showCorrectness;

  bool? get _selectedBool {
    if (answer == 'true') return true;
    if (answer == 'false') return false;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedBool;
    final correct = question.correctBoolean;

    return QuestionCardFrame(
      questionNumber: questionNumber,
      sectionLabel: sectionLabel,
      prompt: question.prompt,
      topSlot: Row(
        children: [
          Expanded(
            child: _BoolButton(
              label: 'Richtig',
              subLabel: 'Đúng',
              icon: Icons.check_circle_outline,
              isSelected: selected == true,
              isCorrectAnswer: showCorrectness && correct == true,
              isUserWrong: showCorrectness && selected == true && correct != true,
              positive: true,
              onTap: () => onSelect('true'),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: _BoolButton(
              label: 'Falsch',
              subLabel: 'Sai',
              icon: Icons.cancel_outlined,
              isSelected: selected == false,
              isCorrectAnswer: showCorrectness && correct == false,
              isUserWrong: showCorrectness && selected == false && correct != false,
              positive: false,
              onTap: () => onSelect('false'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoolButton extends StatelessWidget {
  const _BoolButton({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.isUserWrong,
    required this.positive,
    required this.onTap,
  });

  final String label;
  final String subLabel;
  final IconData icon;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool isUserWrong;
  final bool positive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color border = ExamDesignTokens.examBorder;
    Color bg = Colors.white;
    Color fg = ExamDesignTokens.examTextSecondary;

    if (isCorrectAnswer) {
      border = ExamDesignTokens.examAnswerCorrectColor;
      bg = ExamDesignTokens.examSuccessSoft;
      fg = ExamDesignTokens.examSuccessFg;
    } else if (isUserWrong) {
      border = ExamDesignTokens.examAnswerWrongColor;
      bg = ExamDesignTokens.examDangerSoft;
      fg = ExamDesignTokens.examDangerFg;
    } else if (isSelected) {
      border = ExamDesignTokens.examActive;
      bg = ExamDesignTokens.examActiveSoft;
      fg = ExamDesignTokens.examActiveStrong;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: DesignTokens.spacingLg,
          horizontal: DesignTokens.spacingMd,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: fg),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
            Text(
              subLabel,
              style: const TextStyle(
                fontSize: 12,
                color: ExamDesignTokens.examTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}