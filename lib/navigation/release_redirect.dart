import '../core/release/release_feature_flags.dart';

/// Prevents a deep link from bypassing a release gate. The redirect is applied
/// only after authentication redirect has allowed the route.
String? resolveReleaseRedirect(String path) {
  if (_matches(path, '/landing') || _matches(path, '/welcome-full')) {
    return '/home';
  }
  if (path == '/journey/session') return null;

  if (_matches(path, '/grammar') && !ReleaseFeatureFlags.grammar) {
    return '/learn';
  }
  if (_matches(path, '/listening') && !ReleaseFeatureFlags.listening) {
    return '/learn';
  }
  if (_matches(path, '/reading') && !ReleaseFeatureFlags.reading) {
    return '/learn';
  }
  if (_matches(path, '/news') && !ReleaseFeatureFlags.news) {
    return '/learn';
  }
  if (_matches(path, '/journey') && !ReleaseFeatureFlags.journey) {
    return '/learn';
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
  // Cases Mastery Hub (`/user/cases/*`) and Konjugationstrainer
  // (`/user/conjugation/exercise`) also have live backend contracts — same
  // exemption pattern.
  if (_matches(path, '/games/cases')) {
    return ReleaseFeatureFlags.casesMastery ? null : '/learn';
  }
  if (_matches(path, '/games/konjugation')) {
    return ReleaseFeatureFlags.konjugation ? null : '/learn';
  }
  // Flashcard/Writing-word/Writing-sentence/Listening/Runner games also have
  // live backend contracts (see `docs/flutter-live-data-inventory.md`) — same
  // per-game exemption pattern.
  if (_matches(path, '/games/flashcard')) {
    return ReleaseFeatureFlags.flashcardGame ? null : '/learn';
  }
  if (_matches(path, '/games/writing-sentence')) {
    return ReleaseFeatureFlags.writingSentenceGame ? null : '/learn';
  }
  if (_matches(path, '/games/writing')) {
    return ReleaseFeatureFlags.writingWordGame ? null : '/learn';
  }
  if (_matches(path, '/games/listening')) {
    return ReleaseFeatureFlags.listeningGame ? null : '/learn';
  }
  if (_matches(path, '/games/runner')) {
    return ReleaseFeatureFlags.runnerGame ? null : '/learn';
  }
  // Artikel/Wortstellung/Fill-blank also have a live backend contract
  // (`/user/learning-items/balanced`) — same per-game exemption pattern.
  if (_matches(path, '/games/article')) {
    return ReleaseFeatureFlags.articleGame ? null : '/learn';
  }
  if (_matches(path, '/games/word-order')) {
    return ReleaseFeatureFlags.wordOrderGame ? null : '/learn';
  }
  if (_matches(path, '/games/fill-blank')) {
    return ReleaseFeatureFlags.fillBlankGame ? null : '/learn';
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
  if (_matches(path, '/ai') && !ReleaseFeatureFlags.aiTutor) return '/learn';
  if (_matches(path, '/ai-tutor') && !ReleaseFeatureFlags.aiTutor) {
    return '/learn';
  }
  if (_matches(path, '/social') && !ReleaseFeatureFlags.social) return '/home';
  // Groups/Challenges/Duels stay gated independently of the blanket `social`
  // flag — no wired backend contract (groups/challenges) or realtime/
  // moderation POC (duels) yet. See `docs/flutter-live-data-inventory.md`.
  if (_matches(path, '/social/groups') && !ReleaseFeatureFlags.socialGroups) {
    return '/social';
  }
  if (_matches(path, '/social/group') && !ReleaseFeatureFlags.socialGroups) {
    return '/social';
  }
  if (_matches(path, '/social/challenges') &&
      !ReleaseFeatureFlags.socialChallenges) {
    return '/social';
  }
  if (_matches(path, '/social/duel') && !ReleaseFeatureFlags.socialDuels) {
    return '/social';
  }
  if (_matches(path, '/stats') && !ReleaseFeatureFlags.stats) return '/home';
  if (_matches(path, '/achievements') && !ReleaseFeatureFlags.achievements) {
    return '/home';
  }
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
  return null;
}

bool _matches(String path, String root) =>
    path == root || path.startsWith('$root/');
