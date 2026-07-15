/// Moments-feed DTOs matching `internal/infra/database/moment_repo.go`.
/// Read + like are live in this phase; comment/create writes stay out of
/// scope (public UGC write needs moderation, see phase-03 spec).
class Moment {
  const Moment({
    required this.id,
    required this.userId,
    required this.content,
    required this.tags,
    required this.createdAt,
    required this.displayName,
    required this.avatarUrl,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
  });

  final String id;
  final String userId;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
  final String displayName;
  final String avatarUrl;
  final int likeCount;
  final int commentCount;
  final bool isLiked;

  Moment copyWithLike({required bool isLiked, required int likeCount}) =>
      Moment(
        id: id,
        userId: userId,
        content: content,
        tags: tags,
        createdAt: createdAt,
        displayName: displayName,
        avatarUrl: avatarUrl,
        likeCount: likeCount,
        commentCount: commentCount,
        isLiked: isLiked,
      );

  factory Moment.fromJson(Map<String, dynamic> json) => Moment(
    id: json['id'] as String? ?? '',
    userId: json['user_id'] as String? ?? '',
    content: json['content'] as String? ?? '',
    tags:
        (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        const [],
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
    displayName: json['display_name'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String? ?? '',
    likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
    commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
    isLiked: json['is_liked'] as bool? ?? false,
  );
}

class MomentComment {
  const MomentComment({
    required this.id,
    required this.momentId,
    required this.userId,
    required this.content,
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
  });

  final String id;
  final String momentId;
  final String userId;
  final String content;
  final String displayName;
  final String avatarUrl;
  final DateTime createdAt;

  factory MomentComment.fromJson(Map<String, dynamic> json) => MomentComment(
    id: json['id'] as String? ?? '',
    momentId: json['moment_id'] as String? ?? '',
    userId: json['user_id'] as String? ?? '',
    content: json['content'] as String? ?? '',
    displayName: json['display_name'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String? ?? '',
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
  );
}
