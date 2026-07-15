import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../core/design_tokens.dart';
import '../../data/reading/reading_models.dart';
import '../../shared/widgets/skeleton_loader.dart';
import 'widgets/reading_cards.dart';

/// Reading Feed — gợi ý bài đọc "vừa sức" (i+1) theo coverage từ vựng đã
/// biết. Nguồn `GET /reading-feed?levels=`. Mirror `reading-feed-page.tsx`.
///
/// Family key là chuỗi comma-separated levels (rỗng = tất cả) thay vì
/// `List<String>` — `List` không có value equality mặc định nên sẽ phá
/// cache/override theo tham số của Riverpod family.
final readingFeedProvider = FutureProvider.autoDispose
    .family<ReadingFeedResult, String>((ref, levels) {
      return ref.watch(readingRepositoryProvider).fetchFeed(levels: levels);
    });

class ReadingFeedScreen extends ConsumerStatefulWidget {
  const ReadingFeedScreen({super.key});

  @override
  ConsumerState<ReadingFeedScreen> createState() => _ReadingFeedScreenState();
}

class _ReadingFeedScreenState extends ConsumerState<ReadingFeedScreen> {
  static const _levels = ['A1', 'A2', 'B1', 'B2', 'C1'];
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final selectedLevels = (_selected.toList()..sort()).join(',');
    final feedAsync = ref.watch(readingFeedProvider(selectedLevels));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: const Text('Đọc vừa sức'),
        backgroundColor: DesignTokens.background,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Wrap(
              spacing: DesignTokens.spacingSm,
              runSpacing: DesignTokens.spacingSm,
              children: [
                ChoiceChip(
                  label: const Text('Tất cả'),
                  selected: _selected.isEmpty,
                  onSelected: (_) => setState(_selected.clear),
                ),
                for (final level in _levels)
                  ChoiceChip(
                    label: Text(level),
                    selected: _selected.contains(level),
                    onSelected: (_) => setState(() {
                      if (!_selected.add(level)) _selected.remove(level);
                    }),
                  ),
              ],
            ),
          ),
          Expanded(
            child: feedAsync.when(
              loading: () => const _ReadingFeedSkeleton(),
              error: (e, _) => ErrorView(
                onRetry: () => ref.invalidate(readingFeedProvider(selectedLevels)),
              ),
              data: (result) {
                if (result.articles.isEmpty) {
                  return ErrorView(
                    message: result.coverageReady
                        ? 'Chưa có bài đọc phù hợp trình độ của bạn lúc này.'
                        : 'Đang chuẩn bị kho bài đọc — vui lòng quay lại sau ít phút.',
                    onRetry: () =>
                        ref.invalidate(readingFeedProvider(selectedLevels)),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(readingFeedProvider(selectedLevels)),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingMd,
                    ),
                    itemCount: result.articles.length,
                    itemBuilder: (context, index) =>
                        _FeedArticleCard(article: result.articles[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingFeedSkeleton extends StatelessWidget {
  const _ReadingFeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: 5,
      separatorBuilder: (_, _) =>
          const SizedBox(height: DesignTokens.spacingSm),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLine(widthFactor: 0.4, height: 12),
            SizedBox(height: DesignTokens.spacingSm),
            SkeletonLine(widthFactor: 0.8, height: 18),
            SizedBox(height: DesignTokens.spacingXs),
            SkeletonLine(widthFactor: 1, height: 14),
          ],
        ),
      ),
    );
  }
}

const _fitLabels = {
  ReadingFeedFit.ideal: 'Vừa sức',
  ReadingFeedFit.accessible: 'Hơi thử thách',
  ReadingFeedFit.challenging: 'Khó',
};

const _fitColors = {
  ReadingFeedFit.ideal: Color(0xFF059669),
  ReadingFeedFit.accessible: Color(0xFFB45309),
  ReadingFeedFit.challenging: Color(0xFFDC2626),
};

class _FeedArticleCard extends StatelessWidget {
  const _FeedArticleCard({required this.article});
  final ReadingFeedArticle article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fitColor = _fitColors[article.fit]!;
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
                Row(
                  children: [
                    ReadingLevelBadge(level: article.level),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: fitColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                      child: Text(
                        _fitLabels[article.fit]!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: fitColor,
                          fontSize: 12,
                        ),
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
                if (article.titleVi != null && article.titleVi!.isNotEmpty)
                  Text(
                    article.titleVi!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DesignTokens.mutedForeground,
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
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  '${article.vocabNew} từ mới · Đã biết '
                  '${(article.coverage * 100).round()}% từ khó',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignTokens.mutedForeground,
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
