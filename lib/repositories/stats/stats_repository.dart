import '../../data/stats/stats_models.dart';

class StatsRepository {
  Future<List<ErrorPattern>> getErrorPatterns() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockErrorPatterns;
  }

  Future<SRSStats> getSRSStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const SRSStats(
      odlId: 'user1',
      totalReviews: 1250,
      totalCorrect: 1050,
      totalIncorrect: 200,
      retentionRate: 84.0,
      currentStreak: 15,
      longestStreak: 45,
      totalActiveDays: 120,
      cardsLearned: 500,
      cardsMature: 300,
      cardsYoung: 180,
      cardsRelearning: 20,
      intervalDistribution: {
        '1d': 50,
        '3d': 80,
        '7d': 100,
        '14d': 70,
        '30d': 50,
        '60d+': 30,
      },
    );
  }

  Future<List<NearAchievement>> getNearAchievements() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockNearAchievements;
  }

  Future<StreakInfo> getStreakInfo() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const StreakInfo(
      odlId: 'user1',
      currentStreak: 15,
      longestStreak: 45,
      totalActiveDays: 120,
      weeklyGoal: 7,
      weeklyProgress: 5,
    );
  }

  Future<TimeStats> getTimeStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const TimeStats(
      odlId: 'user1',
      totalMinutes: 1800,
      todayMinutes: 45,
      weekMinutes: 320,
      monthMinutes: 1250,
      minutesByFeature: {
        'vocabulary': 600,
        'grammar': 400,
        'speaking': 300,
        'listening': 250,
        'games': 250,
      },
      averageMinutesPerDay: 35.0,
    );
  }

  Future<List<ErrorPattern>> getTopErrors({int limit = 5}) async {
    final patterns = await getErrorPatterns();
    patterns.sort((a, b) => b.errorCount.compareTo(a.errorCount));
    return patterns.take(limit).toList();
  }

  Future<Map<String, dynamic>> getDetailedAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'totalXp': 12500,
      'level': 12,
      'xpToNextLevel': 500,
      'totalWordsLearned': 500,
      'totalSentencesLearned': 200,
      'averageAccuracy': 84.5,
      'strongestArea': 'Vocabulary',
      'weakestArea': 'Grammar Cases',
      'weeklyProgress': {
        'xp': 1200,
        'words': 45,
        'sentences': 15,
        'accuracy': 82.0,
      },
      'monthlyTrend': {
        'xpGrowth': 15.5,
        'accuracyImprovement': 3.2,
        'timeSpentGrowth': 8.7,
      },
    };
  }

  static final List<ErrorPattern> _mockErrorPatterns = [
    const ErrorPattern(
      id: 'error-1',
      odlId: 'user1',
      grammarCategory: 'Akkusativ',
      grammarCategoryVi: 'Tân ngữ',
      errorCount: 45,
      totalAttempts: 200,
      errorRate: 22.5,
      exampleErrors: [
        'Ich habe das Buch genommen (instead of: genommen)',
        'Sie sieht der Film (instead of: den Film)',
      ],
      suggestions: [
        'Review the article endings for Akkusativ',
        'Practice with: den, die, das → remember the pattern',
      ],
    ),
    const ErrorPattern(
      id: 'error-2',
      odlId: 'user1',
      grammarCategory: 'Verb Conjugation',
      grammarCategoryVi: 'Biến đổi động từ',
      errorCount: 38,
      totalAttempts: 250,
      errorRate: 15.2,
      exampleErrors: [
        'Er gehen nach Hause (instead of: geht)',
        'Wir spielen Fußball (instead of: spielen - correct actually)',
      ],
      suggestions: [
        'Focus on irregular verb conjugations',
        'Practice modal verbs: können, müssen, sollen',
      ],
    ),
    const ErrorPattern(
      id: 'error-3',
      odlId: 'user1',
      grammarCategory: 'Wortstellung',
      grammarCategoryVi: 'Thứ tự từ',
      errorCount: 32,
      totalAttempts: 180,
      errorRate: 17.8,
      exampleErrors: [
        'Gestern ich habe gearbeitet (instead of: ich habe gestern gearbeitet)',
        'Ich möchte einen Kaffee und ich gehe nach Hause (instead of: ...und gehe...)',
      ],
      suggestions: [
        'Time expressions usually come early in the sentence',
        'Verb in second position for main clauses',
      ],
    ),
    const ErrorPattern(
      id: 'error-4',
      odlId: 'user1',
      grammarCategory: 'Präpositionen',
      grammarCategoryVi: 'Giới từ',
      errorCount: 28,
      totalAttempts: 150,
      errorRate: 18.7,
      exampleErrors: [
        'Ich warte auf mein Freund (instead of: auf meinen Freund)',
        'Er interessiert sich für die Musik (instead of: für die Musik - correct)',
      ],
      suggestions: [
        'Learn which prepositions take Akkusativ vs Dativ',
        'Remember: aus, bei, mit, nach, von, zu → always Dativ',
      ],
    ),
    const ErrorPattern(
      id: 'error-5',
      odlId: 'user1',
      grammarCategory: 'Adjective Endings',
      grammarCategoryVi: 'Đuôi tính từ',
      errorCount: 25,
      totalAttempts: 120,
      errorRate: 20.8,
      exampleErrors: [
        'ein gut Mensch (instead of: guter Mensch)',
        'die groß Haus (instead of: große Haus)',
      ],
      suggestions: [
        'Adjectives after ein/eine need different endings',
        'Practice the adjective declension table',
      ],
    ),
  ];

  static final List<NearAchievement> _mockNearAchievements = [
    const NearAchievement(
      achievementId: 'ach-1',
      name: 'Week Warrior',
      nameVi: 'Chiến binh Tuần',
      description: 'Complete a 7-day learning streak',
      descriptionVi: 'Hoàn thành chuỗi học 7 ngày liên tiếp',
      icon: '🔥',
      progress: 0.85,
      currentValue: 6,
      targetValue: 7,
      xpReward: 100,
    ),
    const NearAchievement(
      achievementId: 'ach-2',
      name: 'Vocabulary Master',
      nameVi: 'Bậc thầy Từ vựng',
      description: 'Learn 500 new words',
      descriptionVi: 'Học 500 từ mới',
      icon: '📚',
      progress: 0.90,
      currentValue: 450,
      targetValue: 500,
      xpReward: 200,
    ),
    const NearAchievement(
      achievementId: 'ach-3',
      name: 'Perfect Score',
      nameVi: 'Điểm hoàn hảo',
      description: 'Get 100% on 10 quizzes',
      descriptionVi: 'Đạt 100% trong 10 bài quiz',
      icon: '⭐',
      progress: 0.70,
      currentValue: 7,
      targetValue: 10,
      xpReward: 150,
    ),
    const NearAchievement(
      achievementId: 'ach-4',
      name: 'Speaking Champion',
      nameVi: 'Vô địch Nói',
      description: 'Complete 50 speaking exercises',
      descriptionVi: 'Hoàn thành 50 bài tập nói',
      icon: '🎤',
      progress: 0.60,
      currentValue: 30,
      targetValue: 50,
      xpReward: 175,
    ),
  ];
}
