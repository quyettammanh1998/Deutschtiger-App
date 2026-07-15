import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';

/// Learning preferences (level/goals/daily targets), mirrors web "Learning
/// preferences" settings section. `GET`/`PUT /api/v1/user/preferences`
/// (`database.UserPreferences` / `UpdatePreferencesInput`). Distinct from
/// the on-device [AppPreferences] in `preferences_provider.dart` (TTS
/// volume, reminder time, app language) which has no backend counterpart.
class LearningPreferences {
  const LearningPreferences({
    this.cefrLevel = 'A1',
    this.dailyMinutes = 15,
    this.dailyXpGoal = 50,
  });

  final String cefrLevel;
  final int dailyMinutes;
  final int dailyXpGoal;

  factory LearningPreferences.fromJson(Map<String, dynamic> json) =>
      LearningPreferences(
        cefrLevel: json['cefr_level'] as String? ?? 'A1',
        dailyMinutes: (json['daily_minutes'] as num?)?.toInt() ?? 15,
        dailyXpGoal: (json['daily_xp_goal'] as num?)?.toInt() ?? 50,
      );

  LearningPreferences copyWith({
    String? cefrLevel,
    int? dailyMinutes,
    int? dailyXpGoal,
  }) => LearningPreferences(
    cefrLevel: cefrLevel ?? this.cefrLevel,
    dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    dailyXpGoal: dailyXpGoal ?? this.dailyXpGoal,
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
      },
    );
    return LearningPreferences.fromJson(json);
  }
}

final learningPreferencesRepositoryProvider =
    Provider<LearningPreferencesRepository>((ref) {
      return LearningPreferencesRepository(ref.watch(apiClientProvider));
    });
