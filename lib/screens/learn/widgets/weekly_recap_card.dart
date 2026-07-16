import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/learn/learn_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';

const _rungIcons = ['👂', '👁️', '✍️', '🗣️'];

/// "Tuần vừa qua" — recap of rungs the learner climbed this week + the
/// production streak. Mirrors web `WeeklyRecapCard` (part of
/// `LearnerCapabilitySection`). Data: [WeeklyRecap] (`GET
/// /user/learn/weekly-recap`), same provider the mission-complete overlay
/// reuses.
class WeeklyRecapCard extends StatelessWidget {
  const WeeklyRecapCard({super.key, required this.recap});

  final WeeklyRecap recap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return AppCard.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnerModelWeeklyRecapTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 8),
          if (recap.climbed.isEmpty)
            Text(
              l10n.learnerModelWeeklyRecapEmpty,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            )
          else
            for (final c in recap.climbed.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      c.kind == 'structure' ? '🧩' : '🃏',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        c.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: tokens.foreground,
                        ),
                      ),
                    ),
                    Text(
                      '${_rungIcons[c.fromRung.clamp(0, 3)]} → '
                      '${_rungIcons[c.toRung.clamp(0, 3)]}',
                      style: TextStyle(
                        fontSize: 11,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
          if (recap.productionStreak > 0) ...[
            const SizedBox(height: 6),
            Text(
              l10n.learnerModelWeeklyRecapStreak(recap.productionStreak),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: tokens.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
