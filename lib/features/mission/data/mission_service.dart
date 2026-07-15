import '../../../services/api_client.dart';
import '../domain/mission_models.dart';

/// Mission-native persistence — mirrors web `lib/learn/learn-service.ts`
/// mission calls. NEVER FSRS: rounds/mission completion use their own
/// backend endpoints (`user_daily_missions` table), not `/user/srs/review`.
class MissionService {
  MissionService(this._api);

  final ApiClient _api;

  /// `GET /api/v1/user/learn/mission/today` — today's mission (words + rounds),
  /// computed/persisted server-side.
  Future<DailyMission> fetchTodayMission() async {
    final json =
        await _api.get<Map<String, dynamic>>('/user/learn/mission/today');
    return DailyMission.fromJson(json);
  }

  /// `POST /api/v1/user/learn/mission/{id}/start` — marks `started_at` once.
  Future<void> startMission(String missionId) async {
    await _api
        .post<Map<String, dynamic>>('/user/learn/mission/$missionId/start');
  }

  /// `POST /api/v1/user/learn/mission/{id}/round/{idx}/complete`.
  Future<void> completeRound(
    String missionId,
    int roundIndex,
    CompleteRoundPayload payload,
  ) async {
    await _api.post<Map<String, dynamic>>(
      '/user/learn/mission/$missionId/round/$roundIndex/complete',
      body: payload.toJson(),
    );
  }

  /// `POST /api/v1/user/learn/mission/{id}/complete` — idempotent finalize + XP award.
  Future<CompleteMissionResult> completeMission(String missionId) async {
    final json = await _api.post<Map<String, dynamic>>(
        '/user/learn/mission/$missionId/complete');
    return CompleteMissionResult.fromJson(json);
  }
}
