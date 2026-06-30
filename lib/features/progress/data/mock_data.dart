import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User progress model.
class UserProgress {
  final int totalWordsLearned;
  final int totalWordsReview;
  final int currentStreak;
  final int longestStreak;
  final int totalXp;
  final int weeklyXp;
  final int correctRate;
  final int totalQuizzesCompleted;
  final double averageQuizScore;
  final Map<String, int> wordsByCefr;
  final List<DailyActivity> weeklyActivity;

  const UserProgress({
    this.totalWordsLearned = 0,
    this.totalWordsReview = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalXp = 0,
    this.weeklyXp = 0,
    this.correctRate = 0,
    this.totalQuizzesCompleted = 0,
    this.averageQuizScore = 0.0,
    this.wordsByCefr = const {},
    this.weeklyActivity = const [],
  });
}

/// Daily activity model.
class DailyActivity {
  final DateTime date;
  final int wordsLearned;
  final int minutesSpent;
  final int xpEarned;
  final bool hasActivity;

  const DailyActivity({
    required this.date,
    this.wordsLearned = 0,
    this.minutesSpent = 0,
    this.xpEarned = 0,
    this.hasActivity = false,
  });
}

/// Mock progress data.
final mockUserProgress = UserProgress(
  totalWordsLearned: 156,
  totalWordsReview: 423,
  currentStreak: 7,
  longestStreak: 21,
  totalXp: 2450,
  weeklyXp: 380,
  correctRate: 82,
  totalQuizzesCompleted: 12,
  averageQuizScore: 78.5,
  wordsByCefr: {
    'A1': 80,
    'A2': 45,
    'B1': 25,
    'B2': 6,
    'C1': 0,
    'C2': 0,
  },
  weeklyActivity: _generateWeeklyActivity(),
);

List<DailyActivity> _generateWeeklyActivity() {
  final now = DateTime.now();
  return List.generate(7, (index) {
    final date = now.subtract(Duration(days: 6 - index));
    final hasActivity = index != 5 && index != 6;
    return DailyActivity(
      date: date,
      wordsLearned: hasActivity ? (10 + (index * 3) % 20) : 0,
      minutesSpent: hasActivity ? (15 + (index * 5) % 45) : 0,
      xpEarned: hasActivity ? (50 + (index * 20) % 100) : 0,
      hasActivity: hasActivity,
    );
  });
}

/// Provider for user progress.
final userProgressProvider = FutureProvider<UserProgress>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockUserProgress;
});

/// Provider for streak info.
final streakInfoProvider = Provider<({int current, int longest})>((ref) {
  final progress = ref.watch(userProgressProvider).value;
  return (
    current: progress?.currentStreak ?? 0,
    longest: progress?.longestStreak ?? 0,
  );
});

/// Provider for XP info.
final xpInfoProvider = Provider<({int total, int weekly})>((ref) {
  final progress = ref.watch(userProgressProvider).value;
  return (
    total: progress?.totalXp ?? 0,
    weekly: progress?.weeklyXp ?? 0,
  );
});

/// Weekly XP goal.
const weeklyXpGoal = 500;

/// Provider for weekly XP progress.
final weeklyXpProgressProvider = Provider<double>((ref) {
  final progress = ref.watch(userProgressProvider).value;
  final weeklyXp = progress?.weeklyXp ?? 0;
  return (weeklyXp / weeklyXpGoal).clamp(0.0, 1.0);
});
