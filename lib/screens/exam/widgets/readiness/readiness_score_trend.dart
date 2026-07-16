import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';

/// Inline sparkline of recent exam scores — mirrors web
/// `exam-readiness-score-trend.tsx`. Renders nothing below 2 points.
class ReadinessScoreTrend extends StatelessWidget {
  const ReadinessScoreTrend({super.key, required this.trend});

  final List<ExamTrendPoint> trend;

  @override
  Widget build(BuildContext context) {
    if (trend.length < 2) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final scores = trend.map((p) => p.score).toList();
    final first = scores.first;
    final last = scores.last;
    final delta = last - first;
    final deltaColor = delta > 0
        ? tokens.success
        : delta < 0
        ? tokens.destructive
        : tokens.mutedForeground;
    final deltaLabel = delta > 0
        ? '▲ +$delta'
        : delta < 0
        ? '▼ $delta'
        : '→ 0';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.examReadinessScoreTrendLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: tokens.mutedForeground,
                  ),
                ),
                Text(
                  l10n.examReadinessScoreTrendDelta(deltaLabel),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: deltaColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 56,
              width: double.infinity,
              child: CustomPaint(painter: _SparklinePainter(scores: scores)),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.examReadinessScoreTrendRecentCount(trend.length),
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
                Text.rich(
                  TextSpan(
                    text: l10n.examReadinessScoreTrendLatestPrefix,
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.mutedForeground,
                    ),
                    children: [
                      TextSpan(
                        text: '$last%',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: tokens.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.scores});

  final List<int> scores;

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 4.0;
    final max = scores.reduce((a, b) => a > b ? a : b).clamp(100, 1 << 30);
    final min = scores.reduce((a, b) => a < b ? a : b).clamp(0, 0);
    final span = (max - min) == 0 ? 1 : (max - min);

    Offset pointAt(int i) {
      final x = pad + (i * (size.width - 2 * pad)) / (scores.length - 1);
      final y =
          size.height -
          pad -
          ((scores[i] - min) / span) * (size.height - 2 * pad);
      return Offset(x, y);
    }

    final path = Path();
    for (var i = 0; i < scores.length; i++) {
      final p = pointAt(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xFFF97316)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    for (var i = 0; i < scores.length; i++) {
      final isLast = i == scores.length - 1;
      final dotPaint = Paint()
        ..color = isLast ? const Color(0xFFF97316) : const Color(0x99FB923C);
      canvas.drawCircle(pointAt(i), isLast ? 3 : 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.scores != scores;
}
