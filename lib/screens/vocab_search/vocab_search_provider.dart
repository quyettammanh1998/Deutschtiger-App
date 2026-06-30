import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/repositories/vocab/vocab_notes_repository.dart';
import 'package:deutschtiger/repositories/vocab/vocabulary_repository.dart';
import 'package:deutschtiger/data/vocab/vocab_models.dart';

export 'package:deutschtiger/repositories/vocab/vocabulary_repository.dart' show vocabularyRepositoryProvider;
export 'package:deutschtiger/repositories/vocab/vocab_notes_repository.dart' show vocabNotesRepositoryProvider;

/// CEFR level options.
const cefrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/// Search query state.
class VocabSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  
  void setQuery(String query) => state = query;
}

final vocabSearchQueryProvider = NotifierProvider<VocabSearchQueryNotifier, String>(
  VocabSearchQueryNotifier.new,
);

/// CEFR level filter.
class VocabCefrFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  
  void setFilter(String? cefrLevel) => state = cefrLevel;
}

final vocabCefrFilterProvider = NotifierProvider<VocabCefrFilterNotifier, String?>(
  VocabCefrFilterNotifier.new,
);

/// Search results from real API.
final vocabSearchResultsProvider = FutureProvider<VocabSearchResult>((ref) async {
  final query = ref.watch(vocabSearchQueryProvider);
  final cefrLevel = ref.watch(vocabCefrFilterProvider);

  // Require at least 2 characters to search
  if (query.trim().length < 2) {
    return const VocabSearchResult(words: [], totalCount: 0, page: 1, perPage: 20);
  }

  final repo = ref.watch(vocabularyRepositoryProvider);
  return repo.search(
    query: query,
    cefrLevel: cefrLevel,
  );
});

/// Learned words from real API.
final learnedWordsProvider = FutureProvider<List<VocabWord>>((ref) async {
  final repo = ref.watch(vocabularyRepositoryProvider);
  return repo.getLearnedWords();
});

/// Selected word for detail view.
class SelectedWordNotifier extends Notifier<VocabWord?> {
  @override
  VocabWord? build() => null;
  
  void setWord(VocabWord? word) => state = word;
}

final selectedWordProvider = NotifierProvider<SelectedWordNotifier, VocabWord?>(
  SelectedWordNotifier.new,
);

// ============================================================================
// Notes Providers
// ============================================================================

/// Lay ghi chu cho mot tu.
final vocabNoteProvider = FutureProvider.family<String?, String>((ref, wordId) async {
  final repo = ref.watch(vocabNotesRepositoryProvider);
  return repo.getNote(wordId);
});

/// Lay tat ca ghi chu cua user.
final allVocabNotesProvider = FutureProvider<List<VocabWordWithNote>>((ref) async {
  final repo = ref.watch(vocabNotesRepositoryProvider);
  return repo.getAllNotes();
});

/// Simple notes save service - goi khi can luu ghi chu.
/// Su dung ref.invalidate sau khi goi de refresh cache.
class VocabNoteSaveService {
  VocabNoteSaveService(this._ref);
  final Ref _ref;

  Future<void> saveNote(String wordId, String note) async {
    final repo = _ref.read(vocabNotesRepositoryProvider);
    await repo.saveNote(wordId, note);
    // Refresh cache
    _ref.invalidate(vocabNoteProvider(wordId));
    _ref.invalidate(allVocabNotesProvider);
  }

  Future<void> deleteNote(String wordId) async {
    final repo = _ref.read(vocabNotesRepositoryProvider);
    await repo.deleteNote(wordId);
    // Refresh cache
    _ref.invalidate(vocabNoteProvider(wordId));
    _ref.invalidate(allVocabNotesProvider);
  }
}

final vocabNoteSaveServiceProvider = Provider<VocabNoteSaveService>((ref) {
  return VocabNoteSaveService(ref);
});
