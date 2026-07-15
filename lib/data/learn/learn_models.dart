/// DTOs cho learn extensions: capability map (can-do), focus session, learner
/// model. Mirrors `lib/learn/capability-map-service.ts`,
/// `lib/learning/focus-session-service.ts`, `lib/learning/learner-model-service.ts`
/// (web) — không dùng freezed để tránh chạy build_runner toàn repo trong lúc
/// nhiều agent khác đang sửa file generated song song.
library;

/// Một block (từ vựng hoặc cấu trúc ngữ pháp) trong một can-do.
/// `rung`: 0=nghe 1=nhận biết 2=viết được 3=nói được.
class CanDoMember {
  const CanDoMember({
    required this.kind,
    required this.key,
    required this.ref,
    required this.label,
    required this.rung,
  });

  final String kind; // 'vocab' | 'structure'
  final String key;
  final String ref;
  final String label;
  final int rung;

  bool get isStructure => kind == 'structure';

  factory CanDoMember.fromJson(Map<String, dynamic> json) => CanDoMember(
    kind: json['kind'] as String? ?? 'vocab',
    key: json['key'] as String? ?? '',
    ref: json['ref'] as String? ?? '',
    label: json['label'] as String? ?? '',
    rung: (json['rung'] as num?)?.toInt() ?? 0,
  );
}

/// Một "việc làm được" CEFR — nhóm block đo qua capability map.
class CanDo {
  const CanDo({
    required this.id,
    required this.labelVi,
    required this.labelDe,
    required this.cefr,
    required this.status,
    required this.spoken,
    required this.almostUnlocked,
    required this.members,
    required this.laggards,
  });

  final String id;
  final String labelVi;
  final String labelDe;
  final String cefr;
  final String status; // 'new' | 'in_progress' | 'mastered'
  final bool spoken;
  final bool almostUnlocked;
  final List<CanDoMember> members;
  final List<String> laggards;

  bool get isMastered => status == 'mastered';

  factory CanDo.fromJson(Map<String, dynamic> json) => CanDo(
    id: json['id'] as String? ?? '',
    labelVi: json['label_vi'] as String? ?? '',
    labelDe: json['label_de'] as String? ?? '',
    cefr: json['cefr'] as String? ?? '',
    status: json['status'] as String? ?? 'new',
    spoken: json['spoken'] as bool? ?? false,
    almostUnlocked: json['almost_unlocked'] as bool? ?? false,
    members: (json['members'] as List<dynamic>? ?? [])
        .map((e) => CanDoMember.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    laggards: (json['laggards'] as List<dynamic>? ?? [])
        .map((e) => e as String)
        .toList(growable: false),
  );
}

/// `GET /user/learn/capability-map?goal=`.
class CapabilityMap {
  const CapabilityMap({
    required this.goal,
    required this.progressPct,
    required this.mastered,
    required this.total,
    required this.canDos,
    required this.nextRoute,
  });

  final String goal;
  final int progressPct;
  final int mastered;
  final int total;
  final List<CanDo> canDos;
  final String nextRoute;

  factory CapabilityMap.fromJson(Map<String, dynamic> json) => CapabilityMap(
    goal: json['goal'] as String? ?? '',
    progressPct: (json['progress_pct'] as num?)?.toInt() ?? 0,
    mastered: (json['mastered'] as num?)?.toInt() ?? 0,
    total: (json['total'] as num?)?.toInt() ?? 0,
    canDos: (json['can_dos'] as List<dynamic>? ?? [])
        .map((e) => CanDo.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    nextRoute: json['next_route'] as String? ?? '',
  );
}

/// Một block leo bậc trong tuần — thành phần của [WeeklyRecap].
class RecapItem {
  const RecapItem({
    required this.label,
    required this.kind,
    required this.fromRung,
    required this.toRung,
    required this.arena,
  });

  final String label;
  final String kind;
  final int fromRung;
  final int toRung;
  final String arena;

  factory RecapItem.fromJson(Map<String, dynamic> json) => RecapItem(
    label: json['label'] as String? ?? '',
    kind: json['kind'] as String? ?? '',
    fromRung: (json['from_rung'] as num?)?.toInt() ?? 0,
    toRung: (json['to_rung'] as num?)?.toInt() ?? 0,
    arena: json['arena'] as String? ?? '',
  );
}

/// `GET /user/learn/weekly-recap?tz=&days=`.
class WeeklyRecap {
  const WeeklyRecap({
    required this.climbed,
    required this.newlySpoken,
    required this.productionStreak,
  });

  final List<RecapItem> climbed;
  final List<RecapItem> newlySpoken;
  final int productionStreak;

  factory WeeklyRecap.fromJson(Map<String, dynamic> json) => WeeklyRecap(
    climbed: (json['climbed'] as List<dynamic>? ?? [])
        .map((e) => RecapItem.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    newlySpoken: (json['newly_spoken'] as List<dynamic>? ?? [])
        .map((e) => RecapItem.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    productionStreak: (json['production_streak'] as num?)?.toInt() ?? 0,
  );
}

/// Một thẻ SRS tới hạn trong payload focus-session (schema riêng, KHÔNG dùng
/// chung [ReviewItem] vì field khác: `flashcard_id` thay vì
/// `source_flashcard_id`, không có `state`/`due`/`examples`).
class FocusReviewWord {
  const FocusReviewWord({
    required this.id,
    this.learningItemId,
    this.flashcardId,
    required this.contentDe,
    required this.contentVi,
    this.audioUrl,
    this.level,
  });

  final String id;
  final String? learningItemId;
  final String? flashcardId;
  final String contentDe;
  final String contentVi;
  final String? audioUrl;
  final String? level;

  factory FocusReviewWord.fromJson(Map<String, dynamic> json) =>
      FocusReviewWord(
        id: json['id'] as String? ?? '',
        learningItemId: json['learning_item_id'] as String?,
        flashcardId: json['flashcard_id'] as String?,
        contentDe: json['content_de'] as String? ?? '',
        contentVi: json['content_vi'] as String? ?? '',
        audioUrl: json['audio_url'] as String?,
        level: json['level'] as String?,
      );
}

/// Từ mined từ phụ đề video hoặc từ thi sai, dùng trong focus-session.
class FocusSubtitleWord {
  const FocusSubtitleWord({
    required this.learningItemId,
    required this.contentDe,
    required this.contentVi,
    this.level,
    required this.seenCount,
  });

  final String learningItemId;
  final String contentDe;
  final String contentVi;
  final String? level;
  final int seenCount;

  factory FocusSubtitleWord.fromJson(Map<String, dynamic> json) =>
      FocusSubtitleWord(
        learningItemId: json['learning_item_id'] as String? ?? '',
        contentDe: json['content_de'] as String? ?? '',
        contentVi: json['content_vi'] as String? ?? '',
        level: json['level'] as String?,
        seenCount: (json['seen_count'] as num?)?.toInt() ?? 0,
      );
}

/// Một loại lỗi ngữ pháp lặp lại kèm ví dụ gần nhất.
class FocusWeakness {
  const FocusWeakness({
    required this.errorType,
    required this.count,
    this.lastExampleOriginal,
    this.lastExampleCorrected,
    this.lastExampleExplanation,
  });

  final String errorType;
  final int count;
  final String? lastExampleOriginal;
  final String? lastExampleCorrected;
  final String? lastExampleExplanation;

  factory FocusWeakness.fromJson(Map<String, dynamic> json) => FocusWeakness(
    errorType: json['error_type'] as String? ?? '',
    count: (json['count'] as num?)?.toInt() ?? 0,
    lastExampleOriginal: json['last_example_original'] as String?,
    lastExampleCorrected: json['last_example_corrected'] as String?,
    lastExampleExplanation: json['last_example_explanation'] as String?,
  );
}

/// `GET /focus-session?due=&fails=&subs=`.
class FocusSessionData {
  const FocusSessionData({
    required this.dueWords,
    required this.examFailWords,
    required this.subtitleWords,
    required this.weaknesses,
  });

  final List<FocusReviewWord> dueWords;
  final List<FocusSubtitleWord> examFailWords;
  final List<FocusSubtitleWord> subtitleWords;
  final List<FocusWeakness> weaknesses;

  int get totalActionable =>
      dueWords.length +
      examFailWords.length +
      subtitleWords.length +
      weaknesses.length;

  factory FocusSessionData.fromJson(Map<String, dynamic> json) =>
      FocusSessionData(
        dueWords: (json['due_words'] as List<dynamic>? ?? [])
            .map((e) => FocusReviewWord.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        examFailWords: (json['exam_fail_words'] as List<dynamic>? ?? [])
            .map((e) => FocusSubtitleWord.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        subtitleWords: (json['subtitle_words'] as List<dynamic>? ?? [])
            .map((e) => FocusSubtitleWord.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        weaknesses: (json['weaknesses'] as List<dynamic>? ?? [])
            .map((e) => FocusWeakness.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );
}

/// Độ phủ mastery theo cấp CEFR — thành phần của [LearnerModel].
class LevelCoverage {
  const LevelCoverage({
    required this.level,
    required this.total,
    required this.mature,
  });

  final String level;
  final int total;
  final int mature;

  factory LevelCoverage.fromJson(Map<String, dynamic> json) => LevelCoverage(
    level: json['level'] as String? ?? '',
    total: (json['total'] as num?)?.toInt() ?? 0,
    mature: (json['mature'] as num?)?.toInt() ?? 0,
  );
}

/// Thẻ yếu (lapses cao / đang relearn) cần luyện lại.
class LearnerWeakWord {
  const LearnerWeakWord({
    required this.learningItemId,
    required this.contentDe,
    required this.contentVi,
    required this.level,
    required this.lapses,
  });

  final String learningItemId;
  final String contentDe;
  final String contentVi;
  final String level;
  final int lapses;

  factory LearnerWeakWord.fromJson(Map<String, dynamic> json) =>
      LearnerWeakWord(
        learningItemId: json['learning_item_id'] as String? ?? '',
        contentDe: json['content_de'] as String? ?? '',
        contentVi: json['content_vi'] as String? ?? '',
        level: json['level'] as String? ?? '',
        lapses: (json['lapses'] as num?)?.toInt() ?? 0,
      );
}

/// Loại lỗi ngữ pháp thường gặp trong learner model (khác payload từ
/// focus-session — đây có `code`/`name_vi`/`level`).
class GrammarWeaknessSummary {
  const GrammarWeaknessSummary({
    required this.code,
    required this.nameVi,
    required this.level,
    required this.errorCount,
  });

  final String code;
  final String nameVi;
  final String level;
  final int errorCount;

  factory GrammarWeaknessSummary.fromJson(Map<String, dynamic> json) =>
      GrammarWeaknessSummary(
        code: json['code'] as String? ?? '',
        nameVi: json['name_vi'] as String? ?? '',
        level: json['level'] as String? ?? '',
        errorCount: (json['error_count'] as num?)?.toInt() ?? 0,
      );
}

/// Ước tính "sẵn sàng thi" kèm khoảng tin cậy + hành động ưu tiên.
class LearnerReadiness {
  const LearnerReadiness({
    required this.pct,
    required this.low,
    required this.high,
    required this.hasData,
  });

  final int pct;
  final int low;
  final int high;
  final bool hasData;

  factory LearnerReadiness.fromJson(Map<String, dynamic> json) =>
      LearnerReadiness(
        pct: (json['pct'] as num?)?.toInt() ?? 0,
        low: (json['low'] as num?)?.toInt() ?? 0,
        high: (json['high'] as num?)?.toInt() ?? 0,
        hasData: json['has_data'] as bool? ?? false,
      );
}

/// `GET /user/learner-model?weak_limit=`.
class LearnerModel {
  const LearnerModel({
    required this.totalCards,
    required this.matureCards,
    required this.maturePct,
    required this.dueNow,
    required this.weakTotal,
    required this.coverageByLevel,
    required this.weakWords,
    required this.grammarWeaknesses,
    required this.readiness,
  });

  final int totalCards;
  final int matureCards;
  final int maturePct;
  final int dueNow;
  final int weakTotal;
  final List<LevelCoverage> coverageByLevel;
  final List<LearnerWeakWord> weakWords;
  final List<GrammarWeaknessSummary> grammarWeaknesses;
  final LearnerReadiness readiness;

  factory LearnerModel.fromJson(Map<String, dynamic> json) => LearnerModel(
    totalCards: (json['total_cards'] as num?)?.toInt() ?? 0,
    matureCards: (json['mature_cards'] as num?)?.toInt() ?? 0,
    maturePct: (json['mature_pct'] as num?)?.toInt() ?? 0,
    dueNow: (json['due_now'] as num?)?.toInt() ?? 0,
    weakTotal: (json['weak_total'] as num?)?.toInt() ?? 0,
    coverageByLevel: (json['coverage_by_level'] as List<dynamic>? ?? [])
        .map((e) => LevelCoverage.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    weakWords: (json['weak_words'] as List<dynamic>? ?? [])
        .map((e) => LearnerWeakWord.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    grammarWeaknesses: (json['grammar_weaknesses'] as List<dynamic>? ?? [])
        .map((e) => GrammarWeaknessSummary.fromJson(e as Map<String, dynamic>))
        .toList(growable: false),
    readiness: json['readiness'] is Map<String, dynamic>
        ? LearnerReadiness.fromJson(json['readiness'] as Map<String, dynamic>)
        : const LearnerReadiness(
            pct: 0,
            low: 0,
            high: 0,
            hasData: false,
          ),
  );
}

/// `GET/PUT /user/preferences` — chỉ field topic explore cần (đủ dùng, không
/// map hết toàn bộ preferences để tránh phình DTO ngoài phạm vi màn hình).
class LearnPreferences {
  const LearnPreferences({
    required this.learningGoals,
    required this.priorityTopics,
  });

  final List<String> learningGoals;
  final List<String> priorityTopics;

  factory LearnPreferences.fromJson(Map<String, dynamic> json) =>
      LearnPreferences(
        learningGoals: (json['learning_goals'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(growable: false),
        priorityTopics: (json['priority_topics'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(growable: false),
      );
}

/// Kết quả chấm câu từ `POST /ai/grade-sentence` — chỉ field practice
/// session dùng (score/corrected_sentence/summary_vi); các field khác của
/// response (contains_word, grammar_ok, corrections chi tiết...) không hiển
/// thị trong can-do practice nên không cần parse ở đây.
class GradeSentenceResult {
  const GradeSentenceResult({
    required this.score,
    required this.correctedSentence,
    required this.summaryVi,
  });

  final int score;
  final String correctedSentence;
  final String summaryVi;

  bool get isCorrect => score >= 70;

  factory GradeSentenceResult.fromJson(Map<String, dynamic> json) =>
      GradeSentenceResult(
        score: (json['score'] as num?)?.toInt() ?? 0,
        correctedSentence: json['corrected_sentence'] as String? ?? '',
        summaryVi: json['summary_vi'] as String? ?? '',
      );
}
