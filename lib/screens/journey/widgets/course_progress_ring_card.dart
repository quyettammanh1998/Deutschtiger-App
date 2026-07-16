import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// "Tiến độ học" card — web parity `ProgressSidebar` ring in
/// `course-detail-page.tsx`. Uses a native [CircularProgressIndicator] ring
/// instead of a hand-drawn SVG circle (visually equivalent, no custom
/// painter needed).
class CourseProgressRingCard extends StatelessWidget {
  const CourseProgressRingCard({
    super.key,
    required this.videosCompleted,
    required this.lessonsStarted,
    required this.total,
    required this.pct,
  });

  final int videosCompleted;
  final int lessonsStarted;
  final int total;
  final int pct;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.coursesProgressTitle,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: pct / 100,
                        strokeWidth: 6,
                        backgroundColor: tokens.muted,
                        valueColor: AlwaysStoppedAnimation(tokens.primary),
                      ),
                    ),
                    Text(
                      '$pct%',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: tokens.foreground),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$videosCompleted/$total ',
                            style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground, fontSize: 13),
                          ),
                          TextSpan(
                            text: l10n.coursesProgressVideosWatched,
                            style: TextStyle(color: tokens.mutedForeground, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$lessonsStarted ',
                            style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground, fontSize: 13),
                          ),
                          TextSpan(
                            text: l10n.coursesProgressLessonsStarted,
                            style: TextStyle(color: tokens.mutedForeground, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
