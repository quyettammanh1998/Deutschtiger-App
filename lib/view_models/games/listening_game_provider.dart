import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vocab/vocab_models.dart';
import '../../repositories/vocab/vocabulary_repository.dart';

/// Nguồn từ cho Listening game — tái dùng [VocabularyRepository]
/// (`GET /vocabulary/learned`, đã live). Audio phát qua [AudioService]
/// (server TTS cache `/user/tts/vocab-cache` → fallback TTS trên máy),
/// giống cách flashcard hiện tại phát âm — không cần endpoint audio riêng.
final listeningGameWordsProvider =
    FutureProvider.autoDispose<List<VocabWord>>((ref) async {
  return ref.watch(vocabularyRepositoryProvider).getLearnedWords(pageSize: 50);
});
