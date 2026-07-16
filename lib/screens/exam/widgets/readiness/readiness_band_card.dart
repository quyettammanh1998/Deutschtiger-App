import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';

/// Colored readiness band with a 0/50/100 tick gradient bar — mirrors web
/// `ReadinessBand` in `exam-readiness-page.tsx`.
class ReadinessBandCard extends StatelessWidget {
  const ReadinessBandCard({super.key, required this.snapshot});

  final ExamReadinessSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final low = snapshot.readinessLow.clamp(0, 100);
    final high = snapshot.readinessHigh.clamp(low, 100);
    final mid = ((low + high) / 2).round();
    final color = mid >= 70
        ? tokens.success
        : mid >= 50
        ? tokens.warning
        : tokens.destructive;

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
            Text(
              l10n.examReadinessBandLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: tokens.mutedForeground,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$low–$high%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Stack(
                  children: [
                    Container(
                      height: 12,
                      width: width,
                      decoration: BoxDecoration(
                        color: tokens.muted,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Positioned(
                      left: width * (low / 100),
                      width: width * ((high - low) / 100).clamp(0.02, 1.0),
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0%',
                  style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                ),
                Text(
                  '50%',
                  style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                ),
                Text(
                  '100%',
                  style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty-state band shown when [ExamReadinessSnapshot.attemptCount] is 0.
class ReadinessBandEmptyCard extends StatelessWidget {
  const ReadinessBandEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.examReadinessEmpty,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}
