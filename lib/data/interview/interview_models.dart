import 'package:freezed_annotation/freezed_annotation.dart';

part 'interview_models.freezed.dart';
part 'interview_models.g.dart';

/// Một nhóm video trong lộ trình tĩnh (`/data/youtube/phong_van/learning-path.json`).
@freezed
abstract class InterviewGroup with _$InterviewGroup {
  const factory InterviewGroup({
    @Default(0) int order,
    @JsonKey(name: 'group_id') @Default('') String groupId,
    @JsonKey(name: 'group_name_vi') @Default('') String nameVi,
    @JsonKey(name: 'group_name_de') @Default('') String nameDe,
    @JsonKey(name: 'description_vi') @Default('') String descriptionVi,
    @Default('') String level,
    @JsonKey(name: 'video_count') @Default(0) int videoCount,
    @Default(<PathVideo>[]) List<PathVideo> videos,
  }) = _InterviewGroup;

  factory InterviewGroup.fromJson(Map<String, dynamic> json) =>
      _$InterviewGroupFromJson(json);
}

/// Video trong lộ trình tĩnh (metadata YouTube, chưa có trạng thái xem).
@freezed
abstract class PathVideo with _$PathVideo {
  const factory PathVideo({
    @JsonKey(name: 'video_id') @Default('') String videoId,
    @Default('') String title,
    @JsonKey(name: 'duration_seconds') @Default(0) int durationSeconds,
  }) = _PathVideo;

  factory PathVideo.fromJson(Map<String, dynamic> json) =>
      _$PathVideoFromJson(json);
}

/// Trạng thái xem một video từ DB (`GET /user/interview/videos?group_id=`).
/// `status` ∈ pending | completed.
@freezed
abstract class InterviewVideo with _$InterviewVideo {
  const factory InterviewVideo({
    required String id,
    @JsonKey(name: 'group_id') @Default('') String groupId,
    @JsonKey(name: 'video_id') @Default('') String videoId,
    @Default('') String title,
    @Default('pending') String status,
    @JsonKey(name: 'watch_count') @Default(0) int watchCount,
  }) = _InterviewVideo;

  const InterviewVideo._();

  bool get isCompleted => status == 'completed';

  factory InterviewVideo.fromJson(Map<String, dynamic> json) =>
      _$InterviewVideoFromJson(json);
}

/// Tiến độ một nhóm (`GET /user/interview/group-progress`).
@freezed
abstract class InterviewGroupProgress with _$InterviewGroupProgress {
  const factory InterviewGroupProgress({
    @JsonKey(name: 'group_id') @Default('') String groupId,
    @Default(0) int total,
    @Default(0) int completed,
    @Default(0) int percentage,
  }) = _InterviewGroupProgress;

  factory InterviewGroupProgress.fromJson(Map<String, dynamic> json) =>
      _$InterviewGroupProgressFromJson(json);
}
