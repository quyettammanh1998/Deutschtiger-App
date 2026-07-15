import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vocab/vocab_models.dart';
import '../../repositories/vocab/vocabulary_repository.dart';

/// Nguồn từ cho Deutsch Runner — tái dùng [VocabularyRepository]
/// (`GET /vocabulary/learned`, đã live). Web dùng learning-items pool riêng
/// (`useRunnerWords`/`fetchItemsWithWeakMix`) với 4 kiểu câu hỏi (de-to-vi,
/// vi-to-de, listen-de, listen-vi) không phụ thuộc giống đực/cái/trung —
/// quiz ở đây theo cùng ý tưởng "chọn nghĩa đúng" (không phải quiz
/// der/die/das như bản tĩnh cũ, vì API vocab không trả gender).
final runnerGameWordsProvider =
    FutureProvider.autoDispose<List<VocabWord>>((ref) async {
  return ref.watch(vocabularyRepositoryProvider).getLearnedWords(pageSize: 50);
});
