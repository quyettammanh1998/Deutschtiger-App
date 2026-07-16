// DTO cho vành đai Exam ecosystem (readiness, registration, buddy finder,
// community exams read-only, dictation, de-thi public registry).
//
// Đọc từ Go backend `internal/feature/exam/{examreadiness,examregistration,
// communityexam,exam}` — schema map trực tiếp field-by-field, KHÔNG đoán.
// Models thuần Dart (không freezed) vì đây là DTO read-mostly, không cần
// copyWith/union — tránh phụ thuộc build_runner khi nhiều agent khác đang
// chạy codegen song song trên cùng repo.

/// Một điểm yếu ngữ pháp có thể luyện (`ErrorWeakness` ở Go).
class ExamErrorWeakness {
  const ExamErrorWeakness({required this.errorType, required this.count});

  final String errorType;
  final int count;

  factory ExamErrorWeakness.fromJson(Map<String, dynamic> json) =>
      ExamErrorWeakness(
        errorType: json['error_type'] as String? ?? '',
        count: (json['count'] as num?)?.toInt() ?? 0,
      );
}

/// Ví dụ sai→sửa cụ thể cho một điểm yếu (`WeaknessDetail` ở Go).
class ExamWeaknessDetail {
  const ExamWeaknessDetail({
    required this.errorType,
    required this.count,
    required this.original,
    required this.corrected,
    required this.explanation,
  });

  final String errorType;
  final int count;
  final String original;
  final String corrected;
  final String explanation;

  factory ExamWeaknessDetail.fromJson(Map<String, dynamic> json) =>
      ExamWeaknessDetail(
        errorType: json['error_type'] as String? ?? '',
        count: (json['count'] as num?)?.toInt() ?? 0,
        original: json['last_example_original'] as String? ?? '',
        corrected: json['last_example_corrected'] as String? ?? '',
        explanation: json['last_example_explanation'] as String? ?? '',
      );
}

/// Một điểm trên biểu đồ điểm số theo thời gian (`TrendPoint` ở Go).
class ExamTrendPoint {
  const ExamTrendPoint({required this.score, required this.submittedAt});

  final int score;
  final String submittedAt;

  factory ExamTrendPoint.fromJson(Map<String, dynamic> json) => ExamTrendPoint(
    score: (json['score'] as num?)?.toInt() ?? 0,
    submittedAt: json['submitted_at'] as String? ?? '',
  );
}

/// Độ sẵn sàng theo từng kỹ năng (`SkillStat` ở Go).
class ExamSkillStat {
  const ExamSkillStat({
    required this.skill,
    required this.accuracy,
    required this.attemptCount,
  });

  final String skill;
  final double accuracy;
  final int attemptCount;

  factory ExamSkillStat.fromJson(Map<String, dynamic> json) => ExamSkillStat(
    skill: json['skill'] as String? ?? '',
    accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
    attemptCount: (json['attempt_count'] as num?)?.toInt() ?? 0,
  );
}

/// Snapshot readiness đầy đủ — `GET /api/v1/exam-readiness`.
class ExamReadinessSnapshot {
  const ExamReadinessSnapshot({
    required this.attemptCount,
    required this.avgScore,
    required this.recentAvgScore,
    required this.bestScore,
    required this.readinessLow,
    required this.readinessHigh,
    required this.dueReviewCount,
    required this.examFailPending,
    required this.topWeaknesses,
    required this.weaknessDetails,
    required this.scoreTrend,
    required this.skillReadiness,
  });

  final int attemptCount;
  final double avgScore;
  final double recentAvgScore;
  final int bestScore;
  final int readinessLow;
  final int readinessHigh;
  final int dueReviewCount;
  final int examFailPending;
  final List<ExamErrorWeakness> topWeaknesses;
  final List<ExamWeaknessDetail> weaknessDetails;
  final List<ExamTrendPoint> scoreTrend;
  final List<ExamSkillStat> skillReadiness;

  factory ExamReadinessSnapshot.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) parse) {
      final raw = json[key] as List<dynamic>? ?? const [];
      return raw.whereType<Map<String, dynamic>>().map(parse).toList();
    }

    return ExamReadinessSnapshot(
      attemptCount: (json['attempt_count'] as num?)?.toInt() ?? 0,
      avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0,
      recentAvgScore: (json['recent_avg_score'] as num?)?.toDouble() ?? 0,
      bestScore: (json['best_score'] as num?)?.toInt() ?? 0,
      readinessLow: (json['readiness_low'] as num?)?.toInt() ?? 0,
      readinessHigh: (json['readiness_high'] as num?)?.toInt() ?? 0,
      dueReviewCount: (json['due_review_count'] as num?)?.toInt() ?? 0,
      examFailPending: (json['exam_fail_pending'] as num?)?.toInt() ?? 0,
      topWeaknesses: list('top_weaknesses', ExamErrorWeakness.fromJson),
      weaknessDetails: list('weakness_details', ExamWeaknessDetail.fromJson),
      scoreTrend: list('score_trend', ExamTrendPoint.fromJson),
      skillReadiness: list('skill_readiness', ExamSkillStat.fromJson),
    );
  }
}

/// Lịch thi đã đăng ký của người dùng (`ExamRegistration` ở Go).
class ExamRegistration {
  const ExamRegistration({
    required this.id,
    required this.examLevel,
    required this.examType,
    required this.examDate,
    required this.skills,
    this.phone = '',
    this.email = '',
    this.facebook = '',
    this.location = '',
    this.note = '',
  });

  final String id;
  final String examLevel;
  final String examType;
  final String examDate; // YYYY-MM-DD
  final List<String> skills;
  final String phone;
  final String email;
  final String facebook;
  final String location;
  final String note;

  factory ExamRegistration.fromJson(Map<String, dynamic> json) =>
      ExamRegistration(
        id: json['id'] as String? ?? '',
        examLevel: json['exam_level'] as String? ?? '',
        examType: json['exam_type'] as String? ?? '',
        examDate: json['exam_date'] as String? ?? '',
        skills:
            (json['skills'] as List<dynamic>?)
                ?.whereType<String>()
                .toList() ??
            const [],
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String? ?? '',
        facebook: json['facebook'] as String? ?? '',
        location: json['location'] as String? ?? '',
        note: json['note'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'email': email,
    'facebook': facebook,
    'exam_level': examLevel,
    'exam_type': examType,
    'exam_date': examDate,
    'location': location,
    'skills': skills,
    'note': note,
  };
}

/// Một mục trong danh bạ tìm bạn ôn thi (`ExamBuddy` ở Go) — READ-ONLY, không
/// lộ has_phone/has_email/has_facebook thành hành động liên hệ (GĐ2 P3 chưa
/// có report/block cho tương tác user-user).
class ExamBuddy {
  const ExamBuddy({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.examLevel,
    required this.examType,
    required this.examDate,
    required this.location,
    required this.skills,
    required this.daysUntil,
  });

  final String id;
  final String displayName;
  final String avatarUrl;
  final String examLevel;
  final String examType;
  final String examDate;
  final String location;
  final List<String> skills;
  final int daysUntil;

  factory ExamBuddy.fromJson(Map<String, dynamic> json) => ExamBuddy(
    id: json['id'] as String? ?? '',
    displayName: json['display_name'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String? ?? '',
    examLevel: json['exam_level'] as String? ?? '',
    examType: json['exam_type'] as String? ?? '',
    examDate: json['exam_date'] as String? ?? '',
    location: json['location'] as String? ?? '',
    skills:
        (json['skills'] as List<dynamic>?)?.whereType<String>().toList() ??
        const [],
    daysUntil: (json['days_until'] as num?)?.toInt() ?? 0,
  );
}

/// Đề thi cộng đồng — chỉ field cần cho list/detail READ-ONLY (không có
/// comment/vote write ở phase này).
class CommunityExamTopic {
  const CommunityExamTopic({
    required this.id,
    required this.provider,
    required this.level,
    required this.skill,
    required this.teil,
    required this.titleDe,
    this.titleVi,
    required this.contributorName,
    required this.contributorAvatar,
    required this.voteCount,
    required this.versionCount,
    required this.isVerified,
    required this.createdAt,
    this.inputText = '',
    this.status = 'published',
    this.examDate,
    this.examLocation,
    this.generatedData,
  });

  final String id;
  final String provider;
  final String level;
  final String skill;
  final int teil;
  final String titleDe;
  final String? titleVi;
  final String contributorName;
  final String contributorAvatar;
  final int voteCount;
  final int versionCount;
  final bool isVerified;
  final String createdAt;
  final String inputText;

  /// `status` (Go `CommunityExamTopic.Status`) — `published` | `hidden`.
  /// Non-owners never see `hidden` rows (backend 404s them), but the
  /// caller's own topics can still be `hidden` after a report threshold.
  final String status;

  /// `exam_date` (Go: `*string`, nullable) — presence marks the topic as a
  /// recalled real-exam submission ("Đề thật" badge), vs. an AI-generated
  /// practice topic.
  final String? examDate;

  /// `exam_location` (Go: `*string`, nullable).
  final String? examLocation;

  /// `generated_data` (Go: `json.RawMessage`) — structured exam content.
  /// Shape depends on [skill]: writing = `{task, taskAnalysis, modelAnswers,
  /// usefulPhrases, grammarFocus, commonMistakes}`; speaking = a raw string
  /// or `{content: string}`. Parsed here only when it decodes to a JSON
  /// object; left `null` otherwise (e.g. plain-string speaking payloads —
  /// callers fall back to [inputText]/raw handling for those).
  final Map<String, dynamic>? generatedData;

  factory CommunityExamTopic.fromJson(Map<String, dynamic> json) =>
      CommunityExamTopic(
        id: json['id'] as String? ?? '',
        provider: json['provider'] as String? ?? '',
        level: json['level'] as String? ?? '',
        skill: json['skill'] as String? ?? '',
        teil: (json['teil'] as num?)?.toInt() ?? 0,
        titleDe: json['title_de'] as String? ?? '',
        titleVi: json['title_vi'] as String?,
        contributorName: json['contributor_name'] as String? ?? '',
        contributorAvatar: json['contributor_avatar'] as String? ?? '',
        voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
        versionCount: (json['version_count'] as num?)?.toInt() ?? 0,
        isVerified: json['is_verified'] as bool? ?? false,
        createdAt: json['created_at'] as String? ?? '',
        inputText: json['input_text'] as String? ?? '',
        status: json['status'] as String? ?? 'published',
        examDate: json['exam_date'] as String?,
        examLocation: json['exam_location'] as String?,
        generatedData: json['generated_data'] is Map<String, dynamic>
            ? json['generated_data'] as Map<String, dynamic>
            : null,
      );
}

// ─── Dictation (word-transcript) ───────────────────────────────────────────

class ExamWordTiming {
  const ExamWordTiming({
    required this.word,
    required this.clean,
    required this.start,
    required this.end,
  });

  final String word;
  final String clean;
  final double start;
  final double end;

  factory ExamWordTiming.fromJson(Map<String, dynamic> json) =>
      ExamWordTiming(
        word: json['word'] as String? ?? '',
        clean: json['clean'] as String? ?? '',
        start: (json['start'] as num?)?.toDouble() ?? 0,
        end: (json['end'] as num?)?.toDouble() ?? 0,
      );
}

class ExamDictationSentence {
  const ExamDictationSentence({
    required this.text,
    required this.textVi,
    required this.start,
    required this.end,
    required this.words,
  });

  final String text;
  final String textVi;
  final double start;
  final double end;
  final List<ExamWordTiming> words;

  factory ExamDictationSentence.fromJson(Map<String, dynamic> json) =>
      ExamDictationSentence(
        text: json['text'] as String? ?? '',
        textVi: json['text_vi'] as String? ?? '',
        start: (json['start'] as num?)?.toDouble() ?? 0,
        end: (json['end'] as num?)?.toDouble() ?? 0,
        words: (json['words'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ExamWordTiming.fromJson)
            .toList(),
      );
}

class ExamDictationAudio {
  const ExamDictationAudio({
    required this.file,
    required this.audioUrl,
    required this.duration,
    required this.teil,
    required this.sentences,
  });

  final String file;
  final String audioUrl;
  final double duration;
  final String teil;
  final List<ExamDictationSentence> sentences;

  factory ExamDictationAudio.fromJson(Map<String, dynamic> json) =>
      ExamDictationAudio(
        file: json['file'] as String? ?? '',
        audioUrl: json['audio_url'] as String? ?? '',
        duration: (json['duration'] as num?)?.toDouble() ?? 0,
        teil: json['teil'] as String? ?? '',
        sentences: (json['sentences'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ExamDictationSentence.fromJson)
            .toList(),
      );
}

class ExamContentWord {
  const ExamContentWord({
    required this.word,
    required this.clean,
    required this.textVi,
  });

  final String word;
  final String clean;
  final String textVi;

  factory ExamContentWord.fromJson(Map<String, dynamic> json) =>
      ExamContentWord(
        word: json['word'] as String? ?? '',
        clean: json['clean'] as String? ?? '',
        textVi: json['text_vi'] as String? ?? '',
      );
}

/// `GET /api/v1/exams/{telc/b1|goethe/{level}}/{slug}/word-transcript`.
class ExamWordTranscript {
  const ExamWordTranscript({required this.audios, required this.words});

  final List<ExamDictationAudio> audios;
  final List<ExamContentWord> words;

  factory ExamWordTranscript.fromJson(Map<String, dynamic> json) =>
      ExamWordTranscript(
        audios: (json['audios'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ExamDictationAudio.fromJson)
            .toList(),
        words: (json['words'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ExamContentWord.fromJson)
            .toList(),
      );
}

// ─── De-thi public registry (static, không auth) ───────────────────────────

class DeThiQuestion {
  const DeThiQuestion({
    required this.no,
    required this.questionDe,
    required this.questionVi,
    required this.optionsDe,
    required this.optionsVi,
    required this.answer,
    required this.explanationVi,
  });

  final int no;
  final String questionDe;
  final String questionVi;
  final Map<String, String> optionsDe;
  final Map<String, String> optionsVi;
  final String answer;
  final String explanationVi;

  factory DeThiQuestion.fromJson(Map<String, dynamic> json) {
    Map<String, String> options(String key) =>
        (json[key] as Map<String, dynamic>? ?? const {}).map(
          (k, v) => MapEntry(k, v as String? ?? ''),
        );
    return DeThiQuestion(
      no: (json['no'] as num?)?.toInt() ?? 0,
      questionDe: json['question_de'] as String? ?? '',
      questionVi: json['question_vi'] as String? ?? '',
      optionsDe: options('options_de'),
      optionsVi: options('options_vi'),
      answer: json['answer'] as String? ?? '',
      explanationVi: json['explanation_vi'] as String? ?? '',
    );
  }
}

class DeThiPassage {
  const DeThiPassage({
    required this.id,
    required this.title,
    required this.textDe,
    required this.textVi,
    required this.questions,
    this.source,
  });

  final String id;
  final String title;
  final String? source;
  final String textDe;
  final String textVi;
  final List<DeThiQuestion> questions;

  factory DeThiPassage.fromJson(Map<String, dynamic> json) => DeThiPassage(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    source: json['source'] as String?,
    textDe: json['text_de'] as String? ?? '',
    textVi: json['text_vi'] as String? ?? '',
    questions: (json['questions'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(DeThiQuestion.fromJson)
        .toList(),
  );
}

/// Đề thi public (JSON tĩnh phục vụ từ `WEBVIEW_BASE_URL/data/de-thi/*.json`).
class DeThiExam {
  const DeThiExam({
    required this.examCode,
    required this.level,
    required this.title,
    required this.passages,
  });

  final String examCode;
  final String level;
  final String title;
  final List<DeThiPassage> passages;

  factory DeThiExam.fromJson(Map<String, dynamic> json) => DeThiExam(
    examCode: json['exam_code'] as String? ?? '',
    level: json['level'] as String? ?? '',
    title: json['title'] as String? ?? '',
    passages: (json['passages'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(DeThiPassage.fromJson)
        .toList(),
  );
}

/// Đăng ký đề public tĩnh — thêm đề mới: bỏ JSON vào backend `data/de-thi/`
/// rồi thêm 1 entry vào [deThiRegistry] (mirror
/// `deutschtiger-frontend/src/pages/exam/de-thi-registry.ts`).
class DeThiRegistryEntry {
  const DeThiRegistryEntry({
    required this.code,
    required this.level,
    required this.title,
    required this.skill,
    required this.dataPath,
    this.year,
    this.disclaimer,
  });

  final String code;
  final String level;
  final String title;
  final String skill;

  /// Đường dẫn tương đối dưới `/data/...` (Go DataDir tĩnh).
  final String dataPath;
  final int? year;
  final String? disclaimer;
}

const List<DeThiRegistryEntry> deThiRegistry = [
  DeThiRegistryEntry(
    code: '1525',
    level: 'B1',
    title: 'THPT Quốc gia 2026 – Mã đề 1525',
    skill: 'Lesen (Đọc hiểu) · Tiếng Đức',
    dataPath: '/data/de-thi/exam-1525.json',
    year: 2026,
    disclaimer:
        'Đáp án tham khảo — chưa phải đáp án chính thức của Bộ GD&ĐT',
  ),
];

DeThiRegistryEntry? findDeThiEntry(String code) {
  for (final entry in deThiRegistry) {
    if (entry.code == code) return entry;
  }
  return null;
}
