import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/repositories/flashcard/review_repository.dart';
import 'package:deutschtiger/services/api_client.dart';

import 'vocab_lesson_models.dart';

/// SRS lesson-batch fetch + rating for [VocabularyLessonScreen] — web parity
/// `srsService.getLessonBatch{,ForTopic,ForLevel}` /
/// `srsService.recordReviewRated` (`src/lib/srs/srs-service.ts`).
///
/// Rating is delegated to [ReviewRepository.rate] (already used by the
/// flashcard/daily-review flows) — same `POST /user/srs/review` endpoint,
/// no new wire format needed.
class VocabLessonRepository {
  VocabLessonRepository(this._api) : _reviewRepository = ReviewRepository(_api);

  final ApiClient _api;
  final ReviewRepository _reviewRepository;

  /// Lesson batch for a curated `word_collection` (legacy slugs, e.g.
  /// goethe-a1/medical/sprechen). `GET /user/srs/lesson-batch`.
  Future<LessonBatch> fetchForCollection(
    String collectionId, {
    required int newCount,
    required int dueCount,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/srs/lesson-batch',
      query: {
        'collection_id': collectionId,
        'new': newCount,
        'due': dueCount,
      },
    );
    return LessonBatch.fromJson(json);
  }

  /// Lesson batch scoped to a vocabulary topic (`topic-{key}` slugs).
  /// `GET /user/srs/lesson-batch-by-topic`.
  Future<LessonBatch> fetchForTopic(
    String topicKey, {
    String level = '',
    required int newCount,
    required int dueCount,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/srs/lesson-batch-by-topic',
      query: {
        'topic': topicKey,
        if (level.isNotEmpty) 'level': level,
        'new': newCount,
        'due': dueCount,
      },
    );
    return LessonBatch.fromJson(json);
  }

  /// Lesson batch scoped to a CEFR level, mixed topics (`level-{level}`
  /// slugs). `GET /user/srs/lesson-batch-by-level`.
  Future<LessonBatch> fetchForLevel(
    String level, {
    required int newCount,
    required int dueCount,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/srs/lesson-batch-by-level',
      query: {'level': level, 'new': newCount, 'due': dueCount},
    );
    return LessonBatch.fromJson(json);
  }

  /// Records one FSRS review event for [card] — `mode` tags provenance
  /// (`vocab_lesson_flip`, `vocab_lesson_cloze`, …) same as web.
  Future<void> rate(LessonCard card, int rating, {required String mode}) async {
    final hasLearningItem = (card.learningItemId ?? '').isNotEmpty;
    final item = ReviewItem(
      learningItemId: hasLearningItem ? card.learningItemId : null,
      sourceFlashcardId: hasLearningItem ? null : card.sourceFlashcardId,
    );
    final ratingEnum = ReviewRating.values.firstWhere(
      (r) => r.apiRating == rating,
      orElse: () => ReviewRating.medium,
    );
    await _reviewRepository.rate(
      item,
      ratingEnum,
      responseTime: Duration.zero,
      mode: mode,
    );
  }
}
