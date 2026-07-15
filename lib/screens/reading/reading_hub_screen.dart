import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../core/design_tokens.dart';
import '../../data/reading/reading_models.dart';
import '../../shared/widgets/skeleton_loader.dart';
import 'widgets/reading_cards.dart';

/// Reading Hub — danh sách bài đọc theo level, nguồn `GET /reading/articles`.
///
/// Lấy toàn bộ level trong 1 request (mỗi level ≤ 59 bài — xem
/// `ReadingRepository.fetchArticlesByLevel`) rồi lọc/nhóm phía client theo
/// tab level đang chọn.
final readingArticlesProvider = FutureProvider<List<ReadingArticleSummary>>(
  (ref) => ref.watch(readingRepositoryProvider).fetchArticlesByLevel(),
);

class ReadingHubScreen extends ConsumerStatefulWidget {
  const ReadingHubScreen({super.key});

  @override
  ConsumerState<ReadingHubScreen> createState() => _ReadingHubScreenState();
}

class _ReadingHubScreenState extends ConsumerState<ReadingHubScreen> {
  static const _levels = ['all', 'A1', 'A2', 'B1', 'B2', 'C1'];
  String _selectedLevel = 'all';

  @override
  Widget build(BuildContext context) {
    final articlesAsync = ref.watch(readingArticlesProvider);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: const Text('Luyện đọc'),
        backgroundColor: DesignTokens.background,
        actions: [
          IconButton(
            tooltip: 'Đọc vừa sức (gợi ý riêng)',
            icon: const Icon(Icons.auto_awesome_outlined),
            onPressed: () => context.push('/reading/feed'),
          ),
        ],
      ),
      body: articlesAsync.when(
        loading: () => const _ReadingHubSkeleton(),
        error: (e, _) => ErrorView(
          onRetry: () => ref.invalidate(readingArticlesProvider),
        ),
        data: (articles) {
          if (articles.isEmpty) {
            return ErrorView(
              message: 'Chưa có bài đọc nào.',
              onRetry: () => ref.invalidate(readingArticlesProvider),
            );
          }
          final filtered = _selectedLevel == 'all'
              ? articles
              : articles.where((a) => a.level == _selectedLevel).toList();
          final byLevel = <String, List<ReadingArticleSummary>>{};
          for (final a in filtered) {
            byLevel.putIfAbsent(a.level, () => []).add(a);
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(readingArticlesProvider),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _LevelFilter(
                    levels: _levels,
                    selected: _selectedLevel,
                    onChanged: (l) => setState(() => _selectedLevel = l),
                  ),
                ),
                for (final entry in byLevel.entries) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        DesignTokens.spacingMd,
                        DesignTokens.spacingMd,
                        DesignTokens.spacingMd,
                        DesignTokens.spacingSm,
                      ),
                      child: Row(
                        children: [
                          ReadingLevelBadge(level: entry.key),
                          const SizedBox(width: DesignTokens.spacingSm),
                          Text(
                            '${entry.value.length} bài đọc',
                            style: const TextStyle(
                              color: DesignTokens.mutedForeground,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingMd,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            ReadingArticleCard(article: entry.value[index]),
                        childCount: entry.value.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: DesignTokens.spacingMd),
                  ),
                ],
                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignTokens.spacingXl),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReadingHubSkeleton extends StatelessWidget {
  const _ReadingHubSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: 6,
      separatorBuilder: (_, _) =>
          const SizedBox(height: DesignTokens.spacingSm),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonLine(widthFactor: 0.3, height: 12),
            SizedBox(height: DesignTokens.spacingSm),
            SkeletonLine(widthFactor: 0.7, height: 18),
            SizedBox(height: DesignTokens.spacingXs),
            SkeletonLine(widthFactor: 1, height: 14),
          ],
        ),
      ),
    );
  }
}

class _LevelFilter extends StatelessWidget {
  const _LevelFilter({
    required this.levels,
    required this.selected,
    required this.onChanged,
  });
  final List<String> levels;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingSm,
        ),
        itemCount: levels.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: DesignTokens.spacingSm),
        itemBuilder: (context, index) {
          final level = levels[index];
          final isSelected = level == selected;
          final label = level == 'all' ? 'Tất cả' : level;
          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onChanged(level),
            selectedColor: DesignTokens.tigerOrange.withValues(alpha: 0.18),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color:
                  isSelected ? DesignTokens.tigerOrange : DesignTokens.foreground,
            ),
            side: BorderSide(
              color: isSelected ? DesignTokens.tigerOrange : DesignTokens.border,
            ),
          );
        },
      ),
    );
  }
}
