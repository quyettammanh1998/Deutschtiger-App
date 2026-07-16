import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/learn/learn_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/learn/learn_provider.dart';
import '../../../widgets/common/app_card.dart';

/// "Hành trình A1→C2" — horizontal per-CEFR-level progress strip. Mirrors
/// web `level-journey-strip.tsx` (mobile): 6 level tiles with per-level tone
/// colors + an orange mini progress bar (`mature/total`). Data source:
/// [learnerModelProvider]'s `coverage_by_level` (already fetched for
/// `/learner-model` — reused here, autoDispose keeps the extra call cheap).
class JourneyLevelJourneyStrip extends ConsumerWidget {
  const JourneyLevelJourneyStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelAsync = ref.watch(learnerModelProvider);
    return modelAsync.maybeWhen(
      data: (model) => model.coverageByLevel.isEmpty
          ? const SizedBox.shrink()
          : _Strip(levels: model.coverageByLevel),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

const _levelTones = <String, Color>{
  'A1': Color(0xFF059669), // emerald-600
  'A2': Color(0xFF0284C7), // sky-600
  'B1': Color(0xFF7C3AED), // violet-600
  'B2': Color(0xFFD97706), // amber-600
  'C1': Color(0xFFE11D48), // rose-600
  'C2': Color(0xFF64748B), // slate-500
};

class _Strip extends StatelessWidget {
  const _Strip({required this.levels});

  final List<LevelCoverage> levels;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppCard.card(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.levelJourneyTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/learner-model'),
                  child: Text(
                    l10n.levelJourneyDetailCta,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: tokens.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 74,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: levels.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) => _LevelTile(coverage: levels[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({required this.coverage});

  final LevelCoverage coverage;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final tone = _levelTones[coverage.level] ?? tokens.mutedForeground;
    final pct = coverage.total > 0 ? coverage.mature / coverage.total : 0.0;
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            coverage.level,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: tone,
            ),
          ),
          const SizedBox(height: 6),
          if (coverage.total == 0)
            Text(
              l10n.levelJourneyEmptyLevel,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: 9, color: tokens.mutedForeground),
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: pct.clamp(0.0, 1.0),
                minHeight: 5,
                backgroundColor: tokens.muted,
                valueColor: AlwaysStoppedAnimation(tokens.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${coverage.mature}/${coverage.total}',
              style: TextStyle(fontSize: 9, color: tokens.mutedForeground),
            ),
          ],
        ],
      ),
    );
  }
}
