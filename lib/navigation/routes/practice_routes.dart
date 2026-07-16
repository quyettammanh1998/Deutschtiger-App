// Owner: P4 (vocabulary-practice) — web-mobile UI fidelity plan.
//
// The 4 "practice-view" mini-games under `/games/*` that P4 rebuilds as
// dedicated practice-view components (web `practice-cloze-page`,
// `practice-listening-page`, `practice-matching-page`, `practice-writing-page`
// — see phase-04 route table "Router ownership" note). Everything else under
// `/games/*` belongs to `games_routes.dart` (P7).
//
// Renamed per phase-04 web-path alignment (redirects registered in
// `release_redirect.dart`):
//   /games/fill-blank → /games/cloze      (practice-cloze-page)
//   /games/flashcard  → /games/flashcards (practice-listening-page)
//   /games/matching   → /games/matching   (unchanged, practice-matching-page)
//   /games/writing    → /games/writing    (unchanged, practice-writing-page)
// The legacy game screens these routes used to point at
// (fill_blank/flashcard/matching/writing_word) are deleted, replaced by the
// practice views above. `/games/writing-sentence` had no web counterpart and
// is gone entirely — no redirect.

import 'package:go_router/go_router.dart';

import '../../screens/practice/practice_cloze_route_screen.dart';
import '../../screens/practice/practice_listening_route_screen.dart';
import '../../screens/practice/practice_matching_route_screen.dart';
import '../../screens/practice/practice_writing_route_screen.dart';

final List<RouteBase> practiceRoutes = [
  GoRoute(
    path: '/games/cloze',
    builder: (context, state) => const PracticeClozeRouteScreen(),
  ),
  GoRoute(
    path: '/games/flashcards',
    builder: (context, state) => const PracticeListeningRouteScreen(),
  ),
  GoRoute(
    path: '/games/matching',
    builder: (context, state) => const PracticeMatchingRouteScreen(),
  ),
  GoRoute(
    path: '/games/writing',
    builder: (context, state) => const PracticeWritingRouteScreen(),
  ),
];
