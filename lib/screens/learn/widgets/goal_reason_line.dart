import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';

/// "Vì bạn thi..." one-liner shown under a page subtitle — mirrors web
/// `goal-reason-line.tsx`: prefixes the user's exam goal (level + days
/// remaining) before an optional page-provided [suffix]. Degrades to a
/// "set a goal" prompt when the goal is still the default (never set).
class GoalReasonLine extends ConsumerWidget {
  const GoalReasonLine({super.key, this.suffix});

  final String? suffix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(learnGoalProvider);
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return goalAsync.maybeWhen(
      data: (goal) {
        if (goal.isDefault) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: GestureDetector(
              onTap: () => context.push('/home'),
              child: Text(
                l10n.focusSessionGoalDefaultCta,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tokens.primary,
                ),
              ),
            ),
          );
        }
        final days = goal.targetDate?.difference(DateTime.now()).inDays;
        final prefix = (days != null && days >= 0)
            ? l10n.focusSessionGoalWithDays(goal.targetLevel, days)
            : l10n.focusSessionGoalNoDays(goal.targetLevel);
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              children: [
                TextSpan(
                  text: prefix,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEA580C),
                  ),
                ),
                if (suffix != null) TextSpan(text: ' — $suffix'),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
