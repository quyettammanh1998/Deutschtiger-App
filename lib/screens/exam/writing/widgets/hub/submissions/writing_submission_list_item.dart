import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_tokens.dart';
import '../../../../../../features/writing/domain/writing_submission.dart';
import '../../../../../../features/writing/domain/writing_submission_meta.dart';

/// One row in "Bài của tôi" — web parity `SubmissionListItem`
/// (`components/ai-writing-practice/submission-list-item.tsx`): badge pill +
/// title, 100-char snippet, date, right colored score.
class WritingSubmissionListItem extends StatelessWidget {
  const WritingSubmissionListItem({
    super.key,
    required this.submission,
    required this.meta,
  });

  final WritingSubmission submission;
  final WritingSubmissionMeta meta;

  Color _scoreColor(int? score, AppTokens tokens) {
    if (score == null) return tokens.mutedForeground;
    if (score >= 80) return const Color(0xFF16A34A);
    if (score >= 60) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final snippet = submission.studentAnswer.length > 100
        ? '${submission.studentAnswer.substring(0, 100)}…'
        : submission.studentAnswer;
    final date = DateFormat('dd/MM/yyyy HH:mm').format(submission.submittedAt.toLocal());

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/writing-practice/${submission.id}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: tokens.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text(
                            meta.badge,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: tokens.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meta.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
                  ),
                  if (snippet.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(date, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              submission.aiScore != null ? '${submission.aiScore}/100' : '—',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _scoreColor(submission.aiScore, tokens),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
