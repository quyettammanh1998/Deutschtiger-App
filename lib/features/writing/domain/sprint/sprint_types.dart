/// Sprint v2 SR (spaced-repetition) types — web parity `sprint-types.ts`.
/// Read-only content DTOs (`SprintTopicData`/`SprintCluster`) plus the
/// persisted SR state (`SRCardState`/`SRQueue`/`SprintEssayResult`) that round-trips
/// through [SrQueueStore].
library;

/// `marathon` = 1-session minute-based intervals capped at `sessionStart+10h`.
/// `daily` = standard multi-day SM-2.
enum SRMode {
  marathon,
  daily;

  static SRMode fromJson(String? v) => v == 'daily' ? SRMode.daily : SRMode.marathon;
  String toJson() => name;
}

enum SRRating {
  again,
  hard,
  good,
  easy;

  static SRRating fromJson(String? v) =>
      SRRating.values.firstWhere((r) => r.name == v, orElse: () => SRRating.again);
  String toJson() => name;
}

/// Per-card SR state — persisted, `due` is an ABSOLUTE ISO timestamp (not a
/// countdown), which is what makes the queue restart-safe with no background
/// timer (verified 17/07 against web's `sm2-scheduler.ts`).
class SRCardState {
  const SRCardState({
    required this.slug,
    required this.due,
    this.ef = 2.5,
    this.interval = 0,
    this.reps = 0,
    this.lastRating,
    this.seenCount = 0,
    this.lastSeenAt,
  });

  final String slug;
  final DateTime due;
  final double ef;
  final int interval;
  final int reps;
  final SRRating? lastRating;
  final int seenCount;
  final DateTime? lastSeenAt;

  SRCardState copyWith({
    DateTime? due,
    double? ef,
    int? interval,
    int? reps,
    SRRating? lastRating,
    int? seenCount,
    DateTime? lastSeenAt,
  }) {
    return SRCardState(
      slug: slug,
      due: due ?? this.due,
      ef: ef ?? this.ef,
      interval: interval ?? this.interval,
      reps: reps ?? this.reps,
      lastRating: lastRating ?? this.lastRating,
      seenCount: seenCount ?? this.seenCount,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'slug': slug,
    'due': due.toIso8601String(),
    'ef': ef,
    'interval': interval,
    'reps': reps,
    if (lastRating != null) 'lastRating': lastRating!.toJson(),
    'seenCount': seenCount,
    if (lastSeenAt != null) 'lastSeenAt': lastSeenAt!.toIso8601String(),
  };

  factory SRCardState.fromJson(Map<String, dynamic> json) => SRCardState(
    slug: json['slug']?.toString() ?? '',
    due: DateTime.tryParse(json['due']?.toString() ?? '') ?? DateTime.now(),
    ef: (json['ef'] as num?)?.toDouble() ?? 2.5,
    interval: (json['interval'] as num?)?.toInt() ?? 0,
    reps: (json['reps'] as num?)?.toInt() ?? 0,
    lastRating: json['lastRating'] == null ? null : SRRating.fromJson(json['lastRating']?.toString()),
    seenCount: (json['seenCount'] as num?)?.toInt() ?? 0,
    lastSeenAt: json['lastSeenAt'] == null ? null : DateTime.tryParse(json['lastSeenAt'].toString()),
  );
}

class SprintEssayErrorItem {
  const SprintEssayErrorItem({required this.snippet, required this.correction, required this.explanation});

  final String snippet;
  final String correction;
  final String explanation;

  Map<String, dynamic> toJson() => {'snippet': snippet, 'correction': correction, 'explanation': explanation};

  factory SprintEssayErrorItem.fromJson(Map<String, dynamic> json) => SprintEssayErrorItem(
    snippet: json['snippet']?.toString() ?? '',
    correction: json['correction']?.toString() ?? '',
    explanation: json['explanation']?.toString() ?? '',
  );
}

/// AI-graded mini practice-exam essay result. `total`/the 4
/// criteria are already 0-100 (backend converts from its 0-4 native rubric).
class SprintEssayResult {
  const SprintEssayResult({
    required this.topicSlug,
    required this.teil,
    required this.total,
    required this.erfullung,
    required this.koharenz,
    required this.wortschatz,
    required this.strukturen,
    required this.grade,
    required this.feedback,
    required this.errors,
    required this.gradedAt,
  });

  final String topicSlug;
  final int teil;
  final int total;
  final int erfullung;
  final int koharenz;
  final int wortschatz;
  final int strukturen;

  /// `sehr_gut` | `gut` | `befriedigend` | `schwach`.
  final String grade;
  final Map<String, String> feedback;
  final List<SprintEssayErrorItem> errors;
  final DateTime gradedAt;

  Map<String, dynamic> toJson() => {
    'topicSlug': topicSlug,
    'teil': teil,
    'total': total,
    'erfullung': erfullung,
    'koharenz': koharenz,
    'wortschatz': wortschatz,
    'strukturen': strukturen,
    'grade': grade,
    'feedback': feedback,
    'errors': errors.map((e) => e.toJson()).toList(),
    'gradedAt': gradedAt.toIso8601String(),
  };

  factory SprintEssayResult.fromJson(Map<String, dynamic> json) => SprintEssayResult(
    topicSlug: json['topicSlug']?.toString() ?? '',
    teil: (json['teil'] as num?)?.toInt() ?? 1,
    total: (json['total'] as num?)?.toInt() ?? 0,
    erfullung: (json['erfullung'] as num?)?.toInt() ?? 0,
    koharenz: (json['koharenz'] as num?)?.toInt() ?? 0,
    wortschatz: (json['wortschatz'] as num?)?.toInt() ?? 0,
    strukturen: (json['strukturen'] as num?)?.toInt() ?? 0,
    grade: json['grade']?.toString() ?? 'schwach',
    feedback: (json['feedback'] as Map?)?.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')) ?? const {},
    errors: (json['errors'] as List?)
            ?.whereType<Map>()
            .map((e) => SprintEssayErrorItem.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        const [],
    gradedAt: DateTime.tryParse(json['gradedAt']?.toString() ?? '') ?? DateTime.now(),
  );
}

/// Persisted SR queue — round-trips whole through [SrQueueStore]. `version`
/// is fixed at 2 (sprint v2 only, matches web).
class SRQueue {
  const SRQueue({
    required this.mode,
    required this.sessionStart,
    required this.cards,
    this.essayResults = const {},
    this.essayDrafts = const {},
  });

  final SRMode mode;
  final DateTime sessionStart;
  final List<SRCardState> cards;
  final Map<String, SprintEssayResult> essayResults;
  final Map<String, String> essayDrafts;

  SRQueue copyWith({
    List<SRCardState>? cards,
    Map<String, SprintEssayResult>? essayResults,
    Map<String, String>? essayDrafts,
  }) {
    return SRQueue(
      mode: mode,
      sessionStart: sessionStart,
      cards: cards ?? this.cards,
      essayResults: essayResults ?? this.essayResults,
      essayDrafts: essayDrafts ?? this.essayDrafts,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': 2,
    'mode': mode.toJson(),
    'sessionStart': sessionStart.toIso8601String(),
    'cards': cards.map((c) => c.toJson()).toList(),
    'essayResults': essayResults.map((k, v) => MapEntry(k, v.toJson())),
    'essayDrafts': essayDrafts,
  };

  factory SRQueue.fromJson(Map<String, dynamic> json) => SRQueue(
    mode: SRMode.fromJson(json['mode']?.toString()),
    sessionStart: DateTime.tryParse(json['sessionStart']?.toString() ?? '') ?? DateTime.now(),
    cards: (json['cards'] as List?)
            ?.whereType<Map>()
            .map((c) => SRCardState.fromJson(Map<String, dynamic>.from(c)))
            .toList() ??
        const [],
    essayResults: (json['essayResults'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), SprintEssayResult.fromJson(Map<String, dynamic>.from(v as Map))),
        ) ??
        const {},
    essayDrafts: (json['essayDrafts'] as Map?)?.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')) ??
        const {},
  );
}

// ── Read-only content DTOs (from `GET /goethe-b1-writing/teil/{n}`) ────────

class Outline3 {
  const Outline3({this.de = const [], this.vi = const []});
  final List<String> de;
  final List<String> vi;

  factory Outline3.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Outline3();
    return Outline3(
      de: (json['de'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      vi: (json['vi'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}

class MiniModel {
  const MiniModel({required this.de, this.vi = '', this.audioUrl});
  final String de;
  final String vi;
  final String? audioUrl;

  factory MiniModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MiniModel(de: '');
    return MiniModel(
      de: json['de']?.toString() ?? '',
      vi: json['vi']?.toString() ?? '',
      audioUrl: json['audioUrl']?.toString(),
    );
  }
}

/// `opening` | `reason` | `suggestion` | `closing` | `connector`.
class RedemittelItem {
  const RedemittelItem({required this.de, this.vi = '', required this.function, this.audioUrl});

  final String de;
  final String vi;
  final String function;
  final String? audioUrl;

  factory RedemittelItem.fromJson(Map<String, dynamic> json) => RedemittelItem(
    de: json['de']?.toString() ?? '',
    vi: json['vi']?.toString() ?? '',
    function: json['function']?.toString() ?? 'connector',
    audioUrl: json['audioUrl']?.toString(),
  );
}

class SpeedrunContent {
  const SpeedrunContent({
    required this.outline3,
    this.outline3Audio = const [],
    required this.miniModel,
    this.redemittelCore = const [],
    this.generationCheckKeywords = const [],
    this.clusterId = '',
  });

  final Outline3 outline3;
  final List<String> outline3Audio;
  final MiniModel miniModel;
  final List<RedemittelItem> redemittelCore;
  final List<String> generationCheckKeywords;
  final String clusterId;

  factory SpeedrunContent.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SpeedrunContent(outline3: const Outline3(), miniModel: const MiniModel(de: ''));
    }
    return SpeedrunContent(
      outline3: Outline3.fromJson(json['outline3'] as Map<String, dynamic>?),
      outline3Audio: (json['outline3Audio'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      miniModel: MiniModel.fromJson(json['miniModel'] as Map<String, dynamic>?),
      redemittelCore: (json['redemittelCore'] as List?)
              ?.whereType<Map>()
              .map((e) => RedemittelItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      generationCheckKeywords:
          (json['generationCheckKeywords'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      clusterId: json['clusterId']?.toString() ?? '',
    );
  }
}

class TaskAnalysisPoint {
  const TaskAnalysisPoint({required this.de, this.vi = ''});
  final String de;
  final String vi;

  factory TaskAnalysisPoint.fromJson(Map<String, dynamic> json) =>
      TaskAnalysisPoint(de: json['de']?.toString() ?? '', vi: json['vi']?.toString() ?? '');
}

/// One sprint topic (Teil manifest entry, `speedrun` populated for the ~73
/// cards eligible for the SR queue). Web parity `SprintTopicData`.
class SprintTopicData {
  const SprintTopicData({
    required this.slug,
    required this.teil,
    required this.titleDe,
    this.titleVi = '',
    this.topicCluster,
    required this.taskDe,
    this.taskVi = '',
    this.taskAnalysisPoints = const [],
    this.speedrun,
  });

  final String slug;
  final int teil;
  final String titleDe;
  final String titleVi;
  final String? topicCluster;
  final String taskDe;
  final String taskVi;
  final List<TaskAnalysisPoint> taskAnalysisPoints;
  final SpeedrunContent? speedrun;

  factory SprintTopicData.fromJson(Map<String, dynamic> json) {
    final task = json['task'] as Map<String, dynamic>?;
    final taskAnalysis = json['taskAnalysis'] as Map<String, dynamic>?;
    final rawPoints = taskAnalysis?['points'] as List?;
    return SprintTopicData(
      slug: json['slug']?.toString() ?? '',
      teil: (json['teil'] as num?)?.toInt() ?? 0,
      titleDe: json['titleDe']?.toString() ?? '',
      titleVi: json['titleVi']?.toString() ?? '',
      topicCluster: json['topicCluster']?.toString(),
      taskDe: task?['de']?.toString() ?? '',
      taskVi: task?['vi']?.toString() ?? '',
      taskAnalysisPoints: rawPoints
              ?.whereType<Map>()
              .map((p) => TaskAnalysisPoint.fromJson(Map<String, dynamic>.from(p)))
              .toList() ??
          const [],
      speedrun: json['speedrun'] == null
          ? null
          : SpeedrunContent.fromJson(json['speedrun'] as Map<String, dynamic>),
    );
  }
}

class SprintCluster {
  const SprintCluster({
    required this.id,
    required this.titleDe,
    this.titleVi = '',
    this.topicSlugs = const [],
    this.byTeil = const {},
    this.count = 0,
    this.commonPatternDe,
    this.commonPatternVi,
  });

  final String id;
  final String titleDe;
  final String titleVi;
  final List<String> topicSlugs;

  /// `teil1`/`teil2`/`teil3` → slugs.
  final Map<String, List<String>> byTeil;
  final int count;
  final String? commonPatternDe;
  final String? commonPatternVi;

  factory SprintCluster.fromJson(Map<String, dynamic> json) {
    final rawByTeil = json['byTeil'] as Map?;
    return SprintCluster(
      id: json['id']?.toString() ?? '',
      titleDe: json['titleDe']?.toString() ?? '',
      titleVi: json['titleVi']?.toString() ?? '',
      topicSlugs: (json['topicSlugs'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      byTeil: rawByTeil?.map(
            (k, v) =>
                MapEntry(k.toString(), (v as List?)?.map((e) => e.toString()).toList() ?? const <String>[]),
          ) ??
          const {},
      count: (json['count'] as num?)?.toInt() ?? 0,
      commonPatternDe: json['commonPatternDe']?.toString(),
      commonPatternVi: json['commonPatternVi']?.toString(),
    );
  }
}
