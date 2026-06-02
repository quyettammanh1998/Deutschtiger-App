import '../../../core/network/api_client.dart';
import '../domain/dashboard_data.dart';

/// Lấy dữ liệu Home trong 1 round-trip (`GET /api/v1/user/dashboard-init`).
class DashboardRepository {
  DashboardRepository(this._api);

  final ApiClient _api;

  Future<DashboardData> fetchDashboard() async {
    final json = await _api.get<Map<String, dynamic>>('/user/dashboard-init');
    return DashboardData.fromJson(json);
  }
}
