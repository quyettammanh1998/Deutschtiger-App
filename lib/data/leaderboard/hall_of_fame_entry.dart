/// Top-3 snapshot from a past weekly leaderboard reset.
/// `GET /leaderboard/hall-of-fame` — mirror web `types/leaderboard`
/// `HallOfFameEntry` (backend `database.HallOfFameEntry`).
class HallOfFameEntry {
  const HallOfFameEntry({
    required this.id,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.weeklyXp = 0,
    required this.rank,
    this.weekStart,
  });

  final String id;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int weeklyXp;
  final int rank;
  final String? weekStart;

  factory HallOfFameEntry.fromJson(Map<String, dynamic> json) {
    return HallOfFameEntry(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      weeklyXp: (json['weekly_xp'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      weekStart: json['week_start'] as String?,
    );
  }
}
