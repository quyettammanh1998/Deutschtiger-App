/// Ghi chu cho video YouTube.
/// API: GET/PUT /user/youtube/notes/{videoId}
class VideoNote {
  const VideoNote({
    this.id = '',
    this.userId = '',
    required this.videoId,
    this.content = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  final String id;
  final String userId;
  final String videoId;
  final String content;
  final String createdAt;
  final String updatedAt;

  factory VideoNote.fromJson(Map<String, dynamic> json) {
    return VideoNote(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      videoId: json['video_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'video_id': videoId,
        'content': content,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

/// Ghi chu voi thong tin video (cho list view).
class NoteWithVideo {
  const NoteWithVideo({
    this.id = '',
    required this.videoId,
    this.content = '',
    this.updatedAt = '',
    this.videoTitle,
    this.thumbnailUrl,
    this.category,
    this.groupId,
  });

  final String id;
  final String videoId;
  final String content;
  final String updatedAt;
  final String? videoTitle;
  final String? thumbnailUrl;
  final String? category;
  final String? groupId;

  factory NoteWithVideo.fromJson(Map<String, dynamic> json) {
    return NoteWithVideo(
      id: json['id'] as String? ?? '',
      videoId: json['video_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      videoTitle: json['video_title'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      category: json['category'] as String?,
      groupId: json['group_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'video_id': videoId,
        'content': content,
        'updated_at': updatedAt,
        'video_title': videoTitle,
        'thumbnail_url': thumbnailUrl,
        'category': category,
        'group_id': groupId,
      };
}
