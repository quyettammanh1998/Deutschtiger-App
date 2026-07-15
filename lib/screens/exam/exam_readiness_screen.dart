import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';

/// Màn đánh giá mức sẵn sàng thi — read-only score + gợi ý luyện.
/// `GET /api/v1/exam-readiness`.
class ExamReadinessScreen extends ConsumerWidget {
  const ExamReadinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final readiness = ref.watch(examReadinessProvider);

    return Scaffold(
      backgroundColor: DesignTokens.background,
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
    final l10n = AppLocalizations.of(context);
    if (snapshot.attemptCount == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.examReadinessEmpty,
            textAlign: TextAlign.center,
            style: const TextStyle(color: DesignTokens.mutedForeground),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.screenHorizontalPadding),
      children: [
        _ScoreBandCard(snapshot: snapshot),
        const SizedBox(height: DesignTokens.spacingMd),
        _StatRow(
          label: l10n.examReadinessAttempts,
          value: '${snapshot.attemptCount}',
        ),
        _StatRow(
          label: l10n.examReadinessBestScore,
          value: '${snapshot.bestScore}',
        ),
        _StatRow(
          label: l10n.examReadinessDueReviews,
          value: '${snapshot.dueReviewCount}',
        ),
        if (snapshot.skillReadiness.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            l10n.examReadinessSkillBreakdown,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final skill in snapshot.skillReadiness)
            _SkillBar(skill: skill),
        ],
        if (snapshot.weaknessDetails.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            l10n.examReadinessWeaknesses,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final detail in snapshot.weaknessDetails)
            _WeaknessCard(detail: detail),
        ],
      ],
    );
  }
}

class _ScoreBandCard extends StatelessWidget {
  const _ScoreBandCard({required this.snapshot});
  final ExamReadinessSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.examReadinessBandLabel,
            style: const TextStyle(color: DesignTokens.mutedForeground),
          ),
          const SizedBox(height: 4),
          Text(
            '${snapshot.readinessLow}–${snapshot.readinessHigh}%',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: DesignTokens.mutedForeground)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.skill});
  final ExamSkillStat skill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill.skill),
              Text('${skill.accuracy.round()}%'),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (skill.accuracy / 100).clamp(0, 1),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeaknessCard extends StatelessWidget {
  const _WeaknessCard({required this.detail});
  final ExamWeaknessDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.errorType,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (detail.original.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('❌ ${detail.original}'),
            Text('✅ ${detail.corrected}'),
          ],
          if (detail.explanation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              detail.explanation,
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
          ],
        ],
      ),
    );
  }
}
