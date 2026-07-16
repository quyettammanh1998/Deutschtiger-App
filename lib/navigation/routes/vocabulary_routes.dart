// Owner: P4 (vocabulary-practice) — web-mobile UI fidelity plan.
//
// Vocabulary hub + daily review / my-words / subtitle-words (all owned by the
// vocabulary-practice phase per its route table). Pure structural move out of
// `app_router.dart` — no behavior change.

import 'package:go_router/go_router.dart';

import '../../features/vocabulary/presentation/vocabulary_screen.dart';
import '../../features/vocabulary/presentation/vocabulary_lesson_screen.dart';
import '../../features/vocabulary/presentation/vocabulary_word_screen.dart';
import '../../features/vocabulary/presentation/vocabulary_detail_screen.dart';
import '../../features/my_words/presentation/my_words_screen.dart';
import '../../screens/daily_review/daily_review_screen.dart';
import '../../screens/vocab/subtitle_words_screen.dart';

final List<RouteBase> vocabularyRoutes = [
  GoRoute(
    path: '/vocabulary',
    builder: (context, state) => const VocabularyScreen(),
    routes: [
      GoRoute(
        path: 'lesson/:topicKey',
        builder: (context, state) => VocabularyLessonScreen(
          topicKey: state.pathParameters['topicKey']!,
          level: state.uri.queryParameters['level'],
        ),
      ),
      GoRoute(
        path: 'word/:itemId',
        builder: (context, state) => VocabularyWordRouteScreen(
          topicKey: state.uri.queryParameters['topicKey'] ?? '',
          itemId: state.pathParameters['itemId']!,
          level: state.uri.queryParameters['level'],
        ),
      ),
      GoRoute(
        path: 'detail/:topicKey',
        builder: (context, state) => VocabularyDetailScreen(
          topicKey: state.pathParameters['topicKey']!,
          itemId: state.uri.queryParameters['itemId'],
          level: state.uri.queryParameters['level'],
        ),
      ),
    ],
  ),
  GoRoute(
    path: '/daily-review',
    builder: (context, state) => const DailyReviewScreen(),
  ),
  GoRoute(path: '/my-words', builder: (context, state) => const MyWordsScreen()),
  GoRoute(
    path: '/subtitle-words',
    builder: (context, state) => const SubtitleWordsScreen(),
  ),
];
