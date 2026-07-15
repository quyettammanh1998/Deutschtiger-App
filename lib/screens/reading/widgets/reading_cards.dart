import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../data/reading/reading_models.dart'
    show ReadingArticleSummary, ReadingDetailArgs, readingLevelColor;

/// Tile card dùng trong ReadingHubScreen — tách riêng để file hub < 300 dòng.
class ReadingArticleCard extends StatelessWidget {
  const ReadingArticleCard({super.key, required this.article});
  final ReadingArticleSummary article;

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
          onTap: () => context.push(
            '/reading/detail',
            extra: ReadingDetailArgs(
              level: article.level,
              slug: article.slug,
              title: article.title,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.topic.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 18,
                        color: DesignTokens.orange500,
                      ),
                      const SizedBox(width: DesignTokens.spacingSm),
                      Text(
                        article.topic,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  article.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: DesignTokens.foreground,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  article.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: DesignTokens.foreground,
                    height: 1.4,
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

/// Pill badge cho level — match màu với `readingLevelColor`.
class ReadingLevelBadge extends StatelessWidget {
  const ReadingLevelBadge({super.key, required this.level});
  final String level;

  @override
  Widget build(BuildContext context) {
    final color = readingLevelColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm + 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}