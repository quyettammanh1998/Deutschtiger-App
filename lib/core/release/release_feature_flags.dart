/// Compile-time release gates for route families without a verified production
/// data contract. A feature remains available to local QA only when its
/// matching `--dart-define` is explicitly enabled.
abstract final class ReleaseFeatureFlags {
  static const grammar = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_GRAMMAR',
    defaultValue: true,
  );
  static const listening = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_LISTENING',
    defaultValue: true,
  );
  static const aiTutor = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_AI_TUTOR',
    defaultValue: true,
  );
  static const games = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_GAMES',
    defaultValue: false,
  );

  /// Sentence Builder is the only `/games` route backed by a live contract
  /// (`/sentence-builder/*` + reused `/ai/grade-sentence`) — gated
  /// independently of the blanket `games` flag so it stays reachable while
  /// the other 17 game screens remain mock/local-only. See
  /// `docs/flutter-live-data-inventory.md` for the per-game status table.
  static const sentenceBuilder = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_SENTENCE_BUILDER',
    defaultValue: true,
  );

  /// Word Sprint — live vocab source (`GET /vocabulary/learned`, reused
  /// [VocabularyRepository]). Gated independently of the blanket `games`
  /// flag like `sentenceBuilder`. See `docs/flutter-live-data-inventory.md`.
  static const wordSprint = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_WORD_SPRINT',
    defaultValue: true,
  );

  /// Typing Sprint — live sentence source (`GET /user/typing/sentences` +
  /// `POST /user/typing/results`, backend-computed XP). Gated independently
  /// of the blanket `games` flag like `sentenceBuilder`.
  static const typingSprint = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_TYPING_SPRINT',
    defaultValue: true,
  );

  /// Cases Mastery Hub (4 sub-games: Akkusativ/Dativ, Adjektivendungen,
  /// Wechselpräpositionen, Verb-Case matching) — live contract
  /// `GET /user/cases/{akk-dat,adjektiv,wechselprep,verb-case}` +
  /// `POST /user/grammar-drill/results`. Gated independently of the blanket
  /// `games` flag like `sentenceBuilder`.
  static const casesMastery = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_CASES_MASTERY',
    defaultValue: true,
  );

  /// Konjugationstrainer — live contract `GET /user/conjugation/exercise` +
  /// `POST /user/grammar-drill/results` (personalized when the user has
  /// enough learned verbs). Gated independently of the blanket `games` flag.
  static const konjugation = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_KONJUGATION',
    defaultValue: true,
  );

  /// Flashcard game — live contract `GET /user/srs/queue` +
  /// `POST /user/srs/review` (tái dùng `ReviewRepository`/
  /// `reviewSessionProvider`, giống màn "Ôn từ"). Gated độc lập.
  static const flashcardGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_FLASHCARD_GAME',
    defaultValue: true,
  );

  /// Writing Word game — live `GET /vocabulary/learned` +
  /// `POST /ai/grade-word-writing` (tái dùng, đã live). Gated độc lập.
  static const writingWordGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_WRITING_WORD_GAME',
    defaultValue: true,
  );

  /// Writing Sentence game — live `GET /vocabulary/learned` +
  /// `POST /ai/grade-sentence` (tái dùng `LearnRepository.gradeSentence`).
  /// Gated độc lập.
  static const writingSentenceGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_WRITING_SENTENCE_GAME',
    defaultValue: true,
  );

  /// Listening game — live `GET /vocabulary/learned` + audio qua
  /// `AudioService` (server TTS cache `/user/tts/vocab-cache`). Gated độc
  /// lập với `listening` (đó là bài học nghe, khác route `/games/listening`).
  static const listeningGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_LISTENING_GAME',
    defaultValue: true,
  );

  /// Deutsch Runner — live `GET /vocabulary/learned` (tái dùng
  /// `VocabularyRepository`). Gated độc lập.
  static const runnerGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_RUNNER_GAME',
    defaultValue: true,
  );

  /// Der/Die/Das (Artikel) — live `GET /user/learning-items/balanced?type=
  /// word` (corpus thật, lọc danh từ có `gender`). Gated độc lập.
  static const articleGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_ARTICLE_GAME',
    defaultValue: true,
  );

  /// Wortstellung — live `GET /user/learning-items/balanced?type=sentence`.
  /// Gated độc lập.
  static const wordOrderGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_WORD_ORDER_GAME',
    defaultValue: true,
  );

  /// Điền từ (Fill-blank) — live `GET /user/learning-items/balanced?type=
  /// word`, cloze dựng từ `examples` đính kèm mỗi item (không có endpoint
  /// riêng — web dùng cùng nguồn trong mini-game bài học từ vựng). Gated độc
  /// lập.
  static const fillBlankGame = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_FILL_BLANK_GAME',
    defaultValue: true,
  );
  /// Moments feed (read+like), friends (list/request/accept/reject/block),
  /// public profile, messages (poll-based DM) and announcements are live —
  /// see `docs/flutter-live-data-inventory.md`. Groups/Challenges/Duels
  /// remain gated individually below regardless of this flag.
  static const social = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_SOCIAL',
    defaultValue: true,
  );

  /// Study groups — no wired backend contract and no live web UI either
  /// (see `docs/api-changelog.md`).
  static const socialGroups = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_SOCIAL_GROUPS',
    defaultValue: false,
  );

  /// Challenges — hidden on web too; mock-only in the app.
  static const socialChallenges = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_SOCIAL_CHALLENGES',
    defaultValue: false,
  );

  /// Duels — realtime PvP deferred to GĐ2 P3 (WebRTC/realtime POC owner).
  static const socialDuels = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_SOCIAL_DUELS',
    defaultValue: false,
  );
  static const stats = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_STATS',
    defaultValue: true,
  );
  static const achievements = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_ACHIEVEMENTS',
    defaultValue: false,
  );
  static const journey = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_JOURNEY',
    defaultValue: true,
  );
  static const reading = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_READING',
    defaultValue: true,
  );
  static const news = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_NEWS',
    defaultValue: true,
  );
  static const speaking = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_SPEAKING',
    defaultValue: false,
  );
  static const pronunciation = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_PRONUNCIATION',
    defaultValue: false,
  );
  static const affiliate = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_AFFILIATE',
    defaultValue: false,
  );
  static const premium = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_PREMIUM',
    defaultValue: false,
  );
  static const legacyGoetheB1 = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_LEGACY_GOETHE_B1',
    defaultValue: false,
  );

  /// Deck-scoped practice runner (cloze/listening/matching/writing) + subtitle
  /// words list — both reuse verified live sources (deck/flashcard repos,
  /// `/subtitle-words`), so this stays live by default like grammar/reading.
  static const practice = bool.fromEnvironment(
    'DEUTSCHTIGER_ENABLE_PRACTICE',
    defaultValue: true,
  );

  /// Only governs More-sheet discovery. Direct routes stay registered so local
  /// QA and deep-link contract work can exercise them while they are gated.
  static bool allowsMoreFeature(String path) => switch (path) {
    '/grammar' => grammar,
    '/listening' => listening,
    '/ai-tutor/writing' || '/ai-tutor/chat' => aiTutor,
    '/games' => games,
    '/social' => social,
    '/stats' => stats,
    '/achievements' => achievements,
    '/subtitle-words' => practice,
    '/news' => news,
    _ => true,
  };
}
