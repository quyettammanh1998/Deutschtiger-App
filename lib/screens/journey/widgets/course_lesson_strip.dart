import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';

/// Horizontal lesson-switcher chip strip — web parity "Danh sách bài" in
/// `course-lesson-page.tsx` (`min-w-[110px]` chips, "Bài NN").
class CourseLessonStrip extends StatelessWidget {
  const CourseLessonStrip({
    super.key,
    required this.lessons,
    required this.currentNumber,
    required this.lockedFrom,
    required this.onTap,
  });

  final List<DwCourseLessonSummary> lessons;
  final int currentNumber;
  final int? lockedFrom;
  final ValueChanged<DwCourseLessonSummary> onTap;

  @override
  Widget build(BuildContext context) {
    if (lessons.length <= 1) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.coursesLessonStripTitle,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
                ),
              ),
              Text(
                '$currentNumber/${lessons.length}',
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  for (var index = 0; index < lessons.length; index++) ...[
                    if (index > 0) const SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        final item = lessons[index];
                        final isCurrent = item.number == currentNumber;
                        final isLocked = lockedFrom != null && index >= lockedFrom!;
                        return InkWell(
                          onTap: isLocked ? null : () => onTap(item),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 130,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isCurrent ? tokens.primary.withValues(alpha: 0.1) : tokens.background,
                              border: Border.all(color: isCurrent ? tokens.primary : tokens.border),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Opacity(
                              opacity: isLocked ? 0.5 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.coursesLessonNumberShort(item.number.toString().padLeft(2, '0')),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isCurrent ? tokens.primary : tokens.foreground,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
