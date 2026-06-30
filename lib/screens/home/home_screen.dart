import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/mobile_dashboard_header.dart';
import '../../dashboard/widgets/mobile_stats_card.dart';
import '../../dashboard/widgets/quick_actions.dart';
import '../../dashboard/widgets/streak_claim_modal.dart';

/// Home screen - main dashboard.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showStreakModal = false;

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual providers
    const displayName = 'Học viên';
    const streak = 7;
    const dailyXp = 150;
    const dailyGoal = 200;
    const totalWordsLearned = 156;
    const totalLookups = 423;
    const onlineSeconds = 3600; // 1 hour

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // Dashboard header with gradient
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Header
                    MobileDashboardHeader(
                      displayName: displayName,
                      streak: streak,
                      dailyXp: dailyXp,
                      dailyGoal: dailyGoal,
                      onSettingsTap: () => context.push('/settings'),
                      onMessagesTap: () {},
                      onProfileTap: () => context.push('/profile'),
                    ),

                    // Search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _buildSearchBar(context),
                    ),

                    // Stats card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MobileStatsCard(
                        totalWordsLearned: totalWordsLearned,
                        totalLookups: totalLookups,
                        streak: streak,
                        onlineSeconds: onlineSeconds,
                        onStreakTap: () => setState(() => _showStreakModal = true),
                        onDetailsTap: () {},
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: QuickActions(
                        onMoreTap: () {},
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Daily missions placeholder
                    _buildDailyMissions(),

                    const SizedBox(height: 16),

                    // Continue learning placeholder
                    _buildContinueLearning(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Streak claim modal
          StreakClaimModal(
            open: _showStreakModal,
            onClose: () => setState(() => _showStreakModal = false),
            alreadyClaimed: false,
            heartbeatStreak: streak,
            onClaimed: () {
              // Refresh data after claiming
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/vocab'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.mutedForeground, size: 20),
            const SizedBox(width: 12),
            Text(
              'Tìm kiếm từ vựng...',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMissions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nhiệm vụ hôm nay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MissionCard(
            title: 'Học 10 từ mới',
            subtitle: 'Còn 5 từ',
            progress: 0.5,
            icon: Icons.menu_book,
            color: AppColors.tigerOrange,
          ),
          const SizedBox(height: 8),
          _MissionCard(
            title: 'Ôn tập 20 từ',
            subtitle: 'Còn 15 từ',
            progress: 0.25,
            icon: Icons.refresh,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueLearning() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tiếp tục học',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.tigerOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.style_outlined,
                    color: AppColors.tigerOrange,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A1 - Từ vựng cơ bản',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Đã học 45/150 từ',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.3,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.tigerOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.play_circle_filled,
                  color: AppColors.tigerOrange,
                  size: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
