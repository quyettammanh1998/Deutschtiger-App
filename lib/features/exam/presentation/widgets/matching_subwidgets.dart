// ignore_for_file: prefer_initializing_formals
//
// Sub-widgets cho QuestionMatching — tách riêng để file chính < 200 dòng.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class PickedRight extends StatelessWidget {
  const PickedRight({super.key, required this.text, required this.isCorrect});
  final String text;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: isCorrect
            ? ExamDesignTokens.examSuccessSoft
            : ExamDesignTokens.examDangerSoft,
        border: Border.all(
          color: isCorrect
              ? ExamDesignTokens.examAnswerCorrectColor
              : ExamDesignTokens.examAnswerWrongColor,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect
                ? ExamDesignTokens.examAnswerCorrectColor
                : ExamDesignTokens.examAnswerWrongColor,
            size: 18,
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: ExamDesignTokens.examTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RightLetterStrip extends StatelessWidget {
  const RightLetterStrip({
    super.key,
    required this.rightItems,
    required this.selectedLeft,
    required this.onTapRight,
  });

  final List<String> rightItems;
  final int? selectedLeft;
  final ValueChanged<int> onTapRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          for (var r = 0; r < rightItems.length; r++)
            Expanded(
              child: GestureDetector(
                onTap: () => onTapRight(r),
                child: Container(
                  margin: EdgeInsets.only(left: r == 0 ? 0 : 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedLeft != null
                        ? ExamDesignTokens.examActiveSoft
                        : Colors.white,
                    border: Border.all(
                      color: selectedLeft != null
                          ? ExamDesignTokens.examActive
                          : ExamDesignTokens.examBorder,
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Text(
                    String.fromCharCode(65 + r),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selectedLeft != null
                          ? ExamDesignTokens.examActive
                          : ExamDesignTokens.examTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LeftItemTile extends StatelessWidget {
  const LeftItemTile({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isCorrectPair,
    required this.onTap,
    required this.onClear,
  });

  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrectPair;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: isSelected ? ExamDesignTokens.examActiveSoft : Colors.white,
          border: Border.all(
            color: isSelected
                ? ExamDesignTokens.examActive
                : ExamDesignTokens.examBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: isSelected
                  ? ExamDesignTokens.examActive
                  : ExamDesignTokens.examBorder,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? Colors.white
                      : ExamDesignTokens.examTextSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: ExamDesignTokens.examTextPrimary,
                ),
              ),
            ),
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, size: 16),
              tooltip: l10n.removeMatch,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

class ArrowSeparator extends StatelessWidget {
  const ArrowSeparator({super.key, required this.isCorrect});
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      alignment: Alignment.center,
      child: Text(
        isCorrect ? '✓' : '→',
        style: TextStyle(
          color: isCorrect
              ? ExamDesignTokens.examAnswerCorrectColor
              : ExamDesignTokens.examTextTertiary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
