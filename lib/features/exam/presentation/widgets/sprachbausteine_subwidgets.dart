// ignore_for_file: prefer_initializing_formals
//
// Sub-widgets cho QuestionSprachbausteine — tách riêng để file chính < 200 dòng.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../domain/exam_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class SprachbausteineGapPicker extends StatelessWidget {
  const SprachbausteineGapPicker({
    super.key,
    required this.gapLabel,
    required this.options,
    required this.selectedIdx,
    required this.correctIdx,
    required this.showCorrectness,
    required this.onPick,
  });

  final String gapLabel;
  final List<ExamOption> options;
  final int? selectedIdx;
  final int? correctIdx;
  final bool showCorrectness;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final correct = showCorrectness && selectedIdx == correctIdx;
    final wrong =
        showCorrectness && selectedIdx != null && selectedIdx != correctIdx;

    Color border = ExamDesignTokens.examBorder;
    if (correct) border = ExamDesignTokens.examAnswerCorrectColor;
    if (wrong) border = ExamDesignTokens.examAnswerWrongColor;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: border, width: correct || wrong ? 2 : 1),
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                gapLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ExamDesignTokens.examActive,
                ),
              ),
              const Spacer(),
              if (showCorrectness && correct)
                const Icon(PhosphorIcons.checkCircle,
                    color: ExamDesignTokens.examAnswerCorrectColor, size: 16),
              if (showCorrectness && wrong)
                const Icon(PhosphorIcons.xCircle,
                    color: ExamDesignTokens.examAnswerWrongColor, size: 16),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Wrap(
            spacing: DesignTokens.spacingSm,
            runSpacing: DesignTokens.spacingSm,
            children: [
              for (var i = 0; i < options.length; i++)
                SprachbausteineOptionChip(
                  label: options[i].text,
                  isSelected: selectedIdx == i,
                  isCorrectOption: showCorrectness && i == correctIdx,
                  isUserWrongOption: showCorrectness &&
                      selectedIdx == i &&
                      i != correctIdx,
                  onTap: () => onPick(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SprachbausteineOptionChip extends StatelessWidget {
  const SprachbausteineOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isCorrectOption,
    required this.isUserWrongOption,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isCorrectOption;
  final bool isUserWrongOption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color border = ExamDesignTokens.examBorder;
    Color fg = ExamDesignTokens.examTextPrimary;

    if (isCorrectOption) {
      bg = ExamDesignTokens.examSuccessSoft;
      border = ExamDesignTokens.examAnswerCorrectColor;
      fg = ExamDesignTokens.examSuccessFg;
    } else if (isUserWrongOption) {
      bg = ExamDesignTokens.examDangerSoft;
      border = ExamDesignTokens.examAnswerWrongColor;
      fg = ExamDesignTokens.examDangerFg;
    } else if (isSelected) {
      bg = ExamDesignTokens.examActiveSoft;
      border = ExamDesignTokens.examActive;
      fg = ExamDesignTokens.examActiveStrong;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingSm,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: fg,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}