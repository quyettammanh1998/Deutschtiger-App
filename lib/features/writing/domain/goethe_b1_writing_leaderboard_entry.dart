/// One row of `GET /user/goethe-b1-writing-leaderboard?teil=` — web parity
/// `GoetheB1WritingLeaderboardRow` (Go `database.GoetheB1WritingLeaderboardRow`).
class GoetheB1WritingLeaderboardEntry {
  const GoetheB1WritingLeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.completedCount,
    required this.rank,
  });

  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int completedCount;
  final int rank;

  factory GoetheB1WritingLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return GoetheB1WritingLeaderboardEntry(
      userId: json['user_id']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      completedCount: (json['completed_count'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );
  }
}
