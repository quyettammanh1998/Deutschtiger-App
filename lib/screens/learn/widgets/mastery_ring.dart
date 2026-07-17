import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

/// Vòng tròn % thẻ đã thuộc — vẽ tay bằng [CustomPainter], không thêm package
/// chart mới (pubspec chưa có fl_chart/graphic, giữ KISS cho 1 chỉ số đơn).
class MasteryRing extends StatelessWidget {
  const MasteryRing({super.key, required this.percent, this.size = 108});

  final int percent;
  final double size;

  Color _colorFor(AppTokens tokens) {
    if (percent >= 70) return tokens.success;
    if (percent >= 40) return tokens.warning;
    return tokens.destructive;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = _colorFor(tokens);
    final clamped = percent.clamp(0, 100);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _MasteryRingPainter(
              percent: clamped,
              color: color,
              trackColor: tokens.muted,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$clamped%',
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MasteryRingPainter extends CustomPainter {
  _MasteryRingPainter({
    required this.percent,
    required this.color,
    required this.trackColor,
  });

  final int percent;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final strokeWidth = size.width * 0.09;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * (percent / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MasteryRingPainter oldDelegate) =>
      oldDelegate.percent != percent ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}
