import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../data/news/news_models.dart';

/// Bản dịch tiếng Việt cho chủ đề tin tức — khớp `TOPIC_VI` của web
/// (`news-page.tsx`). Chủ đề không nằm trong bảng thì hiển thị nguyên gốc.
const Map<String, String> newsTopicViMap = {
  'alltag': 'Đời sống',
  'bildung': 'Giáo dục',
  'politik': 'Chính trị',
  'reise': 'Du lịch',
  'sport': 'Thể thao',
  'technologie': 'Công nghệ',
  'welt': 'Thế giới',
  'wirtschaft': 'Kinh tế',
};

String newsTopicVi(String topic) => newsTopicViMap[topic] ?? topic;

/// Card 1 bài trong danh sách kho tin tức.
class NewsStoryCard extends StatelessWidget {
  const NewsStoryCard({
    super.key,
    required this.story,
    required this.completed,
    required this.onTap,
    this.activeLevel,
  });

  final NewsStorySummary story;
  final bool completed;
  final String? activeLevel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm + 4),
      child: Material(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: DesignTokens.spacingXs,
                        runSpacing: DesignTokens.spacingXs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _Chip(
                            label: newsTopicVi(story.topic),
                            color: DesignTokens.orange500,
                            background: DesignTokens.orange100,
                          ),
                          for (final lv in story.levelsAvailable)
                            _Chip(
                              label: lv,
                              color: lv == activeLevel
                                  ? DesignTokens.tigerOrange
                                  : DesignTokens.mutedForeground,
                              background: lv == activeLevel
                                  ? DesignTokens.tigerOrange.withValues(
                                      alpha: 0.12,
                                    )
                                  : Colors.transparent,
                              outlined: true,
                            ),
                          if (completed)
                            const _Chip(
                              label: 'Đã hoàn thành',
                              color: Color(0xFF059669),
                              background: Color(0xFFD1FAE5),
                              icon: Icons.check_circle_rounded,
                            ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacingSm),
                      Text(
                        story.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: DesignTokens.foreground,
                        ),
                      ),
                      if ((story.titleVi ?? '').isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          story.titleVi!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF0284C7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: DesignTokens.spacingSm),
                      Text(
                        story.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: DesignTokens.mutedForeground,
                          height: 1.4,
                        ),
                      ),
                      if (story.audioUrl != null) ...[
                        const SizedBox(height: DesignTokens.spacingSm),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.graphic_eq_rounded,
                              size: 14,
                              color: DesignTokens.tigerOrange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Có audio',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: DesignTokens.tigerOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (story.imageUrl != null) ...[
                  const SizedBox(width: DesignTokens.spacingSm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    child: Image.network(
                      story.imageUrl!,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.background,
    this.outlined = false,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final bool outlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: outlined ? Border.all(color: color.withValues(alpha: 0.5)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ring gọn hiển thị tiến độ đọc tuần này (`GET /user/news-week-stats`).
class NewsWeeklyRingCard extends StatelessWidget {
  const NewsWeeklyRingCard({super.key, required this.stats});

  final NewsWeekStats stats;

  @override
  Widget build(BuildContext context) {
    final total = stats.publishedThisWeek;
    final done = stats.myCompletedThisWeek;
    final progress = total > 0 ? (done / total).clamp(0.0, 1.0) : 0.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(
        DesignTokens.spacingMd,
        DesignTokens.spacingSm,
        DesignTokens.spacingMd,
        DesignTokens.spacingMd,
      ),
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: DesignTokens.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    DesignTokens.tigerOrange,
                  ),
                ),
                Text(
                  '$done',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Text(
              total > 0
                  ? 'Tuần này bạn đã đọc $done/$total bài mới xuất bản'
                  : 'Chưa có bài mới xuất bản tuần này',
              style: const TextStyle(
                color: DesignTokens.mutedForeground,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
