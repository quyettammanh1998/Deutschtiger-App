import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Web parity `StatsBar` in `course-hub-page.tsx`: back button + title +
/// subtitle, "N khoá · M+ bài học" counts, per-level pill counts.
class CourseHubStatsBar extends StatelessWidget {
  const CourseHubStatsBar({super.key, required this.groups});

  final List<CourseGroup> groups;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final allCourses = groups.expand((g) => g.courses).toList();
    final totalCourses = allCourses.length;
    final totalLessons = allCourses.fold<int>(0, (sum, c) => sum + c.totalLessons);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
              icon: Icon(PhosphorIcons.arrowLeft, color: tokens.foreground),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.coursesHubTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tokens.foreground),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.coursesHubSubtitle,
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              l10n.coursesCount(totalCourses),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: tokens.mutedForeground),
            ),
            Text(
              l10n.coursesLessonsCountPlus(totalLessons),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: tokens.mutedForeground),
            ),
          ],
        ),
      ],
    );
  }
}

/// Search input — web `MagnifyingGlass` input with clear button.
class CourseSearchField extends StatelessWidget {
  const CourseSearchField({super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: l10n.coursesSearchHint,
        prefixIcon: Icon(AppPhosphorIcons.magnifyingGlass, size: 18, color: tokens.mutedForeground),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: Icon(AppPhosphorIcons.x, size: 16, color: tokens.mutedForeground),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              ),
        filled: true,
        fillColor: tokens.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tokens.border),
        ),
      ),
    );
  }
}

/// Level-jump pill row — tapping scrolls the hub list to that level section.
class CourseLevelJumpPills extends StatelessWidget {
  const CourseLevelJumpPills({super.key, required this.groups, required this.onTapLevel});

  final List<CourseGroup> groups;
  final ValueChanged<String> onTapLevel;

  @override
  Widget build(BuildContext context) {
    final color = {
      'a1': (bg: const Color(0xFFD1FAE5), fg: const Color(0xFF047857)),
      'a2': (bg: const Color(0xFFE0F2FE), fg: const Color(0xFF0369A1)),
      'b1': (bg: const Color(0xFFFEF3C7), fg: const Color(0xFFB45309)),
      'b2': (bg: const Color(0xFFF3E8FF), fg: const Color(0xFF7E22CE)),
    };
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final g in groups)
          if (g.courses.isNotEmpty)
            InkWell(
              onTap: () => onTapLevel(g.level),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color[g.level]?.bg ?? Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${g.label} · ${g.courses.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color[g.level]?.fg ?? Colors.grey.shade700,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
