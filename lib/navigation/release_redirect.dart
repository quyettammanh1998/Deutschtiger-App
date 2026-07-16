import '../core/release/release_feature_flags.dart';

/// Prevents a deep link from bypassing a release gate. The redirect is applied
/// only after authentication redirect has allowed the route.
String? resolveReleaseRedirect(String path) {
  // P12 wave B route-sweep QA — web's home is `/` (`ROUTE_PATHS.home`);
  // Flutter's is `/home` (`initialLocation`). No route is registered for
  // bare `/`, so without this it 404s.
  if (path == '/') return '/home';
  // Web `/privacy`/`/dieu-khoan` vs Flutter's `/privacy-policy`/
  // `/terms-of-service` (pre-existing naming divergence, unrelated to this
  // wave — fixed here as part of the route-sweep QA pass).
  if (path == '/privacy') return '/privacy-policy';
  if (path == '/dieu-khoan') return '/terms-of-service';
  // Web `ROUTE_PATHS.errorPatterns = '/stats/errors'` vs Flutter's
  // `/stats/error-patterns` child route.
  if (path == '/stats/errors') return '/stats/error-patterns';
  // Web `ROUTE_PATHS.settingsLearning = '/settings/learning'` vs Flutter's
  // `/settings/learning-preferences` child route.
  if (path == '/settings/learning') return '/settings/learning-preferences';
  // Web `ROUTE_PATHS.aiChat = '/ai-chat'` vs Flutter's `/ai` route.
  if (path == '/ai-chat') return '/ai';
  // Web `ROUTE_PATHS.premium = '/premium'` (top-level) vs Flutter's
  // `/settings/premium` child route.
  if (path == '/premium') return '/settings/premium';
  // Web itself internally redirects `learnCapabilityMap` → `learnerModel`
  // (`routes.tsx`: `<Navigate to={ROUTE_PATHS.learnerModel} replace />`) —
  // mirrored here since Flutter only registers `/learner-model`.
  if (path == '/learn/capability-map') return '/learner-model';
  // Web's exam landing is `/exams` (plural, `ROUTE_PATHS.exams`); Flutter's
  // is `/exam` (singular). Only the bare landing path is safe to redirect
  // here — the rest of the `/exams/*` tree (provider-level, writing,
  // sprechen, dictation, sprint…) does not map 1:1 onto Flutter's `/exam/*`
  // segment shapes and needs a case-by-case audit, not a blind prefix swap
  // (see the wave-B report's route-sweep section).
  if (path == '/exams') return '/exam';
  // Dead Flutter-only landing/full-welcome screens have been removed (web
  // parity — the single `/welcome` route now ports the full marketing page).
  if (_matches(path, '/landing') || _matches(path, '/welcome-full')) {
    return '/welcome';
  }
  // Mission session runner moved to web-parity path `/learn/session/:id`
  // (web-mobile UI fidelity P3) — the pseudo-id "today" always resolves to
  // today's mission regardless of the deep-link value.
  if (path == '/journey/session') return '/learn/session/today';

  if (_matches(path, '/grammar') && !ReleaseFeatureFlags.grammar) {
    return '/learn';
  }
  if (_matches(path, '/listening') && !ReleaseFeatureFlags.listening) {
    return '/learn';
  }
  // P11 W1 — old Flutter-only podcast URL collided with the web-identical
  // `/listening/easy-german/:level` (video collection) route; podcast moved
  // to `/listening/podcast/easy_german` (matches web exactly).
  if (path == '/listening/easy-german') {
    return '/listening/podcast/easy_german';
  }
  const oldPodcastEpisodePrefix = '/listening/easy-german/episode/';
  if (path.startsWith(oldPodcastEpisodePrefix)) {
    return '/listening/podcast/easy_german/${path.substring(oldPodcastEpisodePrefix.length)}';
  }
  if (_matches(path, '/reading') && !ReleaseFeatureFlags.reading) {
    return '/learn';
  }
  if (_matches(path, '/news') && !ReleaseFeatureFlags.news) {
    return '/learn';
  }
  // P11 W4 — old Flutter-only `/reading/feed` renamed to web-identical
  // `/reading-feed` (top-level, matches `ROUTE_PATHS.readingFeed`); old
  // `/reading/detail?extra=` renamed to web-identical `/reading/:level/:slug`
  // (no redirect needed — that path only ever carried a Dart `extra` object,
  // never a public/bookmarkable URL). New `/doc-nghe` hub gated the same way.
  if (path == '/reading/feed') return '/reading-feed';
  if (_matches(path, '/reading-feed') && !ReleaseFeatureFlags.reading) {
    return '/learn';
  }
  if (_matches(path, '/doc-nghe') && !ReleaseFeatureFlags.reading) {
    return '/learn';
  }
  if (_matches(path, '/journey') && !ReleaseFeatureFlags.journey) {
    return '/learn';
  }
  // P11 W3 — course hub/detail/lesson moved from `/journey/courses*` to the
  // web-identical top-level `/course/*` (`course_routes.dart`).
  const oldCoursesPrefix = '/journey/courses';
  if (path == oldCoursesPrefix || path.startsWith('$oldCoursesPrefix/')) {
    return '/course${path.substring(oldCoursesPrefix.length)}';
  }
  if (_matches(path, '/speaking') && !ReleaseFeatureFlags.speaking) {
    return '/learn';
  }
  if (_matches(path, '/pronunciation') && !ReleaseFeatureFlags.pronunciation) {
    return '/learn';
  }
  // Sentence Builder has a live backend contract — exempt it from the
  // blanket `/games` gate (which still hides the other mock game screens).
  if (_matches(path, '/games/sentence-builder')) {
    return ReleaseFeatureFlags.sentenceBuilder ? null : '/learn';
  }
  // Word Sprint (`/vocabulary/learned`) and Typing Sprint
  // (`/user/typing/sentences` + `/user/typing/results`) also have live
  // backend contracts — same exemption pattern.
  if (_matches(path, '/games/word-sprint')) {
    return ReleaseFeatureFlags.wordSprint ? null : '/learn';
  }
  if (_matches(path, '/games/typing-sprint')) {
    return ReleaseFeatureFlags.typingSprint ? null : '/learn';
  }
  // Old Flutter-only cases sub-routes (`/games/cases/*`) redirect to the
  // web-identical hyphenated paths (`/games/cases-*`).
  if (_matches(path, '/games/cases/akk-dat')) return '/games/cases-akk-dat';
  if (_matches(path, '/games/cases/adjektiv')) return '/games/cases-adjektiv';
  if (_matches(path, '/games/cases/wechselprep')) {
    return '/games/cases-wechselprep';
  }
  if (_matches(path, '/games/cases/verb-case')) return '/games/cases-verb-case';
  if (path == '/games/cases') return '/games/cases-mastery';
  // Cases Mastery Hub (`/user/cases/*`) and Konjugationstrainer
  // (`/user/conjugation/exercise`) also have live backend contracts — same
  // exemption pattern.
  if (_matches(path, '/games/cases-mastery') ||
      _matches(path, '/games/cases-akk-dat') ||
      _matches(path, '/games/cases-adjektiv') ||
      _matches(path, '/games/cases-wechselprep') ||
      _matches(path, '/games/cases-verb-case')) {
    return ReleaseFeatureFlags.casesMastery ? null : '/learn';
  }
  if (_matches(path, '/games/konjugation')) {
    return ReleaseFeatureFlags.konjugation ? null : '/learn';
  }
  // P4 practice-view routes (web `practice-cloze/listening/matching/writing
  // -page.tsx`) — old paths (legacy game screens, now deleted) redirect to
  // the renamed web-parity paths; live paths gated by the shared `practice`
  // flag (deck-scoped runner + these standalone routes reuse the same live
  // sources, see `ReleaseFeatureFlags.practice` doc comment).
  if (_matches(path, '/games/fill-blank')) return '/games/cloze';
  if (_matches(path, '/games/flashcard')) return '/games/flashcards';
  if (_matches(path, '/games/cloze') ||
      _matches(path, '/games/flashcards') ||
      _matches(path, '/games/matching') ||
      _matches(path, '/games/writing')) {
    return ReleaseFeatureFlags.practice ? null : '/learn';
  }
  if (_matches(path, '/games/listening')) {
    return ReleaseFeatureFlags.listeningGame ? null : '/learn';
  }
  if (_matches(path, '/games/runner')) {
    return ReleaseFeatureFlags.runnerGame ? null : '/learn';
  }
  // Web-path-aligned renames (web-mobile UI fidelity P7): old Flutter-only
  // paths redirect to the web-identical ones below.
  if (_matches(path, '/games/article')) return '/games/artikel';
  if (_matches(path, '/games/word-order')) return '/games/wortstellung';
  // Artikel/Wortstellung/Fill-blank also have a live backend contract
  // (`/user/learning-items/balanced`) — same per-game exemption pattern.
  if (_matches(path, '/games/artikel')) {
    return ReleaseFeatureFlags.articleGame ? null : '/learn';
  }
  if (_matches(path, '/games/wortstellung')) {
    return ReleaseFeatureFlags.wordOrderGame ? null : '/learn';
  }
  if (_matches(path, '/games') && !ReleaseFeatureFlags.games) {
    return '/learn';
  }
  // `/conversation` (web-parity Hội thoại tab, P10 conversation hub) is only
  // registered as a shell-branch route while `speaking` is on (see
  // `app_router.dart`'s tab-4 release switch). Deep links hitting it while
  // the flag is off would otherwise 404 — redirect to the AI tab that
  // occupies that slot instead, same fallback as `/speaking` below.
  if (_matches(path, '/conversation') && !ReleaseFeatureFlags.speaking) {
    return '/ai';
  }
  // Goethe/TELC Sprechen exam UI (P10) reuses the `speaking` flag — same
  // "not yet backed by verified AI-chat/grading live wiring" gate as
  // `/conversation` above, since both depend on MASTER P8's voice/AI
  // grading hookup before shipping to production.
  if (path.startsWith('/exams/goethe/') &&
      path.contains('/sprechen') &&
      !ReleaseFeatureFlags.speaking) {
    return '/exam';
  }
  if ((_matches(path, '/exams/telc-b1/noi') ||
          _matches(path, '/exams/telc/b1/noi')) &&
      !ReleaseFeatureFlags.speaking) {
    return '/exam';
  }
  if (_matches(path, '/ai') && !ReleaseFeatureFlags.aiTutor) return '/learn';
  if (_matches(path, '/ai-tutor') && !ReleaseFeatureFlags.aiTutor) {
    return '/learn';
  }
  // P12 wave B — `social_screen.dart` (bare `/social` hub) deleted, web has
  // no hub page either: every deep link that used to land on it now goes
  // straight to the closest live surface, Friends.
  if (path == '/social') return '/social/friends';
  // `moments_page.dart` deleted (web has no moments feed) — bookmarked deep
  // links fall back to Friends instead of 404ing.
  if (_matches(path, '/social/moments')) return '/social/friends';
  // `announcements_page.dart` deleted — its content now surfaces inline as
  // `AnnouncementBanner` on the dashboard.
  if (_matches(path, '/social/announcements')) return '/home';
  // Groups (`groups_page.dart`/`group_detail_page.dart`) were deleted
  // entirely in the P12 wave-B sweep — web never had a groups feature (see
  // `docs/api-changelog.md` gap entry) — so these always redirect,
  // independent of any flag. Checked ahead of the blanket `social` gate
  // below, same "specific exemption before blanket" pattern as `/games/*`.
  if (_matches(path, '/social/groups') || _matches(path, '/social/group')) {
    return '/social/friends';
  }
  // Challenges/Duels stay gated independently of the blanket `social` flag —
  // no wired backend contract (challenges) or realtime/moderation POC
  // (duels) yet. See `docs/flutter-live-data-inventory.md`.
  if (_matches(path, '/social/challenges') &&
      !ReleaseFeatureFlags.socialChallenges) {
    return '/social/friends';
  }
  if (_matches(path, '/social/duel') && !ReleaseFeatureFlags.socialDuels) {
    return '/social/friends';
  }
  if (_matches(path, '/social') && !ReleaseFeatureFlags.social) return '/home';
  // P12 wave B — route-sweep QA gap fix: web's canonical social paths are
  // top-level (`ROUTE_PATHS.friends = '/friends'`, `.messages = '/messages'`,
  // `.challenges = '/challenges'`, `ROUTE_PATTERNS.chat = '/messages/:id'`,
  // `.profile = '/profile/:userId'`, `.duelLobby = '/duel/:roomId'`,
  // `.duelPlay = '/duel/:roomId/play'`) but Flutter kept every social screen
  // under a `/social/*` prefix (P12 wave A decision, unchanged here — a full
  // rename is out of this task's scope, see the wave-B report). These
  // redirects make the web-canonical paths reachable so deep links copied
  // from web (or typed from memory) land correctly instead of 404ing.
  if (path == '/friends' || path.startsWith('/friends/')) {
    return '/social/friends';
  }
  if (path == '/challenges' || path.startsWith('/challenges/')) {
    return '/social/challenges';
  }
  if (path == '/messages') return '/social/messages';
  const messagesChatPrefix = '/messages/';
  if (path.startsWith(messagesChatPrefix)) {
    return '/social/chat/${path.substring(messagesChatPrefix.length)}';
  }
  // `/duel/:roomId[/play]` has no Flutter equivalent that carries a roomId in
  // the URL (the lobby resolves its own room, play takes the opponent via
  // `extra`) — best-effort fallback to the lobby; the roomId segment is
  // dropped (documented gap, not a broken 404).
  if (path == '/duel' || path.startsWith('/duel/')) {
    return '/social/duel/lobby';
  }
  // P12 wave A — `EditProfileScreen` (`/profile/edit`) removed; profile
  // editing folded into the settings-root profile-edit card (P12 settings
  // agent). `/profile` itself keeps rendering the own-profile view (no
  // redirect needed — same path, new content: web `/u/:id` equivalent).
  if (path == '/profile/edit') return '/settings';
  // Web's `/profile/:userId` (other-user public profile) — Flutter keeps it
  // under `/social/profile/:userId`. `/profile/edit` is already handled and
  // returned above, so anything reaching here is a real userId segment.
  const profilePrefix = '/profile/';
  if (path.startsWith(profilePrefix)) {
    return '/social/profile/${path.substring(profilePrefix.length)}';
  }
  if (_matches(path, '/stats') && !ReleaseFeatureFlags.stats) return '/home';
  // P12 wave B — `achievements_screen.dart` deleted; its grid now lives
  // inside Stats (`stats_achievements_grid.dart`). Web has no standalone
  // achievements route either, so this redirect is unconditional (not
  // flag-gated) — there is no screen left to gate.
  if (_matches(path, '/achievements')) return '/stats';
  if (_matches(path, '/affiliate') && !ReleaseFeatureFlags.affiliate) {
    return '/home';
  }
  if (_matches(path, '/settings/premium') && !ReleaseFeatureFlags.premium) {
    return '/settings';
  }
  if (_matches(path, '/exam/goethe-b1') &&
      !ReleaseFeatureFlags.legacyGoetheB1) {
    return '/exam';
  }
  if (_matches(path, '/subtitle-words') && !ReleaseFeatureFlags.practice) {
    return '/vocabulary';
  }
  // P4b — old `/vocabulary/detail/{topicKey}` route (single-word-view screen,
  // rebuilt as the web-parity topic word-list at `/vocabulary/topic-{key}`).
  const oldDetailPrefix = '/vocabulary/detail/';
  if (path.startsWith(oldDetailPrefix)) {
    return '/vocabulary/topic-${path.substring(oldDetailPrefix.length)}';
  }
  // P5 — deck/flashcard suite renamed to web-identical `/notes/*` (decision
  // #4). `/flashcard-review` had no web counterpart (deleted; web's
  // flip-review runs inside deck-detail practice modes) so bare deep links
  // land on the deck list instead of a query param it can no longer resolve.
  const oldDecksPrefix = '/decks';
  if (path == oldDecksPrefix || path.startsWith('$oldDecksPrefix/')) {
    return '/notes${path.substring(oldDecksPrefix.length)}';
  }
  if (path == '/flashcard-review') return '/notes';
  return null;
}

bool _matches(String path, String root) =>
    path == root || path.startsWith('$root/');
