// ignore_for_file: prefer_initializing_formals
//
// Timer đếm ngược + đếm lên (cho cả 2 mode).
//
// Đếm ngược: dùng tổng durationMinutes của đề (timed=true), cảnh báo khi
// còn < 5 phút (chuyển sang `examTimerColor`).
// Đếm lên (untimed): chỉ hiển thị elapsed, màu muted.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';

class ExamTimer extends StatelessWidget {
  const ExamTimer({
    super.key,
    required this.elapsedSeconds,
    required this.totalSeconds,
    this.showCountdown = false,
  });

  final int elapsedSeconds;
  final int totalSeconds;
  final bool showCountdown;

  @override
  Widget build(BuildContext context) {
    final remaining =
        showCountdown ? (totalSeconds - elapsedSeconds).clamp(0, totalSeconds) : elapsedSeconds;
    final mins = remaining ~/ 60;
    final secs = remaining % 60;
    final timeStr = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    final warning = showCountdown && remaining < 5 * 60;
    final color = warning
        ? ExamDesignTokens.examTimerColor
        : ExamDesignTokens.examActiveStrong;
    final bg = warning
        ? ExamDesignTokens.examTimerColor.withValues(alpha: 0.08)
        : ExamDesignTokens.examActiveSoft;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(DesignTokens.radius * 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            showCountdown ? Icons.timer_outlined : Icons.access_time,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            timeStr,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}