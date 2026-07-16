// Owner: P7 (games) — web-mobile UI fidelity plan.
//
// All `/games/*` routes EXCEPT the 4 practice-view routes owned by P4
// (`/games/fill-blank`, `/games/flashcard`, `/games/matching`,
// `/games/writing` — see `practice_routes.dart`).

import 'package:go_router/go_router.dart';

import '../../screens/games/article_game_screen.dart';
import '../../screens/games/cases/case_cloze_quiz_screen.dart';
import '../../screens/games/cases/cases_mastery_hub_screen.dart';
import '../../screens/games/cases/verb_case_quiz_screen.dart';
import '../../screens/games/conversation_game_screen.dart';
import '../../screens/games/konjugation_game_screen.dart';
import '../../screens/games/listening_game_screen.dart';
import '../../screens/games/pronunciation_game_screen.dart';
import '../../screens/games/runner_game_screen.dart';
import '../../screens/games/sentence_builder/sentence_builder_play_screen.dart';
import '../../screens/games/sentence_builder/sentence_builder_topics_screen.dart';
import '../../screens/games/speaking_game_screen.dart';
import '../../screens/games/typing_sprint_game_screen.dart';
import '../../screens/games/word_order_game_screen.dart';
import '../../screens/games/word_sprint_game_screen.dart';
import '../../screens/games/writing_sentence_game_screen.dart';
import '../../screens/games/game_hub_screen.dart';

final List<RouteBase> gamesRoutes = [
  GoRoute(path: '/games', builder: (context, state) => const GameHubScreen()),
  GoRoute(
    path: '/games/article',
    builder: (context, state) => const ArticleGameScreen(),
  ),
  GoRoute(
    path: '/games/word-sprint',
    builder: (context, state) => const WordSprintGameScreen(),
  ),
  GoRoute(
    path: '/games/listening',
    builder: (context, state) => const ListeningGameScreen(),
  ),
  GoRoute(
    path: '/games/runner',
    builder: (context, state) => const RunnerGameScreen(),
  ),
  GoRoute(
    path: '/games/typing-sprint',
    builder: (context, state) => const TypingSprintGameScreen(),
  ),
  GoRoute(
    path: '/games/word-order',
    builder: (context, state) => const WordOrderGameScreen(),
  ),
  GoRoute(
    path: '/games/writing-sentence',
    builder: (context, state) => const WritingSentenceGameScreen(),
  ),
  GoRoute(
    path: '/games/speaking',
    builder: (context, state) => const SpeakingGameScreen(),
  ),
  GoRoute(
    path: '/games/cases',
    builder: (context, state) => const CasesMasteryHubScreen(),
  ),
  GoRoute(
    path: '/games/cases/akk-dat',
    builder: (context, state) =>
        const CaseClozeQuizScreen(game: 'akk-dat', title: 'Akkusativ vs Dativ'),
  ),
  GoRoute(
    path: '/games/cases/adjektiv',
    builder: (context, state) => const CaseClozeQuizScreen(
      game: 'adjektiv',
      title: 'Adjektivendungen',
    ),
  ),
  GoRoute(
    path: '/games/cases/wechselprep',
    builder: (context, state) => const CaseClozeQuizScreen(
      game: 'wechselprep',
      title: 'Wechselpräpositionen',
    ),
  ),
  GoRoute(
    path: '/games/cases/verb-case',
    builder: (context, state) => const VerbCaseQuizScreen(),
  ),
  GoRoute(
    path: '/games/konjugation',
    builder: (context, state) => const KonjugationGameScreen(),
  ),
  GoRoute(
    path: '/games/pronunciation',
    builder: (context, state) => const PronunciationGameScreen(),
  ),
  GoRoute(
    path: '/games/conversation',
    builder: (context, state) => const ConversationGameScreen(),
  ),
  GoRoute(
    path: '/games/sentence-builder',
    builder: (context, state) => const SentenceBuilderTopicsScreen(),
  ),
  GoRoute(
    path: '/games/sentence-builder/play',
    builder: (context, state) => SentenceBuilderPlayScreen(
      level: state.uri.queryParameters['level'] ?? 'A1',
      topicId: state.uri.queryParameters['topicId'],
    ),
  ),
];
