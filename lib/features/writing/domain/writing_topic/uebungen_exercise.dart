/// Structured interactive exercises — web parity `uebungen-types.ts`
/// discriminated union. Flutter models this as a sealed-ish class hierarchy
/// (no `freezed` per repo convention for read-mostly DTOs) with a `kind`
/// discriminator the UI switches on.
///
/// DEVIATION (documented, W2 scope note): web AI-grades `error-correction`
/// and `mini-write` via `/ai/grade-sentence`(-batch) with a 1.5s idle
/// prefetch. This wave's UI (see `uebungen/error_correction_exercise.dart`
/// and `mini_write_exercise.dart`) ships a local reveal-only mode (no AI
/// call) instead — full AI batch grading is a named follow-up, not silently
/// dropped (see phase report).
abstract class Exercise {
  const Exercise({required this.index, required this.title});

  final int index;
  final String title;

  String get kind;

  static Exercise? fromJson(Map<String, dynamic> json) {
    switch (json['kind']?.toString()) {
      case 'cloze':
        return ClozeExercise.fromJson(json);
      case 'word-order':
        return WordOrderExercise.fromJson(json);
      case 'match':
        return MatchExercise.fromJson(json);
      case 'error-correction':
        return ErrorCorrectionExercise.fromJson(json);
      case 'mini-write':
        return MiniWriteExercise.fromJson(json);
      default:
        return null;
    }
  }

  static List<Exercise> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Exercise.fromJson(Map<String, dynamic>.from(e)))
        .whereType<Exercise>()
        .toList();
  }
}

class ClozeBlank {
  const ClozeBlank({
    required this.options,
    required this.correct,
    this.explanation,
  });

  final List<String> options;
  final String correct;
  final String? explanation;

  factory ClozeBlank.fromJson(Map<String, dynamic> json) => ClozeBlank(
        options:
            (json['options'] as List?)?.map((e) => e.toString()).toList() ??
                const [],
        correct: json['correct']?.toString() ?? '',
        explanation: json['explanation']?.toString(),
      );
}

class ClozeQuestion {
  const ClozeQuestion({
    required this.id,
    required this.textBefore,
    required this.blank,
    required this.textAfter,
    this.vi,
  });

  final String id;
  final String textBefore;
  final ClozeBlank blank;
  final String textAfter;
  final String? vi;

  factory ClozeQuestion.fromJson(Map<String, dynamic> json) => ClozeQuestion(
        id: json['id']?.toString() ?? '',
        textBefore: json['textBefore']?.toString() ?? '',
        blank: ClozeBlank.fromJson(
          Map<String, dynamic>.from(json['blank'] as Map? ?? const {}),
        ),
        textAfter: json['textAfter']?.toString() ?? '',
        vi: json['vi']?.toString(),
      );
}

class ClozeExercise extends Exercise {
  const ClozeExercise({
    required super.index,
    required super.title,
    required this.questions,
  });

  final List<ClozeQuestion> questions;

  @override
  String get kind => 'cloze';

  factory ClozeExercise.fromJson(Map<String, dynamic> json) => ClozeExercise(
        index: (json['index'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        questions: (json['questions'] as List? ?? const [])
            .whereType<Map>()
            .map((q) => ClozeQuestion.fromJson(Map<String, dynamic>.from(q)))
            .toList(),
      );
}

class WordOrderQuestion {
  const WordOrderQuestion({
    required this.id,
    required this.tokens,
    required this.correct,
    this.vi,
    this.explanation,
  });

  final String id;
  final List<String> tokens;
  final String correct;
  final String? vi;
  final String? explanation;

  factory WordOrderQuestion.fromJson(Map<String, dynamic> json) =>
      WordOrderQuestion(
        id: json['id']?.toString() ?? '',
        tokens:
            (json['tokens'] as List?)?.map((e) => e.toString()).toList() ??
                const [],
        correct: json['correct']?.toString() ?? '',
        vi: json['vi']?.toString(),
        explanation: json['explanation']?.toString() ?? json['note']?.toString(),
      );
}

class WordOrderExercise extends Exercise {
  const WordOrderExercise({
    required super.index,
    required super.title,
    required this.questions,
  });

  final List<WordOrderQuestion> questions;

  @override
  String get kind => 'word-order';

  factory WordOrderExercise.fromJson(Map<String, dynamic> json) =>
      WordOrderExercise(
        index: (json['index'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        questions: (json['questions'] as List? ?? const [])
            .whereType<Map>()
            .map((q) =>
                WordOrderQuestion.fromJson(Map<String, dynamic>.from(q)))
            .toList(),
      );
}

class MatchPair {
  const MatchPair({
    required this.id,
    required this.phrase,
    required this.correctFunctionIndex,
    this.vi,
    this.explanation,
  });

  final String id;
  final String phrase;
  final String? vi;
  final int correctFunctionIndex;
  final String? explanation;

  factory MatchPair.fromJson(Map<String, dynamic> json) => MatchPair(
        id: json['id']?.toString() ?? '',
        phrase: json['phrase']?.toString() ?? '',
        vi: json['vi']?.toString(),
        correctFunctionIndex:
            (json['correctFunctionIndex'] as num?)?.toInt() ?? 0,
        explanation: json['explanation']?.toString(),
      );
}

class MatchExercise extends Exercise {
  const MatchExercise({
    required super.index,
    required super.title,
    required this.pairs,
    required this.functions,
  });

  final List<MatchPair> pairs;
  final List<String> functions;

  @override
  String get kind => 'match';

  factory MatchExercise.fromJson(Map<String, dynamic> json) => MatchExercise(
        index: (json['index'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        pairs: (json['pairs'] as List? ?? const [])
            .whereType<Map>()
            .map((p) => MatchPair.fromJson(Map<String, dynamic>.from(p)))
            .toList(),
        functions:
            (json['functions'] as List?)?.map((e) => e.toString()).toList() ??
                const [],
      );
}

class ErrorCorrectionQuestion {
  const ErrorCorrectionQuestion({
    required this.id,
    required this.wrong,
    required this.correct,
    this.wrongVi,
    this.correctVi,
    this.errorType,
    this.explanation,
  });

  final String id;
  final String wrong;
  final String? wrongVi;
  final String correct;
  final String? correctVi;
  final String? errorType;
  final String? explanation;

  factory ErrorCorrectionQuestion.fromJson(Map<String, dynamic> json) =>
      ErrorCorrectionQuestion(
        id: json['id']?.toString() ?? '',
        wrong: json['wrong']?.toString() ?? '',
        wrongVi: json['wrongVi']?.toString(),
        correct: json['correct']?.toString() ?? '',
        correctVi: json['correctVi']?.toString(),
        errorType: json['errorType']?.toString(),
        explanation: json['explanation']?.toString(),
      );
}

class ErrorCorrectionExercise extends Exercise {
  const ErrorCorrectionExercise({
    required super.index,
    required super.title,
    required this.questions,
  });

  final List<ErrorCorrectionQuestion> questions;

  @override
  String get kind => 'error-correction';

  factory ErrorCorrectionExercise.fromJson(Map<String, dynamic> json) =>
      ErrorCorrectionExercise(
        index: (json['index'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        questions: (json['questions'] as List? ?? const [])
            .whereType<Map>()
            .map((q) => ErrorCorrectionQuestion.fromJson(
                Map<String, dynamic>.from(q)))
            .toList(),
      );
}

class MiniWritePrompt {
  const MiniWritePrompt({
    required this.id,
    required this.promptVi,
    required this.patternDe,
    this.sampleAnswer,
    this.sampleAnswerVi,
  });

  final String id;
  final String promptVi;
  final String patternDe;
  final String? sampleAnswer;
  final String? sampleAnswerVi;

  factory MiniWritePrompt.fromJson(Map<String, dynamic> json) =>
      MiniWritePrompt(
        id: json['id']?.toString() ?? '',
        promptVi: json['promptVi']?.toString() ?? '',
        patternDe: json['patternDe']?.toString() ?? '',
        sampleAnswer: json['sampleAnswer']?.toString(),
        sampleAnswerVi: json['sampleAnswerVi']?.toString(),
      );
}

class MiniWriteExercise extends Exercise {
  const MiniWriteExercise({
    required super.index,
    required super.title,
    required this.prompts,
  });

  final List<MiniWritePrompt> prompts;

  @override
  String get kind => 'mini-write';

  factory MiniWriteExercise.fromJson(Map<String, dynamic> json) =>
      MiniWriteExercise(
        index: (json['index'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        prompts: (json['prompts'] as List? ?? const [])
            .whereType<Map>()
            .map((p) =>
                MiniWritePrompt.fromJson(Map<String, dynamic>.from(p)))
            .toList(),
      );
}
