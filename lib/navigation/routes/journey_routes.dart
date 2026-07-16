// Owner: P3 (learn-journey) — web-mobile UI fidelity plan.
//
// Top-level `/journey` (DW course catalog) + the mission session runner
// entry point. The `/learn` shell-branch tree (also P3) lives in
// `learn_routes.dart` since it is nested inside the StatefulShellRoute.

import 'package:go_router/go_router.dart';

import '../../features/mission/presentation/mission_session_page.dart';
import '../../screens/journey/journey_screen.dart';
import '../../screens/journey/courses_hub_screen.dart';
import '../../screens/journey/course_detail_screen.dart';
import '../../screens/journey/course_lesson_screen.dart';

final List<RouteBase> journeyRoutes = [
  GoRoute(
    // B3 — mission session runner (mirrors web `/learn/session/:id`).
    path: '/journey/session',
    builder: (context, state) => const MissionSessionPage(),
  ),
  GoRoute(
    path: '/journey',
    builder: (context, state) => const JourneyScreen(),
    routes: [
      GoRoute(
        path: 'courses',
        builder: (context, state) => const CoursesHubScreen(),
      ),
      GoRoute(
        path: 'courses/:slug',
        builder: (context, state) =>
            CourseDetailScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: 'courses/:slug/lessons/:num',
        builder: (context, state) => CourseLessonScreen(
          slug: state.pathParameters['slug']!,
          lessonNumber: int.tryParse(state.pathParameters['num'] ?? '') ?? 1,
        ),
      ),
    ],
  ),
];
