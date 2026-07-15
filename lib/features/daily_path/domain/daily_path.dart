class DailyPath {
  static const _gd1HiddenSkills = {'speaking', 'pronunciation', 'voice'};

  const DailyPath({
    required this.steps,
    required this.doneCount,
    required this.totalCount,
    required this.estimatedMinutesRemaining,
    this.daysToExam,
    this.examLabel,
  });

  final List<DailyPathStep> steps;
  final int doneCount;
  final int totalCount;
  final int estimatedMinutesRemaining;
  final int? daysToExam;
  final String? examLabel;

  DailyPathStep? get currentStep {
    for (final step in steps) {
      if (!step.done &&
          !step.premium &&
          !_gd1HiddenSkills.contains(step.skill)) {
        return step;
      }
    }
    return null;
  }

  bool get isComplete => steps.isNotEmpty && currentStep == null;

  factory DailyPath.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'];
    return DailyPath(
      steps: rawSteps is List
          ? rawSteps
                .whereType<Map>()
                .map(
                  (item) =>
                      DailyPathStep.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
      doneCount: _asInt(json['done_count']),
      totalCount: _asInt(json['total_count']),
      estimatedMinutesRemaining: _asInt(json['est_minutes_remaining']),
      daysToExam: json['days_to_exam'] == null
          ? null
          : _asInt(json['days_to_exam']),
      examLabel: json['exam_label'] as String?,
    );
  }
}

class DailyPathStep {
  const DailyPathStep({
    required this.key,
    required this.skill,
    required this.title,
    required this.description,
    required this.route,
    required this.estimatedMinutes,
    required this.done,
    required this.premium,
  });

  final String key;
  final String skill;
  final String title;
  final String description;
  final String route;
  final int estimatedMinutes;
  final bool done;
  final bool premium;

  factory DailyPathStep.fromJson(Map<String, dynamic> json) => DailyPathStep(
    key: json['key'] as String? ?? '',
    skill: json['skill'] as String? ?? '',
    title: json['title'] as String? ?? 'Tiếp tục học',
    description: json['description'] as String? ?? '',
    route: json['route'] as String? ?? '',
    estimatedMinutes: _asInt(json['est_minutes']),
    done: json['done'] == true,
    premium: json['premium'] == true,
  );
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
