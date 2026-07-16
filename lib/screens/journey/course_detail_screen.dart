import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/journey/domain/course_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/journey/journey_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/course_lesson_row.dart';
import 'widgets/course_numbered_pagination.dart';
import 'widgets/course_premium_upsell_banner.dart';
import 'widgets/course_progress_ring_card.dart';

const _pageSize = 15;
const _freeLessonLimit = 5;

/// Course detail — lesson list w/ score%/status pills, pagination, progress
/// ring. Web parity `course-detail-page.tsx`.
class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final detailAsync = ref.watch(courseDetailProvider(slug));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: detailAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(onRetry: () => ref.invalidate(courseDetailProvider(slug))),
          data: (detail) => _CourseDetailBody(slug: slug, detail: detail),
        ),
      ),
    );
  }
}

class _CourseDetailBody extends ConsumerStatefulWidget {
  const _CourseDetailBody({required this.slug, required this.detail});
  final String slug;
  final DwCourseDetail detail;

  @override
  ConsumerState<_CourseDetailBody> createState() => _CourseDetailBodyState();
}

class _CourseDetailBodyState extends ConsumerState<_CourseDetailBody> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final progressAsync = ref.watch(courseProgressProvider(widget.slug));
    final progressRows = progressAsync.maybeWhen(data: (rows) => rows, orElse: () => const <int, CourseLessonProgress>{});
    final canAccessAllAsync = ref.watch(courseCanAccessAllProvider);
    final canAccessAll = canAccessAllAsync.maybeWhen(data: (v) => v, orElse: () => true);

    final lessons = [...widget.detail.lessons]..sort((a, b) => a.number.compareTo(b.number));
    if (lessons.isEmpty) {
      return Center(child: Text(l10n.coursesNoLessonsYet));
    }

    final totalPages = (lessons.length / _pageSize).ceil();
    final startIndex = (_page - 1) * _pageSize;
    final pageLessons = lessons.skip(startIndex).take(_pageSize).toList();

    final videosCompleted = progressRows.values.where((p) => p.videoCompleted).length;
    final lessonsStarted = progressRows.length;
    final total = widget.detail.totalLessons;
    final pct = total > 0 ? ((videosCompleted / total) * 100).round() : 0;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(courseDetailProvider(widget.slug));
        ref.invalidate(courseProgressProvider(widget.slug));
        await ref.read(courseDetailProvider(widget.slug).future);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.canPop() ? context.pop() : context.go('/course'),
                  icon: Icon(Icons.arrow_back, color: tokens.foreground),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.detail.name,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: tokens.foreground),
                      ),
                      if ((widget.detail.nameVi ?? '').toLowerCase() != widget.detail.name.toLowerCase())
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.detail.nameVi!,
                            style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    widget.detail.level.name.toUpperCase(),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: tokens.card,
                border: Border.all(color: tokens.border),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < pageLessons.length; i++)
                    CourseLessonRow(
                      lesson: pageLessons[i],
                      progress: progressRows[pageLessons[i].number],
                      locked: !canAccessAll && (startIndex + i) >= _freeLessonLimit,
                      showTopBorder: i > 0,
                      onTap: () => context.push('/course/${widget.slug}/lessons/${pageLessons[i].number}'),
                    ),
                ],
              ),
            ),
            if (!canAccessAll && lessons.length > _freeLessonLimit) ...[
              const SizedBox(height: 12),
              CoursePremiumUpsellBanner(
                title: l10n.coursesUpsellDetailTitle(lessons.length),
                subtitle: l10n.coursesUpsellDetailSubtitle(_freeLessonLimit),
                ctaLabel: l10n.coursesUpsellCta,
              ),
            ],
            const SizedBox(height: 12),
            CourseNumberedPagination(
              page: _page,
              totalPages: totalPages,
              pageSize: _pageSize,
              totalItems: lessons.length,
              onChanged: (p) => setState(() => _page = p),
            ),
            const SizedBox(height: 16),
            CourseProgressRingCard(
              videosCompleted: videosCompleted,
              lessonsStarted: lessonsStarted,
              total: total,
              pct: pct,
            ),
          ],
        ),
      ),
    );
  }
}
