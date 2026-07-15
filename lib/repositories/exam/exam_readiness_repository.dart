import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/exam/exam_ecosystem_models.dart';

/// Repository cho exam readiness — mức sẵn sàng thi theo level/provider.
class ExamReadinessRepository {
  ExamReadinessRepository(this._apiClient);
  final ApiClient _apiClient;

  /// API: GET /api/v1/exam-readiness
  Future<ExamReadinessSnapshot> getReadiness() async {
    final data = await _apiClient.get<Map<String, dynamic>>('/exam-readiness');
    return ExamReadinessSnapshot.fromJson(data);
  }
}

final examReadinessRepositoryProvider = Provider<ExamReadinessRepository>((
  ref,
) {
  return ExamReadinessRepository(ref.watch(apiClientProvider));
});
