import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../domain/grammar_curriculum_order.dart';
import 'grammar_provider.dart';
import 'widgets/grammar_home_grid.dart';
import 'widgets/grammar_level_detail_view.dart';
import 'widgets/grammar_search_results.dart';

/// Grammar hub — web parity `grammar-list-page.tsx`: header + global search
/// (mọi màn hình con), rồi tuỳ trạng thái: kết quả tìm kiếm / level detail /
/// (bản đồ ngữ pháp bỏ qua — không có backend endpoint sống, xem ghi chú
/// dưới) + level grid (2-col gradient cards).
///
/// Deviation: web's `GrammarMap` ("Bản đồ ngữ pháp") calls `GET
/// /user/grammar-map`, which this backend snapshot does not register
/// (`grep` across `cmd/server/routes_*.go` — no match). Web itself renders
/// nothing when that query errors (`if (isError || !topics) return null`),
/// so omitting the section here reproduces the *live* web behavior exactly,
/// not a shortcut — building it against a non-existent endpoint would mean
/// fabricating fake data. Offline-sync banner similarly omitted: `OfflineService`
/// (`lib/services/offline/offline_service.dart`) documents an explicit
/// product decision that this app does NOT queue writes for offline replay
/// (no idempotent outbox contract yet) — a grammar-specific sync queue would
/// contradict that decision; `markGrammarComplete` keeps its existing
/// best-effort retry-on-tap behavior instead.
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

  void _goHome() => context.go('/grammar');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final level = _level;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final lessonsAsync = ref.watch(grammarLessonIndexProvider);
            final completedAsync = ref.watch(grammarCompletedIdsProvider);
            return lessonsAsync.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                onRetry: () => ref.invalidate(grammarLessonIndexProvider),
              ),
              data: (lessons) {
                final completed = Set<String>.from(
                  completedAsync.value ?? const [],
                );
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        if (level != null)
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _goHome,
                          )
                        else
                          const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            level != null
                                ? '${l10n.grammar} $level'
                                : l10n.grammar,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: tokens.foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: l10n.grammarSearchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => _searchQuery = ''),
                              )
                            : null,
                        filled: true,
                        fillColor: tokens.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (q) => setState(() => _searchQuery = q),
                    ),
                    const SizedBox(height: 16),
                    if (_searchQuery.trim().isNotEmpty)
                      _GlobalSearchResults(
                        query: _searchQuery,
                        lessons: lessons,
                        completed: completed,
                      )
                    else if (level != null)
                      GrammarLevelDetailView(
                        level: level,
                        lessons: lessons
                            .where((l) => l.level == level)
                            .toList(),
                        completed: completed,
                      )
                    else
                      GrammarHomeGrid(lessons: lessons, completed: completed),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _GlobalSearchResults extends StatelessWidget {
  const _GlobalSearchResults({
    required this.query,
    required this.lessons,
    required this.completed,
  });
  final String query;
  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final q = normalizeGrammarSearch(query.trim());
    final results = sortByCurriculum(
      lessons
          .where((l) => normalizeGrammarSearch(l.title).contains(q))
          .toList(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            l10n.grammarSearchResultsCount(results.length, query.trim()),
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
        ),
        GrammarSearchResults(
          results: results,
          completed: completed,
          showLevelPill: true,
        ),
      ],
    );
  }
}
