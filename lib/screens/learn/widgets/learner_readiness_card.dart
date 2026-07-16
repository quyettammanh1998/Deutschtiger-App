import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/learn/learn_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';

/// "Mức sẵn sàng thi (ước lượng)" — mirrors web `LearnerReadinessCard`: a
/// `{low}–{high}%` band colored green/amber/red by [LearnerReadiness.pct],
/// a positioned progress segment, and a "basis" caption. Web's "việc tăng
/// điểm nhanh nhất" action rows need the readiness action-item contract
/// (not yet exposed by [LearnerReadiness]) — deferred, card links to the
/// full exam-readiness screen instead.
class LearnerReadinessCard extends StatelessWidget {
  const LearnerReadinessCard({super.key, required this.readiness});

  final LearnerReadiness readiness;

  Color _bandColor(int pct) {
    if (pct >= 70) return const Color(0xFF16A34A);
    if (pct >= 40) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    if (!readiness.hasData) {
      return AppCard.card(
        onTap: () => context.push('/exam/readiness'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.learnerModelReadinessTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.learnerModelReadinessNoData,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ],
        ),
      );
    }

    final color = _bandColor(readiness.pct);
    return AppCard.card(
      onTap: () => context.push('/exam/readiness'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.learnerModelReadinessTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: tokens.foreground,
                ),
              ),
              Text(
                '${readiness.low}–${readiness.high}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final left = (readiness.low / 100 * width).clamp(0.0, width);
              final segWidth =
                  ((readiness.high - readiness.low) / 100 * width).clamp(
                4.0,
                width,
              );
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: tokens.muted,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Positioned(
                    left: left,
                    child: Container(
                      width: segWidth,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [tokens.primary, color],
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            l10n.learnerModelReadinessBasis,
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
        ],
      ),
    );
  }
}
