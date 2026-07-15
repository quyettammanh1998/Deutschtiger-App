import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../data/learn/learn_models.dart';
import '../../repositories/learn/learn_repository.dart';

final learnRepositoryProvider = Provider<LearnRepository>((ref) {
  return LearnRepository(ref.watch(apiClientProvider));
});

/// Bản đồ năng lực CEFR (can-do) — nguồn cho màn learner model + can-do
/// practice. `autoDispose` vì screen chỉ cần dữ liệu khi đang mở.
final capabilityMapProvider = FutureProvider.autoDispose<CapabilityMap>((
  ref,
) async {
  return ref.watch(learnRepositoryProvider).fetchCapabilityMap();
});

/// Recap sản sinh 7 ngày qua, timezone thiết bị.
final weeklyRecapProvider = FutureProvider.autoDispose<WeeklyRecap>((
  ref,
) async {
  return ref
      .watch(learnRepositoryProvider)
      .fetchWeeklyRecap(timezone: DateTime.now().timeZoneName);
});

/// Tổng hợp việc cần luyện ngay (focus session).
final focusSessionProvider = FutureProvider.autoDispose<FocusSessionData>((
  ref,
) async {
  return ref.watch(learnRepositoryProvider).fetchFocusSession();
});

/// Hồ sơ năng lực đầy đủ (mastery, độ phủ theo cấp, điểm yếu).
final learnerModelProvider = FutureProvider.autoDispose<LearnerModel>((
  ref,
) async {
  return ref.watch(learnRepositoryProvider).fetchLearnerModel();
});

/// Preferences cho topic explore (learning_goals + priority_topics).
final learnPreferencesProvider = FutureProvider.autoDispose<LearnPreferences>((
  ref,
) async {
  return ref.watch(learnRepositoryProvider).fetchPreferences();
});
