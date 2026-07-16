import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';

/// Learning preferences (level/goals/daily targets), mirrors web "Learning
/// preferences" settings section. `GET`/`PUT /api/v1/user/preferences`
/// (`database.UserPreferences` / `UpdatePreferencesInput`). Distinct from
/// the on-device [AppPreferences] in `preferences_provider.dart` (TTS
/// volume, reminder time, app language) which has no backend counterpart.
/// Recognized `learning_goals` values — web `GOAL_OPTIONS`
/// (`settings-learning-page.tsx`). Unknown values from the server are kept
/// (round-tripped) but not offered as selectable chips.
const learningGoalValues = ['goethe', 'communication', 'medical', 'work', 'other'];

class LearningPreferences {
  const LearningPreferences({
    this.cefrLevel = 'A1',
    this.dailyMinutes = 15,
    this.dailyXpGoal = 50,
    this.learningGoals = const [],
  });

  final String cefrLevel;
  final int dailyMinutes;
  final int dailyXpGoal;
  final List<String> learningGoals;

  factory LearningPreferences.fromJson(Map<String, dynamic> json) =>
      LearningPreferences(
        cefrLevel: json['cefr_level'] as String? ?? 'A1',
        dailyMinutes: (json['daily_minutes'] as num?)?.toInt() ?? 15,
        dailyXpGoal: (json['daily_xp_goal'] as num?)?.toInt() ?? 50,
        learningGoals:
            (json['learning_goals'] as List<dynamic>?)
                ?.whereType<String>()
                .toList() ??
            const [],
      );

  LearningPreferences copyWith({
    String? cefrLevel,
    int? dailyMinutes,
    int? dailyXpGoal,
    List<String>? learningGoals,
  }) => LearningPreferences(
    cefrLevel: cefrLevel ?? this.cefrLevel,
    dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    dailyXpGoal: dailyXpGoal ?? this.dailyXpGoal,
    learningGoals: learningGoals ?? this.learningGoals,
  );
}

class LearningPreferencesRepository {
  LearningPreferencesRepository(this._api);

  final ApiClient _api;

  Future<LearningPreferences> get() async {
    final json = await _api.get<Map<String, dynamic>>('/user/preferences');
    return LearningPreferences.fromJson(json);
  }

  Future<LearningPreferences> save(LearningPreferences preferences) async {
    final json = await _api.put<Map<String, dynamic>>(
      '/user/preferences',
      body: {
        'cefr_level': preferences.cefrLevel,
        'daily_minutes': preferences.dailyMinutes,
        'daily_xp_goal': preferences.dailyXpGoal,
        'learning_goals': preferences.learningGoals,
      },
    );
    return LearningPreferences.fromJson(json);
  }
}

final learningPreferencesRepositoryProvider =
    Provider<LearningPreferencesRepository>((ref) {
      return LearningPreferencesRepository(ref.watch(apiClientProvider));
    });
