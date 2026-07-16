import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/learn/learn_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/learn/learn_provider.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/async_state_views.dart';
import '../../shared/widgets/page_intro.dart';
import 'widgets/learner_model_sections.dart';
import 'widgets/learner_readiness_card.dart';
import 'widgets/mastery_ring.dart';
import 'widgets/weekly_recap_card.dart';

/// "Hồ sơ năng lực" — độ thành thạo theo trình độ, việc làm được (can-do) và
/// điểm cần cải thiện. `GET /user/learner-model` + `GET
/// /user/learn/capability-map`. Mirrors web `learner-model-page.tsx` block
/// order: PageIntro → readiness → mastery → stat tiles → coverage → grammar
/// weaknesses → weekly recap → can-do → weak words. `LearningDepthCard`
/// (Biết/Hiểu/Áp dụng breakdown) is deferred — no backend field exposes that
/// split on [LearnerModel] yet (see phase report).
class LearnerModelScreen extends ConsumerWidget {
  const LearnerModelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final modelAsync = ref.watch(learnerModelProvider);
    final mapAsync = ref.watch(capabilityMapProvider);
    final recapAsync = ref.watch(weeklyRecapProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: modelAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            onRetry: () => ref.invalidate(learnerModelProvider),
          ),
          data: (model) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(learnerModelProvider);
                ref.invalidate(capabilityMapProvider);
                ref.invalidate(weeklyRecapProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back, size: 20, color: tokens.foreground),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.learnerModelTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                  Text(
                    l10n.learnerModelSubtitle,
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 12),
                  PageIntro(
                    pageKey: 'learner-model',
                    why: l10n.learnerModelSubtitle,
                    todo: l10n.learnerModelMasteryHint,
                    next: l10n.learnerModelCanDoSectionTitle,
                  ),
                  const SizedBox(height: 12),
                  LearnerReadinessCard(readiness: model.readiness),
                  const SizedBox(height: 12),
                  AppCard.card(
                    child: Row(
                      children: [
                        MasteryRing(percent: model.maturePct),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${model.matureCards}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: ' / ${model.totalCards} ${l10n.learnerModelCardsSuffix}',
                                      style: TextStyle(color: tokens.mutedForeground),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.learnerModelMasteryHint,
                                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LearnerModelStatTile(
                          label: l10n.learnerModelDueNow,
                          value: '${model.dueNow}',
                          color: AppColors.warning,
                          onTap: () => context.push('/daily-review'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LearnerModelStatTile(
                          label: l10n.learnerModelWeakTotal,
                          value: '${model.weakTotal}',
                          color: AppColors.destructive,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LearnerModelStatTile(
                          label: l10n.learnerModelTotalCards,
                          value: '${model.totalCards}',
                          onTap: () => context.push('/vocabulary'),
                        ),
                      ),
                    ],
                  ),
                  if (model.coverageByLevel.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    LearnerModelSectionCard(
                      title: l10n.learnerModelCoverageTitle,
                      child: Column(
                        children: model.coverageByLevel
                            .map((c) => LearnerModelLevelBar(coverage: c))
                            .toList(),
                      ),
                    ),
                  ],
                  if (model.grammarWeaknesses.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    LearnerModelSectionCard(
                      title: l10n.learnerModelGrammarWeaknessesTitle,
                      child: Column(
                        children: model.grammarWeaknesses
                            .map((g) => LearnerModelGrammarWeaknessRow(weakness: g, l10n: l10n))
                            .toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  recapAsync.maybeWhen(
                    data: (recap) => Column(
                      children: [
                        WeeklyRecapCard(recap: recap),
                        const SizedBox(height: 16),
                      ],
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  mapAsync.when(
                    loading: () => const SizedBox(
                      height: 96,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (map) => LearnerModelCanDoSection(map: map, l10n: l10n),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.learnerModelWeakWordsTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: tokens.foreground),
                  ),
                  const SizedBox(height: 8),
                  if (model.weakWords.isEmpty)
                    AppCard.card(
                      child: Center(
                        child: Text(
                          l10n.learnerModelWeakWordsEmpty,
                          style: TextStyle(color: tokens.mutedForeground),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...model.weakWords.map((w) => LearnerModelWeakWordRow(word: w)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
