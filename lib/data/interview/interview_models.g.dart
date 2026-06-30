// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InterviewGroup _$InterviewGroupFromJson(Map<String, dynamic> json) =>
    _InterviewGroup(
      order: (json['order'] as num?)?.toInt() ?? 0,
      groupId: json['group_id'] as String? ?? '',
      nameVi: json['group_name_vi'] as String? ?? '',
      nameDe: json['group_name_de'] as String? ?? '',
      descriptionVi: json['description_vi'] as String? ?? '',
      level: json['level'] as String? ?? '',
      videoCount: (json['video_count'] as num?)?.toInt() ?? 0,
      videos:
          (json['videos'] as List<dynamic>?)
              ?.map((e) => PathVideo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PathVideo>[],
    );

Map<String, dynamic> _$InterviewGroupToJson(_InterviewGroup instance) =>
    <String, dynamic>{
      'order': instance.order,
      'group_id': instance.groupId,
      'group_name_vi': instance.nameVi,
      'group_name_de': instance.nameDe,
      'description_vi': instance.descriptionVi,
      'level': instance.level,
      'video_count': instance.videoCount,
      'videos': instance.videos,
    };

_PathVideo _$PathVideoFromJson(Map<String, dynamic> json) => _PathVideo(
  videoId: json['video_id'] as String? ?? '',
  title: json['title'] as String? ?? '',
  durationSeconds: (json['duration_seconds'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PathVideoToJson(_PathVideo instance) =>
    <String, dynamic>{
      'video_id': instance.videoId,
      'title': instance.title,
      'duration_seconds': instance.durationSeconds,
    };

_InterviewVideo _$InterviewVideoFromJson(Map<String, dynamic> json) =>
    _InterviewVideo(
      id: json['id'] as String,
      groupId: json['group_id'] as String? ?? '',
      videoId: json['video_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      watchCount: (json['watch_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$InterviewVideoToJson(_InterviewVideo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'video_id': instance.videoId,
      'title': instance.title,
      'status': instance.status,
      'watch_count': instance.watchCount,
    };

_InterviewGroupProgress _$InterviewGroupProgressFromJson(
  Map<String, dynamic> json,
) => _InterviewGroupProgress(
  groupId: json['group_id'] as String? ?? '',
  total: (json['total'] as num?)?.toInt() ?? 0,
  completed: (json['completed'] as num?)?.toInt() ?? 0,
  percentage: (json['percentage'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$InterviewGroupProgressToJson(
  _InterviewGroupProgress instance,
) => <String, dynamic>{
  'group_id': instance.groupId,
  'total': instance.total,
  'completed': instance.completed,
  'percentage': instance.percentage,
};
