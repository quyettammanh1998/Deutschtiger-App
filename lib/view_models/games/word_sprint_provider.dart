import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vocab/vocab_models.dart';
import '../../repositories/vocab/vocabulary_repository.dart';

/// Nguồn từ vựng cho Word Sprint — tái dùng [VocabularyRepository] (đã live,
/// dùng chung với màn "Từ đã học") thay vì danh sách tĩnh cũ.
/// `GET /vocabulary/learned` trả về các từ user đã đánh dấu đã học; game cần
/// tối thiểu 4 từ để tạo đáp án nhiễu (2x2 grid).
final wordSprintWordsProvider =
    FutureProvider.autoDispose<List<VocabWord>>((ref) async {
  return ref
      .watch(vocabularyRepositoryProvider)
      .getLearnedWords(pageSize: 50);
});
