// ignore_for_file: prefer_initializing_formals
//
// Question palette — grid nhỏ để user nhảy nhanh giữa các câu.
//  - answered → active background
//  - current → border highlight
//  - unanswered → neutral

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../domain/exam_models.dart';

class QuestionPalette extends StatelessWidget {
  const QuestionPalette({
    super.key,
    required this.questions,
    required this.answeredIds,
    required this.currentGlobalIndex,
    required this.onTap,
  });

  final List<ExamQuestion> questions;
  final Set<String> answeredIds;
  final int currentGlobalIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DesignTokens.spacingXs,
      runSpacing: DesignTokens.spacingXs,
      children: [
        for (var i = 0; i < questions.length; i++)
          _PaletteCell(
            index: i,
            isAnswered: answeredIds.contains(questions[i].answerKey),
            isCurrent: i == currentGlobalIndex,
            hasAudio: questions[i].hasAudio,
            onTap: () => onTap(i),
          ),
      ],
    );
  }
}

class _PaletteCell extends StatelessWidget {
  const _PaletteCell({
    required this.index,
    required this.isAnswered,
    required this.isCurrent,
    required this.hasAudio,
    required this.onTap,
  });

  final int index;
  final bool isAnswered;
  final bool isCurrent;
  final bool hasAudio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color border = ExamDesignTokens.examBorder;
    Color fg = ExamDesignTokens.examTextSecondary;

    if (isCurrent) {
      border = ExamDesignTokens.examActive;
      bg = ExamDesignTokens.examActiveSoft;
      fg = ExamDesignTokens.examActiveStrong;
    }
    if (isAnswered) {
      bg = ExamDesignTokens.examActive;
      fg = Colors.white;
      border = ExamDesignTokens.examActive;
    }

    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border, width: isCurrent ? 2 : 1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                if (hasAudio)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isAnswered
                            ? Colors.white
                            : ExamDesignTokens.examActive,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
