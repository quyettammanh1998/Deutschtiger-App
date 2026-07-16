import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/grammar/grammar_models.dart';
import '../../domain/grammar_curriculum_order.dart';
import '../grammar_level_widgets.dart';
import 'grammar_leaderboard_card.dart';
import 'grammar_search_results.dart';

/// `/grammar?level=X` khi có level — web parity `grammar-level-detail.tsx`:
/// gradient hero + progress ring, search-trong-level, topic sections
/// (border-l-4 accent, expand/collapse, mini progress bar), leaderboard bên
/// dưới (mobile = stacked, không sidebar).
class GrammarLevelDetailView extends StatefulWidget {
  const GrammarLevelDetailView({
    super.key,
    required this.level,
    required this.lessons,
    required this.completed,
  });

  final String level;
  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;

  @override
  State<GrammarLevelDetailView> createState() => _GrammarLevelDetailViewState();
}

class _GrammarLevelDetailViewState extends State<GrammarLevelDetailView> {
  String _query = '';
  final _expanded = <String>{};

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final meta = grammarLevelMeta(widget.level);
    final sorted = sortByCurriculum(widget.lessons);
    final total = sorted.length;
    final done = sorted.where((l) => widget.completed.contains(l.id)).length;

    final query = _query.trim();
    final searchResults = query.isEmpty
        ? null
        : sorted
              .where(
                (l) => normalizeGrammarSearch(
                  l.title,
                ).contains(normalizeGrammarSearch(query)),
              )
              .toList();

    final grouped = <String, List<GrammarLessonSummary>>{};
    for (final lesson in sorted) {
      grouped.putIfAbsent(lessonGroupKey(lesson), () => []).add(lesson);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient hero.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [meta.color, meta.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              GrammarProgressRing(completed: done, total: total, size: 64),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(meta.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 6),
                      Text(
                        widget.level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    meta.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    l10n.grammarCompletedOfTotal(done, total),
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Search-in-level.
        TextField(
          decoration: InputDecoration(
            hintText: l10n.grammarSearchInLevelHint(widget.level),
            prefixIcon: const Icon(Icons.search, size: 18),
            filled: true,
            fillColor: tokens.card,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 16),
        if (searchResults != null)
          GrammarSearchResults(
            results: searchResults,
            completed: widget.completed,
          )
        else ...[
          for (final entry in grouped.entries)
            isSoloGroup(entry.key)
                ? _SoloLessonRow(
                    index: sorted.indexOf(entry.value.first),
                    lesson: entry.value.first,
                    done: widget.completed.contains(entry.value.first.id),
                    ring: meta.color,
                  )
                : _TopicSection(
                    sectionIndex: sorted.indexOf(entry.value.first),
                    topic: entry.value.first.tags.isNotEmpty
                        ? entry.value.first.tags.first
                        : entry.key,
                    lessons: entry.value,
                    completed: widget.completed,
                    level: widget.level,
                    expanded: _expanded.contains(entry.key),
                    onToggle: () => setState(() {
                      if (!_expanded.add(entry.key)) {
                        _expanded.remove(entry.key);
                      }
                    }),
                  ),
        ],
        const SizedBox(height: 16),
        GrammarLeaderboardCard(
          level: widget.level,
          totalLessons: total,
          completedCount: done,
        ),
      ],
    );
  }
}

class _SoloLessonRow extends StatelessWidget {
  const _SoloLessonRow({
    required this.index,
    required this.lesson,
    required this.done,
    required this.ring,
  });
  final int index;
  final GrammarLessonSummary lesson;
  final bool done;
  final Color ring;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: done ? tokens.success.withValues(alpha: 0.06) : tokens.card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push(
            '/grammar/${lesson.level.toLowerCase()}/${lesson.id}',
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: done
                    ? tokens.success.withValues(alpha: 0.3)
                    : tokens.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: done ? tokens.success : ring,
                    shape: BoxShape.circle,
                  ),
                  child: done
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: done ? tokens.success : tokens.foreground,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: tokens.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicSection extends StatelessWidget {
  const _TopicSection({
    required this.sectionIndex,
    required this.topic,
    required this.lessons,
    required this.completed,
    required this.level,
    required this.expanded,
    required this.onToggle,
  });
  final int sectionIndex;
  final String topic;
  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;
  final String level;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final meta = grammarLevelMeta(level);
    final total = lessons.length;
    final done = lessons.where((l) => completed.contains(l.id)).length;
    final allDone = done == total;
    final pct = total > 0 ? done / total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            top: BorderSide(color: tokens.border),
            right: BorderSide(color: tokens.border),
            bottom: BorderSide(color: tokens.border),
            left: BorderSide(color: meta.color, width: 4),
          ),
        ),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: allDone ? tokens.success : tokens.muted,
                          shape: BoxShape.circle,
                        ),
                        child: allDone
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : Text(
                                '${sectionIndex + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: tokens.mutedForeground,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              topic,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: allDone ? tokens.success : meta.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: SizedBox(
                                    width: 80,
                                    height: 6,
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      backgroundColor: tokens.muted,
                                      color: allDone
                                          ? tokens.success
                                          : meta.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$done/$total',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: tokens.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: expanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (expanded)
              Column(
                children: [
                  Divider(height: 1, color: tokens.border),
                  for (var i = 0; i < lessons.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: tokens.border),
                    _SubLessonRow(
                      index: i,
                      lesson: lessons[i],
                      done: completed.contains(lessons[i].id),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SubLessonRow extends StatelessWidget {
  const _SubLessonRow({
    required this.index,
    required this.lesson,
    required this.done,
  });
  final int index;
  final GrammarLessonSummary lesson;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: done ? tokens.success.withValues(alpha: 0.05) : Colors.transparent,
      child: InkWell(
        onTap: () =>
            context.push('/grammar/${lesson.level.toLowerCase()}/${lesson.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: done
                      ? tokens.success.withValues(alpha: 0.15)
                      : tokens.muted,
                  shape: BoxShape.circle,
                ),
                child: done
                    ? Icon(Icons.check, size: 13, color: tokens.success)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: tokens.mutedForeground,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 13,
                    color: done ? tokens.success : tokens.foreground,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 15,
                color: tokens.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
