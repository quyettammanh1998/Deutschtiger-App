import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/grammar/grammar_models.dart';
import '../domain/grammar_curriculum_order.dart';
import 'grammar_level_widgets.dart';
import 'grammar_provider.dart';

/// Grammar Hub — level grid (không chọn level) hoặc chi tiết 1 level
/// (bài học nhóm theo chủ đề + bài đọc). Live data qua [grammarLessonIndexProvider]
/// + [grammarCompletedIdsProvider].
class GrammarScreen extends ConsumerStatefulWidget {
  const GrammarScreen({super.key, this.initialLevel});
  final String? initialLevel;

  @override
  ConsumerState<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends ConsumerState<GrammarScreen> {
  String _searchQuery = '';

  String? get _level =>
      grammarLevels.contains(widget.initialLevel?.toUpperCase())
      ? widget.initialLevel!.toUpperCase()
      : null;

  void _selectLevel(String level) => context.go('/grammar?level=$level');
  void _goHome() => context.go('/grammar');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final level = _level;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        leading: level != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goHome,
              )
            : null,
        title: Text(
          level != null ? '${l10n.grammar} $level' : l10n.grammar,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.grammarSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (q) => setState(() => _searchQuery = q),
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final lessonsAsync = ref.watch(grammarLessonIndexProvider);
                final completedAsync = ref.watch(
                  grammarCompletedIdsProvider,
                );
                return lessonsAsync.when(
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(
                    onRetry: () => ref.invalidate(grammarLessonIndexProvider),
                  ),
                  data: (lessons) {
                    final completed = Set<String>.from(
                      completedAsync.value ?? const [],
                    );
                    if (_searchQuery.trim().isNotEmpty) {
                      return _SearchResults(
                        query: _searchQuery,
                        lessons: lessons,
                        completed: completed,
                      );
                    }
                    if (level != null) {
                      return _LevelDetail(
                        level: level,
                        lessons: lessons
                            .where((l) => l.level == level)
                            .toList(),
                        completed: completed,
                      );
                    }
                    return _LevelGrid(
                      lessons: lessons,
                      completed: completed,
                      onSelectLevel: _selectLevel,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.query,
    required this.lessons,
    required this.completed,
  });
  final String query;
  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final results = sortByCurriculum(
      lessons.where((l) => l.title.toLowerCase().contains(q)).toList(),
    );
    final l10n = AppLocalizations.of(context);
    if (results.isEmpty) {
      return Center(child: Text(l10n.grammarNoResults));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, i) =>
          _LessonRow(lesson: results[i], done: completed.contains(results[i].id)),
    );
  }
}

class _LevelGrid extends StatelessWidget {
  const _LevelGrid({
    required this.lessons,
    required this.completed,
    required this.onSelectLevel,
  });
  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;
  final ValueChanged<String> onSelectLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: grammarLevels.map((level) {
        final meta = grammarLevelMeta(level);
        final levelLessons = lessons.where((l) => l.level == level).toList();
        final total = levelLessons.length;
        final done = levelLessons.where((l) => completed.contains(l.id)).length;
        final recommended = levelLessons
            .where((l) => !completed.contains(l.id))
            .take(3)
            .toList();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: meta.color.withValues(alpha: 0.3)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: meta.color,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meta.emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                          Text(
                            level,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            meta.label,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GrammarProgressRing(completed: done, total: total, size: 44),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: recommended.isEmpty
                      ? Center(
                          child: Text(
                            total == 0 ? l10n.grammarNoLessons : l10n.grammarAllDone,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.mutedForeground,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: recommended
                              .map(
                                (l) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    '• ${l.title}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => onSelectLevel(level),
                    child: Text(l10n.grammarViewAll),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _LevelDetail extends ConsumerWidget {
  const _LevelDetail({
    required this.level,
    required this.lessons,
    required this.completed,
  });
  final String level;
  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorted = sortByCurriculum(lessons);
    final grouped = <String, List<GrammarLessonSummary>>{};
    for (final lesson in sorted) {
      grouped.putIfAbsent(lessonGroupKey(lesson), () => []).add(lesson);
    }

    final total = sorted.length;
    final done = sorted.where((l) => completed.contains(l.id)).length;
    final meta = grammarLevelMeta(level);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: meta.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              GrammarProgressRing(completed: done, total: total, size: 56),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${meta.emoji} $level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(meta.label, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final entry in grouped.entries)
          isSoloGroup(entry.key)
              ? _LessonRow(
                  lesson: entry.value.first,
                  done: completed.contains(entry.value.first.id),
                )
              : _TopicSection(
                  topic: entry.value.first.tags.isNotEmpty
                      ? entry.value.first.tags.first
                      : entry.key,
                  lessons: entry.value,
                  completed: completed,
                ),
        _ArticlesSection(level: level, completed: completed),
      ],
    );
  }
}

/// Danh sách bài đọc dài (article) của level — file tĩnh, tách khỏi lesson
/// index. Ẩn hoàn toàn khi level chưa có bài đọc nào.
class _ArticlesSection extends ConsumerWidget {
  const _ArticlesSection({required this.level, required this.completed});
  final String level;
  final Set<String> completed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(grammarArticleIndexProvider);
    return indexAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (index) {
        final articles = index[level.toLowerCase()] ?? const [];
        if (articles.isEmpty) return const SizedBox.shrink();
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            child: ExpansionTile(
              title: Text(
                l10n.grammarArticles,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: articles
                  .map(
                    (a) => ListTile(
                      leading: Icon(
                        completed.contains(a.progressId)
                            ? Icons.check_circle
                            : Icons.article_outlined,
                        color: completed.contains(a.progressId)
                            ? AppColors.success
                            : AppColors.mutedForeground,
                      ),
                      title: Text(a.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(
                        '/grammar/articles/${level.toLowerCase()}/${a.slug}',
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class _TopicSection extends StatelessWidget {
  const _TopicSection({
    required this.topic,
    required this.lessons,
    required this.completed,
  });
  final String topic;
  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final done = lessons.where((l) => completed.contains(l.id)).length;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(topic, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$done/${lessons.length}'),
        children: lessons
            .map((l) => _LessonRow(lesson: l, done: completed.contains(l.id)))
            .toList(),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.lesson, required this.done});
  final GrammarLessonSummary lesson;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: done ? AppColors.success : AppColors.muted,
        child: Icon(
          done ? Icons.check : Icons.menu_book_outlined,
          color: done ? Colors.white : AppColors.mutedForeground,
          size: 18,
        ),
      ),
      title: Text(lesson.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/grammar/${lesson.level.toLowerCase()}/${lesson.id}'),
    );
  }
}
