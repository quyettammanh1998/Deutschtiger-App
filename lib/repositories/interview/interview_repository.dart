import 'package:deutschtiger/services/api_client.dart';
import '../domain/interview_models.dart';

/// Lấy lộ trình video (file tĩnh) + trạng thái xem (API) + đánh dấu hoàn thành.
///
/// Lộ trình nằm ở file tĩnh NGOÀI `/api/v1` nên fetch bằng absolute URL qua
/// dio raw; các call user-state đi qua [ApiClient] bình thường (kèm JWT).
class InterviewRepository {
  InterviewRepository(this._api, {required String staticBaseUrl})
    : _learningPathUrl =
          '$staticBaseUrl/data/youtube/phong_van/learning-path.json';

  final ApiClient _api;
  final String _learningPathUrl;

  /// 18 nhóm video từ file tĩnh. Bọc trong `{ learning_path: [...] }`.
  Future<List<InterviewGroup>> fetchLearningPath() async {
    final res = await _api.raw.get<Map<String, dynamic>>(_learningPathUrl);
    final data = res.data ?? const <String, dynamic>{};
    final list = (data['learning_path'] as List<dynamic>?) ?? const [];
    return list
        .map((e) => InterviewGroup.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Trạng thái xem các video của một nhóm (`GET /user/interview/videos`).
  /// Premium-gated: nếu chưa mua server trả 403 → ApiClient ném, caller bắt.
  Future<List<InterviewVideo>> fetchVideosByGroup(String groupId) async {
    final list = await _api.get<List<dynamic>>(
      '/user/interview/videos',
      query: {'group_id': groupId},
    );
    return list
        .map((e) => InterviewVideo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Seed metadata video vào DB để mỗi video có `id` (dùng cho complete/rewatch).
  /// Backend `ON CONFLICT DO NOTHING` → gọi nhiều lần an toàn (idempotent).
  /// Body: { group_id, videos: [{video_id, title}] }.
  Future<void> seedGroupVideos(
    String groupId,
    List<({String videoId, String title})> videos,
  ) async {
    if (videos.isEmpty) return;
    await _api.post<dynamic>(
      '/user/interview/videos/batch',
      body: {
        'group_id': groupId,
        'videos': [
          for (final v in videos) {'video_id': v.videoId, 'title': v.title},
        ],
      },
    );
  }

  /// Tiến độ tất cả nhóm (`GET /user/interview/group-progress`).
  Future<List<InterviewGroupProgress>> fetchGroupProgress() async {
    final list = await _api.get<List<dynamic>>(
      '/user/interview/group-progress',
    );
    return list
        .map((e) => InterviewGroupProgress.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Đánh dấu video hoàn thành (`PUT .../{id}/complete`, body rỗng).
  /// Server trả `{status:ok}`; ta không dùng body, chỉ refetch sau đó.
  Future<void> complete(String id) =>
      _putVideo('/user/interview/videos/$id/complete');

  /// Xem lại video đã hoàn thành (`PUT .../{id}/rewatch`, body rỗng).
  Future<void> rewatch(String id) =>
      _putVideo('/user/interview/videos/$id/rewatch');

  Future<void> _putVideo(String path) =>
      _api.put<dynamic>(path, body: const {});
}
