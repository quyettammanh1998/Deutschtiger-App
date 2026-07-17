import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/release/release_feature_flags.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/more_features_sheet.dart';

/// One pinned shortcut tile — mirrors web `PINNED_SHORTCUTS`
/// (`components/dashboard/quick-actions-data.tsx`).
class _Shortcut {
  const _Shortcut({
    required this.title,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.path,
    this.enabled = true,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String path;
  final bool enabled;
}

/// "🔗 Lối tắt" — 10 pinned shortcuts (2 rows x 5) surfaced directly on the
/// dashboard. "Xem tất cả" opens [MoreFeaturesSheet] with the rest of the
/// app. Gated destinations (behind a disabled [ReleaseFeatureFlags]) are
/// skipped rather than shown disabled, matching the more-features sheet
/// pattern already used elsewhere on Home.
class PinnedShortcuts extends StatelessWidget {
  const PinnedShortcuts({super.key});

  // Icon/color tiles mirror web `PINNED_SHORTCUTS` (quick-actions-data.tsx)
  // + `feature-icons.tsx`: -50 shade tile backgrounds (not -100), and the
  // Luyện thi/Khóa học glyphs corrected (they were swapped — mortarboard now
  // belongs to Luyện thi, open book to Khóa học).
  List<_Shortcut> _shortcuts(AppLocalizations l10n) => [
    _Shortcut(
      title: l10n.examPractice,
      icon: Icons.school_rounded,
      color: DesignTokens.tigerOrange,
      bgColor: DesignTokens.orange50,
      path: '/exam',
    ),
    _Shortcut(
      title: l10n.dailyReview,
      icon: Icons.autorenew_rounded,
      color: DesignTokens.emerald600,
      bgColor: DesignTokens.emerald50,
      path: '/daily-review',
    ),
    _Shortcut(
      title: l10n.vocabulary,
      icon: Icons.translate_rounded,
      color: const Color(0xFF0EA5E9),
      bgColor: const Color(0xFFF0F9FF),
      path: '/vocabulary',
    ),
    _Shortcut(
      title: l10n.myWords,
      icon: Icons.bookmark_rounded,
      color: const Color(0xFF8B5CF6),
      bgColor: const Color(0xFFF5F3FF),
      path: '/my-words',
    ),
    _Shortcut(
      title: l10n.pinnedShortcutConversation,
      icon: Icons.chat_bubble_outline_rounded,
      color: const Color(0xFF14B8A6),
      bgColor: const Color(0xFFF0FDFA),
      path: '/speaking/conversation-hub',
      enabled: ReleaseFeatureFlags.aiTutor,
    ),
    _Shortcut(
      title: l10n.pinnedShortcutWriteSentence,
      icon: Icons.edit_rounded,
      color: const Color(0xFF22C55E),
      bgColor: const Color(0xFFF0FDF4),
      path: '/games/sentence-builder',
      enabled: ReleaseFeatureFlags.sentenceBuilder,
    ),
    _Shortcut(
      title: l10n.pinnedShortcutListening,
      icon: Icons.volume_up_rounded,
      color: const Color(0xFFA855F7),
      bgColor: const Color(0xFFFAF5FF),
      path: '/listening',
      enabled: ReleaseFeatureFlags.listening,
    ),
    _Shortcut(
      title: l10n.pinnedShortcutYoutube,
      icon: Icons.smart_display_rounded,
      color: const Color(0xFFEF4444),
      bgColor: const Color(0xFFFEF2F2),
      path: '/listening/youtube',
      enabled: ReleaseFeatureFlags.listening,
    ),
    _Shortcut(
      title: l10n.gamePractice,
      icon: Icons.sports_esports_rounded,
      color: const Color(0xFFF59E0B),
      bgColor: const Color(0xFFFFFBEB),
      path: '/games',
      enabled: ReleaseFeatureFlags.games,
    ),
    _Shortcut(
      title: l10n.pinnedShortcutCourse,
      icon: Icons.menu_book_rounded,
      color: const Color(0xFF6366F1),
      bgColor: const Color(0xFFEEF2FF),
      path: '/journey/courses',
      enabled: ReleaseFeatureFlags.journey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final items = _shortcuts(
      l10n,
    ).where((item) => item.enabled).toList(growable: false);
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
      ),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.cardPadding),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.pinnedShortcutsTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => MoreFeaturesSheet.show(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    '${l10n.seeAll} →',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.orange600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: DesignTokens.spacingSm,
                crossAxisSpacing: DesignTokens.spacingXs,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => _ShortcutTile(item: items[index]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({required this.item});

  final _Shortcut item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: item.title,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => context.push(item.path),
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: context.tokens.foreground,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
