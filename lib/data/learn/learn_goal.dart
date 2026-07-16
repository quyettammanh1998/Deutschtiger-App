/// Plain Dart model for a user's exam learning goal — mirrors backend
/// `GET /api/v1/user/learn/goals` (see
/// `learning/learn_goals_handler.go`). Manual `fromJson`, NOT freezed, to
/// avoid triggering a build_runner codegen pass for a single small model.
library;

class LearnGoal {
  const LearnGoal({
    required this.targetLevel,
    required this.targetProvider,
    required this.targetDate,
    required this.isDefault,
  });

  /// CEFR level the user is aiming for (e.g. "B1"). Defaults to "A1" when
  /// the backend has no row yet.
  final String targetLevel;

  /// Exam provider id: "goethe" | "telc" | "osd".
  final String targetProvider;

  /// Local-midnight date of the exam, or null when the user never set one —
  /// the backend omits `target_date` entirely for a default/empty goal.
  final DateTime? targetDate;

  /// True when this response is a synthesized fallback (no row in
  /// `user_learning_goals` for this user yet).
  final bool isDefault;

  factory LearnGoal.fromJson(Map<String, dynamic> json) => LearnGoal(
    targetLevel: json['target_level'] as String? ?? 'A1',
    targetProvider: json['target_provider'] as String? ?? 'goethe',
    targetDate: _parseLocalDate(json['target_date']),
    isDefault: json['is_default'] as bool? ?? false,
  );

  /// Backend serializes `target_date` as an RFC3339 timestamp (e.g.
  /// "2026-12-01T00:00:00Z"). Only the date head is meaningful for the
  /// countdown, so parse just the `YYYY-MM-DD` prefix as local midnight —
  /// mirrors the web `ExamCornerCard` comment on this exact pitfall.
  static DateTime? _parseLocalDate(Object? raw) {
    if (raw is! String || raw.length < 10) return null;
    return DateTime.tryParse(raw.substring(0, 10));
  }
}
