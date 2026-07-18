import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/news/news_repository.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/news/news_models.dart';
import '../../shared/widgets/skeleton_loader.dart';
import 'widgets/news_cards.dart';
import 'widgets/news_leaderboard.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _pageSize = 10;
const _cefrLevels = ['A1', 'A2', 'B1', 'B2'];

/// Key cho [newsListProvider] — page + filter tuỳ chọn xác định 1 trang kết quả.
typedef NewsListKey = ({int page, String? topic, String? level});

/// News Hub — danh sách tin tức Đức phân trang, nguồn `GET /news/list`.
final newsListProvider = FutureProvider.autoDispose
    .family<NewsListResult, NewsListKey>((ref, key) {
      return ref
          .watch(newsRepositoryProvider)
          .fetchList(
            page: key.page,
            pageSize: _pageSize,
            topic: key.topic,
            level: key.level,
          );
    });

/// Chủ đề tin tức + số bài, nguồn `GET /news/topics`.
final newsTopicsProvider = FutureProvider<Map<String, int>>((ref) {
  return ref.watch(newsRepositoryProvider).fetchTopics();
});

/// story_group_id các bài user đã hoàn thành (quiz đạt), nguồn
/// `GET /user/news-progress`.
final newsCompletedIdsProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(newsRepositoryProvider).fetchCompletedIds();
});

/// Tiến độ tuần cá nhân, nguồn `GET /user/news-week-stats`.
final newsWeekStatsProvider = FutureProvider<NewsWeekStats?>((ref) {
  return ref.watch(newsRepositoryProvider).fetchWeekStats();
});

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  int _page = 1;
  String? _activeLevel;
  String? _activeTopic;

  NewsListKey get _key =>
      (page: _page, topic: _activeTopic, level: _activeLevel);

  void _toggleLevel(String level) {
    setState(() {
      _activeLevel = _activeLevel == level ? null : level;
      _page = 1;
    });
  }

  void _toggleTopic(String topic) {
    setState(() {
      _activeTopic = _activeTopic == topic ? null : topic;
      _page = 1;
    });
  }

  void _goToPage(int page, int totalPages) {
    setState(() => _page = page.clamp(1, totalPages));
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(newsListProvider(_key));
    final topicsAsync = ref.watch(newsTopicsProvider);
    final completedAsync = ref.watch(newsCompletedIdsProvider);
    final weekStatsAsync = ref.watch(newsWeekStatsProvider);

    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            _NewsHubTabBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(newsListProvider(_key));
                  ref.invalidate(newsTopicsProvider);
                  ref.invalidate(newsCompletedIdsProvider);
                  ref.invalidate(newsWeekStatsProvider);
                },
                child: listAsync.when(
                  loading: () => const _NewsListSkeleton(),
                  error: (e, _) => ErrorView(
                    onRetry: () => ref.invalidate(newsListProvider(_key)),
                  ),
                  data: (result) {
                    final completed = completedAsync.valueOrNull ?? const [];
                    final completedSet = completed.toSet();
                    final topics = topicsAsync.valueOrNull ?? const {};
                    final topicNames = topics.keys.toList()..sort();
                    final totalPages = (result.total / _pageSize).ceil().clamp(
                      1,
                      1 << 30,
                    );

                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _NewsHeader()),
                        SliverToBoxAdapter(
                          child: _FilterBar(
                            levels: _cefrLevels,
                            activeLevel: _activeLevel,
                            topics: topicNames,
                            activeTopic: _activeTopic,
                            onLevelTap: _toggleLevel,
                            onTopicTap: _toggleTopic,
                          ),
                        ),
                        if (result.stories.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _EmptyState(
                              hasFilter: _activeLevel != null || _activeTopic != null,
                              onClearFilter: () => setState(() {
                                _activeLevel = null;
                                _activeTopic = null;
                                _page = 1;
                              }),
                            ),
                          )
                        else ...[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingMd,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final story = result.stories[index];
                                  return NewsStoryCard(
                                    story: story,
                                    activeLevel: _activeLevel,
                                    completed: completedSet.contains(
                                      story.storyGroupId,
                                    ),
                                    onTap: () => context.push(
                                      '/news/${story.slug.isNotEmpty ? story.slug : story.storyGroupId}',
                                      extra: NewsDetailArgs(
                                        slug: story.slug.isNotEmpty
                                            ? story.slug
                                            : story.storyGroupId,
                                        level: _activeLevel,
                                        title: story.title,
                                      ),
                                    ),
                                  );
                                },
                                childCount: result.stories.length,
                              ),
                            ),
                          ),
                          if (totalPages > 1)
                            SliverToBoxAdapter(
                              child: _PaginationBar(
                                page: _page,
                                totalPages: totalPages,
                                onPrev: () => _goToPage(_page - 1, totalPages),
                                onNext: () => _goToPage(_page + 1, totalPages),
                              ),
                            ),
                        ],
                        // Weekly ring + leaderboard nằm dưới danh sách (mobile
                        // web: aside stack xuống dưới) — khác vị trí "trên
                        // cùng" cũ của Flutter.
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              DesignTokens.spacingMd,
                              DesignTokens.spacingMd,
                              DesignTokens.spacingMd,
                              0,
                            ),
                            child: Column(
                              children: [
                                if (weekStatsAsync.valueOrNull != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
                                    child: NewsWeeklyRingCard(stats: weekStatsAsync.valueOrNull!),
                                  ),
                                const NewsLeaderboardCard(),
                              ],
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: DesignTokens.spacingXl),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsHubTabBar extends StatelessWidget {
  const _NewsHubTabBar();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      child: Row(
        children: [
          Flexible(child: _NewsTabButton(label: l10n.newsTabLabel, active: true, onTap: null)),
          Flexible(child: _NewsTabButton(label: l10n.readingTabLabel, active: false, onTap: () => context.go('/reading'))),
        ],
      ),
    );
  }
}

class _NewsTabButton extends StatelessWidget {
  const _NewsTabButton({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: active ? tokens.primary : Colors.transparent, width: 2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: active ? tokens.primary : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}

class _NewsHeader extends StatelessWidget {
  const _NewsHeader();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacingMd,
        DesignTokens.spacingMd,
        DesignTokens.spacingMd,
        0,
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                border: Border.all(color: tokens.border),
              ),
              child: Icon(PhosphorIcons.caretLeft, size: 18, color: tokens.mutedForeground),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.newsHeaderTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: tokens.foreground),
                ),
                Text(
                  l10n.newsHeaderSubtitle,
                  style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.levels,
    required this.activeLevel,
    required this.topics,
    required this.activeTopic,
    required this.onLevelTap,
    required this.onTopicTap,
  });

  final List<String> levels;
  final String? activeLevel;
  final List<String> topics;
  final String? activeTopic;
  final ValueChanged<String> onLevelTap;
  final ValueChanged<String> onTopicTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: DesignTokens.spacingSm,
            runSpacing: DesignTokens.spacingXs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.newsFilterLevelLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tokens.mutedForeground,
                ),
              ),
              for (final level in levels)
                ChoiceChip(
                  label: Text(level),
                  selected: activeLevel == level,
                  onSelected: (_) => onLevelTap(level),
                  selectedColor: DesignTokens.tigerOrange,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: activeLevel == level
                        ? Colors.white
                        : tokens.foreground,
                  ),
                ),
            ],
          ),
          if (topics.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingXs),
            Wrap(
              spacing: DesignTokens.spacingSm,
              runSpacing: DesignTokens.spacingXs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  l10n.newsFilterTopicLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.mutedForeground,
                  ),
                ),
                for (final topic in topics)
                  ChoiceChip(
                    label: Text(newsTopicVi(topic)),
                    selected: activeTopic == topic,
                    onSelected: (_) => onTopicTap(topic),
                    selectedColor: DesignTokens.orange500,
                    backgroundColor: DesignTokens.orange100,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: activeTopic == topic
                          ? Colors.white
                          : DesignTokens.orange500,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.page,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: OutlinedButton.icon(
              onPressed: page > 1 ? onPrev : null,
              icon: const Icon(PhosphorIcons.caretLeft),
              label: Text(l10n.examSetPagePrev, overflow: TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Flexible(
            child: Text(
              l10n.newsPaginationInfo(page, totalPages),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: tokens.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Flexible(
            child: OutlinedButton.icon(
              onPressed: page < totalPages ? onNext : null,
              icon: const Icon(PhosphorIcons.caretRight),
              label: Text(l10n.newsPaginationNext, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilter, required this.onClearFilter});

  final bool hasFilter;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.newspaper,
              size: 40,
              color: tokens.mutedForeground,
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              hasFilter ? l10n.newsEmptyFiltered : l10n.newsEmptyNone,
              textAlign: TextAlign.center,
              style: TextStyle(color: tokens.mutedForeground),
            ),
            if (hasFilter) ...[
              const SizedBox(height: DesignTokens.spacingSm),
              TextButton(
                onPressed: onClearFilter,
                child: Text(l10n.writingClearFilters),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NewsListSkeleton extends StatelessWidget {
  const _NewsListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: DesignTokens.spacingSm),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: context.tokens.card,
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
