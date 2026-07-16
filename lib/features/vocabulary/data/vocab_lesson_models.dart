/// SRS lesson-batch models — mirrors backend `srs.QueueCard` / `srs.LessonBatch`
/// (`internal/feature/learning/srs/{queue_builder,lesson_batch_builder}.go`)
/// and web `src/lib/srs/srs-types.ts` (`QueueCard`, `LessonBatch`).
///
/// Deliberately separate from `vocabulary_models.LearningItem` (page/detail
/// shape) and `data/games/learning_item_models.LearningItem` (balanced-pool
/// shape) — this is the SRS queue-card shape, which has different nullable
/// fields (either `learning_item_id`+`content_*` OR `source_flashcard_id`+
/// `word_*`) and carries `examples` for cloze/compose derivation.
library;

/// One example sentence attached to a lesson card (`de`/`vi`/optional
/// `cloze` template with a literal `___` blank, matches web `VocabExample`).
class LessonExample {
  const LessonExample({required this.de, this.vi, this.cloze, this.audioUrl});

  final String de;
  final String? vi;
  final String? cloze;
  final String? audioUrl;

  factory LessonExample.fromJson(Map<String, dynamic> json) => LessonExample(
    de: json['de'] as String? ?? '',
    vi: json['vi'] as String?,
    cloze: json['cloze'] as String?,
    audioUrl: json['audio_url'] as String?,
  );
}

/// One card in a lesson batch — either a catalog `learning_item_id` (has
/// `content_de`/`content_vi`) or a custom `source_flashcard_id` (has
/// `word_de`/`word_vi`). Use [displayDe]/[displayVi] to read either shape.
class LessonCard {
  const LessonCard({
    this.cardReviewId,
    this.learningItemId,
    this.sourceFlashcardId,
    this.contentDe,
    this.contentVi,
    this.audioUrl,
    this.level,
    this.wordDe,
    this.wordVi,
    this.flashcardAudioUrl,
    this.examples = const [],
  });

  final String? cardReviewId;
  final String? learningItemId;
  final String? sourceFlashcardId;
  final String? contentDe;
  final String? contentVi;
  final String? audioUrl;
  final String? level;
  final String? wordDe;
  final String? wordVi;
  final String? flashcardAudioUrl;
  final List<LessonExample> examples;

  String get id => learningItemId ?? sourceFlashcardId ?? cardReviewId ?? '';

  String get displayDe =>
      (contentDe?.isNotEmpty ?? false) ? contentDe! : (wordDe ?? '');

  String get displayVi =>
      (contentVi?.isNotEmpty ?? false) ? contentVi! : (wordVi ?? '');

  String get displayAudioUrl => audioUrl ?? flashcardAudioUrl ?? '';

  factory LessonCard.fromJson(Map<String, dynamic> json) {
    final rawExamples = json['examples'];
    return LessonCard(
      cardReviewId: json['card_review_id'] as String?,
      learningItemId: json['learning_item_id'] as String?,
      sourceFlashcardId: json['source_flashcard_id'] as String?,
      contentDe: json['content_de'] as String?,
      contentVi: json['content_vi'] as String?,
      audioUrl: json['audio_url'] as String?,
      level: json['level'] as String?,
      wordDe: json['word_de'] as String?,
      wordVi: json['word_vi'] as String?,
      flashcardAudioUrl: json['flashcard_audio_url'] as String?,
      examples: rawExamples is List
          ? rawExamples
                .whereType<Map<String, dynamic>>()
                .map(LessonExample.fromJson)
                .toList(growable: false)
          : const [],
    );
  }
}

/// `GET /user/srs/lesson-batch{,-by-topic,-by-level}` response.
class LessonBatch {
  const LessonBatch({
    required this.cards,
    required this.degenerate,
    required this.reason,
  });

  final List<LessonCard> cards;
  final bool degenerate;

  /// `ok | empty_collection | all_graduated | minimal_batch`.
  final String reason;

  factory LessonBatch.fromJson(Map<String, dynamic> json) {
    final rawCards = json['cards'] as List<dynamic>? ?? const [];
    return LessonBatch(
      cards: rawCards
          .whereType<Map<String, dynamic>>()
          .map(LessonCard.fromJson)
          .toList(growable: false),
      degenerate: json['degenerate'] as bool? ?? false,
      reason: json['reason'] as String? ?? '',
    );
  }
}
