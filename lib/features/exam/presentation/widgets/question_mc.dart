// ignore_for_file: prefer_initializing_formals
//
// Multiple-choice renderer (cũng dùng cho anzeigen cards).
//
// Practice mode: highlight đáp án user; nếu đã chọn đúng → badge xanh ngay.
// Review mode: highlight đáp án đúng + đáp án user (nếu sai) khác màu.
// Test mode: chỉ lưu answer, không reveal.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../domain/exam_models.dart';
import 'question_card_frame.dart';

class QuestionMc extends StatelessWidget {
  const QuestionMc({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.sectionLabel,
    required this.selectedOptionId,
    required this.onSelect,
    this.showCorrectness = false,
  });

  final ExamQuestion question;
  final int questionNumber;
  final String sectionLabel;
  final String? selectedOptionId;
  final ValueChanged<String> onSelect;
  final bool showCorrectness;

  @override
  Widget build(BuildContext context) {
    return QuestionCardFrame(
      questionNumber: questionNumber,
      sectionLabel: sectionLabel,
      prompt: question.prompt,
      topSlot: Column(
        children: [
          for (var i = 0; i < question.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              child: _OptionTile(
                letter: String.fromCharCode(65 + i),
                option: question.options[i],
                isSelected: selectedOptionId == question.options[i].id,
                isCorrectAnswer:
                    showCorrectness && question.options[i].id == question.correctOptionId,
                isUserWrong:
                    showCorrectness &&
                        selectedOptionId == question.options[i].id &&
                        question.options[i].id != question.correctOptionId,
                onTap: () => onSelect(question.options[i].id),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.letter,
    required this.option,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.isUserWrong,
    required this.onTap,
  });

  final String letter;
  final ExamOption option;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool isUserWrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = ExamDesignTokens.examBorder;
    Color bg = Colors.white;
    Color letterBg = Colors.white;
    Color letterFg = ExamDesignTokens.examTextSecondary;
    IconData? trailing;

    if (isCorrectAnswer) {
      borderColor = ExamDesignTokens.examAnswerCorrectColor;
      bg = ExamDesignTokens.examSuccessSoft;
      letterBg = ExamDesignTokens.examAnswerCorrectColor;
      letterFg = Colors.white;
      trailing = Icons.check_circle;
    } else if (isUserWrong) {
      borderColor = ExamDesignTokens.examAnswerWrongColor;
      bg = ExamDesignTokens.examDangerSoft;
      letterBg = ExamDesignTokens.examAnswerWrongColor;
      letterFg = Colors.white;
      trailing = Icons.cancel;
    } else if (isSelected) {
      borderColor = ExamDesignTokens.examActive;
      bg = ExamDesignTokens.examActiveSoft;
      letterBg = ExamDesignTokens.examActive;
      letterFg = Colors.white;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor, width: isSelected || isCorrectAnswer || isUserWrong ? 2 : 1),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: letterBg,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: letterFg,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: Text(
                option.text,
                style: const TextStyle(
                  fontSize: 14,
                  color: ExamDesignTokens.examTextPrimary,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: DesignTokens.spacingSm),
              Icon(trailing,
                  color: isCorrectAnswer
                      ? ExamDesignTokens.examAnswerCorrectColor
                      : ExamDesignTokens.examAnswerWrongColor),
            ],
          ],
        ),
      ),
    );
  }
}