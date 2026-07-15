/// Models cho YouTube tracker cá nhân (`/user/youtube/videos*`).
/// Video do người dùng tự thêm bằng URL, khác lộ trình tĩnh của interview.
class YouTubeVideo {
  const YouTubeVideo({
    this.id = '',
    this.userId = '',
    required this.videoId,
    this.youtubeUrl = '',
    this.title,
    this.thumbnailUrl,
    this.status = 'pending',
    this.watchCount = 0,
    this.addedAt,
    this.watchedAt,
    this.category,
  });

  final String id;
  final String userId;
  final String videoId;
  final String youtubeUrl;
  final String? title;
  final String? thumbnailUrl;
  final String status;
  final int watchCount;
  final DateTime? addedAt;
  final DateTime? watchedAt;
  final String? category;

  bool get isCompleted => status == 'completed';
  bool get isPersisted => id.isNotEmpty;

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) =>
        v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;
    return YouTubeVideo(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      videoId: json['video_id'] as String? ?? '',
      youtubeUrl: json['youtube_url'] as String? ?? '',
      title: json['title'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      watchCount: (json['watch_count'] as num?)?.toInt() ?? 0,
      addedAt: parseDate(json['added_at']),
      watchedAt: parseDate(json['watched_at']),
      category: json['category'] as String?,
    );
  }

  /// Video chưa từng lưu vào DB — dựng tạm từ videoId để hiện player trước
  /// khi lazy-add (giống hành vi web: chỉ persist khi user thực sự xem/hoàn thành).
  factory YouTubeVideo.unsaved({required String videoId, String? title}) {
    return YouTubeVideo(
      videoId: videoId,
      youtubeUrl: 'https://www.youtube.com/watch?v=$videoId',
      title: title,
      thumbnailUrl: 'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
    );
  }

  YouTubeVideo copyWith({String? id, String? status, int? watchCount}) {
    return YouTubeVideo(
      id: id ?? this.id,
      userId: userId,
      videoId: videoId,
      youtubeUrl: youtubeUrl,
      title: title,
      thumbnailUrl: thumbnailUrl,
      status: status ?? this.status,
      watchCount: watchCount ?? this.watchCount,
      addedAt: addedAt,
      watchedAt: watchedAt,
      category: category,
    );
  }
}

/// Video phổ biến do nhiều người dùng thêm (`GET /user/youtube/popular`).
class YouTubePopularVideo {
  const YouTubePopularVideo({
    required this.videoId,
    this.title = '',
    this.thumbnailUrl = '',
    this.youtubeUrl = '',
    this.userCount = 0,
  });

  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String youtubeUrl;
  final int userCount;

  factory YouTubePopularVideo.fromJson(Map<String, dynamic> json) {
    return YouTubePopularVideo(
      videoId: json['video_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      youtubeUrl: json['youtube_url'] as String? ?? '',
      userCount: (json['user_count'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Thống kê tổng hợp (`GET /user/youtube/stats`).
class YouTubeStats {
  const YouTubeStats({
    this.totalCompleted = 0,
    this.thisWeek = 0,
    this.thisMonth = 0,
    this.today = 0,
    this.maxWatchCount = 0,
    this.totalRewatches = 0,
  });

  final int totalCompleted;
  final int thisWeek;
  final int thisMonth;
  final int today;
  final int maxWatchCount;
  final int totalRewatches;

  factory YouTubeStats.fromJson(Map<String, dynamic> json) {
    return YouTubeStats(
      totalCompleted: (json['total_completed'] as num?)?.toInt() ?? 0,
      thisWeek: (json['this_week'] as num?)?.toInt() ?? 0,
      thisMonth: (json['this_month'] as num?)?.toInt() ?? 0,
      today: (json['today'] as num?)?.toInt() ?? 0,
      maxWatchCount: (json['max_watch_count'] as num?)?.toInt() ?? 0,
      totalRewatches: (json['total_rewatches'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Một ngày trong biểu đồ hoạt động (`GET /user/youtube/contributions`).
class YouTubeContributionDay {
  const YouTubeContributionDay({required this.date, this.count = 0});

  final DateTime date;
  final int count;

  factory YouTubeContributionDay.fromJson(Map<String, dynamic> json) {
    return YouTubeContributionDay(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime(1970),
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}
