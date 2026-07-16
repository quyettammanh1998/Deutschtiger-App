import '../decks/deck_models.dart';
import '../games/learning_item_models.dart';

/// One flashcard-shaped unit fed into a practice view (cloze/listening/
/// matching/writing). This is the "round type" contract shared by every
/// caller of the 4 practice views: deck practice ([PracticeRoundItem.fromDeckWord]),
/// the standalone `/games/{cloze,flashcards,matching,writing}` routes
/// ([PracticeRoundItem.fromLearningItem]), the mission runner (P3), and the
/// guided-lesson deck flow (P5). Keeping this model source-agnostic is what
/// makes the 4 views reusable across those callers instead of each view
/// depending on a single repository's model.
class PracticeRoundItem {
  const PracticeRoundItem({
    required this.id,
    required this.word,
    required this.translation,
    this.example,
    this.exampleTranslation,
    this.audioUrl,
  });

  /// Stable id — used as `PracticeResultEntry.cardId` so SRS sync keeps
  /// working regardless of the item's origin.
  final String id;

  /// German target term/sentence the learner must produce or recognize.
  final String word;

  /// Vietnamese meaning.
  final String translation;

  /// German example sentence containing [word] (cloze/writing prompts).
  final String? example;

  final String? exampleTranslation;

  /// Pre-recorded TTS URL, when the source already has one (falls back to
  /// on-device/server TTS by [word] otherwise — see `AudioService`).
  final String? audioUrl;

  factory PracticeRoundItem.fromDeckWord(DeckWord word) => PracticeRoundItem(
    id: word.id,
    word: word.word,
    translation: word.translation,
    example: word.example,
  );

  factory PracticeRoundItem.fromLearningItem(LearningItem item) {
    final example = item.examples.isNotEmpty ? item.examples.first : null;
    return PracticeRoundItem(
      id: item.id,
      word: item.contentDe,
      translation: item.contentVi ?? '',
      example: example?.de,
      exampleTranslation: example?.vi,
    );
  }
}
