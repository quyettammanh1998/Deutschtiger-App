import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/data/social/moment_models.dart';

/// Moments feed — `internal/feature/social/moment/moment_handler.go`. Read +
/// like are live; create-moment/add-comment stay out of scope in this phase
/// (public UGC write needs moderation — see phase-03 spec).
class MomentRepository {
  MomentRepository(this._api);

  final ApiClient _api;

  Future<List<Moment>> getFeed({int limit = 20, int offset = 0}) async {
    final json = await _api.get<List<dynamic>>(
      '/moments/feed',
      query: {'limit': limit, 'offset': offset},
    );
    return json.map((e) => Moment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MomentComment>> getComments(String momentId) async {
    final json = await _api.get<List<dynamic>>('/moments/$momentId/comments');
    return json
        .map((e) => MomentComment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> like(String momentId) async {
    await _api.post<Map<String, dynamic>>('/user/moments/$momentId/like');
  }

  Future<void> unlike(String momentId) async {
    await _api.delete<Map<String, dynamic>>('/user/moments/$momentId/like');
  }
}
