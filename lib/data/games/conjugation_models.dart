/// Plain Dart models cho Konjugationstrainer — mirrors backend
/// `internal/feature/learning/conjugation/conjugation_types.go` and web
/// `src/types/conjugation-exercise.ts`. Không dùng freezed/json_serializable
/// (cùng convention với cases_models.dart / sentence_builder_models.dart).
library;

/// Một câu hỏi chia động từ — `GET /user/conjugation/exercise`.
class ConjugationExercise {
  const ConjugationExercise({
    required this.id,
    required this.verb,
    required this.infinitive,
    required this.type,
    required this.level,
    required this.tense,
    required this.person,
    required this.expected,
    required this.alternatives,
    required this.viVerb,
    required this.prompt,
    required this.key,
    this.learningItemId,
  });

  final String id;
  final String verb;
  final String infinitive;
  final String type;
  final String level;
  final String tense;
  final String person;
  final String expected;
  final List<String> alternatives;
  final String viVerb;
  final String prompt;

  /// Stable drill key `"{infinitive}:{tense}:{person}"` — echoed back on
  /// `POST /user/grammar-drill/results` for Leitner progress tracking.
  final String key;

  /// UUID của learning_items nguồn — chỉ non-null khi câu hỏi lấy từ vốn từ
  /// cá nhân của user (personalized path), dùng để ghi thêm FSRS review.
  final String? learningItemId;

  factory ConjugationExercise.fromJson(Map<String, dynamic> json) =>
      ConjugationExercise(
        id: json['id'] as String? ?? '',
        verb: json['verb'] as String? ?? '',
        infinitive: json['infinitive'] as String? ?? '',
        type: json['type'] as String? ?? '',
        level: json['level'] as String? ?? '',
        tense: json['tense'] as String? ?? '',
        person: json['person'] as String? ?? '',
        expected: json['expected'] as String? ?? '',
        alternatives: (json['alternatives'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        viVerb: json['vi_verb'] as String? ?? '',
        prompt: json['prompt'] as String? ?? '',
        key: json['key'] as String? ?? '',
        learningItemId: json['learning_item_id'] as String?,
      );
}
