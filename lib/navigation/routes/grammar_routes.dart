// Owner: P6 (grammar) — web-mobile UI fidelity plan.

import 'package:go_router/go_router.dart';

import '../../features/grammar/presentation/grammar_screen.dart';
import '../../features/grammar/presentation/grammar_lesson_detail_screen.dart';
import '../../features/grammar/presentation/grammar_article_screen.dart';

final List<RouteBase> grammarRoutes = [
  GoRoute(
    path: '/grammar',
    builder: (context, state) {
      final level = state.uri.queryParameters['level'];
      return GrammarScreen(initialLevel: level);
    },
    routes: [
      GoRoute(
        path: 'articles/:level/:slug',
        builder: (context, state) => GrammarArticleScreen(
          level: state.pathParameters['level']!,
          slug: state.pathParameters['slug']!,
        ),
      ),
      GoRoute(
        path: ':level/:id',
        builder: (context, state) => GrammarLessonDetailScreen(
          level: state.pathParameters['level']!,
          id: state.pathParameters['id']!,
        ),
      ),
    ],
  ),
];
