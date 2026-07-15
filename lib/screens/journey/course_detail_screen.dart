import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../features/journey/domain/course_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/journey/journey_provider.dart';
import '../../widgets/common/async_state_views.dart';

/// Course detail — lesson list with per-lesson progress. Mirrors web
/// `course-detail-page.tsx`. Progress is best-effort: signed-out users or
/// users without the course entitlement simply see lessons unmarked.
class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(courseDetailProvider(slug));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: detailAsync.maybeWhen(
          data: (detail) => Text(detail.nameVi ?? detail.name),
          orElse: () => Text(l10n.coursesHubTitle),
        ),
      ),
      body: SafeArea(
        child: detailAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            onRetry: () => ref.invalidate(courseDetailProvider(slug)),
          ),
          data: (detail) => _CourseDetailBody(slug: slug, detail: detail),
        ),
      ),
    );
  }
}

class _CourseDetailBody extends ConsumerWidget {
  const _CourseDetailBody({required this.slug, required this.detail});

  final String slug;
  final DwCourseDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(courseProgressProvider(slug));
    final progressBySlug = progressAsync.maybeWhen(
      data: (map) => map,
      orElse: () => const <int, CourseLessonProgress>{},
    );

    if (detail.lessons.isEmpty) {
      return Center(child: Text(l10n.coursesNoLessonsYet));
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(courseDetailProvider(slug));
        ref.invalidate(courseProgressProvider(slug));
        await ref.read(courseDetailProvider(slug).future);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        itemCount: detail.lessons.length,
        itemBuilder: (context, index) {
          final lesson = detail.lessons[index];
          final progress = progressBySlug[lesson.number];
          return _LessonTile(slug: slug, lesson: lesson, progress: progress);
        },
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.slug, required this.lesson, this.progress});

  final String slug;
  final DwCourseLessonSummary lesson;
  final CourseLessonProgress? progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCompleted = progress?.videoCompleted ?? false;
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? DesignTokens.success.withValues(alpha: 0.15)
              : DesignTokens.muted,
          child: Icon(
            isCompleted ? Icons.check : Icons.play_arrow,
            color: isCompleted ? DesignTokens.success : DesignTokens.tigerOrange,
          ),
        ),
        title: Text(
          lesson.nameVi ?? lesson.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(l10n.coursesLessonNumber(lesson.number)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            context.push('/journey/courses/$slug/lessons/${lesson.number}'),
      ),
    );
  }
}
