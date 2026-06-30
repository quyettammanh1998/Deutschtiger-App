import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';

/// Achievement model.
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int currentValue;
  final int targetValue;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentValue = 0,
    this.targetValue = 1,
  });

  double get progress => targetValue > 0 ? currentValue / targetValue : 0;
}

/// Mock achievements - for demo/development only.
/// Replace with actual API call in production.
final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  // Simulate network delay for realistic UX testing
  // await Future.delayed(const Duration(milliseconds: 300));
  
  return [
    Achievement(
      id: 'first_word',
      title: 'Từ đầu tiên',
      description: 'Học từ vựng đầu tiên',
      icon: Icons.star,
      color: Colors.amber,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Achievement(
      id: 'streak_7',
      title: 'Kiên trì',
      description: 'Học liên tục 7 ngày',
      icon: Icons.local_fire_department,
      color: AppColors.tigerOrange,
      isUnlocked: true,
      unlockedAt: DateTime.now(),
      currentValue: 7,
      targetValue: 7,
    ),
    Achievement(
      id: 'words_50',
      title: 'Từ vựng phong phú',
      description: 'Học 50 từ vựng',
      icon: Icons.book,
      color: Colors.blue,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
      currentValue: 50,
      targetValue: 50,
    ),
    Achievement(
      id: 'words_100',
      title: 'Kho từ vựng',
      description: 'Học 100 từ vựng',
      icon: Icons.library_books,
      color: Colors.indigo,
      currentValue: 100,
      targetValue: 100,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Tháng nóng bỏng',
      description: 'Học liên tục 30 ngày',
      icon: Icons.whatshot,
      color: Colors.red,
      currentValue: 7,
      targetValue: 30,
    ),
    Achievement(
      id: 'perfect_day',
      title: 'Ngày hoàn hảo',
      description: 'Ôn tất cả từ trong ngày',
      icon: Icons.check_circle,
      color: Colors.green,
      currentValue: 3,
      targetValue: 5,
    ),
    Achievement(
      id: 'speed_learner',
      title: 'Học nhanh',
      description: 'Học 20 từ trong 10 phút',
      icon: Icons.speed,
      color: Colors.purple,
    ),
    Achievement(
      id: 'night_owl',
      title: 'Cú đêm',
      description: 'Học sau 10 giờ đêm',
      icon: Icons.nightlight_round,
      color: Colors.deepPurple,
    ),
    Achievement(
      id: 'early_bird',
      title: 'Gà sáng',
      description: 'Học trước 6 giờ sáng',
      icon: Icons.wb_sunny,
      color: Colors.orange,
    ),
    Achievement(
      id: 'master_a1',
      title: 'Bậc thầy A1',
      description: 'Hoàn thành tất cả từ A1',
      icon: Icons.school,
      color: Colors.green,
      currentValue: 45,
      targetValue: 100,
    ),
  ];
});

/// Màn achievements.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Thành tựu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: achievements.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 64, color: AppColors.muted),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có thành tựu nào',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bắt đầu học để nhận thành tựu!',
                    style: TextStyle(color: AppColors.mutedForeground),
                  ),
                ],
              ),
            );
          }

          final unlocked = list.where((a) => a.isUnlocked).toList();
          final locked = list.where((a) => !a.isUnlocked).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(achievementsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ProgressHeader(
                  unlockedCount: unlocked.length,
                  totalCount: list.length,
                ),
                const SizedBox(height: 24),
                if (unlocked.isNotEmpty) ...[
                  const _SectionTitle(title: 'Đã đạt được'),
                  const SizedBox(height: 12),
                  ...unlocked.map((a) => _AchievementCard(achievement: a)),
                  const SizedBox(height: 24),
                ],
                if (locked.isNotEmpty) ...[
                  const _SectionTitle(title: 'Đang theo đuổi'),
                  const SizedBox(height: 12),
                  ...locked.map((a) => _AchievementCard(achievement: a)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.unlockedCount,
    required this.totalCount,
  });

  final int unlockedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  '$unlockedCount / $totalCount',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Thành tựu đã đạt được',
              style: TextStyle(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(Colors.amber),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? achievement.color.withValues(alpha: 0.1)
                    : AppColors.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                achievement.icon,
                color: achievement.isUnlocked
                    ? achievement.color
                    : AppColors.mutedForeground,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: achievement.isUnlocked
                          ? AppColors.foreground
                          : AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  if (!achievement.isUnlocked) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: achievement.progress,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${achievement.currentValue}/${achievement.targetValue}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                  if (achievement.isUnlocked && achievement.unlockedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Đạt ngày ${_formatDate(achievement.unlockedAt!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (achievement.isUnlocked)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
