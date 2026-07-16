/// Canonical dispatch target for a mission round's `game_type`.
///
/// Mirrors web `lib/practice/game-type.ts` (`mapMissionGameType`), narrowed
/// to the two practice-view families the mission rotation actually emits
/// (`gameRotation` in the backend only cycles flashcard/recall/typing/
/// sentence — see `mission/game_selector.go`):
/// - `flashcard`/`recall` → recognition → [PracticeListeningView] (flip
///   card, self-graded recall).
/// - `typing`/`sentence`/`wortstellung` → production → [PracticeWritingView]
///   (type the German word/sentence).
enum MissionCanonicalGame { recognition, production }

MissionCanonicalGame canonicalMissionGame(String gameType) {
  switch (gameType) {
    case 'flashcard':
    case 'recall':
      return MissionCanonicalGame.recognition;
    case 'typing':
    case 'sentence':
    case 'wortstellung':
      return MissionCanonicalGame.production;
    default:
      // Unknown/future game_type: default to production (typing) — the
      // stricter of the two, never silently skips the round.
      return MissionCanonicalGame.production;
  }
}
