// Owner: P11 W3 (media web-mobile UI fidelity) — course hub/detail/lesson.
//
// Top-level `/course/*` — web parity path (was nested under `/journey/
// courses` before this rebuild; old links redirect via
// `release_redirect.dart`). `/course/interview` is a sibling literal path
// registered by `media_routes.dart` (P11 W2) — no collision with a real DW
// course slug expected.

import 'package:go_router/go_router.dart';

import '../../screens/journey/course_detail_screen.dart';
import '../../screens/journey/course_lesson_screen.dart';
import '../../screens/journey/courses_hub_screen.dart';

final List<RouteBase> courseRoutes = [
  GoRoute(path: '/course', builder: (context, state) => const CoursesHubScreen()),
  GoRoute(
    path: '/course/:slug',
    builder: (context, state) => CourseDetailScreen(slug: state.pathParameters['slug']!),
  ),
  GoRoute(
    path: '/course/:slug/lessons/:num',
    builder: (context, state) => CourseLessonScreen(
      slug: state.pathParameters['slug']!,
      lessonNumber: int.tryParse(state.pathParameters['num'] ?? '') ?? 1,
    ),
  ),
];
