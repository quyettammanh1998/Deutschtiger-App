// ignore_for_file: prefer_initializing_formals
//
// Khung chung cho mọi question renderer: badge số câu + prompt text.
//
// Prompt có thể là multi-line; dùng SelectableText để user copy được từ vựng
// trong câu hỏi.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class QuestionCardFrame extends StatelessWidget {
  const QuestionCardFrame({
    super.key,
    required this.questionNumber,
    required this.sectionLabel,
    required this.prompt,
    this.topSlot,
  });

  final int questionNumber;
  final String sectionLabel;
  final String prompt;
  final Widget? topSlot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ExamDesignTokens.examCardPadding),
      decoration: BoxDecoration(
        color: ExamDesignTokens.examPaperColor,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: ExamDesignTokens.examBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: DesignTokens.spacingSm,
            runSpacing: DesignTokens.spacingXs,
            children: [
              _Badge(
                label: l10n.examQuestionNumber(questionNumber),
                color: ExamDesignTokens.examActive,
              ),
              _Badge(
                label: sectionLabel,
                color: ExamDesignTokens.examActiveStrong,
                soft: true,
              ),
            ],
          ),
          if (topSlot != null) ...[
            const SizedBox(height: DesignTokens.spacingMd),
            topSlot!,
          ],
          const SizedBox(height: DesignTokens.spacingMd),
          SelectableText(
            prompt,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: ExamDesignTokens.examTextPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.soft = false});

  final String label;
  final Color color;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXs / 2,
      ),
      decoration: BoxDecoration(
        color: soft ? color.withValues(alpha: 0.08) : color,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm / 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: soft ? color : Colors.white,
        ),
      ),
    );
  }
}
