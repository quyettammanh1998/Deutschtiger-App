import '../../../services/api_client.dart';
import '../domain/daily_path.dart';

class DailyPathRepository {
  const DailyPathRepository(this._api);

  final ApiClient _api;

  Future<DailyPath> fetchToday({String timezone = 'Asia/Bangkok'}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/learn/path/today',
      query: {'tz': timezone},
    );
    return DailyPath.fromJson(json);
  }
}
