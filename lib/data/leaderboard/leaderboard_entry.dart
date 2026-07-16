/// A row in either the weekly composite leaderboard or the all-time XP
/// leaderboard. Backend response shapes:
///   - `/leaderboard/weekly`, `/user/leaderboard/friends`,
///     `/user/leaderboard/weekly-rank` -> full weekly composite fields.
///   - `/gamification/leaderboard`, `/gamification/user-rank` -> user_id,
///     display_name, avatar_url, total_xp, level, current_streak (no
///     weekly_* fields).
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.id,
    required this.displayName,
    this.avatarUrl,
    required this.xp,
    required this.streak,
    this.isCurrentUser = false,
    this.weeklyXp = 0,
    this.examPoints = 0,
    this.missionCount = 0,
    this.vocabReviewed = 0,
    this.readingCount = 0,
    this.speakWriteCount = 0,
    this.wordsAdded = 0,
    this.isPremium = false,
    this.isNewUserDampened = false,
    this.lastWeekRank,
    this.totalXp = 0,
    this.level = 0,
  });

  final int rank;
  final String id;
  final String displayName;
  final String? avatarUrl;

  /// Điểm hiển thị chính (composite `weekly_score` khi có, fallback
  /// `weekly_xp`/`total_xp`/`xp` — mirror web `entry.weekly_score ?? entry.weekly_xp`,
  /// verified `weekly-leaderboard.tsx:112`).
  final int xp;
  final int streak;
  final bool isCurrentUser;

  /// XP tuần thô (khác [xp] composite) — dùng cho breakdown chips/detail sheet.
  final int weeklyXp;
  final int examPoints;
  final int missionCount;
  final int vocabReviewed;
  final int readingCount;
  final int speakWriteCount;
  final int wordsAdded;
  final bool isPremium;
  final bool isNewUserDampened;

  /// Rank tuần trước; null = chưa có tuần xếp hạng nào trước đó ("Mới").
  final int? lastWeekRank;
  final int totalXp;
  final int level;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> j, int rank) {
    final weeklyScore = (j['weekly_score'] as num?)?.toInt();
    final weeklyXp = (j['weekly_xp'] as num?)?.toInt();
    return LeaderboardEntry(
      rank: rank,
      id: j['user_id'] as String? ?? j['id'] as String? ?? '',
      displayName:
          j['display_name'] as String? ?? j['displayName'] as String? ?? '',
      avatarUrl: j['avatar_url'] as String?,
      xp:
          weeklyScore ??
          weeklyXp ??
          (j['total_xp'] as num?)?.toInt() ??
          (j['xp'] as num?)?.toInt() ??
          0,
      streak:
          (j['current_streak'] as num?)?.toInt() ??
          (j['streak'] as num?)?.toInt() ??
          0,
      isCurrentUser: j['is_current_user'] as bool? ?? false,
      weeklyXp: weeklyXp ?? 0,
      examPoints: (j['weekly_exam_points'] as num?)?.toInt() ?? 0,
      missionCount: (j['weekly_mission_count'] as num?)?.toInt() ?? 0,
      vocabReviewed: (j['weekly_vocab_reviewed'] as num?)?.toInt() ?? 0,
      readingCount: (j['weekly_reading_count'] as num?)?.toInt() ?? 0,
      speakWriteCount: (j['weekly_speak_write_count'] as num?)?.toInt() ?? 0,
      wordsAdded: (j['weekly_words_added'] as num?)?.toInt() ?? 0,
      isPremium: j['is_premium'] as bool? ?? false,
      isNewUserDampened: j['is_new_user_dampened'] as bool? ?? false,
      lastWeekRank: (j['last_week_rank'] as num?)?.toInt(),
      totalXp: (j['total_xp'] as num?)?.toInt() ?? 0,
      level: (j['level'] as num?)?.toInt() ?? 0,
    );
  }
}
