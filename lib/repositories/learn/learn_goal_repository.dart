import 'package:deutschtiger/services/api_client.dart';

import '../../data/learn/learn_goal.dart';

/// Repository for the user's exam learning goal — `GET /user/learn/goals`.
/// Backend always responds 200 with a synthesized default when no goal row
/// exists yet (see `learning/learn_goals_handler.go`), so this never
/// surfaces a 404 for "no goal" — callers check `targetDate == null` instead.
class LearnGoalRepository {
  LearnGoalRepository(this._api);

  final ApiClient _api;

  Future<LearnGoal> fetchGoal() async {
    final json = await _api.get<Map<String, dynamic>>('/user/learn/goals');
    return LearnGoal.fromJson(json);
  }

  /// Creates/updates the user's exam goal — `POST /user/learn/goals`.
  /// [targetDate] must be `YYYY-MM-DD` (backend floors to that date).
  Future<void> upsertGoal({
    required String targetLevel,
    required String targetProvider,
    required String targetDate,
  }) {
    return _api.post<void>(
      '/user/learn/goals',
      body: {
        'target_level': targetLevel,
        'target_provider': targetProvider,
        'target_date': targetDate,
      },
    );
  }
}
