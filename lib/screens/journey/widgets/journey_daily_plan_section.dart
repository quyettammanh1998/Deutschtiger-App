import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/daily_path/domain/daily_path.dart';
import '../../../features/daily_path/presentation/daily_path_provider.dart';
import '../../../features/daily_path/presentation/daily_path_route_resolver.dart';
import '../../../l10n/app_localizations.dart';
import 'journey_daily_plan_step_row.dart';

/// "Kế hoạch hôm nay" — the full-day step overview with a per-step CTA.
/// Mirrors web `daily-path-stepper.tsx` (mobile): a vertical rail of
/// status dots (done ✓ / premium 🔒 / current gradient / upcoming) each
/// followed by the step's title, description and a "Bắt đầu"-style badge.
/// Row rendering lives in `journey_daily_plan_step_row.dart`.
class JourneyDailyPlanSection extends ConsumerWidget {
  const JourneyDailyPlanSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pathAsync = ref.watch(dailyPathProvider);

    return pathAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.screenHorizontalPadding,
        ),
        child: LinearProgressIndicator(color: DesignTokens.orange500),
      ),
      // Path fetch failed — the header/session card already surface their
      // own retry affordances, so this section quietly collapses rather
      // than duplicating an error banner.
      error: (_, _) => const SizedBox.shrink(),
      data: (path) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.screenHorizontalPadding,
        ),
        child: path.steps.isEmpty
            ? _EmptyPlanCard(
                l10n: l10n,
                onTap: () => context.push(resolveDailyPathRoute(null)),
              )
            : _PlanCard(path: path),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.path});

  final DailyPath path;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyPathPlanSummary(path.doneCount, path.totalCount),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          if (path.isComplete)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              decoration: BoxDecoration(
                color: DesignTokens.emerald50,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
              ),
              child: Text(
                l10n.dailyPathCompleteCelebration,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: DesignTokens.emerald700,
                ),
              ),
            )
          else
            for (var i = 0; i < path.steps.length; i++)
              JourneyPlanStepRow(
                step: path.steps[i],
                isCurrent: path.steps[i].key == path.currentStep?.key,
                isLast: i == path.steps.length - 1,
              ),
        ],
      ),
    );
  }
}

class _EmptyPlanCard extends StatelessWidget {
  const _EmptyPlanCard({required this.l10n, required this.onTap});

  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyPathEmptyTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.dailyPathEmptyDescription,
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [DesignTokens.orange500, DesignTokens.orange600],
                  ),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.radiusSm + 4,
                  ),
                ),
                child: Text(
                  '${l10n.dailyPathEmptyCta} →',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
