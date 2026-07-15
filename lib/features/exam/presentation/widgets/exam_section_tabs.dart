// ignore_for_file: prefer_initializing_formals
//
// Tabs chuyển Lesen / Hören trong player. Mỗi tab hiển thị progress answered/total.

import 'package:flutter/material.dart';

import '../../../../core/exam_design_tokens.dart';
import '../../domain/exam_models.dart';

class ExamSectionTabs extends StatelessWidget {
  const ExamSectionTabs({
    super.key,
    required this.sections,
    required this.currentSection,
    required this.answeredIds,
    required this.onTap,
  });

  final List<ExamSection> sections;
  final int currentSection;
  final Set<String> answeredIds;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          for (var i = 0; i < sections.length; i++)
            Expanded(
              child: _Tab(
                section: sections[i],
                isActive: i == currentSection,
                answered: sections[i].questions
                    .where((q) => answeredIds.contains(q.answerKey))
                    .length,
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.section,
    required this.isActive,
    required this.answered,
    required this.onTap,
  });

  final ExamSection section;
  final bool isActive;
  final int answered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? ExamDesignTokens.examActiveSoft : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isActive
                  ? ExamDesignTokens.examActive
                  : ExamDesignTokens.examBorder,
              width: isActive ? 2 : 1,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              section.kind.labelDe,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? ExamDesignTokens.examActiveStrong
                    : ExamDesignTokens.examTextSecondary,
              ),
            ),
            Text(
              '$answered/${section.questionCount}',
              style: const TextStyle(
                fontSize: 10,
                color: ExamDesignTokens.examTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
