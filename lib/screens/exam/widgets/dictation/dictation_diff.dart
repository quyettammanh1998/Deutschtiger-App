import 'dictation_cue.dart';

/// One aligned expected/typed token pair for [dictation_diff.diffSentence].
class WordDiff {
  const WordDiff({
    required this.expected,
    required this.expectedClean,
    this.userWord,
    required this.correct,
  });

  final String expected;
  final String expectedClean;
  final String? userWord;
  final bool correct;
}

/// Word-by-word positional diff between the learner's typed sentence and the
/// expected transcript sentence. Simplified vs. web's `sentence-diff.ts`
/// (positional pairing, not Levenshtein alignment) — good enough to color
/// correct/incorrect words for the result view; see phase report deviation.
List<WordDiff> diffSentence(String typed, String expected) {
  final expectedTokens = expected
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();
  final typedTokens = typed
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();

  return [
    for (var i = 0; i < expectedTokens.length; i++)
      () {
        final expectedToken = expectedTokens[i];
        final userToken = i < typedTokens.length ? typedTokens[i] : null;
        final correct =
            userToken != null &&
            foldGerman(userToken) == foldGerman(expectedToken);
        return WordDiff(
          expected: expectedToken,
          expectedClean: normaliseWord(expectedToken),
          userWord: correct ? null : userToken,
          correct: correct,
        );
      }(),
  ];
}

bool isAllCorrect(List<WordDiff> diff) => diff.every((d) => d.correct);
