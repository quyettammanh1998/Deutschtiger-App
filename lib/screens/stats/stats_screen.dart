import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../data/home/dashboard_data.dart';
import '../../l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/home/home_provider.dart';
import 'package:deutschtiger/view_models/stats/stats_provider.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'widgets/error_patterns_list.dart';
import 'widgets/srs_stats_card.dart';
import '../../view_models/stats/error_patterns_provider.dart';

/// Màn Thống kê — live data từ FSRS/XP/error-patterns.
///
/// Nguồn dữ liệu:
///   - `dashboardProvider` (đã có sẵn): level, tổng XP, streak hiện tại/tốt nhất
///   - `reviewStatsProvider`: tổng lượt ôn + số từ đã học
///   - `weeklyXpLogProvider`: XP 7 ngày qua
///   - `masteryProvider` + `srsDailyStatsProvider`: độ nhớ FSRS + xu hướng 30 ngày
///   - `errorPatternsSummaryProvider`: lỗi hay gặp (xem trước, top 3)
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Text(l10n.statsScreenTitle),
        backgroundColor: DesignTokens.background,
      ),
      body: dashboard.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: l10n.couldNotLoadData,
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (dashboardData) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardProvider);
            ref.invalidate(reviewStatsProvider);
            ref.invalidate(weeklyXpLogProvider);
            ref.invalidate(masteryProvider);
            ref.invalidate(srsDailyStatsProvider);
            ref.invalidate(errorPatternsSummaryProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _OverviewSection(gamification: dashboardData.gamification),
              ),
              const SliverToBoxAdapter(child: _WeeklyXpChartCard()),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: l10n.statsMasteryTitle,
                  icon: Icons.auto_graph,
                ),
              ),
              const SliverToBoxAdapter(child: _MasterySection()),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: l10n.statsErrorPatternsTitle,
                  icon: Icons.error_outline,
                  onSeeAll: () => context.push('/stats/error-patterns'),
                ),
              ),
              const SliverToBoxAdapter(child: _ErrorPatternsSection()),
              const SliverToBoxAdapter(
                child: SizedBox(height: DesignTokens.spacingXl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewSection extends ConsumerWidget {
  const _OverviewSection({required this.gamification});

  final Gamification? gamification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reviewStats = ref.watch(reviewStatsProvider);
    final streak = gamification?.currentStreak ?? 0;
    final level = gamification?.level ?? 1;
    final wordsLearned = reviewStats.valueOrNull?.wordsLearned ?? 0;
    final totalReviews = reviewStats.valueOrNull?.totalReviews ?? 0;

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: l10n.statsCurrentStreak,
                  value: '$streak',
                  unit: l10n.statsDaysUnit,
                  icon: Icons.local_fire_department,
                  accent: DesignTokens.warning,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm + 4),
              Expanded(
                child: _StatCard(
                  title: l10n.statsCurrentLevel,
                  value: '$level',
                  unit: '',
                  icon: Icons.star,
                  accent: DesignTokens.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm + 4),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: l10n.statsWordsLearned,
                  value: '$wordsLearned',
                  unit: '',
                  icon: Icons.style,
                  accent: DesignTokens.success,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm + 4),
              Expanded(
                child: _StatCard(
                  title: l10n.statsTotalReviews,
                  value: '$totalReviews',
                  unit: '',
                  icon: Icons.repeat,
                  accent: DesignTokens.orange500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(icon, color: accent, size: 16),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignTokens.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: DesignTokens.foreground,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: DesignTokens.spacingXs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DesignTokens.mutedForeground,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyXpChartCard extends ConsumerWidget {
  const _WeeklyXpChartCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(weeklyXpLogProvider);
    final entries = async.valueOrNull ?? const [];
    final sorted = [...entries]..sort((a, b) => a.logDate.compareTo(b.logDate));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacingMd,
        0,
        DesignTokens.spacingMd,
        DesignTokens.spacingMd,
      ),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          border: Border.all(color: DesignTokens.border),
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: DesignTokens.orange500, size: 18),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  l10n.statsWeeklyXpChartTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            SizedBox(
              height: 100,
              child: sorted.every((e) => e.xpEarned == 0)
                  ? Center(
                      child: Text(
                        l10n.statsMasteryTrendEmpty,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                    )
                  : CustomPaint(
                      painter: _BarChartPainter(sorted),
                      size: Size.infinite,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter(this.entries);
  final List<dynamic> entries;

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;
    final maxValue = entries
        .map((e) => e.xpEarned as int)
        .fold<int>(0, (a, b) => a > b ? a : b)
        .clamp(1, 1 << 30);
    final barWidth = size.width / (entries.length * 1.5);
    final paint = Paint()
      ..color = DesignTokens.orange500
      ..style = PaintingStyle.fill;
    final labelStyle = TextStyle(
      color: DesignTokens.mutedForeground,
      fontSize: 10,
    );

    for (var i = 0; i < entries.length; i++) {
      final value = entries[i].xpEarned as int;
      final barHeight = (value / maxValue) * (size.height - 24);
      final x = (i * 1.5 + 0.25) * barWidth;
      final rect = Rect.fromLTWH(
        x,
        size.height - 24 - barHeight,
        barWidth,
        barHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );

      final date = entries[i].logDate as DateTime;
      final dayLabel = '${date.day}/${date.month}';
      final tp = TextPainter(
        text: TextSpan(text: dayLabel, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x + (barWidth - tp.width) / 2, size.height - tp.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) => old.entries != entries;
}

class _MasterySection extends ConsumerWidget {
  const _MasterySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mastery = ref.watch(masteryProvider);
    final daily = ref.watch(srsDailyStatsProvider);
    return mastery.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (masterySummary) => SRSStatsCard(
        mastery: masterySummary,
        daily: daily.valueOrNull ?? const [],
      ),
    );
  }
}

class _ErrorPatternsSection extends ConsumerWidget {
  const _ErrorPatternsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(errorPatternsSummaryProvider);
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (patterns) {
        if (patterns.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.statsErrorPatternsEmpty,
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }
        final top = [...patterns]
          ..sort((a, b) => b.totalCount.compareTo(a.totalCount));
        return ErrorPatternsList(patterns: top.take(3).toList());
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon, this.onSeeAll});
  final String title;
  final IconData icon;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacingMd,
        DesignTokens.spacingLg,
        DesignTokens.spacingMd,
        DesignTokens.spacingSm + 4,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: DesignTokens.orange500),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: Text(l10n.seeAll)),
        ],
      ),
    );
  }
}
