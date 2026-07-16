import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';

/// Slim live social-proof strip above the directory tabs — mirrors web
/// `BuddyCountStrip` in `exam-schedule-page.tsx`.
class BuddyCountStrip extends StatelessWidget {
  const BuddyCountStrip({super.key, required this.buddies});

  final List<ExamBuddy> buddies;

  @override
  Widget build(BuildContext context) {
    if (buddies.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final upcoming = buddies.where((b) => b.daysUntil >= 0).length;
    final past = buddies.length - upcoming;
    final soon = buddies
        .where((b) => b.daysUntil >= 0 && b.daysUntil <= 30)
        .length;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: [
            Text(
              l10n.scheduleBuddyCountFire(upcoming),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: tokens.primary,
              ),
            ),
            if (soon > 0)
              Text(
                l10n.scheduleBuddyCountSoon(soon),
                style: TextStyle(
                  fontSize: 12.5,
                  color: tokens.primary.withValues(alpha: 0.9),
                ),
              ),
            if (past > 0)
              Text(
                l10n.scheduleBuddyCountPast(past),
                style: TextStyle(
                  fontSize: 12.5,
                  color: tokens.primary.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
