import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'stats_provider.dart';
import 'widgets/error_patterns_list.dart';
import 'widgets/near_achievements_list.dart';
import 'widgets/srs_stats_card.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(statsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: statsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(statsNotifierProvider.notifier).loadAllStats();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _OverviewCards(statsState: statsState),
                  ),
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'SRS Statistics',
                      icon: Icons.auto_graph,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: statsState.srsStats != null
                        ? SRSStatsCard(stats: statsState.srsStats!)
                        : const SizedBox.shrink(),
                  ),
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Error Patterns',
                      icon: Icons.error_outline,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ErrorPatternsList(patterns: statsState.errorPatterns),
                  ),
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Near Achievements',
                      icon: Icons.emoji_events,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _NearAchievementsSection(),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
    );
  }
}

class _OverviewCards extends StatelessWidget {
  final StatsState statsState;

  const _OverviewCards({required this.statsState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Streak',
                  value: '${statsState.streakInfo?.currentStreak ?? 0}',
                  subtitle: 'days',
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Today',
                  value: '${statsState.timeStats?.todayMinutes ?? 0}',
                  subtitle: 'minutes',
                  icon: Icons.access_time,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Retention',
                  value: '${statsState.srsStats?.retentionRate.toStringAsFixed(0) ?? 0}',
                  subtitle: '%',
                  icon: Icons.psychology,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Cards',
                  value: '${statsState.srsStats?.cardsLearned ?? 0}',
                  subtitle: 'learned',
                  icon: Icons.style,
                  color: Colors.purple,
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
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  subtitle,
                  style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _NearAchievementsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearAsync = ref.watch(nearAchievementsProvider);

    return nearAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (achievements) => NearAchievementsList(achievements: achievements),
    );
  }
}
