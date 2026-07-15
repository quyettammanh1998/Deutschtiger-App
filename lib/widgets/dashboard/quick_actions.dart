import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';

/// Quick action item model.
class QuickActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });
}

/// Quick actions grid widget - sync từ web.
class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onLearnTap,
    required this.onReviewTap,
    required this.onExamTap,
    this.onAiTap,
    this.showAi = true,
  });

  final VoidCallback onLearnTap;
  final VoidCallback onReviewTap;
  final VoidCallback onExamTap;
  final VoidCallback? onAiTap;
  final bool showAi;

  /// Default quick actions.
  static List<QuickActionItem> defaultActions({
    required AppLocalizations l10n,
    VoidCallback? onLearnTap,
    VoidCallback? onReviewTap,
    VoidCallback? onExamTap,
    VoidCallback? onAiTap,
    bool showAi = true,
  }) {
    return [
      QuickActionItem(
        title: l10n.learn,
        subtitle: l10n.todaySession,
        icon: Icons.menu_book_rounded,
        iconColor: DesignTokens.tigerOrange,
        bgColor: DesignTokens.orange100,
        onTap: onLearnTap ?? () {},
      ),
      QuickActionItem(
        title: l10n.dailyReview,
        subtitle: l10n.dueWords,
        icon: Icons.style_outlined,
        iconColor: DesignTokens.success,
        bgColor: DesignTokens.accent,
        onTap: onReviewTap ?? () {},
      ),
      QuickActionItem(
        title: l10n.exam,
        subtitle: l10n.examPractice,
        icon: Icons.assignment_outlined,
        iconColor: DesignTokens.info,
        bgColor: DesignTokens.muted,
        onTap: onExamTap ?? () {},
      ),
      if (showAi)
        QuickActionItem(
          title: l10n.ai,
          subtitle: l10n.aiChat,
          icon: Icons.auto_awesome_outlined,
          iconColor: DesignTokens.rose600,
          bgColor: DesignTokens.orange50,
          onTap: onAiTap ?? () {},
        ),
    ];
  }

  /// Second row actions.
  static List<QuickActionItem> secondRowActions({
    VoidCallback? onCommunityTap,
    VoidCallback? onLeaderboardTap,
    VoidCallback? onVideoTap,
    VoidCallback? onMoreTap,
  }) {
    return [
      QuickActionItem(
        title: 'Cộng đồng',
        subtitle: 'Thảo luận',
        icon: Icons.people_outline,
        iconColor: Colors.indigo,
        bgColor: Colors.indigo.withValues(alpha: 0.1),
        onTap: onCommunityTap ?? () {},
      ),
      QuickActionItem(
        title: 'Bảng xếp hạng',
        subtitle: 'So sánh',
        icon: Icons.leaderboard_outlined,
        iconColor: Colors.amber,
        bgColor: Colors.amber.withValues(alpha: 0.1),
        onTap: onLeaderboardTap ?? () {},
      ),
      QuickActionItem(
        title: 'Video',
        subtitle: 'Học qua phim',
        icon: Icons.play_circle_outline,
        iconColor: Colors.red,
        bgColor: Colors.red.withValues(alpha: 0.1),
        onTap: onVideoTap ?? () {},
      ),
      QuickActionItem(
        title: 'Xem thêm',
        subtitle: 'Nhiều hơn',
        icon: Icons.more_horiz,
        iconColor: Colors.teal,
        bgColor: Colors.teal.withValues(alpha: 0.1),
        onTap: onMoreTap ?? () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actions = defaultActions(
      l10n: l10n,
      onLearnTap: onLearnTap,
      onReviewTap: onReviewTap,
      onExamTap: onExamTap,
      onAiTap: onAiTap,
      showAi: showAi,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DesignTokens.orange50, DesignTokens.orange100],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              final itemWidth = (constraints.maxWidth - spacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final action in actions)
                    SizedBox(
                      width: itemWidth,
                      child: _QuickActionButton(item: action),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.item});

  final QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${item.title}: ${item.subtitle}',
      onTap: item.onTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: item.iconColor.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 24),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: DesignTokens.foreground,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 9,
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
