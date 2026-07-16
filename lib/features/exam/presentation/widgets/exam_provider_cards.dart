import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/settings/learning_preferences_provider.dart';

/// Mirrors web `exam-landing-page.tsx` mobile view: a highlighted
/// "Tìm bạn ôn thi" CTA followed by one card per certificate provider
/// (telc / Goethe / ÖSD), each listing its CEFR levels as tappable pills.
/// A pill tap calls [onLevelSelected] — `ExamScreen` pushes the
/// `/exam/:provider-:level` section route (with a level-mismatch confirm
/// dialog first, matching web).
class ExamProviderCards extends ConsumerWidget {
  const ExamProviderCards({super.key, required this.onLevelSelected});

  /// Web navigates a pill tap straight to `/exams/:provider-:level` (section
  /// page) — see `ExamScreen` which now pushes that route (with a
  /// level-mismatch confirm dialog first) instead of filtering in place.
  final void Function(String provider, String level) onLevelSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userLevel =
        (ref.watch(learningPreferencesProvider).preferences?.cefrLevel ??
                'A1')
            .toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BuddyFinderCta(
          label: l10n.examScheduleTitle,
          subtitle: l10n.examBuddyCtaSubtitle,
          newBadge: l10n.statsMasteryNew,
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        for (final provider in _providers) ...[
          _ProviderCard(
            meta: provider,
            userLevel: userLevel,
            recommendedLabel: l10n.examRecommendedLabel,
            onLevelSelected: onLevelSelected,
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],
      ],
    );
  }
}

class _BuddyFinderCta extends StatelessWidget {
  const _BuddyFinderCta({
    required this.label,
    required this.subtitle,
    required this.newBadge,
  });

  final String label;
  final String subtitle;
  final String newBadge;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      onTap: () => context.push('/exam/schedule'),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.cardPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [
                    Color(0x4D431407), // orange-950/30
                    Color(0x33451A03), // amber-950/20
                  ]
                : const [
                    Color(0xFFFFF7ED), // orange-50
                    Color(0xFFFFFBEB), // amber-50
                  ],
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          border: Border.all(
            color: isDark
                ? DesignTokens.orange500.withValues(alpha: 0.3)
                : const Color(0xB3FED7AA), // orange-200/70
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [DesignTokens.orange500, DesignTokens.orange600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
              ),
              child: const Icon(Icons.groups_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.tokens.foreground,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: DesignTokens.orange500.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          newBadge,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.orange600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xB3F97316), // orange-500/70
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderMeta {
  const _ProviderMeta({
    required this.id,
    required this.name,
    required this.shortDescKey,
    required this.wordmark,
    required this.brandBg,
    required this.accent,
    required this.pillBg,
    required this.pillBorder,
    required this.levels,
  });

  final String id;
  final String name;

  /// Picks the localized short-desc via [_shortDesc] (web `shortDesc`).
  final String shortDescKey;
  final String wordmark;
  final Color brandBg;
  final Color accent;
  final Color pillBg;
  final Color pillBorder;
  final List<String> levels;
}

String _shortDesc(AppLocalizations l10n, String key) => switch (key) {
  'telc' => l10n.examShortDescTelc,
  'goethe' => l10n.examShortDescGoethe,
  _ => l10n.examShortDescOsd,
};

const _levelEmoji = {'A1': '🌱', 'A2': '🌿', 'B1': '🌳', 'B2': '🏔️', 'C1': '🏆'};

// Standard CEFR tier names reused from the goal-setting l10n namespace —
// web shows custom short labels per level; these convey the same
// progression meaning without introducing new strings.
const _cefrOrder = {'A1': 0, 'A2': 1, 'B1': 2, 'B2': 3, 'C1': 4};

final _providers = [
  _ProviderMeta(
    id: 'telc',
    name: 'telc Deutsch',
    shortDescKey: 'telc',
    wordmark: 'telc',
    brandBg: const Color(0xFF0A6CB6),
    accent: DesignTokens.examActive, // blue-600, matches web accentLight
    pillBg: DesignTokens.examActiveSoft, // blue-50
    pillBorder: const Color(0xB3BFDBFE), // blue-200/70
    levels: const ['B1', 'B2'],
  ),
  _ProviderMeta(
    id: 'goethe',
    name: 'Goethe-Zertifikat',
    shortDescKey: 'goethe',
    wordmark: 'Goethe',
    brandBg: const Color(0xFF0A8A3C),
    accent: DesignTokens.emerald600,
    pillBg: DesignTokens.emerald50,
    pillBorder: const Color(0xB3A7F3D0), // emerald-200/70
    levels: const ['A1', 'A2', 'B1', 'B2', 'C1'],
  ),
  _ProviderMeta(
    id: 'osd',
    name: 'ÖSD Zertifikat',
    shortDescKey: 'osd',
    wordmark: 'ÖSD',
    brandBg: const Color(0xFFC8102E),
    accent: DesignTokens.examDanger, // red-600
    pillBg: DesignTokens.examDangerSoft, // red-50
    pillBorder: const Color(0xB3FECACA), // red-200/70
    levels: const ['B2'],
  ),
];

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.meta,
    required this.userLevel,
    required this.recommendedLabel,
    required this.onLevelSelected,
  });

  final _ProviderMeta meta;
  final String userLevel;
  final String recommendedLabel;
  final void Function(String provider, String level) onLevelSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: tokens.border),
        boxShadow: DesignTokens.shadowSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: meta.brandBg,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Text(
                    meta.wordmark,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meta.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: meta.accent,
                        ),
                      ),
                      Text(
                        _shortDesc(l10n, meta.shortDescKey),
                        style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            _LevelGrid(
              meta: meta,
              userLevel: userLevel,
              recommendedLabel: recommendedLabel,
              onLevelSelected: onLevelSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelGrid extends StatelessWidget {
  const _LevelGrid({
    required this.meta,
    required this.userLevel,
    required this.recommendedLabel,
    required this.onLevelSelected,
  });

  final _ProviderMeta meta;
  final String userLevel;
  final String recommendedLabel;
  final void Function(String provider, String level) onLevelSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: DesignTokens.spacingSm,
      crossAxisSpacing: DesignTokens.spacingSm,
      childAspectRatio: 2.6,
      children: [
        for (final level in meta.levels)
          _LevelPill(
            level: level,
            label: _tierLabel(l10n, level),
            recommendedLabel: recommendedLabel,
            emoji: _levelEmoji[level] ?? '📘',
            meta: meta,
            recommended: level == userLevel,
            onTap: () => onLevelSelected(meta.id, level),
          ),
      ],
    );
  }

  static String _tierLabel(AppLocalizations l10n, String level) {
    switch (_cefrOrder[level]) {
      case 0:
        return l10n.cefrBeginner;
      case 1:
        return l10n.cefrPreIntermediate;
      case 2:
        return l10n.cefrIntermediate;
      case 3:
        return l10n.cefrUpperIntermediate;
      case 4:
      default:
        return l10n.cefrAdvanced;
    }
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({
    required this.level,
    required this.label,
    required this.recommendedLabel,
    required this.emoji,
    required this.meta,
    required this.recommended,
    required this.onTap,
  });

  final String level;
  final String label;
  final String recommendedLabel;
  final String emoji;
  final _ProviderMeta meta;
  final bool recommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: meta.pillBg,
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
            border: Border.all(
              color: recommended ? DesignTokens.orange500 : meta.pillBorder,
              width: recommended ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: meta.accent,
                      ),
                    ),
                    Text(
                      recommended ? recommendedLabel : label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: recommended ? FontWeight.w600 : FontWeight.normal,
                        color: recommended
                            ? DesignTokens.orange600
                            : context.tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
