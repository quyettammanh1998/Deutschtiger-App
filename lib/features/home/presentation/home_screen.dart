import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/async_state_views.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/tiger_logo.dart';
import '../domain/dashboard_data.dart';
import 'home_provider.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/mission_list.dart';
import 'widgets/quick_stats_row.dart';

/// Màn Home (tab Trang chủ) — dashboard học hôm nay.
/// 1 round-trip `dashboard-init`: greeting + streak + daily goal + stats + missions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final profile = ref.watch(myProfileProvider);
    final displayName = profile.maybeWhen(
      data: (u) => u.displayName.isEmpty ? 'bạn' : u.displayName,
      orElse: () => 'bạn',
    );

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Row(
          children: const [
            TigerIcon(size: 28),
            SizedBox(width: 8),
            Text(
              'DeutschTiger',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.tigerOrange,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: dashboard.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Không tải được dữ liệu học hôm nay.',
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (data) => _HomeBody(
          data: data,
          displayName: displayName,
          onRefresh: () async => ref.invalidate(dashboardProvider),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.data,
    required this.displayName,
    required this.onRefresh,
  });

  final DashboardData data;
  final String displayName;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final gam = data.gamification ?? const Gamification();
    return RefreshIndicator(
      color: AppColors.tigerOrange,
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DailyGoalCard(displayName: displayName, gamification: gam),
          const SizedBox(height: 16),
          QuickStatsRow(
            wordsLearned: data.wordsLearned,
            dueReviewCount: data.dueReviewCount,
            onlineMinutes: data.onlineTimeToday,
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: data.dueReviewCount > 0
                ? 'Ôn ${data.dueReviewCount} từ đến hạn'
                : 'Bắt đầu học',
            onPressed: () => context.go('/vocab'),
          ),
          const SizedBox(height: 20),
          MissionList(missions: data.missions),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
