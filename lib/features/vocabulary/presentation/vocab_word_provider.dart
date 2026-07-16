import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/flashcard/review_item.dart';
import '../../../repositories/flashcard/review_repository.dart';
import '../../../view_models/providers.dart';

/// New provider file (does not touch the shared `vocabulary_provider.dart`)
/// — "Đã thuộc" (mark-mastered) action for [VocabularyWordScreen]. Reuses
/// the existing `POST /user/srs/review` flow via [ReviewRepository] with an
/// explicit Easy (4) rating — same FSRS effect as web's
/// `srsService.recordPractice([{itemId, rating: 4}], 'vocab')` batch call,
/// without needing a new `/user/srs/practice` Dart wrapper for a
/// single-item action.
final vocabWordReviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(apiClientProvider));
});

/// Marks [learningItemId] as already-known (FSRS rating 4/Easy).
Future<void> markVocabWordMastered(WidgetRef ref, String learningItemId) async {
  final repo = ref.read(vocabWordReviewRepositoryProvider);
  await repo.rate(
    ReviewItem(learningItemId: learningItemId),
    ReviewRating.easy,
    responseTime: Duration.zero,
    mode: 'vocab_mastered',
  );
}
