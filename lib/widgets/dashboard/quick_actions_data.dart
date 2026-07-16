import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../core/release/release_feature_flags.dart';
import '../../l10n/app_localizations.dart';

/// One "Khám phá" catalog tile — mirrors a web `QuickActionItem` entry from
/// `quick-actions-data.tsx`. `route` is null for web items with no Flutter
/// screen yet (Khóa học / Phỏng vấn) — those are simply omitted from
/// [buildExploreGroups] rather than fabricated.
class QuickActionCatalogItem {
  const QuickActionCatalogItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.route,
    this.releaseFlag,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String route;

  /// When false, the item is hidden — same gating pattern as
  /// `MoreFeaturesSheet` / `PinnedShortcuts`.
  final bool Function()? releaseFlag;

  bool get isVisible => releaseFlag?.call() ?? true;
}

/// A tab of the "Khám phá" catalog — a label pill + its tiles.
class QuickActionGroup {
  const QuickActionGroup({
    required this.key,
    required this.label,
    required this.items,
    this.lead = false,
  });

  final String key;
  final String label;
  final List<QuickActionCatalogItem> items;

  /// Highlighted tab (orange gradient) — matches web `EXPLORE_GROUPS[0].lead`.
  final bool lead;
}

/// Builds the explore catalog, grouped by intent — mirrors web
/// `EXPLORE_GROUPS` (`quick-actions-data.tsx`). `Khóa học` and `Phỏng vấn`
/// from the web registry are omitted: Flutter has no `/course` or
/// `/course/interview` screens yet (see plans/reports parity notes) — no
/// route means no tile, rather than a dead-end link.
List<QuickActionGroup> buildExploreGroups(
  AppLocalizations l10n,
  int totalWords,
) {
  final exam = QuickActionCatalogItem(
    title: l10n.qaExamTitle,
    subtitle: l10n.qaExamSubtitle,
    icon: Icons.school_rounded,
    iconColor: DesignTokens.orange500,
    bgColor: DesignTokens.orange50,
    route: '/exam',
  );
  final vocab = QuickActionCatalogItem(
    title: l10n.qaVocabTitle,
    subtitle: l10n.qaVocabSubtitle(totalWords),
    icon: Icons.translate_rounded,
    iconColor: const Color(0xFF0EA5E9), // sky-500
    bgColor: const Color(0xFFE0F2FE), // sky-50
    route: '/vocabulary',
  );
  final notes = QuickActionCatalogItem(
    title: l10n.qaNotesTitle,
    subtitle: l10n.qaNotesSubtitle,
    icon: Icons.bookmark_outline_rounded,
    iconColor: const Color(0xFF8B5CF6), // violet-500
    bgColor: const Color(0xFFF5F3FF), // violet-50
    route: '/my-words',
  );
  final review = QuickActionCatalogItem(
    title: l10n.qaReviewTitle,
    subtitle: l10n.qaReviewSubtitle,
    icon: Icons.autorenew_rounded,
    iconColor: DesignTokens.emerald600,
    bgColor: DesignTokens.emerald50,
    route: '/daily-review',
  );
  final youtube = QuickActionCatalogItem(
    title: l10n.qaYoutubeTitle,
    subtitle: l10n.qaYoutubeSubtitle,
    icon: Icons.smart_display_rounded,
    iconColor: const Color(0xFFEF4444), // red-500
    bgColor: const Color(0xFFFEF2F2), // red-50
    route: '/listening/youtube',
    releaseFlag: () => ReleaseFeatureFlags.listening,
  );
  final listen = QuickActionCatalogItem(
    title: l10n.qaListenTitle,
    subtitle: l10n.qaListenSubtitle,
    icon: Icons.volume_up_rounded,
    iconColor: const Color(0xFFA855F7), // purple-500
    bgColor: const Color(0xFFFAF5FF), // purple-50
    route: '/listening',
    releaseFlag: () => ReleaseFeatureFlags.listening,
  );
  final news = QuickActionCatalogItem(
    title: l10n.qaNewsTitle,
    subtitle: l10n.qaNewsSubtitle,
    icon: Icons.article_rounded,
    iconColor: DesignTokens.orange500,
    bgColor: DesignTokens.orange50,
    route: '/news',
    releaseFlag: () => ReleaseFeatureFlags.news,
  );
  final sentenceAi = QuickActionCatalogItem(
    title: l10n.qaSentenceAiTitle,
    subtitle: l10n.qaSentenceAiSubtitle,
    icon: Icons.edit_rounded,
    iconColor: const Color(0xFF22C55E), // green-500
    bgColor: const Color(0xFFF0FDF4), // green-50
    route: '/games/sentence-builder',
    releaseFlag: () => ReleaseFeatureFlags.sentenceBuilder,
  );
  final aiTutor = QuickActionCatalogItem(
    title: l10n.qaAiTutorTitle,
    subtitle: l10n.qaAiTutorSubtitle,
    icon: Icons.auto_awesome_rounded,
    iconColor: const Color(0xFF14B8A6), // teal-500
    bgColor: const Color(0xFFF0FDFA), // teal-50
    route: '/ai-tutor/chat',
    releaseFlag: () => ReleaseFeatureFlags.aiTutor,
  );
  final games = QuickActionCatalogItem(
    title: l10n.qaGamesTitle,
    subtitle: l10n.qaGamesSubtitle,
    icon: Icons.sports_esports_rounded,
    iconColor: const Color(0xFFF59E0B), // amber-500
    bgColor: const Color(0xFFFFFBEB), // amber-50
    route: '/games',
    releaseFlag: () => ReleaseFeatureFlags.games,
  );
  final affiliate = QuickActionCatalogItem(
    title: l10n.qaAffiliateTitle,
    subtitle: l10n.qaAffiliateSubtitle,
    icon: Icons.card_giftcard_rounded,
    iconColor: DesignTokens.emerald600,
    bgColor: DesignTokens.emerald50,
    route: '/affiliate',
    releaseFlag: () => ReleaseFeatureFlags.affiliate,
  );

  final groups = [
    QuickActionGroup(
      key: 'thi',
      label: l10n.qaTabExam,
      lead: true,
      items: [exam],
    ),
    QuickActionGroup(
      key: 'vocab',
      label: l10n.qaTabVocab,
      items: [vocab, notes, review],
    ),
    QuickActionGroup(
      key: 'listen',
      label: l10n.qaTabListen,
      items: [youtube, listen, news],
    ),
    QuickActionGroup(
      key: 'ai',
      label: l10n.qaTabAi,
      items: [sentenceAi, aiTutor],
    ),
    QuickActionGroup(
      key: 'other',
      label: l10n.qaTabOther,
      items: [games, affiliate],
    ),
  ];

  // Drop gated items per group, then drop groups left empty.
  return groups
      .map(
        (g) => QuickActionGroup(
          key: g.key,
          label: g.label,
          lead: g.lead,
          items: g.items
              .where((item) => item.isVisible)
              .toList(growable: false),
        ),
      )
      .where((g) => g.items.isNotEmpty)
      .toList(growable: false);
}
