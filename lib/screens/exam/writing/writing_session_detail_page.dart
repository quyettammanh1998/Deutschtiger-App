import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/writing/domain/writing_exam_id_parser.dart';
import '../../../features/writing/domain/writing_submission_meta.dart';
import '../../../features/writing/presentation/widgets/grading_result_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/common/gradient_button.dart';
import 'widgets/hub/writing_submissions_tab.dart' show allWritingSubmissionsProvider;
import 'widgets/session_detail/grading_attempt_timeline.dart';

/// `writing-session-detail` (`/writing-practice/:id`) — read-only view of one
/// graded writing submission + "Luyện lại" + grading-attempt timeline. Web
/// parity `WritingSessionDetailPage`.
class WritingSessionDetailPage extends ConsumerWidget {
  const WritingSessionDetailPage({super.key, required this.submissionId});

  final String submissionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(allWritingSubmissionsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: async.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: l10n.couldNotLoadData,
            onRetry: () => ref.invalidate(allWritingSubmissionsProvider),
          ),
          data: (submissions) {
            final submission = submissions.where((s) => s.id == submissionId).firstOrNull;
            final parsed = submission == null ? null : parseWritingExamId(submission.examId);
            if (submission == null || parsed == null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.push('/luyen-viet')),
                        Expanded(
                          child: Text(
                            l10n.writingSessionTitleFallback,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Center(
                      child: Text(
                        l10n.writingSessionNotFound,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                      ),
                    ),
                  ],
                ),
              );
            }

            final meta = getWritingSubmissionMeta(parsed: parsed, taskPrompt: submission.taskPrompt);
            final canPracticeAgain = meta.isCustom || meta.practiceRoute != null;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.push('/luyen-viet')),
                    Expanded(
                      child: Text(
                        meta.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        meta.badge,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (canPracticeAgain)
                  GradientButton(
                    label: l10n.writingSessionPracticeAgain,
                    onPressed: () {
                      if (meta.isCustom) {
                        context.push(
                          '/luyen-viet/tu-nhap'
                          '?taskPrompt=${Uri.encodeComponent(submission.taskPrompt)}'
                          '&provider=${meta.provider}&level=${meta.level}'
                          '${meta.teil != null ? '&teil=${meta.teil}' : ''}',
                        );
                      } else if (meta.practiceRoute != null) {
                        context.push(meta.practiceRoute!);
                      }
                    },
                  ),
                const SizedBox(height: 16),
                _ReadOnlyBlock(
                  title: l10n.communitySectionTask,
                  content: submission.taskPrompt,
                  muted: true,
                ),
                const SizedBox(height: 12),
                _ReadOnlyBlock(
                  title: l10n.writingSessionYourAnswer,
                  content: submission.studentAnswer,
                  muted: false,
                ),
                if (submission.aiFeedback != null) ...[
                  const SizedBox(height: 16),
                  GradingResultCard(result: submission.aiFeedback!),
                ],
                GradingAttemptTimeline(submissionId: submission.id),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReadOnlyBlock extends StatelessWidget {
  const _ReadOnlyBlock({required this.title, required this.content, required this.muted});

  final String title;
  final String content;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: muted ? tokens.muted.withValues(alpha: 0.4) : tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: muted ? null : Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 6),
          Text(content, style: TextStyle(fontSize: 13, color: tokens.foreground, height: 1.4)),
        ],
      ),
    );
  }
}
