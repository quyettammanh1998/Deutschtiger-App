import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/exam/exam_ecosystem_models.dart';

/// Repository cho lịch thi đã đăng ký + danh bạ tìm bạn ôn thi (read-only).
///
/// GAP đã biết: `GET /api/v1/user/exam-buddies/{id}/contact` (lộ SĐT/email/
/// Facebook của người khác) KHÔNG được ship trong phase này — buddy finder là
/// read-only match list, chờ report/block (GĐ2 P3) trước khi mở tương tác
/// liên hệ trực tiếp. Xem `docs/api-changelog.md`.
class ExamRegistrationRepository {
  ExamRegistrationRepository(this._apiClient);
  final ApiClient _apiClient;

  /// API: GET /api/v1/user/exam-registrations
  Future<List<ExamRegistration>> listMine() async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/user/exam-registrations',
    );
    final items = data['registrations'] as List<dynamic>? ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(ExamRegistration.fromJson)
        .toList();
  }

  /// API: POST /api/v1/user/exam-registrations
  Future<ExamRegistration> create(ExamRegistration plan) async {
    final data = await _apiClient.post<Map<String, dynamic>>(
      '/user/exam-registrations',
      body: plan.toJson(),
    );
    return ExamRegistration.fromJson(
      data['registration'] as Map<String, dynamic>,
    );
  }

  /// API: PUT /api/v1/user/exam-registrations/{id}
  Future<ExamRegistration> update(String id, ExamRegistration plan) async {
    final data = await _apiClient.put<Map<String, dynamic>>(
      '/user/exam-registrations/$id',
      body: plan.toJson(),
    );
    return ExamRegistration.fromJson(
      data['registration'] as Map<String, dynamic>,
    );
  }

  /// API: DELETE /api/v1/user/exam-registrations/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete<dynamic>('/user/exam-registrations/$id');
  }

  /// API: GET /api/v1/exam-buddies (public directory, read-only).
  Future<List<ExamBuddy>> listBuddies() async {
    final data = await _apiClient.get<List<dynamic>>('/exam-buddies');
    return data.whereType<Map<String, dynamic>>().map(ExamBuddy.fromJson).toList();
  }
}

final examRegistrationRepositoryProvider =
    Provider<ExamRegistrationRepository>((ref) {
      return ExamRegistrationRepository(ref.watch(apiClientProvider));
    });
