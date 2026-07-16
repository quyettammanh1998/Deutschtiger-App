// Owner: P4 (vocabulary-practice) — web-mobile UI fidelity plan.
//
// The 4 "practice-view" mini-games under `/games/*` that P4 rebuilds as
// dedicated practice-view components (web `practice-cloze-page`,
// `practice-listening-page`, `practice-matching-page`, `practice-writing-page`
// — see phase-04 route table "Router ownership" note). Everything else under
// `/games/*` belongs to `games_routes.dart` (P7).
//
// Current path → target web practice-view mapping (per phase-04 doc):
//   /games/fill-blank → practice-cloze-page (route becomes `/games/cloze`)
//   /games/flashcard  → practice-listening-page (route becomes `/games/flashcards`)
//   /games/matching   → practice-matching-page
//   /games/writing    → practice-writing-page
// Renames/redirects are P4's responsibility; this phase-01 split only moves
// route ownership, it does not rename paths (pure refactor).

import 'package:go_router/go_router.dart';

import '../../screens/games/fill_blank_game_screen.dart';
import '../../screens/games/flashcard_game_screen.dart';
import '../../screens/games/matching_game_screen.dart';
import '../../screens/games/writing_word_game_screen.dart';

final List<RouteBase> practiceRoutes = [
  GoRoute(
    path: '/games/matching',
    builder: (context, state) => const MatchingGameScreen(),
  ),
  GoRoute(
    path: '/games/fill-blank',
    builder: (context, state) => const FillBlankGameScreen(),
  ),
  GoRoute(
    path: '/games/flashcard',
    builder: (context, state) => const FlashcardGameScreen(),
  ),
  GoRoute(
    path: '/games/writing',
    builder: (context, state) => const WritingWordGameScreen(),
  ),
];
