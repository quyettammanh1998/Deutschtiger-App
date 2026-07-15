// ignore_for_file: prefer_initializing_formals
//
// Toggle 3 chế độ: practice | test | review. Lưu trong URL queryParam để
// reload giữ nguyên mode.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/exam_models.dart';

class ExamModeToggle extends StatelessWidget {
  const ExamModeToggle({super.key, required this.mode, required this.onChange});

  final ExamMode mode;
  final ValueChanged<ExamMode> onChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = [
      (ExamMode.practice, l10n.practiceExam),
      (ExamMode.test, l10n.examTestMode),
      (ExamMode.review, l10n.examReviewMode),
    ];
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: ExamDesignTokens.examBorder,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final opt in options)
            _Tab(
              label: opt.$2,
              isActive: mode == opt.$1,
              onTap: () => onChange(opt.$1),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(DesignTokens.radius - 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radius - 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingXs + 2,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? ExamDesignTokens.examActiveStrong
                  : ExamDesignTokens.examTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
