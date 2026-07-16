/// Models cho Easy German level pages (`/listening/easy-german/:level`).
///
/// Index là file JSON tĩnh `{staticBaseUrl}/data/listening/EasyGerman-{LEVEL}/
/// index.json` (không đi qua `/api/v1`) — cùng lộ trình với
/// `PodcastRepository`/`GrammarRepository`. Leaderboard dùng chung endpoint
/// generic `POST /listening/easy-german/leaderboard` cho mọi bộ sưu tập video
/// (Easy German level, Sprechen B1/B2).
class EasyGermanVideo {
  const EasyGermanVideo({
    required this.videoId,
    required this.title,
    this.segments = 0,
  });

  final String videoId;
  final String title;
  final int segments;

  factory EasyGermanVideo.fromJson(Map<String, dynamic> json) {
    return EasyGermanVideo(
      videoId: json['video_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      segments: (json['segments'] as num?)?.toInt() ?? 0,
    );
  }
}

/// 1 dòng trong bảng xếp hạng theo bộ video (generic, không riêng level).
class VideoCollectionLeaderboardEntry {
  const VideoCollectionLeaderboardEntry({
    required this.userId,
    required this.displayName,
    this.avatarUrl = '',
    this.videosCompleted = 0,
    this.totalRewatch = 0,
    this.rank = 0,
    this.score = 0,
  });

  final String userId;
  final String displayName;
  final String avatarUrl;
  final int videosCompleted;
  final int totalRewatch;
  final int rank;
  final int score;

  factory VideoCollectionLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return VideoCollectionLeaderboardEntry(
      userId: json['user_id'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      videosCompleted: (json['videos_completed'] as num?)?.toInt() ?? 0,
      totalRewatch: (json['total_rewatch'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
    );
  }
}
