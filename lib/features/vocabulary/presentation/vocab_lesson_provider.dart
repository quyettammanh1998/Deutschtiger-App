import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/games/word_writing_repository.dart';
import '../../../repositories/learn/learn_repository.dart';
import '../../../view_models/providers.dart';
import '../data/vocab_lesson_models.dart';
import '../data/vocab_lesson_repository.dart';
import '../data/vocab_lesson_utils.dart';

/// New provider file (does not touch the shared `vocabulary_provider.dart`
/// owned jointly with the sibling vocabulary-screen rebuild) — repository +
/// lesson-batch fetch for [VocabularyLessonScreen].
final vocabLessonRepositoryProvider = Provider<VocabLessonRepository>((ref) {
  return VocabLessonRepository(ref.watch(apiClientProvider));
});

/// AI grading for the writing card (`POST /ai/grade-word-writing`) — reused
/// as-is from the Writing Word game, not reimplemented.
final vocabWordWritingRepositoryProvider = Provider<WordWritingRepository>((ref) {
  return WordWritingRepository(ref.watch(apiClientProvider));
});

/// AI grading for the compose card (`POST /ai/grade-sentence`) — reused
/// as-is from the can-do practice / sentence-builder flows.
final vocabLearnRepositoryProvider = Provider<LearnRepository>((ref) {
  return LearnRepository(ref.watch(apiClientProvider));
});

/// Identifies which lesson source to hit — topic-mode (`topic-{key}` slug),
/// level-mode (`level-{level}` slug) or legacy collection-id mode. Mirrors
/// web `vocabulary-lesson-page.tsx`'s 3-way branch.
class VocabLessonBatchParams {
  const VocabLessonBatchParams({
    this.collectionId,
    this.topicKey,
    this.level,
    required this.mode,
  });

  /// Legacy collection-scoped lesson (goethe-a1/medical/sprechen slugs).
  final String? collectionId;

  /// Topic-scoped lesson (`topic-{key}` slugs). Takes precedence over
  /// [collectionId] when non-null.
  final String? topicKey;

  /// CEFR level filter/scope — overlay for topic-mode, or the scope itself
  /// for level-mode (`level-{level}` slugs) when [topicKey]/[collectionId]
  /// are both null.
  final String? level;

  final VocabLessonMode mode;

  @override
  bool operator ==(Object other) =>
      other is VocabLessonBatchParams &&
      other.collectionId == collectionId &&
      other.topicKey == topicKey &&
      other.level == level &&
      other.mode == mode;

  @override
  int get hashCode => Object.hash(collectionId, topicKey, level, mode);
}

final vocabLessonBatchProvider =
    FutureProvider.family<LessonBatch, VocabLessonBatchParams>((ref, params) {
      final repo = ref.watch(vocabLessonRepositoryProvider);
      final config = vocabLessonModeConfig[params.mode]!;
      if (params.topicKey != null) {
        return repo.fetchForTopic(
          params.topicKey!,
          level: params.level ?? '',
          newCount: config.newCount,
          dueCount: config.dueCount,
        );
      }
      if (params.collectionId != null) {
        return repo.fetchForCollection(
          params.collectionId!,
          newCount: config.newCount,
          dueCount: config.dueCount,
        );
      }
      return repo.fetchForLevel(
        params.level ?? '',
        newCount: config.newCount,
        dueCount: config.dueCount,
      );
    });
