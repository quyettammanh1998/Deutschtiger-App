/// German keyword extraction + fuzzy matching for the SR card's
/// type-then-check flow — web parity `keyword-extractor.ts` +
/// `keyword-matcher.ts`. Pure functions, no IO.
const Set<String> _deStopwords = {
  'der', 'die', 'das', 'den', 'dem', 'des', 'ein', 'eine', 'einen', 'einem', 'einer', 'eines',
  'ich', 'du', 'er', 'sie', 'es', 'wir', 'ihr', 'mich', 'mir', 'dich', 'dir', 'ihn', 'ihm', 'sich',
  'mein', 'dein', 'sein', 'unser', 'euer', 'ihre', 'ihren', 'meine', 'deine', 'seine',
  'bin', 'bist', 'ist', 'sind', 'seid', 'war', 'waren', 'gewesen',
  'habe', 'hast', 'hat', 'haben', 'habt', 'hatte', 'hatten', 'gehabt',
  'werde', 'wirst', 'wird', 'werden', 'werdet', 'wurde', 'wurden', 'geworden',
  'kann', 'kannst', 'können', 'könnt', 'könnte', 'konnten',
  'muss', 'musst', 'müssen', 'müsst', 'musste', 'mussten',
  'will', 'willst', 'wollen', 'wollt', 'wollte', 'wollten',
  'soll', 'sollst', 'sollen', 'sollt', 'sollte', 'sollten',
  'mag', 'magst', 'mögen', 'mögt', 'möchte', 'möchten',
  'darf', 'darfst', 'dürfen', 'dürft', 'durfte', 'durften',
  'und', 'oder', 'aber', 'denn', 'sondern', 'weil', 'dass', 'wenn', 'als', 'ob', 'damit',
  'mit', 'von', 'zu', 'für', 'an', 'in', 'auf', 'unter', 'über', 'vor', 'nach', 'bei', 'aus',
  'durch', 'um', 'gegen', 'ohne', 'bis', 'seit', 'während',
  'nicht', 'kein', 'keine', 'keinen', 'keinem', 'keiner',
  'auch', 'noch', 'nur', 'schon', 'sehr', 'ganz', 'mal', 'doch', 'ja', 'nein',
  'so', 'mehr', 'weniger', 'viel', 'viele', 'vielen', 'vieles',
  'alle', 'alles', 'allen', 'aller', 'einige', 'einigen', 'einiger',
  'hier', 'dort', 'da', 'wo', 'wohin', 'woher', 'wann', 'wie', 'was', 'wer', 'warum',
  'jetzt', 'heute', 'morgen', 'gestern', 'immer', 'oft', 'manchmal', 'nie',
  'dann', 'also', 'eben', 'halt', 'wohl',
  'liebe', 'lieber', 'hallo', 'hi', 'guten', 'tag',
};

final _punctRe = RegExp(r'''[.,;:!?¡¿"'()\[\]{}<>«»„“”‘’…—–-]''');

List<String> tokenize(String text) {
  return text
      .toLowerCase()
      .replaceAll(_punctRe, ' ')
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
}

/// Extract up to [count] content keywords from a DE sentence (longest
/// non-stop-word tokens, proxy for nouns/verbs). Falls back to [fallback]
/// keywords if too few extracted.
List<String> extractKeywords(String text, {int count = 3, List<String> fallback = const []}) {
  if (text.isEmpty) return fallback.take(count).toList();
  final content = tokenize(text).where((t) => t.length >= 4 && !_deStopwords.contains(t));
  final seen = <String>{};
  final uniq = <String>[];
  for (final w in content) {
    if (seen.add(w)) uniq.add(w);
  }
  uniq.sort((a, b) => b.length.compareTo(a.length));
  final picked = uniq.take(count).toList();
  if (picked.length >= 2) return picked;
  final out = [...picked];
  for (final f in fallback) {
    if (out.length >= count) break;
    final lower = f.toLowerCase();
    if (!out.contains(lower)) out.add(lower);
  }
  return out;
}

String normalizeGerman(String s) {
  return s
      .toLowerCase()
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

int levenshtein(String a, String b) {
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final dp = List.generate(a.length + 1, (_) => List<int>.filled(b.length + 1, 0));
  for (var i = 0; i <= a.length; i++) {
    dp[i][0] = i;
  }
  for (var j = 0; j <= b.length; j++) {
    dp[0][j] = j;
  }
  for (var i = 1; i <= a.length; i++) {
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      dp[i][j] = [dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost].reduce((x, y) => x < y ? x : y);
    }
  }
  return dp[a.length][b.length];
}

class KeywordMatchResult {
  const KeywordMatchResult({required this.matched, required this.total});
  final int matched;
  final int total;
}

KeywordMatchResult checkKeywordMatch(String userInput, List<String> expectedKeywords, {int threshold = 2}) {
  final normInput = normalizeGerman(userInput);
  final inputWords = normInput.split(' ');
  var matched = 0;
  for (final kw in expectedKeywords) {
    final normKw = normalizeGerman(kw);
    if (normInput.contains(normKw)) {
      matched++;
      continue;
    }
    if (inputWords.any((w) => levenshtein(w, normKw) <= threshold)) matched++;
  }
  return KeywordMatchResult(matched: matched, total: expectedKeywords.length);
}

/// Run keyword match for one bullet against the expected outline sentence —
/// ≥2/3 keywords → correct. Web parity `sr-card.tsx#matchBullet`.
bool matchBullet(String userInput, String outlineDe, List<String> fallbackKeywords) {
  final expected = extractKeywords(outlineDe, count: 3, fallback: fallbackKeywords);
  final result = checkKeywordMatch(userInput, expected);
  return result.matched >= 2;
}
