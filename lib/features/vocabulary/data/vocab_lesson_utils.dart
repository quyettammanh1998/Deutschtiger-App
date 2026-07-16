/// Pure helpers for the vocabulary lesson session — port of web
/// `src/lib/vocabulary/vocab-lesson-utils.ts`. No I/O, no widget deps.
library;

import 'dart:math';

import 'vocab_lesson_models.dart';

/// FSRS rating sent to `POST /user/srs/review` — 1..4 (Again/Hard/Good/Easy).
typedef FsrsRating = int;

/// Practice mode for one card in a lesson session.
///
/// [writing] is DEPRECATED like on web (typed-back-the-same-word had low
/// pedagogical value) — [distributeVocabCardModes] never assigns it to a
/// fresh batch, but the renderer/enum value is kept for completeness and
/// forward-compat with any earlier-saved progress.
enum VocabCardMode { flip, reverse, writing, listen, choice, cloze, compose }

/// Lesson intensity tier — picked before the session starts.
enum VocabLessonMode { quick, standard, intensive }

class VocabLessonModeConfig {
  const VocabLessonModeConfig({
    required this.newCount,
    required this.dueCount,
    required this.pool,
    required this.emoji,
    required this.label,
    required this.desc,
    required this.time,
    required this.skills,
  });

  final int newCount;
  final int dueCount;
  final List<VocabCardMode> pool;
  final String emoji;
  final String label;
  final String desc;
  final String time;
  final String skills;
}

const Map<VocabLessonMode, VocabLessonModeConfig> vocabLessonModeConfig = {
  VocabLessonMode.quick: VocabLessonModeConfig(
    newCount: 4,
    dueCount: 1,
    pool: [VocabCardMode.listen, VocabCardMode.choice, VocabCardMode.flip],
    emoji: '⚡',
    label: 'Nhanh',
    time: '~5 phút',
    desc: 'Nghe + chọn nghĩa — 5 thẻ',
    skills: 'Nghe, chọn nghĩa, lật thẻ',
  ),
  VocabLessonMode.standard: VocabLessonModeConfig(
    newCount: 8,
    dueCount: 4,
    pool: [
      VocabCardMode.flip,
      VocabCardMode.listen,
      VocabCardMode.cloze,
      VocabCardMode.choice,
      VocabCardMode.compose,
    ],
    emoji: '📚',
    label: 'Đầy đủ',
    time: '~10 phút',
    desc: 'Đủ 4 kỹ năng + viết câu — 12 thẻ',
    skills: 'Đọc, nghe, điền từ, viết câu',
  ),
  VocabLessonMode.intensive: VocabLessonModeConfig(
    newCount: 14,
    dueCount: 6,
    pool: [
      VocabCardMode.flip,
      VocabCardMode.reverse,
      VocabCardMode.listen,
      VocabCardMode.cloze,
      VocabCardMode.choice,
      VocabCardMode.compose,
    ],
    emoji: '🏆',
    label: 'Chuyên sâu',
    time: '~20 phút',
    desc: 'Tất cả kỹ năng + đảo chiều — 20 thẻ',
    skills: 'Đủ kỹ năng, có đảo chiều',
  ),
};

/// Modes where the German word is already visible (or listening IS the
/// goal) — auto-playing audio on card change can't spoil the answer.
const autoplayVocabCardModes = {
  VocabCardMode.flip,
  VocabCardMode.listen,
  VocabCardMode.choice,
  VocabCardMode.compose,
};

String _stripGermanArticle(String text) => text
    .replaceFirst(
      RegExp(r'^(der |die |das |ein |eine |einen |einem |einer )', caseSensitive: false),
      '',
    )
    .trim();

RegExp? _targetTokenRegExp(String target) {
  final root = _stripGermanArticle(target);
  if (root.isEmpty) return null;
  final escaped = RegExp.escape(root);
  return RegExp(r'(^|[^\p{L}\p{N}_])(' + escaped + r')(?=$|[^\p{L}\p{N}_])', caseSensitive: false, unicode: true);
}

bool exampleContainsTarget(String sentence, String target) {
  final re = _targetTokenRegExp(target);
  return re != null && re.hasMatch(sentence);
}

LessonExample? pickExampleForTarget(List<LessonExample> examples, String target) {
  final usable = examples.where((e) => e.de.isNotEmpty).toList();
  if (usable.isEmpty) return null;
  for (final ex in usable) {
    if (exampleContainsTarget(ex.de, target)) return ex;
  }
  return usable.first;
}

class ClozeDerivation {
  const ClozeDerivation({required this.prompt, required this.answer, required this.vi});
  final String prompt;
  final String answer;
  final String vi;
}

ClozeDerivation? deriveClozeFromExamples(List<LessonExample> examples, String target) {
  final re = _targetTokenRegExp(target);
  if (target.trim().isEmpty || re == null) return null;
  for (final ex in examples) {
    if (ex.cloze != null && ex.cloze!.contains('_')) {
      return ClozeDerivation(prompt: ex.cloze!, answer: target, vi: ex.vi ?? '');
    }
    if (ex.de.isNotEmpty && re.hasMatch(ex.de)) {
      final match = re.firstMatch(ex.de)!;
      final matchPrefix = match.group(1) ?? '';
      final prompt = ex.de.replaceRange(match.start, match.end, '${matchPrefix}___');
      return ClozeDerivation(prompt: prompt, answer: target, vi: ex.vi ?? '');
    }
  }
  return null;
}

ClozeDerivation? deriveCloze(LessonCard card) =>
    deriveClozeFromExamples(card.examples, card.displayDe.trim());

class ComposeReference {
  const ComposeReference({required this.de, required this.vi});
  final String de;
  final String vi;
}

ComposeReference? pickComposeReference(LessonCard card) {
  final target = card.displayDe.trim();
  final example = pickExampleForTarget(card.examples, target);
  if (example == null || example.de.isEmpty) return null;
  return ComposeReference(de: example.de, vi: example.vi ?? '');
}

String normalizeForWriting(String input) =>
    input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

bool isWritingCorrect(String userInput, String target) =>
    normalizeForWriting(userInput) == normalizeForWriting(target);

/// Distribute card modes deterministically across a batch, round-robin from
/// the chosen tier's [pool] — guarantees every configured skill appears at
/// least once (subject to per-card eligibility below).
Map<String, VocabCardMode> distributeVocabCardModes(
  List<LessonCard> cards,
  List<VocabCardMode> pool, {
  bool? batchHasChoice,
}) {
  final result = <String, VocabCardMode>{};
  final canChoose = batchHasChoice ?? cards.length >= 4;
  var cursor = 0;

  bool accepts(LessonCard card, VocabCardMode mode) {
    switch (mode) {
      case VocabCardMode.listen:
        return card.displayAudioUrl.isNotEmpty;
      case VocabCardMode.choice:
        return canChoose;
      case VocabCardMode.cloze:
        return deriveCloze(card) != null;
      case VocabCardMode.compose:
        return card.examples.isNotEmpty;
      case VocabCardMode.flip:
      case VocabCardMode.reverse:
      case VocabCardMode.writing:
        return true;
    }
  }

  for (final card in cards) {
    if (card.id.isEmpty) continue;
    var chosen = VocabCardMode.flip;
    for (var i = 0; i < pool.length; i++) {
      final candidate = pool[(cursor + i) % pool.length];
      if (accepts(card, candidate)) {
        chosen = candidate;
        cursor = (cursor + i + 1) % pool.length;
        break;
      }
    }
    result[card.id] = chosen;
  }
  return result;
}

/// Pre-computes 4 VI choice options (1 correct + 3 shuffled distractors)
/// per card, for [VocabCardMode.choice] rendering.
Map<String, List<String>> buildChoiceOptions(List<LessonCard> cards, {int? seed}) {
  final result = <String, List<String>>{};
  if (cards.length < 4) return result;
  final random = Random(seed);
  final allVi = cards.map((c) => c.displayVi).where((v) => v.isNotEmpty).toList();

  for (final card in cards) {
    final correct = card.displayVi;
    if (card.id.isEmpty || correct.isEmpty) continue;
    final pool = allVi.where((v) => v != correct).toList();
    final distractors = <String>[];
    final used = <String>{};
    while (distractors.length < 3 && pool.length > used.length) {
      final candidate = pool[random.nextInt(pool.length)];
      if (used.add(candidate)) distractors.add(candidate);
    }
    final options = [correct, ...distractors];
    options.shuffle(random);
    result[card.id] = options;
  }
  return result;
}
