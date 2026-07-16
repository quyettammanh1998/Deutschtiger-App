import 'dart:math';

/// Number of bundled quote photos, `assets/images/quotes/quote-01.webp` …
/// `quote-20.webp` (declared in pubspec by Phase 1).
const int quoteImageCount = 20;

/// Assigns a bundled photo to each of [count] quotes so that no two
/// adjacent quotes share the same image. Cycles through a shuffled image
/// list, re-shuffling (and swapping the boundary duplicate away) once
/// exhausted — mirrors web `assignImages` in `daily-quote-page.tsx`.
List<String> assignQuoteImages(int count, {Random? random}) {
  final rng = random ?? Random();
  final images = <String>[];
  var pool = <int>[];
  var lastUsed = -1;

  for (var i = 0; i < count; i++) {
    if (pool.isEmpty) {
      pool = List<int>.generate(quoteImageCount, (k) => k + 1)..shuffle(rng);
      if (pool.first == lastUsed && pool.length > 1) {
        final tmp = pool.first;
        pool[0] = pool.last;
        pool[pool.length - 1] = tmp;
      }
    }
    final idx = pool.removeAt(0);
    lastUsed = idx;
    images.add(
      'assets/images/quotes/quote-${idx.toString().padLeft(2, '0')}.webp',
    );
  }
  return images;
}
