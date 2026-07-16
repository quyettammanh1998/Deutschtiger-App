// ignore_for_file: prefer_initializing_formals
//
// Domain models cho Exam player (GĐ1: Lesen + Hören).
//
// Port từ web `lib/exam/exam-types.ts` + `components/exam/*`. 5 question types
// được GĐ1 hỗ trợ (MC, matching, richtig/falsch, sprachbausteine, anzeigen).
// Sprachbausteine Teil3 anzeigen[] fix shape: `correct_answer` là 0-based option
// index theo `exam-scoring.ts:17`.
//
// Mode: practice (xem đáp án ngay), test (không xem, autosave attempt),
// review (xem lại bài đã nộp, highlight đúng/sai).

import 'package:flutter/foundation.dart';

/// Phần thi trong đề. GĐ1 chỉ có Lesen + Hören.
enum ExamSectionKind {
  lesen('Lesen', 'Đọc hiểu'),
  hoeren('Hören', 'Nghe hiểu');

  const ExamSectionKind(this.labelDe, this.labelVi);
  final String labelDe;
  final String labelVi;
}

/// Mode chạy player.
enum ExamMode {
  practice, // xem đáp án ngay sau khi chọn
  test, // chạy như thi thật, autosave, submit khi hết giờ
  review, // xem lại attempt đã nộp
}

/// 5 question renderer hỗ trợ trong GĐ1.
enum QuestionType {
  mc, // multiple-choice đơn
  matching, // nối cột trái-phải
  richtigFalsch, // true/false
  sprachbausteine, // điền vào chỗ trống (Teil 1)
  anzeigen, // kéo thả / chọn anzeige (Teil 3)
}

/// Một lựa chọn trong câu hỏi MC / anzeigen / sprachbausteine.
@immutable
class ExamOption {
  const ExamOption({required this.id, required this.text});

  final String id;
  final String text;

  Map<String, dynamic> toJson() => {'id': id, 'text': text};

  factory ExamOption.fromJson(Map<String, dynamic> json) =>
      ExamOption(id: json['id'] as String, text: json['text'] as String);
}

/// Câu hỏi trong đề thi. Type-specific payload nằm trong các field tùy chọn —
/// renderer đọc đúng field theo [type].
@immutable
class ExamQuestion {
  const ExamQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    this.contentReference,
    this.options = const [],
    this.correctOptionId,
    this.matchLeft,
    this.matchRight,
    this.correctMatches = const {},
    this.correctBoolean,
    this.gapPositions = const [],
    this.audioUrl,
    this.audioPlays = 0,
    this.audioMaxPlays = 2,
    this.points = 1,
    this.explanation,
    this.imageUrl,
    this.descriptionVi,
  });

  final String id;

  /// Stable content identity supplied by the public exam catalog. Unlike the
  /// legacy display id (`q<entry_id>`), it includes part and section so an ÖSD
  /// entry_id reused in another section cannot overwrite an answer in a draft.
  /// It remains separate from the display id so legacy cached attempts can be
  /// migrated safely while new server-owned drafts use the canonical key.
  final String? contentReference;

  /// Key used for persisted progress. New catalog-backed questions use the
  /// canonical reference; fixtures and legacy cached exams retain their id.
  String get answerKey => contentReference ?? id;
  final QuestionType type;
  final String prompt;

  /// MC / sprachbausteine / anzeigen.
  final List<ExamOption> options;

  /// MC: id của option đúng.
  final String? correctOptionId;

  /// Matching: cột trái (text items).
  final List<String>? matchLeft;

  /// Matching: cột phải (text items).
  final List<String>? matchRight;

  /// Matching: map leftIdx → rightIdx.
  final Map<int, int> correctMatches;

  /// Richtig/Falsch.
  final bool? correctBoolean;

  /// Sprachbausteine: danh sách index trong `options` đúng theo thứ tự gap.
  final List<int> gapPositions;

  /// Hören: URL audio (CDN backend). Null nếu câu Lesen.
  final String? audioUrl;

  /// Hören: số lần đã phát (theo dõi max_plays).
  final int audioPlays;

  /// Hören: tối đa số lần được phát.
  final int audioMaxPlays;

  /// Điểm của câu (mặc định 1).
  final int points;

  /// Giải thích cho review mode.
  final String? explanation;

  /// Anzeigen (Lesen Teil 3): ảnh minh họa quảng cáo, nếu BE cung cấp
  /// `image_url`. Null cho các type câu hỏi khác.
  final String? imageUrl;

  /// Vietnamese translation of the passage/description behind this câu hỏi
  /// (BE field `description_vi`) — chỉ dùng cho toggle "Dịch đoạn văn" ở
  /// mobile player, KHÔNG phải bản dịch của `prompt` (title). Không tham gia
  /// chấm điểm/persist attempt — thuần hiển thị.
  final String? descriptionVi;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get canPlayAudio =>
      hasAudio && (audioMaxPlays == 0 || audioPlays < audioMaxPlays);

  Map<String, dynamic> toJson() => {
    'id': id,
    'contentReference': contentReference,
    'type': type.name,
    'prompt': prompt,
    'options': options.map((o) => o.toJson()).toList(),
    'correctOptionId': correctOptionId,
    'matchLeft': matchLeft,
    'matchRight': matchRight,
    'correctMatches': correctMatches,
    'correctBoolean': correctBoolean,
    'gapPositions': gapPositions,
    'audioUrl': audioUrl,
    'audioPlays': audioPlays,
    'audioMaxPlays': audioMaxPlays,
    'points': points,
    'explanation': explanation,
    'imageUrl': imageUrl,
    'descriptionVi': descriptionVi,
  };

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    return ExamQuestion(
      id: json['id'] as String,
      contentReference: json['contentReference'] as String?,
      type: QuestionType.values.firstWhere((t) => t.name == typeStr),
      prompt: json['prompt'] as String,
      options: ((json['options'] as List?) ?? const [])
          .map((o) => ExamOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      correctOptionId: json['correctOptionId'] as String?,
      matchLeft: (json['matchLeft'] as List?)?.cast<String>(),
      matchRight: (json['matchRight'] as List?)?.cast<String>(),
      correctMatches: ((json['correctMatches'] as Map?) ?? const {}).map(
        (k, v) => MapEntry(int.parse(k.toString()), v as int),
      ),
      correctBoolean: json['correctBoolean'] as bool?,
      gapPositions: ((json['gapPositions'] as List?) ?? const []).cast<int>(),
      audioUrl: json['audioUrl'] as String?,
      audioPlays: (json['audioPlays'] as int?) ?? 0,
      audioMaxPlays: (json['audioMaxPlays'] as int?) ?? 2,
      points: (json['points'] as int?) ?? 1,
      explanation: json['explanation'] as String?,
      imageUrl: json['imageUrl'] as String?,
      descriptionVi: json['descriptionVi'] as String?,
    );
  }
}

/// Phần thi (Lesen / Hören).
@immutable
class ExamSection {
  const ExamSection({
    required this.kind,
    required this.questions,
    required this.durationMinutes,
    this.audioIntroUrl,
  });

  final ExamSectionKind kind;
  final List<ExamQuestion> questions;
  final int durationMinutes;

  /// Hören: file audio giới thiệu đầu phần (Beispiel).
  final String? audioIntroUrl;

  int get questionCount => questions.length;
  bool get isListening => kind == ExamSectionKind.hoeren;

  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    'questions': questions.map((q) => q.toJson()).toList(),
    'durationMinutes': durationMinutes,
    'audioIntroUrl': audioIntroUrl,
  };

  factory ExamSection.fromJson(Map<String, dynamic> json) => ExamSection(
    kind: ExamSectionKind.values.firstWhere(
      (k) => k.name == json['kind'] as String,
    ),
    questions: (json['questions'] as List)
        .map((q) => ExamQuestion.fromJson(q as Map<String, dynamic>))
        .toList(),
    durationMinutes: json['durationMinutes'] as int,
    audioIntroUrl: json['audioIntroUrl'] as String?,
  );
}

/// Một đề thi đầy đủ.
@immutable
class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.level,
    required this.provider,
    required this.sections,
    this.description,
  });

  final String id;
  final String title;
  final String level; // a1, a2, b1, b2, c1, c2
  final String provider; // goethe, telc, testdaf
  final List<ExamSection> sections;
  final String? description;

  int get totalQuestions => sections.fold(0, (sum, s) => sum + s.questionCount);
  int get totalPoints => sections.fold(
    0,
    (sum, s) => sum + s.questions.fold(0, (p, q) => p + q.points),
  );
  int get totalDurationMinutes =>
      sections.fold(0, (sum, s) => sum + s.durationMinutes);
  List<ExamQuestion> get allQuestions =>
      sections.expand((s) => s.questions).toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'level': level,
    'provider': provider,
    'sections': sections.map((s) => s.toJson()).toList(),
    'description': description,
  };

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    id: json['id'] as String,
    title: json['title'] as String,
    level: json['level'] as String,
    provider: json['provider'] as String,
    sections: (json['sections'] as List)
        .map((s) => ExamSection.fromJson(s as Map<String, dynamic>))
        .toList(),
    description: json['description'] as String?,
  );
}

/// Kết quả attempt (điểm + đáp án user).
@immutable
class ExamAttempt {
  const ExamAttempt({
    required this.examId,
    required this.mode,
    required this.answers,
    required this.elapsedSeconds,
    required this.startedAt,
    this.submittedAt,
    this.score = 0,
    this.maxScore = 0,
    this.passed = false,
    this.correctAnswers = 0,
    this.sectionCorrect = const {},
  });

  final String examId;
  final ExamMode mode;

  /// Map questionId → user answer.
  ///   - MC: optionId
  ///   - Matching: "leftIdx:rightIdx,leftIdx:rightIdx"
  ///   - Richtig/Falsch: "true"/"false"
  ///   - Sprachbausteine: "optIdx,optIdx,..."
  ///   - Anzeigen: optionId
  final Map<String, String> answers;

  final int elapsedSeconds;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final int score;
  final int maxScore;
  final bool passed;
  final int correctAnswers;
  final Map<String, int> sectionCorrect;

  ExamAttempt copyWith({
    Map<String, String>? answers,
    int? elapsedSeconds,
    DateTime? submittedAt,
    int? score,
    int? maxScore,
    bool? passed,
    int? correctAnswers,
    Map<String, int>? sectionCorrect,
  }) => ExamAttempt(
    examId: examId,
    mode: mode,
    answers: answers ?? this.answers,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    startedAt: startedAt,
    submittedAt: submittedAt ?? this.submittedAt,
    score: score ?? this.score,
    maxScore: maxScore ?? this.maxScore,
    passed: passed ?? this.passed,
    correctAnswers: correctAnswers ?? this.correctAnswers,
    sectionCorrect: sectionCorrect ?? this.sectionCorrect,
  );

  Map<String, dynamic> toJson() => {
    'exam_id': examId,
    'mode': mode.name,
    'answers': answers,
    'elapsed_seconds': elapsedSeconds,
    'started_at': startedAt.toIso8601String(),
    'submitted_at': submittedAt?.toIso8601String(),
    'score': score,
    'max_score': maxScore,
    'passed': passed,
    'correct_answers': correctAnswers,
    'section_correct': sectionCorrect,
  };

  factory ExamAttempt.fromJson(Map<String, dynamic> json) => ExamAttempt(
    examId: json['exam_id'] as String,
    mode: ExamMode.values.firstWhere(
      (mode) => mode.name == json['mode'],
      orElse: () => ExamMode.test,
    ),
    answers: (json['answers'] as Map? ?? const {}).map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    ),
    elapsedSeconds: (json['elapsed_seconds'] as num?)?.toInt() ?? 0,
    startedAt: DateTime.parse(json['started_at'] as String),
    submittedAt: json['submitted_at'] == null
        ? null
        : DateTime.parse(json['submitted_at'] as String),
    score: (json['score'] as num?)?.toInt() ?? 0,
    maxScore: (json['max_score'] as num?)?.toInt() ?? 0,
    passed: json['passed'] as bool? ?? false,
    correctAnswers: (json['correct_answers'] as num?)?.toInt() ?? 0,
    sectionCorrect: (json['section_correct'] as Map? ?? const {}).map(
      (key, value) => MapEntry(key.toString(), (value as num).toInt()),
    ),
  );
}
