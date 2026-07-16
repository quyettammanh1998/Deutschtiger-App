import 'package:deutschtiger/features/writing/domain/sprint/sr_keyword_match.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extractKeywords drops stopwords and picks longest content words', () {
    final keywords = extractKeywords('Ich bin gestern ins Kino gegangen und war traurig');
    expect(keywords, isNotEmpty);
    expect(keywords.any((k) => k.contains('gegangen') || k.contains('traurig')), isTrue);
  });

  test('extractKeywords falls back when too few content words extracted', () {
    final keywords = extractKeywords('Ich bin', fallback: ['fallback1', 'fallback2']);
    expect(keywords, containsAll(['fallback1', 'fallback2']));
  });

  test('checkKeywordMatch matches exact substrings', () {
    final result = checkKeywordMatch('Ich bin gestern ins Kino gegangen', ['kino', 'gegangen']);
    expect(result.matched, 2);
  });

  test('checkKeywordMatch fuzzy-matches near-typos via Levenshtein', () {
    final result = checkKeywordMatch('Ich bin gestren ins Kiono gegngen', ['gestern', 'kino']);
    expect(result.matched, greaterThanOrEqualTo(1));
  });

  test('matchBullet passes when >=2/3 keywords found', () {
    final ok = matchBullet(
      'Letztes Wochenende war ich mit meiner Familie an einem See',
      'Letztes Wochenende war ich mit meiner Familie an einem See.',
      const [],
    );
    expect(ok, isTrue);
  });

  test('matchBullet fails on unrelated input', () {
    final ok = matchBullet('Ich mag Pizza', 'Letztes Wochenende war ich mit meiner Familie an einem See.', const []);
    expect(ok, isFalse);
  });

  test('levenshtein distance is symmetric and zero for identical strings', () {
    expect(levenshtein('kino', 'kino'), 0);
    expect(levenshtein('kino', 'kiono'), levenshtein('kiono', 'kino'));
  });

  test('normalizeGerman folds umlauts and eszett', () {
    expect(normalizeGerman('Müde Straße'), 'muede strasse');
  });
}
