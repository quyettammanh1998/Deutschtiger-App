import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';

class SRSStatsCard extends StatelessWidget {
  final SRSStats stats;

  const SRSStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Reviews',
                    value: '${stats.totalReviews}',
                    icon: Icons.repeat,
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    label: 'Correct',
                    value: '${stats.totalCorrect}',
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    label: 'Retention',
                    value: '${stats.retentionRate.toStringAsFixed(0)}%',
                    icon: Icons.psychology,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Card Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _CardStatus(
                  label: 'Mature',
                  count: stats.cardsMature,
                  total: stats.cardsLearned,
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                _CardStatus(
                  label: 'Young',
                  count: stats.cardsYoung,
                  total: stats.cardsLearned,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _CardStatus(
                  label: 'Relearning',
                  count: stats.cardsRelearning,
                  total: stats.cardsLearned,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StreakStat(
                    label: 'Current',
                    value: stats.currentStreak,
                    icon: Icons.local_fire_department,
                  ),
                ),
                Expanded(
                  child: _StreakStat(
                    label: 'Longest',
                    value: stats.longestStreak,
                    icon: Icons.emoji_events,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}

class _CardStatus extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _CardStatus({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _StreakStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value days',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
