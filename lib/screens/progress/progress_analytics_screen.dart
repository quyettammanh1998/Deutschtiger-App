import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';

/// Progress analytics data model.
class ProgressAnalytics {
  final int totalWordsLearned;
  final int wordsThisWeek;
  final int wordsThisMonth;
  final int currentStreak;
  final int longestStreak;
  final int totalMinutesLearned;
  final int totalReviewsDone;
  final double accuracyRate;
  final Map<String, int> wordsByLevel;
  final List<DailyProgress> weeklyProgress;

  const ProgressAnalytics({
    required this.totalWordsLearned,
    required this.wordsThisWeek,
    required this.wordsThisMonth,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalMinutesLearned,
    required this.totalReviewsDone,
    required this.accuracyRate,
    required this.wordsByLevel,
    required this.weeklyProgress,
  });
}

class DailyProgress {
  final DateTime date;
  final int wordsLearned;
  final int minutesSpent;

  const DailyProgress({
    required this.date,
    required this.wordsLearned,
    required this.minutesSpent,
  });
}

/// Mock analytics provider.
final progressAnalyticsProvider = FutureProvider<ProgressAnalytics>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return ProgressAnalytics(
    totalWordsLearned: 156,
    wordsThisWeek: 42,
    wordsThisMonth: 128,
    currentStreak: 7,
    longestStreak: 21,
    totalMinutesLearned: 1840,
    totalReviewsDone: 892,
    accuracyRate: 0.78,
    wordsByLevel: {
      'A1': 45,
      'A2': 52,
      'B1': 38,
      'B2': 15,
      'C1': 6,
      'C2': 0,
    },
    weeklyProgress: List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      return DailyProgress(
        date: date,
        wordsLearned: (i * 5 + 10) % 20 + 5,
        minutesSpent: (i * 10 + 15) % 30 + 10,
      );
    }),
  );
});

/// Màn progress analytics.
class ProgressAnalyticsScreen extends ConsumerWidget {
  const ProgressAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(progressAnalyticsProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Thống kê học tập',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: analytics.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Không tải được thống kê',
          onRetry: () => ref.invalidate(progressAnalyticsProvider),
        ),
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OverviewCards(analytics: data),
              const SizedBox(height: 24),
              _WeeklyChart(weeklyProgress: data.weeklyProgress),
              const SizedBox(height: 24),
              _LevelDistribution(levels: data.wordsByLevel),
              const SizedBox(height: 24),
              _StreakSection(
                currentStreak: data.currentStreak,
                longestStreak: data.longestStreak,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewCards extends StatelessWidget {
  const _OverviewCards({required this.analytics});

  final ProgressAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.book,
                label: 'Từ đã học',
                value: '${analytics.totalWordsLearned}',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department,
                label: 'Streak hiện tại',
                value: '${analytics.currentStreak} ngày',
                color: AppColors.tigerOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.timer,
                label: 'Thời gian học',
                value: '${analytics.totalMinutesLearned} phút',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle,
                label: 'Độ chính xác',
                value: '${(analytics.accuracyRate * 100).round()}%',
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.weeklyProgress});

  final List<DailyProgress> weeklyProgress;

  @override
  Widget build(BuildContext context) {
    final maxWords = weeklyProgress
        .map((e) => e.wordsLearned)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tiến độ tuần này',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weeklyProgress.map((progress) {
                  final height = maxWords > 0
                      ? (progress.wordsLearned / maxWords) * 100
                      : 0.0;
                  final dayName = _getDayName(progress.date.weekday);
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${progress.wordsLearned}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tigerOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return days[weekday - 1];
  }
}

class _LevelDistribution extends StatelessWidget {
  const _LevelDistribution({required this.levels});

  final Map<String, int> levels;

  @override
  Widget build(BuildContext context) {
    final total = levels.values.fold<int>(0, (a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân bổ theo cấp độ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...levels.entries.map((entry) {
              final percentage = total > 0 ? entry.value / total : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${entry.value} từ (${(percentage * 100).round()}%)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(
                          _getLevelColor(entry.key),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'A1':
        return Colors.green;
      case 'A2':
        return Colors.lightGreen;
      case 'B1':
        return Colors.orange;
      case 'B2':
        return Colors.deepOrange;
      case 'C1':
        return Colors.red;
      case 'C2':
        return Colors.purple;
      default:
        return AppColors.tigerOrange;
    }
  }
}

class _StreakSection extends StatelessWidget {
  const _StreakSection({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.tigerOrange,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currentStreak',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Streak hiện tại',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              width: 1,
              color: AppColors.border,
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$longestStreak',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Kỷ lục streak',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
