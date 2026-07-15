import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/grammar/grammar_models.dart';
import 'grammar_content_widgets.dart';
import 'grammar_level_widgets.dart';
import 'grammar_provider.dart';

/// Chi tiết 1 bài học ngữ pháp: content blocks (text/list/table/exercises) +
/// bài liên quan + đánh dấu hoàn thành (`POST /user/grammar-progress`).
class GrammarLessonDetailScreen extends ConsumerStatefulWidget {
  const GrammarLessonDetailScreen({
    super.key,
    required this.level,
    required this.id,
  });
  final String level;
  final String id;

  @override
  ConsumerState<GrammarLessonDetailScreen> createState() =>
      _GrammarLessonDetailScreenState();
}

class _GrammarLessonDetailScreenState
    extends ConsumerState<GrammarLessonDetailScreen> {
  bool _marking = false;
  bool _justCompleted = false;

  @override
  Widget build(BuildContext context) {
    final key = (level: widget.level, id: widget.id);
    final lessonAsync = ref.watch(grammarLessonProvider(key));
    final completedAsync = ref.watch(grammarCompletedIdsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(l10n.grammar),
      ),
      body: lessonAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: l10n.grammarNotFound,
          onRetry: () => ref.invalidate(grammarLessonProvider(key)),
        ),
        data: (lesson) {
          final completed = Set<String>.from(completedAsync.value ?? const []);
          final alreadyDone = completed.contains(lesson.id);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  GrammarLevelBadge(level: lesson.level),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (lesson.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: lesson.tags
                      .map(
                        (t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 11)),
                          backgroundColor: AppColors.muted,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (alreadyDone && !_justCompleted) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.grammarAlreadyCompleted,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final block in lesson.contents)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: buildGrammarContentBlock(context, block),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_justCompleted || _marking)
                      ? null
                      : () => _handleComplete(lesson, alreadyDone),
                  child: Text(
                    _marking
                        ? '${l10n.grammarMarkComplete}...'
                        : _justCompleted || alreadyDone
                        ? l10n.grammarCompleted
                        : l10n.grammarMarkComplete,
                  ),
                ),
              ),
              if (lesson.related.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l10n.grammarRelatedLessons,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _RelatedLessons(level: lesson.level, ids: lesson.related),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleComplete(GrammarLesson lesson, bool alreadyDone) async {
    setState(() => _marking = true);
    try {
      await markGrammarComplete(
        ref,
        lessonId: lesson.id,
        level: lesson.level,
      );
      if (mounted) setState(() => _justCompleted = true);
    } catch (_) {
      // Best-effort giống web: lỗi mạng không chặn đọc bài, người dùng có
      // thể bấm lại.
    } finally {
      if (mounted) setState(() => _marking = false);
    }
  }
}

class _RelatedLessons extends ConsumerWidget {
  const _RelatedLessons({required this.level, required this.ids});
  final String level;
  final List<String> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(grammarLessonIndexProvider);
    return indexAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (all) {
        final byId = {for (final l in all) l.id: l};
        final related = ids.map((id) => byId[id]).whereType<GrammarLessonSummary>().toList();
        if (related.isEmpty) return const SizedBox.shrink();
        return Column(
          children: related
              .map(
                (l) => Card(
                  child: ListTile(
                    title: Text(l.title),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(
                      '/grammar/${l.level.toLowerCase()}/${l.id}',
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
