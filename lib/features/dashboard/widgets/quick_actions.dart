import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

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
  const QuickActions({super.key, this.onMoreTap});

  final VoidCallback? onMoreTap;

  /// Default quick actions.
  static List<QuickActionItem> defaultActions({
    VoidCallback? onVocabTap,
    VoidCallback? onGrammarTap,
    VoidCallback? onFlashcardTap,
    VoidCallback? onQuizTap,
    VoidCallback? onPronunciationTap,
    VoidCallback? onMoreTap,
  }) {
    return [
      QuickActionItem(
        title: 'Từ vựng',
        subtitle: 'Học từ mới',
        icon: Icons.menu_book_rounded,
        iconColor: AppColors.tigerOrange,
        bgColor: AppColors.tigerOrange.withValues(alpha: 0.1),
        onTap: onVocabTap ?? () {},
      ),
      QuickActionItem(
        title: 'Ngữ pháp',
        subtitle: 'Quy tắc',
        icon: Icons.school_outlined,
        iconColor: Colors.purple,
        bgColor: Colors.purple.withValues(alpha: 0.1),
        onTap: onGrammarTap ?? () {},
      ),
      QuickActionItem(
        title: 'Flashcard',
        subtitle: 'Ôn tập',
        icon: Icons.style_outlined,
        iconColor: Colors.teal,
        bgColor: Colors.teal.withValues(alpha: 0.1),
        onTap: onFlashcardTap ?? () {},
      ),
      QuickActionItem(
        title: 'Quiz',
        subtitle: 'Kiểm tra',
        icon: Icons.quiz_outlined,
        iconColor: Colors.blue,
        bgColor: Colors.blue.withValues(alpha: 0.1),
        onTap: onQuizTap ?? () {},
      ),
      QuickActionItem(
        title: 'Phát âm',
        subtitle: 'Luyện nói',
        icon: Icons.mic_outlined,
        iconColor: Colors.pink,
        bgColor: Colors.pink.withValues(alpha: 0.1),
        onTap: onPronunciationTap ?? () {},
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
    final actions = defaultActions(onMoreTap: onMoreTap);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.shade50.withValues(alpha: 0.8),
            Colors.pink.shade100.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _QuickActionButton(item: action);
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
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            child: Icon(
              item.icon,
              color: item.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.mutedForeground,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
