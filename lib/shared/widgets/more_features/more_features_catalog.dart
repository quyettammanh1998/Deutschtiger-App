import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/icons/app_icons.dart';
import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/release/release_feature_flags.dart';
import '../../../l10n/app_localizations.dart';

/// Pastel tile background (light `*-100`, dark `*-500 @ 20%`) + icon
/// foreground — ported straight from the web more-sheet's `IC` map colors
/// (`more-features-sheet.tsx`). Bespoke per item like the bottom-nav accents
/// (not semantic [AppTokens]), so pinned here rather than added there.
class TileColor {
  const TileColor({
    required this.light100,
    required this.dark20,
    required this.fg,
  });

  final Color light100;
  final Color dark20;
  final Color fg;

  Color bg(bool isDark) => isDark ? dark20 : light100;
}

/// One tile in the "Tất cả tính năng" grid.
class MoreFeatureItem {
  const MoreFeatureItem({
    required this.label,
    required this.iconBuilder,
    required this.color,
    this.path,
    this.action,
    this.enabled = true,
  }) : assert(
         path == null || action == null,
         'An item navigates OR runs an action, not both.',
       );

  final String label;
  final Widget Function({double size, Color? color}) iconBuilder;
  final TileColor color;

  /// Navigation target. Null when [action] is set, or when the destination
  /// isn't built yet (see [enabled]).
  final String? path;

  /// Action item (e.g. open feedback) instead of navigating.
  final VoidCallback? action;

  /// False for two reasons: (a) a release flag currently hides the
  /// destination, or (b) the destination screen doesn't exist in the
  /// Flutter app yet (a later phase builds it) — matches web's catalog
  /// item-for-item per this phase's spec instead of silently dropping the
  /// tile. Disabled tiles render dimmed and non-interactive rather than
  /// routing to a dead path.
  final bool enabled;
}

class MoreFeatureGroup {
  const MoreFeatureGroup({required this.emoji, required this.label, required this.items});

  final String emoji;
  final String label;
  final List<MoreFeatureItem> items;
}

/// Builds the 4 web groups + the app-only AI exception tile.
///
/// [onFeedback] is invoked (after the dialog is closed) for the "Góp ý"
/// action item — the caller wires it to whatever feedback entry point the
/// app currently uses (`FeedbackSheet`).
List<MoreFeatureGroup> moreFeatureGroups(
  AppLocalizations l10n, {
  required VoidCallback onFeedback,
}) {
  return [
    MoreFeatureGroup(
      emoji: '🎬',
      label: l10n.groupExtraPractice,
      items: [
        MoreFeatureItem(
          label: l10n.featureYoutube,
          iconBuilder: AppIcons.youtube,
          color: const TileColor(
            light100: Color(0xFFFEE2E2),
            dark20: Color(0x33EF4444),
            fg: Color(0xFFEF4444),
          ),
          path: '/listening/youtube',
          enabled: ReleaseFeatureFlags.listening,
        ),
        MoreFeatureItem(
          label: l10n.featureReadListen,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(PhosphorIcons.bookOpen, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFCCFBF1),
            dark20: Color(0x3314B8A6),
            fg: Color(0xFF0D9488),
          ),
          // No combined "Đọc & Nghe" hub screen in Flutter yet — reading and
          // listening are separate top-level routes here.
          enabled: false,
        ),
        MoreFeatureItem(
          label: l10n.featureListening,
          iconBuilder: AppIcons.listening,
          color: const TileColor(
            light100: Color(0xFFF3E8FF),
            dark20: Color(0x33A855F7),
            fg: Color(0xFFA855F7),
          ),
          path: '/listening',
          enabled: ReleaseFeatureFlags.listening,
        ),
        MoreFeatureItem(
          label: l10n.featureReadingFeed,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(PhosphorIcons.bookOpen, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFCCFBF1),
            dark20: Color(0x3314B8A6),
            fg: Color(0xFF0D9488),
          ),
          path: '/reading/feed',
          enabled: ReleaseFeatureFlags.reading,
        ),
        MoreFeatureItem(
          label: l10n.featureNews,
          iconBuilder: AppIcons.news,
          color: const TileColor(
            light100: Color(0xFFFFEDD5),
            dark20: Color(0x33F97316),
            fg: Color(0xFFF97316),
          ),
          path: '/news',
          enabled: ReleaseFeatureFlags.news,
        ),
        MoreFeatureItem(
          label: l10n.featureSubtitleWords,
          iconBuilder: AppIcons.youtube,
          color: const TileColor(
            light100: Color(0xFFFEE2E2),
            dark20: Color(0x33EF4444),
            fg: Color(0xFFEF4444),
          ),
          path: '/subtitle-words',
          enabled: ReleaseFeatureFlags.practice,
        ),
        MoreFeatureItem(
          label: l10n.featureFocusSession,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(PhosphorIcons.target, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFFE4E6),
            dark20: Color(0x33F43F5E),
            fg: Color(0xFFF43F5E),
          ),
          path: '/focus-session',
        ),
      ],
    ),
    MoreFeatureGroup(
      emoji: '📗',
      label: l10n.groupGrammarSkills,
      items: [
        MoreFeatureItem(
          label: l10n.grammar,
          iconBuilder: AppIcons.course,
          color: const TileColor(
            light100: Color(0xFFE0E7FF),
            dark20: Color(0x336366F1),
            fg: Color(0xFF6366F1),
          ),
          path: '/grammar',
          enabled: ReleaseFeatureFlags.grammar,
        ),
        MoreFeatureItem(
          label: l10n.featureCasesHub,
          iconBuilder: ({double size = 24, Color? color}) => Icon(
            AppPhosphorIcons.squaresFour,
            size: size,
            color: color,
          ),
          color: const TileColor(
            light100: Color(0xFFCFFAFE),
            dark20: Color(0x3306B6D4),
            fg: Color(0xFF0891B2),
          ),
          path: '/games/cases',
          enabled: ReleaseFeatureFlags.casesMastery,
        ),
        MoreFeatureItem(
          label: l10n.verbConjugation,
          iconBuilder: ({double size = 24, Color? color}) => Icon(
            AppPhosphorIcons.arrowsClockwise,
            size: size,
            color: color,
          ),
          color: const TileColor(
            light100: Color(0xFFFAE8FF),
            dark20: Color(0x33D946EF),
            fg: Color(0xFFC026D3),
          ),
          path: '/games/konjugation',
          enabled: ReleaseFeatureFlags.konjugation,
        ),
        MoreFeatureItem(
          label: l10n.featureMinimalPairs,
          iconBuilder: AppIcons.listening,
          color: const TileColor(
            light100: Color(0xFFF3E8FF),
            dark20: Color(0x33A855F7),
            fg: Color(0xFFA855F7),
          ),
          // No dedicated minimal-pairs screen in Flutter yet.
          enabled: false,
        ),
        MoreFeatureItem(
          label: l10n.featureInterview,
          iconBuilder: AppIcons.interview,
          color: const TileColor(
            light100: Color(0xFFCFFAFE),
            dark20: Color(0x3306B6D4),
            fg: Color(0xFF0891B2),
          ),
          // InterviewRoadmapScreen exists but isn't routed anywhere yet.
          enabled: false,
        ),
      ],
    ),
    MoreFeatureGroup(
      emoji: '👥',
      label: l10n.groupCommunityProgress,
      items: [
        MoreFeatureItem(
          label: l10n.statistics,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.chartBar, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFCCFBF1),
            dark20: Color(0x3314B8A6),
            fg: Color(0xFF0D9488),
          ),
          path: '/stats',
          enabled: ReleaseFeatureFlags.stats,
        ),
        MoreFeatureItem(
          label: l10n.featureLeaderboardFull,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.trophy, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFEF3C7),
            dark20: Color(0x33F59E0B),
            fg: Color(0xFFF59E0B),
          ),
          path: '/leaderboard',
        ),
        MoreFeatureItem(
          label: l10n.featureLearnerModel,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.chartBar, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFCCFBF1),
            dark20: Color(0x3314B8A6),
            fg: Color(0xFF0D9488),
          ),
          path: '/learner-model',
        ),
        MoreFeatureItem(
          label: l10n.featureExamReadiness,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.flag, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFE0E7FF),
            dark20: Color(0x336366F1),
            fg: Color(0xFF4F46E5),
          ),
          path: '/exam/readiness',
        ),
        MoreFeatureItem(
          label: l10n.featureErrorPatterns,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.warning, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFEF3C7),
            dark20: Color(0x33F59E0B),
            fg: Color(0xFFF59E0B),
          ),
          path: '/stats/error-patterns',
          enabled: ReleaseFeatureFlags.stats,
        ),
        MoreFeatureItem(
          label: l10n.featureMessages,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.chatCircleDots, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFDBEAFE),
            dark20: Color(0x333B82F6),
            fg: Color(0xFF3B82F6),
          ),
          path: '/social/messages',
          enabled: ReleaseFeatureFlags.social,
        ),
        MoreFeatureItem(
          label: l10n.featureFriends,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.usersThree, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFCE7F3),
            dark20: Color(0x33EC4899),
            fg: Color(0xFFEC4899),
          ),
          path: '/social/friends',
          enabled: ReleaseFeatureFlags.social,
        ),
        MoreFeatureItem(
          label: l10n.featureExamSchedule,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(PhosphorIcons.calendarCheck, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFCE7F3),
            dark20: Color(0x33EC4899),
            fg: Color(0xFFEC4899),
          ),
          path: '/exam/schedule',
        ),
      ],
    ),
    MoreFeatureGroup(
      emoji: '⚙️',
      label: l10n.groupAccountOther,
      items: [
        MoreFeatureItem(
          label: l10n.featureDailyQuote,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(PhosphorIcons.quotes, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFEDE9FE),
            dark20: Color(0x338B5CF6),
            fg: Color(0xFF8B5CF6),
          ),
          path: '/stats/daily-quote',
        ),
        MoreFeatureItem(
          label: l10n.featureAffiliateIntro,
          iconBuilder: AppIcons.affiliate,
          color: const TileColor(
            light100: Color(0xFFD1FAE5),
            dark20: Color(0x3310B981),
            fg: Color(0xFF10B981),
          ),
          path: '/affiliate',
          enabled: ReleaseFeatureFlags.affiliate,
        ),
        MoreFeatureItem(
          label: l10n.featurePremiumUpgrade,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.crown, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFEF3C7),
            dark20: Color(0x33F59E0B),
            fg: Color(0xFFF59E0B),
          ),
          path: '/settings/premium',
          enabled: ReleaseFeatureFlags.premium,
        ),
        MoreFeatureItem(
          label: l10n.settings,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.gearSix, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFF1F5F9),
            dark20: Color(0x3364748B),
            fg: Color(0xFF64748B),
          ),
          path: '/settings',
        ),
        if (ReleaseFeatureFlags.aiTutor)
          MoreFeatureItem(
            label: l10n.writingPractice,
            iconBuilder: AppIcons.sentenceBuilder,
            color: const TileColor(
              light100: Color(0xFFCCFBF1),
              dark20: Color(0x3314B8A6),
              fg: Color(0xFF059669),
            ),
            path: '/ai-tutor/writing',
          ),
        MoreFeatureItem(
          label: l10n.featureAdmin,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.chartBar, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFFE4E6),
            dark20: Color(0x33F43F5E),
            fg: Color(0xFF0D9488),
          ),
          // No admin console in the Flutter app yet.
          enabled: false,
        ),
        MoreFeatureItem(
          label: l10n.featureFeedback,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(AppPhosphorIcons.chatText, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFFFEDD5),
            dark20: Color(0x33F97316),
            fg: Color(0xFFF97316),
          ),
          action: onFeedback,
        ),
        // APP-ONLY EXCEPTION (approved deviation, see phase-01 §7 req 3): the
        // web sheet has no AI tile — AI lives in the bottom nav there. The
        // Flutter app instead moves AI *into* this sheet once tab 4 becomes
        // "Hội thoại" (see `app_shell.dart`'s tab-4 release switch), so AI
        // stays reachable either way.
        MoreFeatureItem(
          label: l10n.featureAiAssistant,
          iconBuilder: ({double size = 24, Color? color}) =>
              Icon(Icons.smart_toy_rounded, size: size, color: color),
          color: const TileColor(
            light100: Color(0xFFDBEAFE),
            dark20: Color(0x333B82F6),
            fg: Color(0xFF2563EB),
          ),
          path: '/ai-tutor/chat',
          enabled: ReleaseFeatureFlags.aiTutor,
        ),
      ],
    ),
  ];
}
