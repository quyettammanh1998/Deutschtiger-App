import '../../../data/flashcard/review_item.dart';
import '../../../data/practice/practice_round_item.dart';

/// Mini-game round type cycled through a daily-review playlist. Web
/// (`practice-session.tsx` `GAME_CONFIG`) dispatches 9 game types
/// (matching/artikel/wordSprint/listening/flashcard/fillBlank/typing/writing/
/// speaking); this app only has the 4 P4 practice-view round types
/// (matching/cloze/listening/writing) built as reusable `{items, onComplete}`
/// widgets, so the playlist cycles through those 4 instead of rebuilding the
/// other 5 mini-games (YAGNI — out of this pass's scope).
enum DailyReviewGameType { matching, cloze, listening, writing }

const kDailyReviewRoundOrder = [
  DailyReviewGameType.matching,
  DailyReviewGameType.cloze,
  DailyReviewGameType.listening,
  DailyReviewGameType.writing,
];

/// Web parity: web's `buildRounds()` groups matching into 6-pair batches;
/// re-used here as the uniform round size for every game type.
const kDailyReviewItemsPerRound = 6;

class DailyReviewRound {
  const DailyReviewRound({required this.gameType, required this.items});

  final DailyReviewGameType gameType;
  final List<ReviewItem> items;
}

/// Splits [items] into ~6-word rounds, cycling through the 4 implemented
/// game types in a fixed order — a scoped-down version of web's
/// `buildRounds()` (see [DailyReviewGameType] doc for what's out of scope).
List<DailyReviewRound> buildDailyReviewRounds(List<ReviewItem> items) {
  final rounds = <DailyReviewRound>[];
  for (var i = 0; i < items.length; i += kDailyReviewItemsPerRound) {
    final end = (i + kDailyReviewItemsPerRound).clamp(0, items.length);
    final gameType = kDailyReviewRoundOrder[(i ~/ kDailyReviewItemsPerRound) %
        kDailyReviewRoundOrder.length];
    rounds.add(
      DailyReviewRound(gameType: gameType, items: items.sublist(i, end)),
    );
  }
  return rounds;
}

/// Converts a queued SRS card into the source-agnostic round-item contract
/// (`PracticeRoundItem`) the 4 P4 practice views expect.
PracticeRoundItem roundItemFromReview(ReviewItem item) {
  final example = item.examples.isNotEmpty ? item.examples.first : null;
  final exampleDe = (example != null && example.de.isNotEmpty) ? example.de : null;
  final exampleVi = (example != null && example.vi.isNotEmpty) ? example.vi : null;
  return PracticeRoundItem(
    id: item.id,
    word: item.displayDe,
    translation: item.displayVi,
    example: exampleDe,
    exampleTranslation: exampleVi,
    audioUrl: item.displayAudioUrl,
  );
}

/// One German word the learner missed this session — feeds the "Từ cần ôn
/// lại" chip list + "Luyện lại N từ yếu" CTA on [DailyReviewDoneScreen].
class DailyReviewWeakWord {
  const DailyReviewWeakWord({required this.contentDe, required this.contentVi});

  final String contentDe;
  final String contentVi;
}

/// Session summary — web parity: `DailyReviewDoneProps`.
class DailyReviewResult {
  const DailyReviewResult({
    required this.totalCount,
    required this.correctCount,
    required this.xpEarned,
    required this.weakWords,
    this.hasMore = false,
  });

  const DailyReviewResult.empty()
    : totalCount = 0,
      correctCount = 0,
      xpEarned = 0,
      weakWords = const [],
      hasMore = false;

  final int totalCount;
  final int correctCount;
  final int xpEarned;
  final List<DailyReviewWeakWord> weakWords;

  /// True when the session filled the full batch limit — more due words
  /// likely remain (web: `sessionWasFull`).
  final bool hasMore;

  int get accuracy =>
      totalCount == 0 ? 0 : (correctCount / totalCount * 100).round();
}
