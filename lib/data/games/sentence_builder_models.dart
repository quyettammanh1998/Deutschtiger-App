/// Plain Dart models cho Sentence Builder game — mirrors backend
/// `internal/feature/gamify/game/sentence_builder_*_handler.go` và web
/// `src/types/sentence-builder.ts`. Không dùng freezed/json_serializable để
/// tránh race build_runner với các domain khác đang chạy song song.
library;

/// Tiến độ người dùng cho một topic (chỉ có khi đã luyện tập topic đó).
class SentenceBuilderUserProgress {
  const SentenceBuilderUserProgress({
    required this.wordsPracticed,
    required this.wordsMastered,
    this.lastPracticedAt,
  });

  final int wordsPracticed;
  final int wordsMastered;
  final DateTime? lastPracticedAt;

  factory SentenceBuilderUserProgress.fromJson(Map<String, dynamic> json) =>
      SentenceBuilderUserProgress(
        wordsPracticed: (json['wordsPracticed'] as num?)?.toInt() ?? 0,
        wordsMastered: (json['wordsMastered'] as num?)?.toInt() ?? 0,
        lastPracticedAt: json['lastPracticedAt'] != null
            ? DateTime.tryParse(json['lastPracticedAt'] as String)
            : null,
      );
}

/// Chủ đề từ vựng — `GET /sentence-builder/topics?level=`.
class SentenceBuilderTopic {
  const SentenceBuilderTopic({
    required this.id,
    required this.key,
    required this.label,
    required this.labelVi,
    required this.icon,
    this.color,
    required this.wordCount,
    required this.essentialWordCount,
    this.userProgress,
  });

  final String id;
  final String key;
  final String label;
  final String labelVi;
  final String icon;
  final String? color;
  final int wordCount;
  final int essentialWordCount;
  final SentenceBuilderUserProgress? userProgress;

  factory SentenceBuilderTopic.fromJson(Map<String, dynamic> json) =>
      SentenceBuilderTopic(
        id: json['id'] as String? ?? '',
        key: json['key'] as String? ?? '',
        label: json['label'] as String? ?? '',
        labelVi: json['labelVi'] as String? ?? '',
        icon: json['icon'] as String? ?? 'book',
        color: json['color'] as String?,
        wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
        essentialWordCount: (json['essentialWordCount'] as num?)?.toInt() ?? 0,
        userProgress: json['userProgress'] != null
            ? SentenceBuilderUserProgress.fromJson(
                json['userProgress'] as Map<String, dynamic>,
              )
            : null,
      );
}

/// Từ trong một session đang chơi — `SessionWord` bên backend.
class SentenceBuilderSessionWord {
  const SentenceBuilderSessionWord({
    required this.id,
    required this.contentDe,
    required this.contentVi,
    required this.wordType,
    this.gender,
  });

  final String id;
  final String contentDe;
  final String contentVi;
  final String wordType;
  final String? gender;

  factory SentenceBuilderSessionWord.fromJson(Map<String, dynamic> json) =>
      SentenceBuilderSessionWord(
        id: json['id'] as String? ?? '',
        contentDe: json['contentDe'] as String? ?? '',
        contentVi: json['contentVi'] as String? ?? '',
        wordType: json['wordType'] as String? ?? 'other',
        gender: json['gender'] as String?,
      );
}

/// Thông tin topic rút gọn kèm session — `TopicInfo` bên backend.
class SentenceBuilderSessionTopic {
  const SentenceBuilderSessionTopic({
    required this.id,
    required this.key,
    required this.label,
    required this.labelVi,
  });

  final String id;
  final String key;
  final String label;
  final String labelVi;

  factory SentenceBuilderSessionTopic.fromJson(Map<String, dynamic> json) =>
      SentenceBuilderSessionTopic(
        id: json['id'] as String? ?? '',
        key: json['key'] as String? ?? '',
        label: json['label'] as String? ?? '',
        labelVi: json['labelVi'] as String? ?? '',
      );
}

/// Kết quả `POST /sentence-builder/session`.
class SentenceBuilderSession {
  const SentenceBuilderSession({
    required this.sessionId,
    required this.topic,
    required this.words,
  });

  final String sessionId;
  final SentenceBuilderSessionTopic topic;
  final List<SentenceBuilderSessionWord> words;

  factory SentenceBuilderSession.fromJson(Map<String, dynamic> json) =>
      SentenceBuilderSession(
        sessionId: json['sessionId'] as String? ?? '',
        topic: SentenceBuilderSessionTopic.fromJson(
          json['topic'] as Map<String, dynamic>? ?? const {},
        ),
        words: (json['words'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(SentenceBuilderSessionWord.fromJson)
            .toList(growable: false),
      );
}

/// Kết quả 1 câu đã chấm trong phiên chơi — dùng cho màn hình kết quả cuối.
class SentenceBuilderResult {
  const SentenceBuilderResult({
    required this.itemId,
    required this.word,
    required this.score,
    required this.skipped,
  });

  final String itemId;
  final String word;
  final int score;
  final bool skipped;

  bool get isGraded => !skipped && score > 0;
}

/// Một từ trong danh sách xem trước của 1 topic — `GET /sentence-builder/
/// topics/:id/words`. Mirrors web `Word` (`src/types/sentence-builder.ts`).
///
/// `examples` luôn rỗng ở backend hiện tại: field JSON tồn tại
/// (`WordResponse.Examples`) nhưng handler Go chỉ `Scan` 8 cột và không bao
/// giờ gán giá trị cho nó (xem `docs/flutter-api-contract-matrix.md`) — UI
/// không được coi rỗng là "chưa tải" mà phải ẩn hẳn mục ví dụ.
class SentenceBuilderTopicWord {
  const SentenceBuilderTopicWord({
    required this.id,
    required this.contentDe,
    required this.contentVi,
    required this.wordType,
    this.gender,
    required this.importanceScore,
    required this.isEssential,
    this.examples = const [],
  });

  final String id;
  final String contentDe;
  final String contentVi;
  final String wordType;
  final String? gender;
  final double importanceScore;
  final bool isEssential;
  final List<String> examples;

  factory SentenceBuilderTopicWord.fromJson(Map<String, dynamic> json) =>
      SentenceBuilderTopicWord(
        id: json['id'] as String? ?? '',
        contentDe: json['contentDe'] as String? ?? '',
        contentVi: json['contentVi'] as String? ?? '',
        wordType: json['wordType'] as String? ?? 'other',
        gender: json['gender'] as String?,
        importanceScore: (json['importanceScore'] as num?)?.toDouble() ?? 0,
        isEssential: json['isEssential'] as bool? ?? false,
        examples: (json['examples'] as List<dynamic>? ?? const [])
            .whereType<String>()
            .toList(growable: false),
      );
}

/// Thống kê số từ theo loại — phần `stats` của response preview.
class SentenceBuilderWordStats {
  const SentenceBuilderWordStats({
    required this.totalWords,
    required this.essentialWords,
    required this.verbs,
    required this.nouns,
    required this.adjectives,
  });

  final int totalWords;
  final int essentialWords;
  final int verbs;
  final int nouns;
  final int adjectives;

  factory SentenceBuilderWordStats.fromJson(Map<String, dynamic> json) =>
      SentenceBuilderWordStats(
        totalWords: (json['totalWords'] as num?)?.toInt() ?? 0,
        essentialWords: (json['essentialWords'] as num?)?.toInt() ?? 0,
        verbs: (json['verbs'] as num?)?.toInt() ?? 0,
        nouns: (json['nouns'] as num?)?.toInt() ?? 0,
        adjectives: (json['adjectives'] as num?)?.toInt() ?? 0,
      );
}

/// `GET /sentence-builder/topics/:id/words?level=&limit=` response.
class SentenceBuilderTopicWordsResponse {
  const SentenceBuilderTopicWordsResponse({
    required this.topic,
    required this.words,
    required this.stats,
  });

  final SentenceBuilderSessionTopic topic;
  final List<SentenceBuilderTopicWord> words;
  final SentenceBuilderWordStats stats;

  factory SentenceBuilderTopicWordsResponse.fromJson(
    Map<String, dynamic> json,
  ) => SentenceBuilderTopicWordsResponse(
    topic: SentenceBuilderSessionTopic.fromJson(
      json['topic'] as Map<String, dynamic>? ?? const {},
    ),
    words: (json['words'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SentenceBuilderTopicWord.fromJson)
        .toList(growable: false),
    stats: SentenceBuilderWordStats.fromJson(
      json['stats'] as Map<String, dynamic>? ?? const {},
    ),
  );
}
