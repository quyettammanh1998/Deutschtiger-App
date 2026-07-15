import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Lightweight confetti effect: 24 small rotated rectangles falling from the
/// top of the screen, fading out as they go. No third-party packages used.
///
/// Use inside an [AnimatedBuilder] whose animation is fed to [progress] in
/// the 0.0..1.0 range.
class ConfettiOverlay extends StatelessWidget {
  const ConfettiOverlay({super.key, required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (ctx, child) => CustomPaint(
          painter: _ConfettiPainter(progress: controller.value),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});
  final double progress;

  static const _colors = <Color>[
    DesignTokens.orange500,
    DesignTokens.rose600,
    DesignTokens.warning,
    DesignTokens.success,
    DesignTokens.darkPrimary,
    Color(0xFFA855F7),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint();
    final rng = math.Random(7); // deterministic
    for (int i = 0; i < 24; i++) {
      final dx = rng.nextDouble() * size.width;
      final fall = size.height * (0.6 + rng.nextDouble() * 0.4);
      final dy = fall * progress;
      final angle = progress * (math.pi * 2) * (rng.nextDouble() * 0.4 + 0.4);
      paint.color = _colors[i % _colors.length]
          .withValues(alpha: (1 - progress).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle);
      final s = 6.0 + rng.nextDouble() * 6.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: s, height: s * 0.5),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
