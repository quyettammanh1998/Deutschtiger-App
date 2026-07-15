// Models cho "Video library": bộ sưu tập video YouTube được biên tập sẵn
// theo nhóm (`libraries.json` + `{slug}/learning-path.json` trên Supabase
// Storage, bucket công khai `video-libraries`), trạng thái xem lưu qua cùng
// endpoint tracker YouTube nhưng scoped theo `library_slug`/`group_id`
// (`/user/youtube/library/{slug}/...`).

/// Một thư viện (vd: "Sprechen B1"), khai báo trong `libraries.json`.
class VideoLibraryConfig {
  const VideoLibraryConfig({
    required this.slug,
    this.title = '',
    this.description = '',
  });

  final String slug;
  final String title;
  final String description;

  factory VideoLibraryConfig.fromJson(Map<String, dynamic> json) {
    return VideoLibraryConfig(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

/// Một nhóm video trong lộ trình tĩnh của thư viện.
class VideoLibraryGroup {
  const VideoLibraryGroup({
    this.order = 0,
    this.groupId = '',
    this.nameVi = '',
    this.nameDe = '',
    this.level = '',
    this.videoCount = 0,
    this.videos = const <VideoLibraryPathVideo>[],
  });

  final int order;
  final String groupId;
  final String nameVi;
  final String nameDe;
  final String level;
  final int videoCount;
  final List<VideoLibraryPathVideo> videos;

  factory VideoLibraryGroup.fromJson(Map<String, dynamic> json) {
    final videos = (json['videos'] as List<dynamic>? ?? const [])
        .map((e) => VideoLibraryPathVideo.fromJson(e as Map<String, dynamic>))
        .toList();
    return VideoLibraryGroup(
      order: (json['order'] as num?)?.toInt() ?? 0,
      groupId: json['group_id'] as String? ?? '',
      nameVi: json['group_name_vi'] as String? ?? '',
      nameDe: json['group_name_de'] as String? ?? '',
      level: json['level'] as String? ?? '',
      videoCount: (json['video_count'] as num?)?.toInt() ?? videos.length,
      videos: videos,
    );
  }
}

/// Video trong lộ trình tĩnh (chưa có trạng thái xem).
class VideoLibraryPathVideo {
  const VideoLibraryPathVideo({
    this.videoId = '',
    this.title = '',
    this.durationSeconds,
  });

  final String videoId;
  final String title;
  final int? durationSeconds;

  factory VideoLibraryPathVideo.fromJson(Map<String, dynamic> json) {
    return VideoLibraryPathVideo(
      videoId: json['video_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
    );
  }
}

/// Video đã persist trong DB, scoped theo library/group
/// (`GET/POST /user/youtube/library/{slug}/groups/{groupId}/videos`).
class LibraryVideo {
  const LibraryVideo({
    this.id = '',
    required this.videoId,
    this.groupId,
    this.librarySlug,
    this.title = '',
    this.thumbnailUrl = '',
    this.durationSeconds,
    this.status = 'pending',
    this.watchCount = 0,
  });

  final String id;
  final String videoId;
  final String? groupId;
  final String? librarySlug;
  final String title;
  final String thumbnailUrl;
  final int? durationSeconds;
  final String status;
  final int watchCount;

  bool get isCompleted => status == 'completed';
  bool get isPersisted => id.isNotEmpty;

  factory LibraryVideo.fromJson(Map<String, dynamic> json) {
    return LibraryVideo(
      id: json['id'] as String? ?? '',
      videoId: json['video_id'] as String? ?? '',
      groupId: json['group_id'] as String?,
      librarySlug: json['library_slug'] as String?,
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'pending',
      watchCount: (json['watch_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Video chưa persist — dựng tạm từ lộ trình tĩnh để hiện danh sách trước
  /// khi seed vào DB (`addGroupVideos`).
  factory LibraryVideo.fromPathVideo(
    VideoLibraryPathVideo v,
    String groupId,
    String librarySlug,
  ) {
    return LibraryVideo(
      videoId: v.videoId,
      groupId: groupId,
      librarySlug: librarySlug,
      title: v.title,
      thumbnailUrl: 'https://img.youtube.com/vi/${v.videoId}/mqdefault.jpg',
      durationSeconds: v.durationSeconds,
    );
  }
}

/// Tiến độ một nhóm (`GET /user/youtube/library/{slug}/progress`).
class LibraryGroupProgress {
  const LibraryGroupProgress({
    this.groupId = '',
    this.total = 0,
    this.completed = 0,
    this.percentage = 0,
  });

  final String groupId;
  final int total;
  final int completed;
  final double percentage;

  factory LibraryGroupProgress.fromJson(Map<String, dynamic> json) {
    return LibraryGroupProgress(
      groupId: json['group_id'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Thống kê tổng hợp của một thư viện (`GET /user/youtube/library/{slug}/stats`).
class LibraryStats {
  const LibraryStats({
    this.totalCompleted = 0,
    this.totalRewatch = 0,
    this.currentStreak = 0,
    this.groupsCompleted = 0,
  });

  final int totalCompleted;
  final int totalRewatch;
  final int currentStreak;
  final int groupsCompleted;

  factory LibraryStats.fromJson(Map<String, dynamic> json) {
    return LibraryStats(
      totalCompleted: (json['total_completed'] as num?)?.toInt() ?? 0,
      totalRewatch: (json['total_rewatch'] as num?)?.toInt() ?? 0,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      groupsCompleted: (json['groups_completed'] as num?)?.toInt() ?? 0,
    );
  }
}
