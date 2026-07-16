/// Admin-authored "official" writing topic for a generic provider/level —
/// web parity `OfficialTopicResponse` (`src/lib/exam-content/official-topic-
/// service.ts`). Backend: `GET /exams/official?provider=&level=&skill=writing`
/// (`official_exam_handler.go`, authed, premium-enforced per topic).
class OfficialWritingTopic {
  const OfficialWritingTopic({
    required this.id,
    required this.provider,
    required this.level,
    required this.teil,
    required this.slug,
    required this.titleDe,
    this.titleVi,
    this.generatedData,
    required this.isPremium,
    required this.locked,
    required this.sortOrder,
  });

  final String id;
  final String provider;
  final String level;
  final int teil;
  final String slug;
  final String titleDe;
  final String? titleVi;

  /// `{task:{de,vi}, taskAnalysis:{points:[{de,vi}], summaryVi}, ...}` — same
  /// shape as community writing topics. Empty/`{}` when [locked].
  final Map<String, dynamic>? generatedData;
  final bool isPremium;

  /// True when the caller isn't entitled to premium content — server strips
  /// [generatedData] to `{}` in that case.
  final bool locked;
  final int sortOrder;

  factory OfficialWritingTopic.fromJson(Map<String, dynamic> json) {
    final gd = json['generated_data'];
    return OfficialWritingTopic(
      id: json['id']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      teil: json['teil'] is num ? (json['teil'] as num).toInt() : 0,
      slug: json['slug']?.toString() ?? '',
      titleDe: json['title_de']?.toString() ?? '',
      titleVi: json['title_vi']?.toString(),
      generatedData: gd is Map ? Map<String, dynamic>.from(gd) : null,
      isPremium: json['is_premium'] == true,
      locked: json['locked'] == true,
      sortOrder: json['sort_order'] is num ? (json['sort_order'] as num).toInt() : 0,
    );
  }

  /// `generatedData['task']['de']` — the German task prompt for
  /// [WritingPracticePanel].
  String get taskPromptDe {
    final task = generatedData?['task'];
    if (task is Map) return task['de']?.toString() ?? '';
    return '';
  }

  /// `generatedData['taskAnalysis']['points'][].de`.
  List<String> get writingPoints {
    final analysis = generatedData?['taskAnalysis'];
    if (analysis is! Map) return const [];
    final points = analysis['points'];
    if (points is! List) return const [];
    return points
        .whereType<Map>()
        .map((p) => p['de']?.toString())
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
