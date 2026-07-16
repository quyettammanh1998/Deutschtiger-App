// Owner: P5 (decks-flashcards) — web-mobile UI fidelity plan.

import 'package:go_router/go_router.dart';

import '../../screens/decks/card_form_screen.dart';
import '../../screens/decks/deck_detail_screen.dart';
import '../../screens/decks/deck_list_screen.dart';
import '../../screens/decks/folder_detail_screen.dart';
import '../../screens/decks/guided_lesson_screen.dart';
import '../../screens/decks/speak_to_notes_screen.dart';
import '../../screens/decks/starred_view_screen.dart';
import '../../screens/practice/practice_screen.dart';

/// Web-path-aligned routes (`/notes/*` — was `/decks/*`, see decision #4 /
/// `release_redirect.dart` for the old→new redirect). `/flashcard-review`
/// (Flutter-only, no web counterpart) is deleted per the plan — web's
/// flip-review runs inside deck-detail practice modes (now `.../lesson` +
/// `.../practice`).
final List<RouteBase> decksRoutes = [
  GoRoute(
    path: '/notes',
    builder: (context, state) => const DeckListScreen(),
    routes: [
      GoRoute(
        path: 'starred',
        builder: (context, state) => const StarredViewScreen(),
      ),
      GoRoute(
        path: 'speak',
        builder: (context, state) => const SpeakToNotesScreen(),
      ),
      GoRoute(
        path: 'folder/:folderId',
        builder: (context, state) => FolderDetailScreen(
          folderId: state.pathParameters['folderId']!,
        ),
      ),
      GoRoute(
        path: ':deckId',
        builder: (context, state) =>
            DeckDetailScreen(deckId: state.pathParameters['deckId']!),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) =>
                CardFormScreen(deckId: state.pathParameters['deckId']!),
          ),
          GoRoute(
            path: 'edit/:cardId',
            builder: (context, state) => CardFormScreen(
              deckId: state.pathParameters['deckId']!,
              cardId: state.pathParameters['cardId']!,
            ),
          ),
          GoRoute(
            path: 'lesson',
            builder: (context, state) =>
                GuidedLessonScreen(deckId: state.pathParameters['deckId']!),
          ),
          GoRoute(
            path: 'practice',
            builder: (context, state) =>
                PracticeScreen(deckId: state.pathParameters['deckId']!),
          ),
        ],
      ),
    ],
  ),
];
