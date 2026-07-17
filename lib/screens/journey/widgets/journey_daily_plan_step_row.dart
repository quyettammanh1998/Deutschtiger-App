import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/daily_path/domain/daily_path.dart';
import '../../../features/daily_path/domain/skill_emoji.dart';
import '../../../features/daily_path/presentation/daily_path_route_resolver.dart';
import '../../../l10n/app_localizations.dart';

/// Single row inside [JourneyDailyPlanSection]'s vertical stepper — a status
/// dot + rail connector on the left, and a tappable step card on the right.
/// Mirrors web `daily-path-stepper.tsx` `<li>` markup: done ✓ / premium 🔒 /
/// current gradient dot / upcoming muted dot, followed by title, short
/// description and a "Bắt đầu →"-style CTA badge.
class JourneyPlanStepRow extends StatelessWidget {
  const JourneyPlanStepRow({
    super.key,
    required this.step,
    required this.isCurrent,
    required this.isLast,
  });

  final DailyPathStep step;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : DesignTokens.spacingSm),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusRail(step: step, isCurrent: isCurrent, isLast: isLast),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: _StepBody(step: step, isCurrent: isCurrent, l10n: l10n),
            ),
          ],
        ),
      ),
    );
  }
}

/// Status dot (done/premium/current/upcoming) + vertical connector line.
class _StatusRail extends StatelessWidget {
  const _StatusRail({
    required this.step,
    required this.isCurrent,
    required this.isLast,
  });

  final DailyPathStep step;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isGradientDot = !step.done && !step.premium && isCurrent;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: step.done
                ? DesignTokens.emerald100
                : step.premium
                ? DesignTokens.amber100
                : isGradientDot
                ? null
                : tokens.muted,
            gradient: isGradientDot
                ? const LinearGradient(
                    colors: [DesignTokens.orange500, DesignTokens.orange600],
                  )
                : null,
          ),
          child: step.done
              ? const Icon(Icons.check, size: 18, color: DesignTokens.emerald600)
              : step.premium
              ? const Text('🔒', style: TextStyle(fontSize: 14))
              : Text(
                  skillEmoji(step.skill),
                  style: TextStyle(
                    fontSize: 14,
                    color: isCurrent ? Colors.white : tokens.mutedForeground,
                  ),
                ),
        ),
        if (!isLast)
          Expanded(child: Container(width: 1, color: tokens.border)),
      ],
    );
  }
}

/// Tappable step card: title (+strikethrough when done), description with
/// estimated minutes, and a trailing CTA badge. Tapping routes through
/// [resolveDailyPathRoute], which already special-cases the vocab step to
/// deep-link into the mission session (matches web's `openStep`).
class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.step,
    required this.isCurrent,
    required this.l10n,
  });

  final DailyPathStep step;
  final bool isCurrent;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
        onTap: () => context.push(resolveDailyPathRoute(step)),
        child: Ink(
          padding: const EdgeInsets.all(DesignTokens.spacingSm + 4),
          decoration: BoxDecoration(
            color: isCurrent ? DesignTokens.orange50 : Colors.transparent,
            border: isCurrent
                ? Border.all(color: DesignTokens.orange100)
                : null,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      step.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: step.done
                            ? tokens.mutedForeground
                            : tokens.foreground,
                        decoration: step.done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingXs),
                  _CtaBadge(step: step, isCurrent: isCurrent, l10n: l10n),
                ],
              ),
              if (!step.done) ...[
                const SizedBox(height: 2),
                Text(
                  step.estimatedMinutes > 0
                      ? '${step.description} · ~${step.estimatedMinutes}p'
                      : step.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Trailing badge: "Đã xong" (done), "Nâng cấp →" (premium, amber gradient)
/// or "Bắt đầu →" (orange gradient when current, muted chip otherwise).
class _CtaBadge extends StatelessWidget {
  const _CtaBadge({
    required this.step,
    required this.isCurrent,
    required this.l10n,
  });

  final DailyPathStep step;
  final bool isCurrent;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (step.done) {
      return Text(
        l10n.done,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: DesignTokens.emerald600,
        ),
      );
    }
    if (step.premium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: DesignTokens.amber700,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Text(
          '${l10n.premium} →',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: isCurrent
            ? const LinearGradient(
                colors: [DesignTokens.orange500, DesignTokens.orange600],
              )
            : null,
        color: isCurrent ? null : tokens.muted,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Text(
        '${l10n.start} →',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isCurrent ? Colors.white : tokens.foreground,
        ),
      ),
    );
  }
}
