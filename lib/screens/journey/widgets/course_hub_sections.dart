import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/journey/journey_provider.dart';
import 'course_card.dart';
import 'course_grid_expandable.dart';
import 'course_hub_my_featured_sections.dart';
import 'course_premium_upsell_banner.dart';

const kCourseHubFreeLimit = 5;

/// Search-result list — web `filteredCourses` block in `course-hub-page.tsx`.
class CourseHubSearchResults extends StatelessWidget {
  const CourseHubSearchResults({super.key, required this.query, required this.groups});
  final String query;
  final List<CourseGroup> groups;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final trimmed = query.trim().toLowerCase();
    final all = groups.expand((g) => g.courses).toList();
    final results = all
        .where((c) =>
            c.name.toLowerCase().contains(trimmed) ||
            (c.nameVi ?? '').toLowerCase().contains(trimmed))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          results.isNotEmpty
              ? l10n.coursesSearchResultsCount(results.length, query.trim())
              : l10n.coursesSearchNoResults(query.trim()),
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.mutedForeground),
        ),
        const SizedBox(height: 8),
        for (final c in results)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CourseCard(course: c, onTap: () => context.push('/course/${c.slug}')),
          ),
      ],
    );
  }
}

/// Normal (non-search) hub body: my-courses, featured, upsell, level
/// sections — web `!isSearching` branch in `course-hub-page.tsx`.
class CourseHubBody extends ConsumerWidget {
  const CourseHubBody({super.key, required this.groups, required this.levelKeys});
  final List<CourseGroup> groups;
  final Map<String, GlobalKey> levelKeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final allCourses = groups.expand((g) => g.courses).toList();
    final canAccessAllAsync = ref.watch(courseCanAccessAllProvider);
    final canAccessAll = canAccessAllAsync.maybeWhen(data: (v) => v, orElse: () => true);
    final lockedSlugs = canAccessAll
        ? const <String>{}
        : allCourses.skip(kCourseHubFreeLimit).map((c) => c.slug).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CourseHubMySection(),
        CourseHubFeaturedSection(lockedSlugs: lockedSlugs),
        if (!canAccessAll && allCourses.length > kCourseHubFreeLimit)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CoursePremiumUpsellBanner(
              title: l10n.coursesUpsellHubTitle(allCourses.length),
              subtitle: l10n.coursesUpsellHubSubtitle(kCourseHubFreeLimit),
              ctaLabel: l10n.coursesUpsellCta,
            ),
          ),
        if (groups.every((g) => g.courses.isEmpty))
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text(l10n.coursesEmptyCatalog)),
          )
        else
          for (final group in groups)
            Container(
              key: levelKeys[group.level],
              padding: const EdgeInsets.only(bottom: 16),
              child: _LevelSection(group: group, lockedSlugs: lockedSlugs),
            ),
      ],
    );
  }
}

class _LevelSection extends StatelessWidget {
  const _LevelSection({required this.group, required this.lockedSlugs});
  final CourseGroup group;
  final Set<String> lockedSlugs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                l10n.coursesLevelHeading(group.label),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tokens.foreground),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.coursesLessonsCount(group.courses.length),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (group.courses.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: tokens.border, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(l10n.coursesLevelEmpty, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
          )
        else
          CourseGridExpandable(
            courses: group.courses,
            lockedSlugs: lockedSlugs,
            onTapCourse: (c) => context.push('/course/${c.slug}'),
          ),
      ],
    );
  }
}
