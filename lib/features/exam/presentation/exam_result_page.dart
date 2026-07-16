// ignore_for_file: prefer_initializing_formals
//
// Wave B — Exam result page rebuild (web parity).
//
// Web source of truth: `exam-result-page.tsx` — header (back + title) →
// ResultSummary → SmartExamReviewCard → (NextActionCard, omitted — no
// Flutter data source, see report) → AttemptHistoryList → CommentSection.
// Score/attempt contract giữ nguyên (`exam_player_provider.dart`).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/exam_models.dart';
import 'exam_player_provider.dart';
import 'widgets/mobile_player/exam_comment_section.dart';
import 'widgets/result/attempt_history_list.dart';
import 'widgets/result/result_summary_card.dart';
import 'widgets/result/smart_review_card.dart';

class ExamResultPage extends ConsumerWidget {
  const ExamResultPage({super.key, required this.examId});
  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final examAsync = ref.watch(examByIdProvider(examId));
    final resultAsync = ref.watch(examResultProvider(examId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: examAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.couldNotLoadExamResult)),
          data: (exam) => resultAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(child: Text(l10n.couldNotLoadExamResult)),
            data: (attempt) => attempt == null
                ? Center(child: Text(l10n.noExamResult))
                : _ResultBody(exam: exam, attempt: attempt, examId: examId),
          ),
        ),
      ),
    );
  }
}

class _ResultBody extends StatelessWidget {
  const _ResultBody({
    required this.exam,
    required this.attempt,
    required this.examId,
  });

  final Exam exam;
  final ExamAttempt attempt;
  final String examId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () =>
                    context.go('/exam/practice/${exam.id}?mode=review'),
                icon: Icon(Icons.arrow_back, color: tokens.foreground),
              ),
              Expanded(
                child: Text(
                  exam.title.isNotEmpty
                      ? exam.title
                      : l10n.examResultHeaderFallback,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: tokens.foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
        ResultSummaryCard(
          exam: exam,
          attempt: attempt,
          onRetry: () =>
              context.push('/exam/practice/${exam.id}?mode=practice'),
          onReview: () => context.push('/exam/practice/${exam.id}?mode=review'),
        ),
        const SizedBox(height: 12),
        SmartReviewCard(
          exam: exam,
          attempt: attempt,
          onJumpToWrong: () =>
              context.push('/exam/practice/${exam.id}?mode=review'),
          onPractice: () =>
              context.push('/exam/practice/${exam.id}?mode=practice'),
        ),
        const SizedBox(height: 12),
        AttemptHistoryList(examId: exam.id),
        const SizedBox(height: 12),
        ExamCommentSection(examId: exam.id),
      ],
    );
  }
}
