// Owner: P5 (decks-flashcards) — web-mobile UI fidelity plan.

import 'package:go_router/go_router.dart';

import '../../screens/decks/deck_list_screen.dart';
import '../../screens/decks/deck_detail_screen.dart';
import '../../screens/practice/practice_screen.dart';
import '../../screens/flashcard/flashcard_review_screen.dart';

final List<RouteBase> decksRoutes = [
  GoRoute(
    path: '/decks',
    builder: (context, state) => const DeckListScreen(),
    routes: [
      GoRoute(
        path: ':deckId',
        builder: (context, state) =>
            DeckDetailScreen(deckId: state.pathParameters['deckId']!),
        routes: [
          GoRoute(
            path: 'practice',
            builder: (context, state) =>
                PracticeScreen(deckId: state.pathParameters['deckId']!),
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: '/flashcard-review',
    builder: (context, state) =>
        FlashcardReviewScreen(deckId: state.uri.queryParameters['deckId']),
  ),
];
