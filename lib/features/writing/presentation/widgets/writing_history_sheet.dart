import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/writing_repository.dart';
import '../../domain/writing_submission.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Past-submission history bottom sheet for one `examId` — web parity
/// `components/exam/history/writing-history-sheet.tsx`. Opened from the
/// clock-icon button in [WritingPracticePanel]'s header row.
class WritingHistorySheet extends ConsumerWidget {
  const WritingHistorySheet({super.key, required this.examId});

  final String examId;

  static Future<void> show(BuildContext context, {required String examId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => WritingHistorySheet(examId: examId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final submissionsAsync = ref.watch(_writingHistoryProvider(examId));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: tokens.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.writingHistoryTitle,
                        style: TextStyle(fontWeight: FontWeight.bold, color: tokens.foreground),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(PhosphorIcons.x),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: submissionsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(
                    child: Text(l10n.writingHistoryEmpty, style: TextStyle(color: tokens.mutedForeground)),
                  ),
                  data: (submissions) => submissions.isEmpty
                      ? Center(
                          child: Text(
                            l10n.writingHistoryEmpty,
                            style: TextStyle(color: tokens.mutedForeground),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: submissions.length,
                          itemBuilder: (context, i) =>
                              _SubmissionTile(submission: submissions[i], l10n: l10n),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubmissionTile extends StatelessWidget {
  const _SubmissionTile({required this.submission, required this.l10n});
  final WritingSubmission submission;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final score = submission.aiScore;
    final scoreColor = score == null
        ? tokens.mutedForeground
        : score >= 80
        ? tokens.success
        : score >= 60
        ? tokens.warning
        : tokens.destructive;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  submission.studentAnswer,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: tokens.foreground),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(submission.submittedAt),
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          if (score != null) ...[
            const SizedBox(width: 8),
            Text(
              '$score/100',
              style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

final _writingHistoryProvider = FutureProvider.family<List<WritingSubmission>, String>((
  ref,
  examId,
) {
  return ref.watch(writingRepositoryProvider).listSubmissions(examId);
});
