import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Achievement model.
class Achievement {
  final String id;
  final String title;
  final String description;
  final String titleVi;
  final String descriptionVi;
  final IconData icon;
  final Color color;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress;
  final int targetValue;
  final int currentValue;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.titleVi,
    required this.descriptionVi,
    required this.icon,
    required this.color,
    this.xpReward = 50,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.targetValue = 1,
    this.currentValue = 0,
  });
}

/// Mock achievements.
final mockAchievements = [
  Achievement(
    id: 'first-login',
    title: 'First Step',
    description: 'Complete your first login',
    titleVi: 'Bước chân đầu tiên',
    descriptionVi: 'Hoàn thành đăng nhập lần đầu',
    icon: Icons.flag,
    color: Colors.blue,
    xpReward: 10,
    isUnlocked: true,
    progress: 1.0,
    targetValue: 1,
    currentValue: 1,
  ),
  Achievement(
    id: 'first-word',
    title: 'Word Collector',
    description: 'Learn your first word',
    titleVi: 'Người sưu tập từ',
    descriptionVi: 'Học từ đầu tiên',
    icon: Icons.abc,
    color: Colors.green,
    xpReward: 20,
    isUnlocked: true,
    progress: 1.0,
    targetValue: 1,
    currentValue: 1,
  ),
  Achievement(
    id: '10-words',
    title: 'Vocabulary Novice',
    description: 'Learn 10 words',
    titleVi: 'Tân binh từ vựng',
    descriptionVi: 'Học 10 từ',
    icon: Icons.menu_book,
    color: Colors.teal,
    xpReward: 50,
    isUnlocked: true,
    progress: 1.0,
    targetValue: 10,
    currentValue: 10,
  ),
  Achievement(
    id: '100-words',
    title: 'Vocabulary Master',
    description: 'Learn 100 words',
    titleVi: 'Bậc thầy từ vựng',
    descriptionVi: 'Học 100 từ',
    icon: Icons.workspace_premium,
    color: Colors.amber,
    xpReward: 200,
    progress: 0.75,
    targetValue: 100,
    currentValue: 75,
  ),
];

/// Provider for all achievements.
final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockAchievements;
});

/// Provider for unlocked achievements.
final unlockedAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final achievements = await ref.watch(achievementsProvider.future);
  return achievements.where((a) => a.isUnlocked).toList();
});

/// Provider for locked achievements.
final lockedAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final achievements = await ref.watch(achievementsProvider.future);
  return achievements.where((a) => !a.isUnlocked).toList();
});

/// Total XP from achievements.
final totalAchievementXpProvider = Provider<int>((ref) {
  final asyncValue = ref.watch(achievementsProvider);
  return asyncValue.when(
    data: (achievements) => achievements.where((a) => a.isUnlocked).fold(0, (sum, a) => sum + a.xpReward),
    loading: () => 0,
    error: (e, s) => 0,
  );
});

/// Achievement count.
final achievementCountProvider = Provider<({int unlocked, int total})>((ref) {
  final asyncValue = ref.watch(achievementsProvider);
  return asyncValue.when(
    data: (achievements) {
      final unlocked = achievements.where((a) => a.isUnlocked).length;
      return (unlocked: unlocked, total: achievements.length);
    },
    loading: () => (unlocked: 0, total: 0),
    error: (_, __) => (unlocked: 0, total: 0),
  );
});
