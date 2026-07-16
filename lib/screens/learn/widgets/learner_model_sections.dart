/// Section-level widgets for `/learner-model`, split out of
/// `learner_model_screen.dart` for the <200 LOC file guideline: stat tiles,
/// coverage level bars, grammar-weakness rows, the can-do section wrapper,
/// and weak-word rows. Mirrors web `learner-model-page.tsx` sub-components.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/learn/learn_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';
import 'can_do_card.dart';

class LearnerModelStatTile extends StatelessWidget {
  const LearnerModelStatTile({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: tokens.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color ?? tokens.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class LearnerModelSectionCard extends StatelessWidget {
  const LearnerModelSectionCard({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class LearnerModelLevelBar extends StatelessWidget {
  const LearnerModelLevelBar({super.key, required this.coverage});
  final LevelCoverage coverage;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final pct = coverage.total > 0 ? coverage.mature / coverage.total : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(coverage.level, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${coverage.mature}/${coverage.total}',
                style: TextStyle(color: tokens.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              decoration: BoxDecoration(color: tokens.muted),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: pct.clamp(0.0, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [tokens.primary, tokens.brandDark],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => context.push('/vocabulary?level=${coverage.level}'),
            child: Text(
              l10n.learnerModelLevelPracticeCta(coverage.level),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class LearnerModelGrammarWeaknessRow extends StatelessWidget {
  const LearnerModelGrammarWeaknessRow({super.key, required this.weakness, required this.l10n});

  final GrammarWeaknessSummary weakness;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        weakness.nameVi,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: tokens.foreground),
                      ),
                    ),
                    if (weakness.level.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Chip(
                        label: Text(weakness.level, style: const TextStyle(fontSize: 10)),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ],
                ),
                Text(
                  l10n.learnerModelErrorCount(weakness.errorCount),
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/grammar?source=wrong_answer'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: tokens.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.canDoPracticeNow,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LearnerModelCanDoSection extends StatelessWidget {
  const LearnerModelCanDoSection({super.key, required this.map, required this.l10n});
  final CapabilityMap map;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.learnerModelCanDoSectionTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: tokens.foreground),
            ),
            Text(
              '${map.mastered}/${map.total}',
              style: TextStyle(fontWeight: FontWeight.bold, color: tokens.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (map.canDos.isEmpty)
          Text(
            l10n.learnerModelCanDoEmpty,
            style: TextStyle(color: tokens.mutedForeground),
          )
        else
          Column(
            children: map.canDos
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CanDoCard(canDo: c),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class LearnerModelWeakWordRow extends StatelessWidget {
  const LearnerModelWeakWordRow({super.key, required this.word});
  final LearnerWeakWord word;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard.card(
        onTap: () => context.push('/daily-review'),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          word.contentDe,
                          style: TextStyle(fontWeight: FontWeight.bold, color: tokens.foreground),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (word.level.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Chip(
                          label: Text(word.level, style: const TextStyle(fontSize: 10)),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ],
                  ),
                  Text(word.contentVi, style: TextStyle(color: tokens.mutedForeground)),
                ],
              ),
            ),
            if (word.lapses > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.learnerModelLapsesCount(word.lapses),
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: tokens.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.canDoPracticeNow,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
