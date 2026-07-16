import 'dart:math';

/// One TTS-only quiz round: either [item]'s primary word or its minimal-pair
/// counterpart was played; [playedTarget] tells the caller which.
class TtsQuizRound<T> {
  const TtsQuizRound({required this.item, required this.playedTarget});
  final T item;

  /// `true` when the item's own word was played this round, `false` when
  /// its minimal-pair counterpart was played.
  final bool playedTarget;
}

/// Builds a fixed-length quiz round list from a trainer item pool — web
/// parity: `buildRounds()` in `umlaute-trainer-page.tsx` /
/// `ich-ach-laut-page.tsx`. Prefers items that actually have a minimal-pair
/// counterpart; falls back to the full pool if none do.
List<TtsQuizRound<T>> buildTtsQuizRounds<T>(
  List<T> items, {
  required String Function(T item) minimalPairOf,
  int count = 10,
}) {
  final eligible = items
      .where((it) => minimalPairOf(it).trim().isNotEmpty)
      .toList(growable: false);
  final pool = eligible.isNotEmpty ? eligible : items;
  if (pool.isEmpty) return const [];
  final random = Random();
  return List.generate(count, (i) {
    final item = pool[i % pool.length];
    return TtsQuizRound<T>(item: item, playedTarget: random.nextBool());
  }, growable: false);
}
