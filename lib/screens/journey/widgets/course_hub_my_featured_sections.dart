import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/journey/journey_provider.dart';
import 'course_card.dart';
import 'course_grid_expandable.dart';

/// "Khoá học của tôi" section — web `myCourses` block in `course-hub-page.tsx`.
class CourseHubMySection extends ConsumerWidget {
  const CourseHubMySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
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
                final bySlug = {for (final c in groups.expand((g) => g.courses)) c.slug: c};
                final courses =
                    entries.map((e) => bySlug[e.courseSlug]).whereType<Course>().toList();
                if (courses.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(AppPhosphorIcons.graduationCap, size: 16, color: tokens.primary),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.coursesMySection,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tokens.foreground),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      for (final c in courses)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CourseCard(course: c, onTap: () => context.push('/course/${c.slug}')),
                        ),
                    ],
                  ),
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

/// "Nổi bật" section — web `featuredCourses` block in `course-hub-page.tsx`.
class CourseHubFeaturedSection extends ConsumerWidget {
  const CourseHubFeaturedSection({super.key, required this.lockedSlugs});
  final Set<String> lockedSlugs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final featuredAsync = ref.watch(featuredCoursesProvider);
    return featuredAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (courses) {
        if (courses.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(AppPhosphorIcons.star, size: 16, color: const Color(0xFFF59E0B)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l10n.coursesFeaturedSection,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tokens.foreground),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CourseGridExpandable(
                courses: courses,
                lockedSlugs: lockedSlugs,
                onTapCourse: (c) => context.push('/course/${c.slug}'),
              ),
            ],
          ),
        );
      },
    );
  }
}
