import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/games/sentence_builder_models.dart';
import '../../repositories/games/sentence_builder_repository.dart';
import '../providers.dart';

final sentenceBuilderRepositoryProvider =
    Provider<SentenceBuilderRepository>((ref) {
  return SentenceBuilderRepository(ref.watch(apiClientProvider));
});

/// Danh sách chủ đề theo level — key theo level để đổi level tự refetch.
final sentenceBuilderTopicsProvider = FutureProvider.autoDispose
    .family<List<SentenceBuilderTopic>, String>((ref, level) async {
  return ref
      .watch(sentenceBuilderRepositoryProvider)
      .fetchTopics(level: level);
});
