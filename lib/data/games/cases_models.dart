/// Plain Dart models cho Cases Mastery Hub games — mirrors backend
/// `internal/feature/learning/cases/cases_types.go` and web
/// `src/types/case-exercise.ts` / `src/lib/cases/cases-service.ts`. Không dùng
/// freezed/json_serializable để tránh race build_runner với các domain khác
/// đang chạy song song (cùng convention với sentence_builder/typing_sprint).
library;

/// Một câu điền khuyết (cloze) dùng chung cho 3 game: Akkusativ/Dativ,
/// Adjektivendungen, Wechselpräpositionen — field `case` bên Go/JSON đổi tên
/// thành [caseType] vì `case` là từ khoá Dart.
class CaseExercise {
  const CaseExercise({
    required this.id,
    required this.level,
    required this.sentence,
    required this.options,
    required this.answer,
    required this.caseType,
    required this.reason,
    required this.vi,
  });

  final String id;
  final String level;

  /// Câu có chỗ trống đánh dấu bằng `___` (ba dấu gạch dưới).
  final String sentence;
  final List<String> options;
  final String answer;
  final String caseType;
  final String reason;
  final String vi;

  factory CaseExercise.fromJson(Map<String, dynamic> json) => CaseExercise(
        id: json['id'] as String? ?? '',
        level: json['level'] as String? ?? '',
        sentence: json['sentence'] as String? ?? '',
        options: (json['options'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        answer: json['answer'] as String? ?? '',
        caseType: json['case'] as String? ?? '',
        reason: json['reason'] as String? ?? '',
        vi: json['vi'] as String? ?? '',
      );
}

/// Tóm tắt mức độ thành thạo theo từng case — chỉ có khi user đã đăng nhập
/// và grammarRepo được wire ở backend (`buildClozeMastery`/`buildVerbCaseMastery`).
class CaseMastery {
  const CaseMastery({
    required this.byCase,
    required this.mastered,
    required this.total,
  });

  final Map<String, int> byCase;
  final int mastered;
  final int total;

  factory CaseMastery.fromJson(Map<String, dynamic> json) => CaseMastery(
        byCase: (json['byCase'] as Map<String, dynamic>? ?? const {}).map(
          (key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0),
        ),
        mastered: (json['mastered'] as num?)?.toInt() ?? 0,
        total: (json['total'] as num?)?.toInt() ?? 0,
      );
}

/// `GET /user/cases/{akk-dat,adjektiv,wechselprep}` response.
class CaseExercisesResponse {
  const CaseExercisesResponse({required this.exercises, this.mastery});

  final List<CaseExercise> exercises;
  final CaseMastery? mastery;

  factory CaseExercisesResponse.fromJson(Map<String, dynamic> json) =>
      CaseExercisesResponse(
        exercises: (json['exercises'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(CaseExercise.fromJson)
            .toList(growable: false),
        mastery: json['mastery'] != null
            ? CaseMastery.fromJson(json['mastery'] as Map<String, dynamic>)
            : null,
      );
}

/// Verb-Case matching item — `GET /user/cases/verb-case`. [caseType] là một
/// trong Akkusativ/Dativ/Genitiv (backend không ràng buộc enum, giữ String).
class VerbCaseItem {
  const VerbCaseItem({
    required this.id,
    required this.level,
    required this.verb,
    required this.caseType,
    required this.example,
    required this.viExample,
    required this.viVerb,
  });

  final String id;
  final String level;
  final String verb;
  final String caseType;
  final String example;
  final String viExample;
  final String viVerb;

  factory VerbCaseItem.fromJson(Map<String, dynamic> json) => VerbCaseItem(
        id: json['id'] as String? ?? '',
        level: json['level'] as String? ?? '',
        verb: json['verb'] as String? ?? '',
        caseType: json['case'] as String? ?? '',
        example: json['example'] as String? ?? '',
        viExample: json['vi_example'] as String? ?? '',
        viVerb: json['vi_verb'] as String? ?? '',
      );
}

/// `GET /user/cases/verb-case` response.
class VerbCaseResponse {
  const VerbCaseResponse({required this.items, this.mastery});

  final List<VerbCaseItem> items;
  final CaseMastery? mastery;

  factory VerbCaseResponse.fromJson(Map<String, dynamic> json) =>
      VerbCaseResponse(
        items: (json['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(VerbCaseItem.fromJson)
            .toList(growable: false),
        mastery: json['mastery'] != null
            ? CaseMastery.fromJson(json['mastery'] as Map<String, dynamic>)
            : null,
      );
}
