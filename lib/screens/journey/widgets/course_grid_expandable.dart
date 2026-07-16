import 'package:flutter/material.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';
import 'course_card.dart';

/// Vertical list of [CourseCard]s that collapses to the first 4 with a
/// "Xem thêm N khoá" expander — web parity `CourseGrid` (mobile viewport =
/// single column, `INITIAL_VISIBLE = 4`).
class CourseGridExpandable extends StatefulWidget {
  const CourseGridExpandable({
    super.key,
    required this.courses,
    required this.onTapCourse,
    this.lockedSlugs = const {},
  });

  final List<Course> courses;
  final ValueChanged<Course> onTapCourse;
  final Set<String> lockedSlugs;

  static const initialVisible = 4;

  @override
  State<CourseGridExpandable> createState() => _CourseGridExpandableState();
}

class _CourseGridExpandableState extends State<CourseGridExpandable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final hasMore = widget.courses.length > CourseGridExpandable.initialVisible;
    final visible = _expanded
        ? widget.courses
        : widget.courses.take(CourseGridExpandable.initialVisible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final course in visible)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CourseCard(
              course: course,
              locked: widget.lockedSlugs.contains(course.slug),
              onTap: () => widget.onTapCourse(course),
            ),
          ),
        if (hasMore)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _expanded
                        ? l10n.coursesCollapse
                        : l10n.coursesShowMore(widget.courses.length - CourseGridExpandable.initialVisible),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.primary),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? AppPhosphorIcons.caretUp : AppPhosphorIcons.caretDown,
                    size: 14,
                    color: tokens.primary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
