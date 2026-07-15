import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/learn/learn_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/learn/learn_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/can_do_card.dart';
import 'widgets/mastery_ring.dart';

/// "Hồ sơ năng lực" — độ thành thạo theo trình độ, việc làm được (can-do) và
/// điểm cần cải thiện. `GET /user/learner-model` + `GET
/// /user/learn/capability-map`. Mirrors web `learner-model-page.tsx`
/// (rút gọn: bỏ readiness action routing chi tiết + weekly recap card riêng,
/// giữ số liệu cốt lõi — không cần parity pixel với web theo yêu cầu).
class LearnerModelScreen extends ConsumerWidget {
  const LearnerModelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final modelAsync = ref.watch(learnerModelProvider);
    final mapAsync = ref.watch(capabilityMapProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.learnerModelTitle),
      ),
      body: modelAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(learnerModelProvider),
        ),
        data: (model) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(learnerModelProvider);
              ref.invalidate(capabilityMapProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' / ${model.totalCards} ${l10n.learnerModelCardsSuffix}',
                                      style: const TextStyle(
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.learnerModelMasteryHint,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        label: l10n.learnerModelDueNow,
                        value: '${model.dueNow}',
                        color: AppColors.warning,
                        onTap: () => context.push('/daily-review'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatTile(
                        label: l10n.learnerModelWeakTotal,
                        value: '${model.weakTotal}',
                        color: AppColors.destructive,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatTile(
                        label: l10n.learnerModelTotalCards,
                        value: '${model.totalCards}',
                        onTap: () => context.push('/vocabulary'),
                      ),
                    ),
                  ],
                ),
                if (model.coverageByLevel.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: l10n.learnerModelCoverageTitle,
                    child: Column(
                      children: model.coverageByLevel
                          .map((c) => _LevelBar(coverage: c))
                          .toList(),
                    ),
                  ),
                ],
                if (model.grammarWeaknesses.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: l10n.learnerModelGrammarWeaknessesTitle,
                    child: Column(
                      children: model.grammarWeaknesses
                          .map(
                            (g) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(g.nameVi),
                              subtitle: Text(
                                l10n.learnerModelErrorCount(g.errorCount),
                              ),
                              trailing: g.level.isEmpty
                                  ? null
                                  : Chip(
                                      label: Text(
                                        g.level,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                mapAsync.when(
                  loading: () => const SizedBox(
                    height: 96,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (map) => _CanDoSection(map: map, l10n: l10n),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.learnerModelWeakWordsTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (model.weakWords.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          l10n.learnerModelWeakWordsEmpty,
                          style: const TextStyle(
                            color: AppColors.mutedForeground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  ...model.weakWords.map((w) => _WeakWordRow(word: w)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color ?? AppColors.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _LevelBar extends StatelessWidget {
  const _LevelBar({required this.coverage});
  final LevelCoverage coverage;

  @override
  Widget build(BuildContext context) {
    final pct = coverage.total > 0
        ? (coverage.mature / coverage.total * 100).round()
        : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                coverage.level,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${coverage.mature}/${coverage.total}',
                style: const TextStyle(color: AppColors.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 8,
              backgroundColor: AppColors.muted,
              color: AppColors.tigerOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class _CanDoSection extends StatelessWidget {
  const _CanDoSection({required this.map, required this.l10n});
  final CapabilityMap map;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.learnerModelCanDoSectionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${map.mastered}/${map.total}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.tigerOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (map.canDos.isEmpty)
          Text(
            l10n.learnerModelCanDoEmpty,
            style: const TextStyle(color: AppColors.mutedForeground),
          )
        else
          Column(
            children: map.canDos
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CanDoCard(canDo: c),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _WeakWordRow extends StatelessWidget {
  const _WeakWordRow({required this.word});
  final LearnerWeakWord word;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Row(
          children: [
            Flexible(
              child: Text(
                word.contentDe,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (word.level.isNotEmpty) ...[
              const SizedBox(width: 6),
              Chip(
                label: Text(word.level, style: const TextStyle(fontSize: 10)),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ],
        ),
        subtitle: Text(word.contentVi),
        trailing: word.lapses > 0
            ? Text(
                l10n.learnerModelLapsesCount(word.lapses),
                style: const TextStyle(
                  color: AppColors.destructive,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        // Router `/daily-review` chưa nhận query `retry` theo id cụ thể
        // (khác web) — mở hàng đợi ôn tập chung, đủ hành động "luyện ngay".
        onTap: () => context.push('/daily-review'),
      ),
    );
  }
}
