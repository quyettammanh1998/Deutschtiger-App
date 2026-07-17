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
import 'widgets/reading_leaderboard.dart';
import 'widgets/reading_level_theme.dart';

/// Reading Hub — nguồn `GET /reading/articles` (tất cả level, 1 request).
///
/// Mirror `reading-page.tsx`: tab shell Tin tức|Truyện → lưới 2 cột 6 level
/// (A1–C2, ring tiến trình + gợi ý bài chưa đọc) → chọn level mở chi tiết
/// (tìm kiếm + danh sách + bảng xếp hạng).
final readingArticlesProvider = FutureProvider<List<ReadingArticleSummary>>(
  (ref) => ref.watch(readingRepositoryProvider).fetchArticlesByLevel(),
);

/// Id các bài đã đọc của user hiện tại (rỗng khi chưa đăng nhập/lỗi mạng).
final readingCompletedIdsProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(readingRepositoryProvider).fetchCompletedIds();
});

class ReadingHubScreen extends ConsumerStatefulWidget {
  const ReadingHubScreen({super.key});

  @override
  ConsumerState<ReadingHubScreen> createState() => _ReadingHubScreenState();
}

class _ReadingHubScreenState extends ConsumerState<ReadingHubScreen> {
  String? _level;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final articlesAsync = ref.watch(readingArticlesProvider);
    final completedAsync = ref.watch(readingCompletedIdsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            _ReadingHubTabBar(active: _ReadingHubTab.truyen),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(readingArticlesProvider);
                  ref.invalidate(readingCompletedIdsProvider);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    DesignTokens.spacingMd,
                    DesignTokens.spacingMd,
                    DesignTokens.spacingMd,
                    DesignTokens.spacingXl,
                  ),
                  children: [
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusSm,
                          ),
                          onTap: () {
                            if (_level != null) {
                              setState(() => _level = null);
                            } else {
                              context.pop();
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: tokens.card,
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusSm,
                              ),
                              border: Border.all(color: tokens.border),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingSm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _level != null
                                    ? l10n.readingHubTitleLevel(_level!)
                                    : l10n.readingHubTitle,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: tokens.foreground,
                                ),
                              ),
                              Text(
                                _level != null
                                    ? l10n.readingHubSubtitleLevel
                                    : l10n.readingHubSubtitleHome,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: tokens.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingMd),
                    articlesAsync.when(
                      loading: () => const _ReadingHubSkeleton(),
                      error: (e, _) => ErrorView(
                        onRetry: () => ref.invalidate(readingArticlesProvider),
                      ),
                      data: (articles) {
                        final completedIds =
                            (completedAsync.valueOrNull ?? const []).toSet();
                        if (_level == null) {
                          return _ReadingHome(
                            articles: articles,
                            completedIds: completedIds,
                            onSelectLevel: (l) => setState(() => _level = l),
                          );
                        }
                        return _ReadingLevelDetail(
                          level: _level!,
                          articles: articles
                              .where((a) => a.level == _level)
                              .toList(),
                          completedIds: completedIds,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ReadingHubTab { tinTuc, truyen }

/// Tab bar dùng chung giữa `/reading` và `/news` — mirror `ReadingHubShell`.
class _ReadingHubTabBar extends StatelessWidget {
  const _ReadingHubTabBar({required this.active});
  final _ReadingHubTab active;

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
          Flexible(
            child: _TabButton(
              label: l10n.newsTabLabel,
              active: active == _ReadingHubTab.tinTuc,
              onTap: active == _ReadingHubTab.tinTuc
                  ? null
                  : () => context.go('/news'),
            ),
          ),
          Flexible(
            child: _TabButton(
              label: l10n.readingTabLabel,
              active: active == _ReadingHubTab.truyen,
              onTap: active == _ReadingHubTab.truyen
                  ? null
                  : () => context.go('/reading'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? tokens.primary : Colors.transparent,
              width: 2,
            ),
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

class _ReadingHome extends StatelessWidget {
  const _ReadingHome({
    required this.articles,
    required this.completedIds,
    required this.onSelectLevel,
  });

  final List<ReadingArticleSummary> articles;
  final Set<String> completedIds;
  final ValueChanged<String> onSelectLevel;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: DesignTokens.spacingSm,
      mainAxisSpacing: DesignTokens.spacingSm,
      childAspectRatio: 0.78,
      children: [
        for (final level in kReadingLevels)
          _LevelCard(
            level: level,
            articles: articles.where((a) => a.level == level).toList(),
            completedIds: completedIds,
            onTap: () => onSelectLevel(level),
          ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.articles,
    required this.completedIds,
    required this.onTap,
  });

  final String level;
  final List<ReadingArticleSummary> articles;
  final Set<String> completedIds;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final theme = readingLevelTheme(level);
    final total = articles.length;
    final completed = articles.where((a) => completedIds.contains(a.id)).length;
    final recommended = articles
        .where((a) => !completedIds.contains(a.id))
        .take(3)
        .toList();
    final progress = total > 0 ? completed / total : 0.0;
    final allDone = total > 0 && completed == total;

    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignTokens.spacingSm + 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.headerFrom, theme.headerTo],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(theme.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 2),
                        Text(
                          level,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          theme.label,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3.5,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                        if (allDone)
                          const Icon(Icons.check, color: Colors.white, size: 18)
                        else
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$completed',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '/$total',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingSm,
                vertical: 6,
              ),
              child: recommended.isEmpty
                  ? Center(
                      child: Text(
                        total == 0
                            ? l10n.readingLevelCardEmpty
                            : l10n.readingLevelCardAllDone,
                        style: TextStyle(
                          fontSize: 11,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < recommended.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.5),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: theme.badgeBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: theme.badgeText,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    recommended[i].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: tokens.foreground,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DesignTokens.spacingSm,
                0,
                DesignTokens.spacingSm,
                DesignTokens.spacingSm,
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    backgroundColor: theme.badgeBg,
                    foregroundColor: theme.badgeText,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    l10n.readingViewAllArrow,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chi tiết 1 level — tìm kiếm + danh sách bài + bảng xếp hạng.
///
/// Deviation: web nhóm bài theo topic-accordion (`reading-topics.ts`, hàng
/// trăm dòng slug→chủ đề không có nguồn backend). Nội dung phân loại đó là
/// dữ liệu tĩnh riêng của web, không phải logic — port lại toàn bộ nằm ngoài
/// phạm vi wave này; danh sách phẳng dưới đây giữ đủ search + trạng thái đã
/// đọc + điều hướng, chỉ thiếu phần chia nhóm theo chủ đề.
class _ReadingLevelDetail extends StatefulWidget {
  const _ReadingLevelDetail({
    required this.level,
    required this.articles,
    required this.completedIds,
  });

  final String level;
  final List<ReadingArticleSummary> articles;
  final Set<String> completedIds;

  @override
  State<_ReadingLevelDetail> createState() => _ReadingLevelDetailState();
}

class _ReadingLevelDetailState extends State<_ReadingLevelDetail> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final theme = readingLevelTheme(widget.level);
    final total = widget.articles.length;
    final completed = widget.articles
        .where((a) => widget.completedIds.contains(a.id))
        .length;
    final progress = total > 0 ? completed / total : 0.0;
    final filtered = _query.isEmpty
        ? widget.articles
        : widget.articles
              .where(
                (a) => a.title.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.headerFrom, theme.headerTo],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4.5,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$completed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '/$total',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(theme.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Text(
                        widget.level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    theme.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    l10n.readingCompletedCountOfTotal(completed, total),
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: l10n.readingSearchHintInLevel(widget.level),
            prefixIcon: const Icon(Icons.search, size: 18),
            filled: true,
            fillColor: tokens.card,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radius),
              borderSide: BorderSide(color: tokens.border),
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: DesignTokens.spacingXl,
            ),
            child: Center(
              child: Text(
                l10n.readingSearchEmpty,
                style: TextStyle(color: tokens.mutedForeground),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(DesignTokens.radius),
              border: Border.all(color: tokens.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < filtered.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: tokens.border),
                  _ArticleRow(
                    article: filtered[i],
                    index: i + 1,
                    done: widget.completedIds.contains(filtered[i].id),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: DesignTokens.spacingMd),
        ReadingLeaderboardCard(
          level: widget.level,
          completed: completed,
          total: total,
        ),
      ],
    );
  }
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({
    required this.article,
    required this.index,
    required this.done,
  });
  final ReadingArticleSummary article;
  final int index;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: () => context.push('/reading/${article.level}/${article.slug}'),
      child: Container(
        color: done ? const Color(0xFF059669).withValues(alpha: 0.06) : null,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingSm + 2,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: done ? const Color(0xFFD1FAE5) : tokens.muted,
                shape: BoxShape.circle,
              ),
              child: done
                  ? const Icon(Icons.check, size: 16, color: Color(0xFF059669))
                  : Text(
                      '$index',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: tokens.mutedForeground,
                      ),
                    ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: Text(
                article.title,
                style: TextStyle(
                  fontSize: 14,
                  color: done ? const Color(0xFF059669) : tokens.foreground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: tokens.mutedForeground),
          ],
        ),
      ),
    );
  }
}

class _ReadingHubSkeleton extends StatelessWidget {
  const _ReadingHubSkeleton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: DesignTokens.spacingSm,
      mainAxisSpacing: DesignTokens.spacingSm,
      childAspectRatio: 0.78,
      children: List.generate(
        6,
        (index) => Container(
          padding: const EdgeInsets.all(DesignTokens.spacingSm),
          decoration: BoxDecoration(
            color: tokens.muted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(widthFactor: 0.4, height: 14),
              SizedBox(height: DesignTokens.spacingSm),
              SkeletonLine(widthFactor: 0.8, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
