import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vocab/subtitle_word.dart';
import '../../repositories/vocab/subtitle_words_repository.dart';

const kSubtitleWordsMinSeen = 2;
const kSubtitleWordsLimit = 50;
const kSubtitleWordsCefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

int subtitleWordsLevelOrder(String level) {
  final i = kSubtitleWordsCefrOrder.indexOf(level);
  return i == -1 ? 99 : i;
}

/// Số từ theo cấp CEFR — web parity `getCounts()`.
final subtitleWordsCountsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(subtitleWordsRepositoryProvider).getCounts(minSeen: kSubtitleWordsMinSeen);
});

/// [levelsKey] = sorted, comma-joined selected levels (`''` = all) — a
/// `family` needs a hashable arg, so the caller flattens the multi-select
/// `Set<String>` into a stable string key before watching this provider.
final subtitleWordsProvider = FutureProvider.autoDispose.family<List<SubtitleWord>, String>((
  ref,
  levelsKey,
) {
  final levels = levelsKey.isEmpty ? null : levelsKey.split(',');
  return ref
      .watch(subtitleWordsRepositoryProvider)
      .getWords(levels: levels, minSeen: kSubtitleWordsMinSeen, limit: kSubtitleWordsLimit);
});
