import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../view_models/journey/journey_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/course_hub_header.dart';
import 'widgets/course_hub_sections.dart';

/// Courses Hub — DW course catalog: search, stats bar, level-jump pills, "my
/// courses"/"featured" sections, premium upsell, per-level poster grids.
/// Web parity `course-hub-page.tsx`.
class CoursesHubScreen extends ConsumerStatefulWidget {
  const CoursesHubScreen({super.key});

  @override
  ConsumerState<CoursesHubScreen> createState() => _CoursesHubScreenState();
}

class _CoursesHubScreenState extends ConsumerState<CoursesHubScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _levelKeys = <String, GlobalKey>{};
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLevel(String level) {
    final key = _levelKeys[level];
    final ctx = key?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final catalogAsync = ref.watch(courseCatalogProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(onRetry: () => ref.invalidate(courseCatalogProvider)),
          data: (groups) {
            for (final g in groups) {
              _levelKeys.putIfAbsent(g.level, () => GlobalKey());
            }
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(courseCatalogProvider);
                ref.invalidate(featuredCoursesProvider);
                ref.invalidate(myCoursesProvider);
                await ref.read(courseCatalogProvider.future);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CourseHubStatsBar(groups: groups),
                    const SizedBox(height: 16),
                    CourseSearchField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _search = v),
                    ),
                    const SizedBox(height: 12),
                    if (_search.trim().isEmpty)
                      CourseLevelJumpPills(groups: groups, onTapLevel: _scrollToLevel),
                    const SizedBox(height: 16),
                    if (_search.trim().isNotEmpty)
                      CourseHubSearchResults(query: _search, groups: groups)
                    else
                      CourseHubBody(groups: groups, levelKeys: _levelKeys),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
