import '../../../../data/exam/exam_ecosystem_models.dart';

/// One selectable-word cue for the cloze activity — the sentence the word
/// sits in, plus the word's own timing. Mirrors web `DictationCue` in
/// `exam-dictation-practice.tsx`.
class DictationCue {
  const DictationCue({
    required this.word,
    required this.clean,
    required this.start,
    required this.end,
    required this.audioIndex,
    required this.sentenceText,
    required this.sentenceTextVi,
    required this.sentenceStart,
    required this.sentenceEnd,
    required this.occurrenceRank,
  });

  final String word;
  final String clean;
  final double start;
  final double end;
  final int audioIndex;
  final String sentenceText;
  final String sentenceTextVi;
  final double sentenceStart;
  final double sentenceEnd;

  /// 0-based rank among same-clean words in the sentence, for repeated-word
  /// gaps (which occurrence to blank).
  final int occurrenceRank;
}

/// Strip punctuation and lowercase — answer-comparison base form.
String normaliseWord(String s) =>
    s.toLowerCase().trim().replaceAll(RegExp('''[.,!?;:'"„“»«]+'''), '');

/// Fold German umlaut alternates so "ue/oe/ae/ss" matches "ü/ö/ä/ß".
String foldGerman(String s) {
  final n = normaliseWord(s);
  return n
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss');
}

/// Letter count of a word (ignoring non-letter chars).
int letterCount(String word) => word.runes
    .map(String.fromCharCode)
    .where((c) => RegExp(r'\p{L}', unicode: true).hasMatch(c))
    .length;

/// Build the ordered cue list for every [selectedWords] occurrence across
/// [audios], sorted by audio index then start time.
List<DictationCue> buildDictationCues(
  List<ExamDictationAudio> audios,
  Set<String> selectedWords,
) {
  final result = <DictationCue>[];
  for (var ai = 0; ai < audios.length; ai++) {
    for (final sentence in audios[ai].sentences) {
      for (var wi = 0; wi < sentence.words.length; wi++) {
        final wt = sentence.words[wi];
        if (!selectedWords.contains(wt.clean)) continue;
        final occurrenceRank = sentence.words
            .take(wi)
            .where((w) => w.clean == wt.clean)
            .length;
        result.add(
          DictationCue(
            word: wt.word,
            clean: wt.clean,
            start: wt.start,
            end: wt.end,
            audioIndex: ai,
            sentenceText: sentence.text,
            sentenceTextVi: sentence.textVi,
            sentenceStart: sentence.start,
            sentenceEnd: sentence.end,
            occurrenceRank: occurrenceRank,
          ),
        );
      }
    }
  }
  result.sort((a, b) {
    final byAudio = a.audioIndex.compareTo(b.audioIndex);
    return byAudio != 0 ? byAudio : a.start.compareTo(b.start);
  });
  return result;
}
