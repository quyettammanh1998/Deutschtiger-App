import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../../shared/widgets/back_button.dart';
import 'grammar_content_widgets.dart';
import 'grammar_level_widgets.dart';
import 'grammar_provider.dart';

/// Chi tiết 1 bài học ngữ pháp — web parity `grammar-lesson-page.tsx`:
/// content blocks (rich text/formula/German-highlight/table/exercises) +
/// read-gate (cuộn 80% + thời gian tối thiểu trước khi cho phép đánh dấu
/// hoàn thành, +5 XP) + bài liên quan.
///
/// Web's read-gate estimates min-time from content character count (~30
/// chars/sec, floor 10s cap 45s) and marks "scrolled 80%" via
/// IntersectionObserver on a sentinel placed at 80% of the content list.
/// Flutter has no IntersectionObserver — this ports the same floor/cap
/// timer plus a [ScrollController] threshold on the lesson card's max
/// scroll extent (0 extent = nothing to scroll = already satisfied).
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

  final _scrollController = ScrollController();
  Timer? _timer;
  int _elapsed = 0;
  bool _scrolled80 = false;
  int _minTime = 10;
  String? _trackedLessonKey;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _elapsed >= _minTime) return;
      setState(() => _elapsed++);
    });
  }

  void _onScroll() {
    if (_scrolled80 || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    final threshold = position.maxScrollExtent <= 0
        ? 0.0
        : position.maxScrollExtent * 0.8;
    if (position.pixels >= threshold) {
      setState(() => _scrolled80 = true);
    }
  }

  /// ~30 ký tự/giây — bài ngữ pháp thường ngắn, sàn 10s, trần 45s. Chạy
  /// SAU frame build hiện tại (không setState trong lúc build) khi bài học
  /// đổi (điều hướng "Bài liên quan" trong cùng screen instance).
  void _scheduleReadProgressReset(GrammarLesson lesson) {
    final key = '${lesson.level}:${lesson.id}';
    if (_trackedLessonKey == key) return;
    _trackedLessonKey = key;
    final weight = _estimateContentChars(lesson.contents);
    final minTime = weight ~/ 30 < 10
        ? 10
        : (weight ~/ 30 > 45 ? 45 : weight ~/ 30);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _minTime = minTime;
        _elapsed = 0;
        _scrolled80 = false;
      });
      _startTimer();
      // No scrollable overflow yet on first frame → treat as already
      // satisfied once layout settles (mirrors web: sentinel never
      // off-screen when content fits without scrolling).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;
        if (_scrollController.position.maxScrollExtent <= 0 && !_scrolled80) {
          setState(() => _scrolled80 = true);
        }
      });
    });
  }

  int _estimateContentChars(List<GrammarContentBlock> contents) {
    var total = 0;
    for (final block in contents) {
      switch (block) {
        case GrammarTextBlock(:final text):
          total += text.length;
        case GrammarListBlock(:final items):
          total += items.fold(0, (sum, i) => sum + i.length);
        case GrammarTableBlock(:final rows):
          total += rows.fold(
            0,
            (sum, row) => sum + row.fold(0, (s, c) => s + c.length),
          );
        case GrammarExercisesBlock(:final exercises):
          total += exercises.fold(
            0,
            (sum, e) =>
                sum +
                e.question.length +
                e.answer.length +
                (e.explanation?.length ?? 0),
          );
        case GrammarImageBlock():
          total += 50;
        case GrammarUnknownBlock():
          break;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final key = (level: widget.level, id: widget.id);
    final lessonAsync = ref.watch(grammarLessonProvider(key));
    final completedAsync = ref.watch(grammarCompletedIdsProvider);
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: lessonAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: l10n.grammarNotFound,
            onRetry: () => ref.invalidate(grammarLessonProvider(key)),
          ),
          data: (lesson) {
            _scheduleReadProgressReset(lesson);
            final completed = Set<String>.from(
              completedAsync.value ?? const [],
            );
            final alreadyDone = completed.contains(lesson.id);
            final canComplete = _scrolled80 && _elapsed >= _minTime;
            final canSubmit = alreadyDone || canComplete;

            return ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    AppBackButton(onPressed: () => context.go('/grammar')),
                    const SizedBox(width: 12),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    GrammarLevelBadge(level: lesson.level),
                    if (lesson.tags.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: lesson.tags
                              .map(
                                (t) => DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: tokens.muted,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    child: Text(
                                      t,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: tokens.mutedForeground,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ],
                ),
                if (alreadyDone && !_justCompleted) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.grammarAlreadyCompleted,
                    style: TextStyle(
                      color: tokens.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                AppCard.card(
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
                AppCard.card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          Text(
                            l10n.grammarReadTime(
                              _elapsed > _minTime ? _minTime : _elapsed,
                              _minTime,
                            ),
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.mutedForeground,
                            ),
                          ),
                          Text(
                            _scrolled80
                                ? l10n.grammarScrolled80
                                : l10n.grammarScrollNeeded,
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: _CompleteButton(
                          marking: _marking,
                          justCompleted: _justCompleted,
                          alreadyDone: alreadyDone,
                          enabled: !_justCompleted && canSubmit,
                          onPressed: () => _handleComplete(lesson, alreadyDone),
                        ),
                      ),
                      if (!alreadyDone && !canComplete) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.grammarReadGateHint,
                          style: TextStyle(
                            fontSize: 11,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (lesson.related.isNotEmpty) ...[
                  const SizedBox(height: 16),
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
      ),
    );
  }

  Future<void> _handleComplete(GrammarLesson lesson, bool alreadyDone) async {
    setState(() => _marking = true);
    try {
      await markGrammarComplete(ref, lessonId: lesson.id, level: lesson.level);
      if (mounted) setState(() => _justCompleted = true);
    } catch (_) {
      // Best-effort giống web: lỗi mạng không chặn đọc bài, người dùng có
      // thể bấm lại.
    } finally {
      if (mounted) setState(() => _marking = false);
    }
  }
}

/// Nút hoàn thành 3 trạng thái — web: primary (+5 XP) / amber (hoàn thành
/// lại) / emerald disabled (đã hoàn thành).
class _CompleteButton extends StatelessWidget {
  const _CompleteButton({
    required this.marking,
    required this.justCompleted,
    required this.alreadyDone,
    required this.enabled,
    required this.onPressed,
  });

  final bool marking;
  final bool justCompleted;
  final bool alreadyDone;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    final Color background;
    final String label;
    if (marking) {
      background = tokens.primary;
      label = l10n.grammarSaving;
    } else if (justCompleted) {
      background = tokens.success;
      label = l10n.grammarJustCompleted;
    } else if (alreadyDone) {
      background = tokens.warning;
      label = l10n.grammarMarkCompleteAgain;
    } else {
      background = tokens.primary;
      label = l10n.grammarMarkCompleteXp;
    }

    return Opacity(
      opacity: enabled || marking ? 1 : 0.5,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: (enabled && !marking) ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RelatedLessons extends ConsumerWidget {
  const _RelatedLessons({required this.level, required this.ids});
  final String level;
  final List<String> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(grammarLessonIndexProvider);
    final tokens = context.tokens;
    return indexAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (all) {
        final byId = {for (final l in all) l.id: l};
        final related = ids
            .map((id) => byId[id])
            .whereType<GrammarLessonSummary>()
            .toList();
        if (related.isEmpty) return const SizedBox.shrink();
        return Column(
          children: related
              .map(
                (l) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Material(
                    color: tokens.muted.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => context.push(
                        '/grammar/${l.level.toLowerCase()}/${l.id}',
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          l.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.foreground,
                          ),
                        ),
                      ),
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
