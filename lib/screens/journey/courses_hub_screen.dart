import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../features/journey/domain/course_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/journey/journey_provider.dart';
import '../../widgets/common/async_state_views.dart';

/// Courses Hub — DW course catalog: featured, in-progress ("my courses") and
/// the full catalog grouped by CEFR level. Mirrors web `course-hub-page.tsx`.
class CoursesHubScreen extends ConsumerWidget {
  const CoursesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(courseCatalogProvider);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: Text(l10n.coursesHubTitle),
      ),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            onRetry: () => ref.invalidate(courseCatalogProvider),
          ),
          data: (groups) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(courseCatalogProvider);
              ref.invalidate(featuredCoursesProvider);
              ref.invalidate(myCoursesProvider);
              await ref.read(courseCatalogProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: DesignTokens.spacingMd,
              ),
              children: [
                _FeaturedSection(l10n: l10n),
                const _MyCoursesSection(),
                if (groups.every((g) => g.courses.isEmpty))
                  Padding(
                    padding: const EdgeInsets.all(DesignTokens.spacingLg),
                    child: Center(child: Text(l10n.coursesEmptyCatalog)),
                  )
                else
                  for (final group in groups)
                    if (group.courses.isNotEmpty) _LevelSection(group: group),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedSection extends ConsumerWidget {
  const _FeaturedSection({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredCoursesProvider);
    return featuredAsync.when(
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (courses) {
        if (courses.isEmpty) return const SizedBox.shrink();
        return _HorizontalCourseSection(
          title: l10n.coursesFeaturedSection,
          courses: courses,
        );
      },
    );
  }
}

class _MyCoursesSection extends ConsumerWidget {
  const _MyCoursesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final myCoursesAsync = ref.watch(myCoursesProvider);
    return myCoursesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();
        return Consumer(
          builder: (context, ref, _) {
            final coursesAsync = ref.watch(courseCatalogProvider);
            return coursesAsync.maybeWhen(
              data: (groups) {
                final bySlug = {
                  for (final g in groups.courses) g.slug: g,
                };
                final courses = entries
                    .map((e) => bySlug[e.courseSlug])
                    .whereType<Course>()
                    .toList();
                if (courses.isEmpty) return const SizedBox.shrink();
                return _HorizontalCourseSection(
                  title: l10n.coursesMySection,
                  courses: courses,
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}

extension on List<CourseGroup> {
  List<Course> get courses => expand((g) => g.courses).toList();
}

class _HorizontalCourseSection extends StatelessWidget {
  const _HorizontalCourseSection({required this.title, required this.courses});

  final String title;
  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.screenHorizontalPadding,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DesignTokens.foreground,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.screenHorizontalPadding,
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: DesignTokens.spacingSm),
              child: _CoursePosterCard(course: courses[index]),
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
      ],
    );
  }
}

class _CoursePosterCard extends StatelessWidget {
  const _CoursePosterCard({required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: GestureDetector(
        onTap: () => context.push('/journey/courses/${course.slug}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              child: SizedBox(
                width: 160,
                height: 90,
                child: course.poster != null
                    ? Image.network(
                        course.poster!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _PosterFallback(),
                      )
                    : const _PosterFallback(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXs),
            Text(
              course.nameVi ?? course.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignTokens.muted,
      alignment: Alignment.center,
      child: const Icon(Icons.play_circle_outline, color: DesignTokens.tigerOrange),
    );
  }
}

class _LevelSection extends StatelessWidget {
  const _LevelSection({required this.group});
  final CourseGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            DesignTokens.screenHorizontalPadding,
            DesignTokens.spacingMd,
            DesignTokens.screenHorizontalPadding,
            DesignTokens.spacingSm,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: DesignTokens.tigerOrange,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Text(
                  group.label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Text(l10n.coursesAllSection, style: const TextStyle(color: DesignTokens.mutedForeground)),
            ],
          ),
        ),
        for (final course in group.courses) _CourseListTile(course: course),
      ],
    );
  }
}

class _CourseListTile extends StatelessWidget {
  const _CourseListTile({required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
        vertical: DesignTokens.spacingXs,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding: const EdgeInsets.all(DesignTokens.spacingSm),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            child: SizedBox(
              width: 56,
              height: 42,
              child: course.poster != null
                  ? Image.network(
                      course.poster!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _PosterFallback(),
                    )
                  : const _PosterFallback(),
            ),
          ),
          title: Text(
            course.nameVi ?? course.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(l10n.coursesLessonsCount(course.totalLessons)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/journey/courses/${course.slug}'),
        ),
      ),
    );
  }
}
