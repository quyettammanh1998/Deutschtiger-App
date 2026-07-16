import 'package:flutter/material.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';

/// One lesson row in the course-detail lesson list — web parity: 80x48
/// poster thumb, "Bài NN" primary + name/name_vi, right pill = emerald
/// "Hoàn thành" / amber "N%" / muted "Chưa học" / lock "Premium".
class CourseLessonRow extends StatelessWidget {
  const CourseLessonRow({
    super.key,
    required this.lesson,
    required this.progress,
    required this.locked,
    required this.showTopBorder,
    required this.onTap,
  });

  final DwCourseLessonSummary lesson;
  final CourseLessonProgress? progress;
  final bool locked;
  final bool showTopBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final isComplete = progress?.videoCompleted ?? false;
    final score = progress?.scorePercentage ?? 0;

    return Opacity(
      opacity: locked ? 0.5 : 1,
      child: InkWell(
        onTap: locked ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: showTopBorder ? Border(top: BorderSide(color: tokens.border)) : null,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 48,
                  child: lesson.poster != null && lesson.poster!.isNotEmpty
                      ? Image.network(
                          lesson.poster!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(color: tokens.muted),
                        )
                      : Container(color: tokens.muted),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            l10n.coursesLessonNumberShort(lesson.number.toString().padLeft(2, '0')),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.primary),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            lesson.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: tokens.foreground),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lesson.nameVi ?? lesson.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 96),
                child: _statusPill(context, l10n, tokens, isComplete: isComplete, score: score),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(
    BuildContext context,
    AppLocalizations l10n,
    AppTokens tokens, {
    required bool isComplete,
    required int score,
  }) {
    if (locked) {
      return _Pill(
        bg: tokens.muted,
        fg: tokens.mutedForeground,
        icon: AppPhosphorIcons.lock,
        label: l10n.coursesPremiumLabel,
      );
    }
    if (progress == null) {
      return _Pill(bg: tokens.muted, fg: tokens.mutedForeground, label: l10n.coursesLessonNotStarted);
    }
    if (isComplete) {
      return _Pill(
        bg: const Color(0xFFD1FAE5),
        fg: const Color(0xFF047857),
        label: l10n.coursesLessonCompleted,
      );
    }
    return _Pill(
      bg: const Color(0xFFFEF3C7),
      fg: const Color(0xFFB45309),
      label: '$score%',
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.bg, required this.fg, required this.label, this.icon});
  final Color bg;
  final Color fg;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
            ),
          ),
        ],
      ),
    );
  }
}
