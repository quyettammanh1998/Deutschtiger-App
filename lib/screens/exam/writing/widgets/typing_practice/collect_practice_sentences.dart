import '../../../../../features/writing/domain/goethe_b1_writing_topic.dart';

/// Flattened list of German sentences worth typing-practicing — simplified
/// web parity `collect-practice-sentences.ts` `flattenGroups`. Web collects
/// task/task-analysis/text-structure/phrases/samples/model/grammar/
/// wortschatz groups; this wave collects task + sample sentences + model
/// answers (split into sentences) — the highest-value subset for a first
/// typing-practice pass. Documented deviation: grammar/wortschatz/phrase
/// sentences are not included yet.
List<String> collectWritingPracticeSentences(GoetheB1WritingTopic topic) {
  final sentences = <String>[];
  final task = topic.task;
  if (task != null && task.de.trim().isNotEmpty) sentences.add(task.de.trim());
  for (final group in topic.sampleSentences) {
    for (final s in group.sentences) {
      if (s.de.trim().isNotEmpty) sentences.add(s.de.trim());
    }
  }
  for (final model in topic.modelAnswers) {
    for (final sentence in model.de.split(RegExp(r'(?<=[.!?])\s+'))) {
      final trimmed = sentence.trim();
      if (trimmed.length >= 3) sentences.add(trimmed);
    }
  }
  return sentences.toSet().toList(growable: false);
}
