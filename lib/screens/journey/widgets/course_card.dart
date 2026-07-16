import 'package:flutter/material.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';

/// Poster card for one DW course — web parity `CourseCard` in
/// `course-hub-page.tsx`. 16:9 poster, level pill + "DW" source badge
/// overlay, optional lock overlay when beyond the free-course limit.
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.locked = false,
  });

  final Course course;
  final VoidCallback onTap;
  final bool locked;

  /// Web `LEVEL_COLORS` (emerald/sky/amber/purple per CEFR level).
  static const _levelColors = {
    CourseLevel.a1: (bg: Color(0xFFD1FAE5), fg: Color(0xFF047857)),
    CourseLevel.a2: (bg: Color(0xFFE0F2FE), fg: Color(0xFF0369A1)),
    CourseLevel.b1: (bg: Color(0xFFFEF3C7), fg: Color(0xFFB45309)),
    CourseLevel.b2: (bg: Color(0xFFF3E8FF), fg: Color(0xFF7E22CE)),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final color = _levelColors[course.level]!;
    final showNameVi = course.nameVi != null &&
        course.nameVi!.trim().isNotEmpty &&
        course.nameVi!.toLowerCase() != course.name.toLowerCase();

    return Opacity(
      opacity: locked ? 0.6 : 1,
      child: Material(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: course.poster != null
                        ? Image.network(
                            course.poster!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _PosterFallback(tokens: tokens),
                          )
                        : _PosterFallback(tokens: tokens),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        _Badge(label: course.level.name.toUpperCase(), bg: color.bg, fg: color.fg),
                        const SizedBox(width: 4),
                        _Badge(
                          label: 'DW',
                          bg: const Color(0xE6EFF6FF),
                          fg: const Color(0xFF2563EB),
                        ),
                      ],
                    ),
                  ),
                  if (locked)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tokens.background.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppPhosphorIcons.lock, size: 11, color: tokens.mutedForeground),
                            const SizedBox(width: 3),
                            Text(
                              l10n.coursesPremiumLabel,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: tokens.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground),
                    ),
                    if (showNameVi) ...[
                      const SizedBox(height: 2),
                      Text(
                        course.nameVi!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(AppPhosphorIcons.bookOpen, size: 14, color: tokens.mutedForeground),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  course.totalLessons > 0
                                      ? l10n.coursesLessonsCount(course.totalLessons)
                                      : l10n.coursesViewContent,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          locked ? l10n.coursesUnlockArrow : l10n.coursesViewArrow,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.tokens});
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tokens.muted,
      alignment: Alignment.center,
      child: Icon(AppPhosphorIcons.videoCamera, size: 32, color: tokens.mutedForeground.withValues(alpha: 0.4)),
    );
  }
}
