import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/stats/stats_models.dart';

/// Sổ lỗi ngữ pháp — tổng hợp từ bài viết/nói/luyện câu của user.
class ErrorPatternsRepository {
  ErrorPatternsRepository(this._api);

  final ApiClient _api;

  /// Tổng hợp theo loại lỗi, đã gộp nguồn. `GET /user/error-patterns/summary`.
  Future<List<ErrorPatternSummary>> getSummary() async {
    final list = await _api.get<List<dynamic>>('/user/error-patterns/summary');
    return list
        .map((e) => ErrorPatternSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final errorPatternsRepositoryProvider = Provider<ErrorPatternsRepository>((
  ref,
) {
  return ErrorPatternsRepository(ref.watch(apiClientProvider));
});
