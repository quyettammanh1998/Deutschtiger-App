import '../../../../data/exam/exam_ecosystem_models.dart';

/// One clip that has at least one sentence with a real time range —
/// mirrors web `TimedClip` in `exam-dictation-full-practice.tsx`.
class TimedClip {
  const TimedClip({
    required this.audioIndex,
    required this.label,
    required this.sentences,
  });

  final int audioIndex;
  final String label;
  final List<ExamDictationSentence> sentences;
}

/// Collect all sentences with `start < end`, grouped per audio — untimed
/// clips (no synced transcript) are skipped entirely, same as web.
List<TimedClip> buildTimedClips(List<ExamDictationAudio> audios) {
  final result = <TimedClip>[];
  for (var i = 0; i < audios.length; i++) {
    final sentences = audios[i].sentences
        .where((s) => s.start < s.end)
        .toList();
    if (sentences.isNotEmpty) {
      result.add(
        TimedClip(audioIndex: i, label: 'Teil ${i + 1}', sentences: sentences),
      );
    }
  }
  return result;
}
