import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

/// Progress + XP header shared by the 4 practice views — web parity: each
/// mode uses its own gradient (`practice-cloze`/`practice-writing-unified` =
/// orange, `practice-listening` = orange, `practice-matching` = pink→rose).
/// Callers pass their mode's gradient via [gradientStart]/[gradientEnd]
/// instead of one shared color (cross-cutting scout finding — web headers
/// are NOT visually identical across modes).
class PracticeProgressHeader extends StatelessWidget {
  const PracticeProgressHeader({
    super.key,
    required this.current,
    required this.total,
    required this.xp,
    this.gradientStart = const Color(0xFFF97316),
    this.gradientEnd = const Color(0xFFEA580C),
    this.extraLabel,
  });

  final int current;
  final int total;

  /// `⚡ {xp} XP` counter — web shows this on every practice mode header.
  final int xp;
  final Color gradientStart;
  final Color gradientEnd;

  /// Optional trailing label (e.g. matching's "{done}/{total} từ").
  final String? extraLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final progress = total > 0 ? current / total : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${current.clamp(0, total)}/$total',
                style: TextStyle(fontWeight: FontWeight.w600, color: tokens.mutedForeground),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (extraLabel != null) ...[
                    Text(extraLabel!, style: TextStyle(color: tokens.mutedForeground, fontSize: 12)),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tokens.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '⚡ $xp XP',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: tokens.warning),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  Container(color: tokens.muted),
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [gradientStart, gradientEnd]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
