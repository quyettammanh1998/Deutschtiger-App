import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/page_intro.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/readiness/readiness_band_card.dart';
import 'widgets/readiness/readiness_goal_header.dart';
import 'widgets/readiness/readiness_score_trend.dart';
import 'widgets/readiness/readiness_skill_bars.dart';
import 'widgets/readiness/readiness_stat_pills.dart';
import 'widgets/readiness/readiness_todo_card.dart';
import 'widgets/readiness/readiness_weakness_list.dart';

/// Màn đánh giá mức sẵn sàng thi — web parity rebuild of
/// `exam-readiness-page.tsx`: goal header, colored readiness band, stat
/// pills, score trend sparkline, per-skill bars, and grammar weakness list.
/// `GET /api/v1/exam-readiness`.
///
/// GAP: web also shows a "Từ thi sai" checklist (fail words → add to SRS
/// review) backed by `fetchExamFailWords`/`addExamFailWordsToReview`. Neither
/// endpoint has a Flutter repository/provider yet (no fail-word list data
/// source at all, not even read) — omitted rather than faked. See the phase
/// report for the exact endpoints to wire up.
class ExamReadinessScreen extends ConsumerWidget {
  const ExamReadinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final readiness = ref.watch(examReadinessProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(title: Text(l10n.examReadinessTitle)),
      body: readiness.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.couldNotLoadData,
          onRetry: () => ref.invalidate(examReadinessProvider),
        ),
        data: (snapshot) => _ReadinessBody(snapshot: snapshot),
      ),
    );
  }
}

class _ReadinessBody extends StatelessWidget {
  const _ReadinessBody({required this.snapshot});
  final ExamReadinessSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const PageIntro(
          pageKey: 'exam-readiness',
          why: 'Xem bạn đã sẵn sàng cho kỳ thi tới mức nào, theo từng kỹ năng.',
          todo: 'Nhìn kỹ năng yếu nhất và bấm luyện ngay.',
          next: 'Luyện xong quay lại xem điểm cải thiện.',
        ),
        const SizedBox(height: 12),
        const ReadinessGoalHeader(),
        const SizedBox(height: 12),
        if (snapshot.attemptCount == 0)
          const ReadinessBandEmptyCard()
        else ...[
          ReadinessBandCard(snapshot: snapshot),
          const SizedBox(height: 12),
          ReadinessStatPills(snapshot: snapshot),
          const SizedBox(height: 12),
          ReadinessScoreTrend(trend: snapshot.scoreTrend),
          if (snapshot.scoreTrend.length >= 2) const SizedBox(height: 12),
          ReadinessSkillBars(skills: snapshot.skillReadiness),
          if (snapshot.skillReadiness.isNotEmpty) const SizedBox(height: 12),
          ReadinessWeaknessList(weaknesses: snapshot.weaknessDetails),
          if (snapshot.weaknessDetails.isNotEmpty) const SizedBox(height: 12),
          ReadinessTodoCard(dueReviewCount: snapshot.dueReviewCount),
        ],
      ],
    );
  }
}
