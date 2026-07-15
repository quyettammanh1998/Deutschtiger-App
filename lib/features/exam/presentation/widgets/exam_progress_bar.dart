// ignore_for_file: prefer_initializing_formals
//
// Progress bar tổng quan (% câu đã trả lời / tổng câu).

import 'package:flutter/material.dart';

import '../../../../core/exam_design_tokens.dart';

class ExamProgressBar extends StatelessWidget {
  const ExamProgressBar({
    super.key,
    required this.answered,
    required this.total,
    this.label,
  });

  final int answered;
  final int total;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : answered / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label ?? 'Tiến độ',
              style: const TextStyle(
                fontSize: 11,
                color: ExamDesignTokens.examTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$answered / $total',
              style: const TextStyle(
                fontSize: 11,
                color: ExamDesignTokens.examActiveStrong,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio.clamp(0, 1),
            minHeight: 5,
            backgroundColor: ExamDesignTokens.examBorder,
            valueColor: const AlwaysStoppedAnimation(
                ExamDesignTokens.examActive),
          ),
        ),
      ],
    );
  }
}