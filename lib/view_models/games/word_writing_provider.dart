import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vocab/vocab_models.dart';
import '../../repositories/games/word_writing_repository.dart';
import '../../repositories/vocab/vocabulary_repository.dart';
import '../providers.dart';

final wordWritingRepositoryProvider = Provider<WordWritingRepository>((ref) {
  return WordWritingRepository(ref.watch(apiClientProvider));
});

/// Nguồn từ cho Writing Word game — tái dùng [VocabularyRepository]
/// (`GET /vocabulary/learned`, đã live), giống Word Sprint.
final writingWordWordsProvider =
    FutureProvider.autoDispose<List<VocabWord>>((ref) async {
  return ref.watch(vocabularyRepositoryProvider).getLearnedWords(pageSize: 50);
});
