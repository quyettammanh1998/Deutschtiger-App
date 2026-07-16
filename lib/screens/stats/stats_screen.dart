import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/back_button.dart';
import '../../view_models/providers.dart' hide dashboardProvider;
import 'package:deutschtiger/view_models/home/home_provider.dart';
import 'package:deutschtiger/view_models/stats/stats_provider.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'widgets/stats_achievements_data.dart';
import 'widgets/stats_overview_cards.dart';
import 'widgets/stats_progress_cards.dart';
import 'widgets/stats_screen_body.dart';
import '../../view_models/stats/error_patterns_provider.dart';

/// Màn Thống kê — 13 khối theo thứ tự web `stats-page.tsx`. Nguồn dữ liệu:
///   - `dashboardProvider`: level/XP/streak (đã có sẵn qua dashboard-init)
///   - `reviewStatsProvider`: tổng lượt ôn + số từ đã học (CEFR card, suggestion)
///   - `flashcardReviewStatsProvider`: "Thống kê ôn tập" hôm nay/tuần/độ chính xác
///   - `weeklyXpLogProvider`: XP 7 ngày qua
///   - `weeklyOnlineTimeProvider`: thời gian online 7 ngày
///   - `masteryProvider` + `srsDailyStatsProvider`: độ nhớ FSRS
///   - `statsAchievementsProvider`: thành tựu tính từ gamification + flashcard count
///   - `leaderboardProvider(allTime)` + `statsCurrentUserRankProvider`: bảng XH
///   - `errorPatternsSummaryProvider`: lỗi hay gặp (xem trước, top 3)
///
/// Block-level widgets live in `widgets/stats_*.dart`; this file only wires
/// providers to [StatsScreenBody] and owns the loading/error/refresh shell.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final dashboard = ref.watch(dashboardProvider);
    final currentUserId = ref.watch(authServiceProvider).currentUser?.id ?? '';

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: dashboard.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: l10n.couldNotLoadData,
            onRetry: () => ref.invalidate(dashboardProvider),
          ),
          data: (dashboardData) {
            final gamification = dashboardData.gamification;
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(dashboardProvider);
                ref.invalidate(reviewStatsProvider);
                ref.invalidate(weeklyXpLogProvider);
                ref.invalidate(masteryProvider);
                ref.invalidate(srsDailyStatsProvider);
                ref.invalidate(flashcardReviewStatsProvider);
                ref.invalidate(flashcardCountStatsProvider);
                ref.invalidate(weeklyOnlineTimeProvider);
                ref.invalidate(statsAchievementsProvider);
                ref.invalidate(errorPatternsSummaryProvider);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppBackButton(onPressed: () => context.pop()),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.statsScreenTitle,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: tokens.foreground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.statsScreenSubtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (gamification == null)
                    SliverFillRemaining(
                      child: ErrorView(
                        message: l10n.couldNotLoadData,
                        onRetry: () => ref.invalidate(dashboardProvider),
                      ),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: StatsOverviewCards(data: gamification),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: StatsProgressCards(data: gamification),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: StatsScreenBody(
                          gamification: gamification,
                          currentUserId: currentUserId,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
