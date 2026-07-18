// ignore_for_file: prefer_initializing_formals
//
// Hiển thị giải thích đáp án — chỉ dùng ở practice / review mode.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/exam_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class ExamExplanationCard extends StatelessWidget {
  const ExamExplanationCard({
    super.key,
    required this.question,
    required this.userAnswer,
  });

  final ExamQuestion question;
  final String? userAnswer;

  bool _userIsCorrect() {
    if (userAnswer == null) return false;
    switch (question.type) {
      case QuestionType.mc:
      case QuestionType.anzeigen:
        return userAnswer == question.correctOptionId;
      case QuestionType.richtigFalsch:
        return (userAnswer == 'true') == (question.correctBoolean ?? false);
      case QuestionType.matching:
      case QuestionType.sprachbausteine:
        return false; // Renderer riêng đã highlight per-item; chỉ show note chung.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCorrect = _userIsCorrect();
    final color = isCorrect
        ? ExamDesignTokens.examAnswerCorrectColor
        : ExamDesignTokens.examAnswerWrongColor;
    final icon = isCorrect ? PhosphorIcons.checkCircle : PhosphorIcons.lightbulb;
    final label = isCorrect ? l10n.examCorrect : l10n.examNotCorrect;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: isCorrect
            ? ExamDesignTokens.examSuccessSoft
            : ExamDesignTokens.examWarnSoft,
        border: Border.all(
          color: isCorrect
              ? ExamDesignTokens.examAnswerCorrectColor
              : ExamDesignTokens.examWarnBorder,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: DesignTokens.spacingSm),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          if (question.explanation != null) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              question.explanation!,
              style: const TextStyle(
                fontSize: 13,
                color: ExamDesignTokens.examTextPrimary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
