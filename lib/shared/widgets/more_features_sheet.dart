import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../core/release/release_feature_flags.dart';
import '../../l10n/app_localizations.dart';

/// BottomSheet 4 nhóm tiện ích, mở từ tab "Thêm" của [AppShell].
///
/// Cấu trúc lấy cảm hứng từ `components/dashboard/more-features-sheet.tsx`
/// (web) — port sang Flutter dạng grid 4 cột thay vì list dọc.
///
/// Mỗi item gồm icon tròn + label. Tap → điều hướng bằng `GoRouter` rồi
/// tự đóng sheet.
class MoreFeaturesSheet extends StatelessWidget {
  const MoreFeaturesSheet({super.key, required this.onClose});

  final VoidCallback onClose;

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Tap ngoài / nút back → đóng nhờ barrierColor mặc định của Material.
      builder: (ctx) =>
          MoreFeaturesSheet(onClose: () => Navigator.of(ctx).pop()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final brightness = Theme.of(context).brightness;
    final sheetColor = brightness == Brightness.dark
        ? DesignTokens.darkCard
        : DesignTokens.card;
    final textColor = brightness == Brightness.dark
        ? DesignTokens.darkForeground
        : DesignTokens.foreground;
    final mutedColor = DesignTokens.mutedForeground;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(DesignTokens.radiusLg),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _Header(
                onClose: onClose,
                textColor: textColor,
                mutedColor: mutedColor,
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    DesignTokens.spacingMd,
                    DesignTokens.spacingSm,
                    DesignTokens.spacingMd,
                    DesignTokens.spacingXl,
                  ),
                  children: [
                    for (final group in _releaseFeatureGroups(l10n)) ...[
                      _GroupTitle(label: group.title, textColor: textColor),
                      const SizedBox(height: DesignTokens.spacingSm),
                      _FeatureGrid(
                        items: group.items,
                        onTap: (path) {
                          Navigator.of(context).pop();
                          context.push(path);
                        },
                      ),
                      const SizedBox(height: DesignTokens.spacingLg),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onClose,
    required this.textColor,
    required this.mutedColor,
  });

  final VoidCallback onClose;
  final Color textColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacingMd,
        DesignTokens.spacingSm,
        DesignTokens.spacingMd,
        0,
      ),
      child: Row(
        children: [
          Icon(Icons.grid_view_rounded, color: DesignTokens.tigerOrange),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              l10n.moreFeaturesTitle,
              style: DesignTokens.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, color: mutedColor),
            tooltip: l10n.close,
          ),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle({required this.label, required this.textColor});

  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingXs,
        vertical: DesignTokens.spacingXs,
      ),
      child: Text(
        label,
        style: DesignTokens.bodySmall.copyWith(
          color: textColor.withValues(alpha: 0.65),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.items, required this.onTap});

  final List<_FeatureItem> items;
  final void Function(String path) onTap;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final isLargeText = textScale >= 1.3;
    final crossAxisCount = isLargeText ? 2 : 3;
    final tileHeight = isLargeText ? 148.0 : 104.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth -
                (crossAxisCount - 1) * DesignTokens.spacingSm) /
            crossAxisCount;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: DesignTokens.spacingMd,
            crossAxisSpacing: DesignTokens.spacingSm,
            childAspectRatio: tileWidth / tileHeight,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _FeatureTile(item: item, onTap: () => onTap(item.path));
          },
        );
      },
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item, required this.onTap});

  final _FeatureItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final tileBg = isDark
        ? item.bgColor.withValues(alpha: 0.20)
        : item.bgColor.withValues(alpha: 0.18);
    final textColor = isDark
        ? DesignTokens.darkForeground
        : DesignTokens.foreground;

    return Semantics(
      button: true,
      label: item.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: tileBg,
                borderRadius: BorderRadius.circular(DesignTokens.radius),
              ),
              child: Icon(item.icon, color: item.fgColor, size: 26),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: DesignTokens.bodySmall.copyWith(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.label,
    required this.icon,
    required this.path,
    required this.fgColor,
    required this.bgColor,
  });

  final String label;
  final IconData icon;
  final String path;
  final Color fgColor;
  final Color bgColor;
}

class _FeatureGroup {
  const _FeatureGroup(this.title, this.items);
  final String title;
  final List<_FeatureItem> items;
}

List<_FeatureGroup> _featureGroups(AppLocalizations l10n) => [
  _FeatureGroup(l10n.groupVocabularyReview, [
    _FeatureItem(
      label: l10n.myWords,
      icon: Icons.bookmarks_rounded,
      path: '/my-words',
      fgColor: DesignTokens.tigerOrange,
      bgColor: DesignTokens.orange100,
    ),
    _FeatureItem(
      label: l10n.flashcardDecks,
      icon: Icons.style_rounded,
      path: '/decks',
      fgColor: Color(0xFF2563EB),
      bgColor: Color(0xFFDBEAFE),
    ),
    _FeatureItem(
      label: l10n.dailyReview,
      icon: Icons.event_repeat_rounded,
      path: '/daily-review',
      fgColor: Color(0xFF0D9488),
      bgColor: Color(0xFFCCFBF1),
    ),
    _FeatureItem(
      label: l10n.vocabularyLibrary,
      icon: Icons.menu_book_rounded,
      path: '/vocabulary',
      fgColor: Color(0xFF7C3AED),
      bgColor: Color(0xFFEDE9FE),
    ),
  ]),
  _FeatureGroup(l10n.groupExtraPractice, [
    _FeatureItem(
      label: l10n.listeningPractice,
      icon: Icons.headphones_rounded,
      path: '/listening',
      fgColor: DesignTokens.tigerOrange,
      bgColor: DesignTokens.orange100,
    ),
    _FeatureItem(
      label: l10n.newsReading,
      icon: Icons.newspaper_rounded,
      path: '/news',
      fgColor: Color(0xFF0D9488),
      bgColor: Color(0xFFCCFBF1),
    ),
    _FeatureItem(
      label: l10n.writingPractice,
      icon: Icons.edit_note_rounded,
      path: '/ai-tutor/writing',
      fgColor: Color(0xFF7C3AED),
      bgColor: Color(0xFFEDE9FE),
    ),
    _FeatureItem(
      label: l10n.aiChat,
      icon: Icons.smart_toy_rounded,
      path: '/ai-tutor/chat',
      fgColor: Color(0xFF2563EB),
      bgColor: Color(0xFFDBEAFE),
    ),
  ]),
  _FeatureGroup(l10n.groupGrammarSkills, [
    _FeatureItem(
      label: l10n.grammar,
      icon: Icons.menu_book_rounded,
      path: '/grammar',
      fgColor: Color(0xFF0EA5E9),
      bgColor: Color(0xFFE0F2FE),
    ),
    _FeatureItem(
      label: l10n.gamePractice,
      icon: Icons.sports_esports_rounded,
      path: '/games',
      fgColor: Color(0xFFF59E0B),
      bgColor: DesignTokens.orange100,
    ),
    _FeatureItem(
      label: l10n.examPractice,
      icon: Icons.assignment_rounded,
      path: '/exam',
      fgColor: DesignTokens.tigerOrange,
      bgColor: Color(0xFFFEF3C7),
    ),
  ]),
  _FeatureGroup(l10n.groupCommunityProgress, [
    _FeatureItem(
      label: l10n.community,
      icon: Icons.groups_rounded,
      path: '/social',
      fgColor: Color(0xFFEC4899),
      bgColor: Color(0xFFFCE7F3),
    ),
    _FeatureItem(
      label: l10n.statistics,
      icon: Icons.insights_rounded,
      path: '/stats',
      fgColor: Color(0xFF0D9488),
      bgColor: Color(0xFFCCFBF1),
    ),
    _FeatureItem(
      label: l10n.achievements,
      icon: Icons.emoji_events_rounded,
      path: '/achievements',
      fgColor: Color(0xFFEAB308),
      bgColor: Color(0xFFFEF9C3),
    ),
    _FeatureItem(
      label: l10n.leaderboard,
      icon: Icons.leaderboard_rounded,
      path: '/leaderboard',
      fgColor: Color(0xFF6366F1),
      bgColor: Color(0xFFE0E7FF),
    ),
  ]),
];

List<_FeatureGroup> _releaseFeatureGroups(AppLocalizations l10n) =>
    _featureGroups(l10n)
        .map(
          (group) => _FeatureGroup(
            group.title,
            group.items
                .where(
                  (item) => ReleaseFeatureFlags.allowsMoreFeature(item.path),
                )
                .toList(growable: false),
          ),
        )
        .where((group) => group.items.isNotEmpty)
        .toList(growable: false);
