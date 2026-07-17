import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/reading/reading_models.dart';
import '../../shared/widgets/skeleton_loader.dart';

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
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final selectedLevels = (_selected.toList()..sort()).join(',');
    final feedAsync = ref.watch(readingFeedProvider(selectedLevels));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(l10n.readingFeedAppBarTitle),
        backgroundColor: tokens.background,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Wrap(
              spacing: DesignTokens.spacingSm,
              runSpacing: DesignTokens.spacingSm,
              children: [
                _FeedLevelPill(
                  label: l10n.allFilters,
                  selected: _selected.isEmpty,
                  onTap: () => setState(_selected.clear),
                ),
                for (final level in _levels)
                  _FeedLevelPill(
                    label: level,
                    selected: _selected.contains(level),
                    onTap: () => setState(() {
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
                  return _FeedEmptyState(
                    coverageReady: result.coverageReady,
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

class _FeedLevelPill extends StatelessWidget {
  const _FeedLevelPill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? DesignTokens.tigerOrange : tokens.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? DesignTokens.tigerOrange : tokens.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}

class _FeedEmptyState extends StatelessWidget {
  const _FeedEmptyState({required this.coverageReady, required this.onRetry});
  final bool coverageReady;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_stories_outlined, size: 40, color: tokens.mutedForeground),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              coverageReady ? l10n.readingFeedEmptyReady : l10n.readingFeedEmptyNotReady,
              textAlign: TextAlign.center,
              style: TextStyle(color: tokens.mutedForeground),
            ),
            if (coverageReady) ...[
              const SizedBox(height: DesignTokens.spacingXs),
              Text(
                l10n.readingFeedSaveVocabHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              FilledButton(
                onPressed: () => context.push('/vocabulary'),
                style: FilledButton.styleFrom(backgroundColor: DesignTokens.tigerOrange),
                child: Text(l10n.focusSessionLearnNewWordsCta),
              ),
            ] else ...[
              const SizedBox(height: DesignTokens.spacingSm),
              TextButton(onPressed: onRetry, child: Text(l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReadingFeedSkeleton extends StatelessWidget {
  const _ReadingFeedSkeleton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: 5,
      separatorBuilder: (_, _) =>
          const SizedBox(height: DesignTokens.spacingSm),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: tokens.card,
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
    final tokens = context.tokens;
    final fitColor = _fitColors[article.fit]!;
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm + 4),
      child: Material(
        color: tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          onTap: () => context.push('/reading/${article.level}/${article.slug}'),
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    child: Image.network(
                      article.imageUrl!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingSm + 2),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: DesignTokens.spacingSm,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: DesignTokens.orange100,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              article.level,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: DesignTokens.orange500,
                              ),
                            ),
                          ),
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
                          color: tokens.foreground,
                        ),
                      ),
                      if (article.titleVi != null && article.titleVi!.isNotEmpty)
                        Text(
                          article.titleVi!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: tokens.mutedForeground,
                          ),
                        ),
                      const SizedBox(height: DesignTokens.spacingSm),
                      Text(
                        article.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: tokens.foreground,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingSm),
                      Text(
                        AppLocalizations.of(context).readingFeedVocabSummary(
                          article.vocabNew,
                          (article.coverage * 100).round(),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.mutedForeground,
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
