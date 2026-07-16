import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';

/// One transcript row (timestamp + DE text + optional VI) inside
/// [CourseTranscriptPanel] — tap-to-seek, highlighted when active.
class CourseTranscriptSegmentTile extends StatelessWidget {
  const CourseTranscriptSegmentTile({
    super.key,
    required this.segment,
    required this.isActive,
    required this.showVietnamese,
    required this.onTap,
  });

  final CourseTranscriptSegment segment;
  final bool isActive;
  final bool showVietnamese;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? tokens.primary.withValues(alpha: 0.1) : tokens.background,
          border: Border.all(color: isActive ? tokens.primary : tokens.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              segment.start,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: tokens.primary),
            ),
            Text(segment.text, style: TextStyle(fontSize: 13, color: tokens.foreground)),
            if (showVietnamese && (segment.textVi ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  segment.textVi!,
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
