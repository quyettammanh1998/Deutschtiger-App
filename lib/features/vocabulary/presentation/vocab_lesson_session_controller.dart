import 'package:flutter/foundation.dart';

import '../../../repositories/games/word_writing_repository.dart';
import '../../../repositories/learn/learn_repository.dart';
import '../data/vocab_lesson_models.dart';
import '../data/vocab_lesson_repository.dart';
import '../data/vocab_lesson_utils.dart';

/// One-shot correct/wrong outcome for a "select the answer" style card.
class ChoiceOutcome {
  const ChoiceOutcome({required this.selected, required this.correct});
  final String selected;
  final bool correct;
}

/// Optional AI feedback shown after a submit (writing/compose).
class GradeFeedback {
  const GradeFeedback({this.hint, this.suggestion});
  final String? hint;
  final String? suggestion;
}

/// Owns the ephemeral per-card session state for [VocabularyLessonScreen]
/// (studying phase only — mode-select/loading/done/empty stay in the
/// widget). Mirrors the state block in web `vocabulary-lesson-page.tsx`.
///
/// Kept as a plain [ChangeNotifier] (not a Riverpod StateNotifier) — it is
/// 1:1 with a single screen instance and short-lived, matching the page's
/// own local `useState` design on web.
class VocabLessonSessionController extends ChangeNotifier {
  VocabLessonSessionController({
    required this.cards,
    required this.cardModes,
    required this.choiceOptions,
    required this._lessonRepository,
    required this.wordWritingRepository,
    required this.learnRepository,
    this.levelHint = '',
  });

  final List<LessonCard> cards;
  final Map<String, VocabCardMode> cardModes;
  final Map<String, List<String>> choiceOptions;
  final VocabLessonRepository _lessonRepository;
  final WordWritingRepository wordWritingRepository;
  final LearnRepository learnRepository;
  final String levelHint;

  int cardIndex = 0;
  int completedCount = 0;
  bool submitting = false;

  bool showBack = false;
  String writingInput = '';
  bool? writingCorrect;
  GradeFeedback? writingFeedback;
  bool writingChecking = false;
  ChoiceOutcome? choiceResult;
  String clozeInput = '';
  bool? clozeCorrect;
  String composeInput = '';
  bool? composeCorrect;
  GradeFeedback? composeFeedback;
  bool composeChecking = false;

  bool get isDone => cardIndex >= cards.length;
  LessonCard? get currentCard => isDone ? null : cards[cardIndex];
  VocabCardMode get currentMode {
    final card = currentCard;
    if (card == null) return VocabCardMode.flip;
    return cardModes[card.id] ?? VocabCardMode.flip;
  }

  bool get hasAnswer =>
      showBack ||
      writingCorrect != null ||
      choiceResult != null ||
      clozeCorrect != null ||
      composeCorrect != null;

  void _resetCardState() {
    showBack = false;
    writingInput = '';
    writingCorrect = null;
    writingFeedback = null;
    writingChecking = false;
    choiceResult = null;
    clozeInput = '';
    clozeCorrect = null;
    composeInput = '';
    composeCorrect = null;
    composeFeedback = null;
    composeChecking = false;
  }

  void toggleBack() {
    showBack = !showBack;
    notifyListeners();
  }

  void setWritingInput(String value) {
    writingInput = value;
    notifyListeners();
  }

  Future<void> submitWriting() async {
    final card = currentCard;
    if (card == null) return;
    final target = card.displayDe;
    final input = writingInput.trim();
    if (input.isEmpty) return;

    if (isWritingCorrect(input, target)) {
      writingCorrect = true;
      writingFeedback = GradeFeedback(suggestion: target);
      showBack = true;
      notifyListeners();
      return;
    }

    writingChecking = true;
    notifyListeners();
    try {
      final res = await wordWritingRepository.gradeWord(
        userInput: input,
        targetWord: target,
        targetVi: card.displayVi,
        level: card.level ?? levelHint,
      );
      writingCorrect = res.correct;
      writingFeedback = GradeFeedback(
        hint: res.hint,
        suggestion: res.suggestion.isNotEmpty ? res.suggestion : target,
      );
    } catch (_) {
      writingCorrect = false;
      writingFeedback = GradeFeedback(suggestion: target);
    } finally {
      writingChecking = false;
      showBack = true;
      notifyListeners();
    }
  }

  void selectChoice(String option) {
    final card = currentCard;
    if (card == null || choiceResult != null) return;
    choiceResult = ChoiceOutcome(
      selected: option,
      correct: card.displayVi == option,
    );
    showBack = true;
    notifyListeners();
  }

  void setClozeInput(String value) {
    clozeInput = value;
    notifyListeners();
  }

  void submitCloze() {
    final card = currentCard;
    if (card == null) return;
    final cloze = deriveCloze(card);
    if (cloze == null) return;
    final strippedTarget = cloze.answer
        .replaceFirst(RegExp(r'^(der |die |das )', caseSensitive: false), '')
        .trim();
    clozeCorrect =
        isWritingCorrect(clozeInput, cloze.answer) ||
        isWritingCorrect(clozeInput, strippedTarget);
    showBack = true;
    notifyListeners();
  }

  void setComposeInput(String value) {
    composeInput = value;
    notifyListeners();
  }

  Future<void> submitCompose() async {
    final card = currentCard;
    if (card == null) return;
    final target = card.displayDe;
    final targetVi = card.displayVi;
    final sentence = composeInput.trim();
    if (sentence.isEmpty || target.isEmpty) return;

    final root = target
        .replaceFirst(RegExp(r'^(der |die |das )', caseSensitive: false), '')
        .trim();
    final containsWord = RegExp(
      r'\b' + RegExp.escape(root) + r'\b',
      caseSensitive: false,
    ).hasMatch(sentence);
    if (!containsWord) {
      composeCorrect = false;
      composeFeedback = GradeFeedback(hint: 'Câu cần dùng từ "$target".');
      showBack = true;
      notifyListeners();
      return;
    }

    composeChecking = true;
    notifyListeners();
    try {
      final res = await learnRepository.gradeSentence(
        promptWord: target,
        promptMeaning: targetVi,
        userSentence: sentence,
        userLevel: (card.level ?? levelHint).isEmpty
            ? 'A1'
            : (card.level ?? levelHint).toUpperCase(),
        targetBlocks: const [],
      );
      composeCorrect = res.isCorrect;
      composeFeedback = GradeFeedback(
        hint: res.summaryVi,
        suggestion: res.correctedSentence,
      );
    } catch (_) {
      composeCorrect = true;
      composeFeedback = const GradeFeedback(
        hint: 'Không kết nối được AI để chấm chi tiết — bạn tự đánh giá nhé.',
      );
    } finally {
      composeChecking = false;
      showBack = true;
      notifyListeners();
    }
  }

  Future<void> rate(int rating) async {
    final card = currentCard;
    if (card == null || submitting) return;
    submitting = true;
    notifyListeners();
    try {
      await _lessonRepository.rate(
        card,
        rating,
        mode: 'vocab_lesson_${currentMode.name}',
      );
      completedCount += 1;
      cardIndex += 1;
      _resetCardState();
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  Future<void> markAlreadyKnown() async {
    final card = currentCard;
    if (card == null || submitting) return;
    submitting = true;
    notifyListeners();
    try {
      await _lessonRepository.rate(
        card,
        reviewRatingEasy,
        mode: 'vocab_lesson_skip',
      );
      completedCount += 1;
      cardIndex += 1;
      _resetCardState();
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}

/// FSRS "Easy" rating (4) — used by the "✓ Đã biết" skip action.
const int reviewRatingEasy = 4;
