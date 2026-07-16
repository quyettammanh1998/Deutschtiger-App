import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/exam/exam_ecosystem_models.dart';

/// Repository cho đề thi cộng đồng — READ-ONLY (list/detail). Comment/vote/
/// report/generate là write path, để GĐ2 P3 quyết chung với social moderation.
class CommunityExamRepository {
  CommunityExamRepository(this._apiClient);
  final ApiClient _apiClient;

  /// API: GET /api/v1/user/community/exams/?provider=&level=&skill=&teil=
  Future<List<CommunityExamTopic>> list({
    String? provider,
    String? level,
    String? skill,
    int? teil,
  }) async {
    final query = <String, dynamic>{};
    if (provider != null) query['provider'] = provider;
    if (level != null) query['level'] = level;
    if (skill != null) query['skill'] = skill;
    if (teil != null) query['teil'] = teil;
    final data = await _apiClient.get<List<dynamic>>(
      '/user/community/exams/',
      query: query,
    );
    return data
        .whereType<Map<String, dynamic>>()
        .map(CommunityExamTopic.fromJson)
        .toList();
  }

  /// API: GET /api/v1/user/community/exams/{id}
  Future<CommunityExamTopic> getById(String id) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/user/community/exams/$id',
    );
    return CommunityExamTopic.fromJson(data);
  }
}

final communityExamRepositoryProvider = Provider<CommunityExamRepository>((
  ref,
) {
  return CommunityExamRepository(ref.watch(apiClientProvider));
});
