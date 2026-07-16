import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';

const Map<String, String> _examTypeLabels = {
  'goethe': 'Goethe',
  'telc': 'telc',
  'osd': 'ÖSD',
  'testdaf_dsh': 'TestDaF/DSH',
  'ecl': 'ECL',
};

final Map<String, IconData> _skillIcons = {
  'lesen': AppPhosphorIcons.bookOpen,
  'hoeren': AppPhosphorIcons.headphones,
  'schreiben': AppPhosphorIcons.pencilSimple,
  'sprechen': AppPhosphorIcons.speakerHigh,
};

const Map<String, String> _skillShort = {
  'lesen': 'Đọc',
  'hoeren': 'Nghe',
  'schreiben': 'Viết',
  'sprechen': 'Nói',
};

/// One buddy directory row — avatar, days badge, exam type/level/date,
/// skill chips. Mirrors web `ExamBuddyList` row (contact-reveal omitted:
/// `GET /user/exam-buddies/{id}/contact` is a known backend gap — see
/// `exam_registration_repository.dart` header comment).
class BuddyCard extends StatelessWidget {
  const BuddyCard({super.key, required this.buddy});

  final ExamBuddy buddy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final past = buddy.daysUntil < 0;

    return Opacity(
      opacity: past ? 0.55 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(tokens.radius),
          border: Border.all(color: tokens.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: tokens.primary.withValues(alpha: 0.1),
                backgroundImage: buddy.avatarUrl.isNotEmpty
                    ? NetworkImage(buddy.avatarUrl)
                    : null,
                child: buddy.avatarUrl.isEmpty
                    ? Text(
                        buddy.displayName.isNotEmpty
                            ? buddy.displayName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: tokens.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          buddy.displayName.isNotEmpty
                              ? buddy.displayName
                              : 'Ẩn danh',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: tokens.foreground,
                          ),
                        ),
                        _DaysBadge(days: buddy.daysUntil),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_examTypeLabels[buddy.examType] ?? buddy.examType.toUpperCase()} · '
                      '${buddy.examLevel} · 📅 ${buddy.examDate}'
                      '${buddy.location.isNotEmpty ? ' · 📍 ${buddy.location}' : ''}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: tokens.mutedForeground,
                      ),
                    ),
                    if (buddy.skills.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final skill in buddy.skills)
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: tokens.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _skillIcons[skill] ??
                                          AppPhosphorIcons.bookOpen,
                                      size: 12,
                                      color: tokens.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _skillShort[skill] ?? skill,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: tokens.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
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

class _DaysBadge extends StatelessWidget {
  const _DaysBadge({required this.days});
  final int days;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final String label;
    final Color color;
    if (days < 0) {
      label = 'Đã thi ${-days} ngày trước';
      color = tokens.mutedForeground;
    } else if (days == 0) {
      label = 'Thi hôm nay!';
      color = tokens.destructive;
    } else if (days <= 14) {
      label = 'Còn $days ngày';
      color = tokens.destructive;
    } else if (days <= 45) {
      label = 'Còn $days ngày';
      color = tokens.warning;
    } else {
      label = 'Còn $days ngày';
      color = tokens.success;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
