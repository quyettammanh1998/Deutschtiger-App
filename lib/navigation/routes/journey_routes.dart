// Owner: P3 (learn-journey) — web-mobile UI fidelity plan.
//
// Top-level `/journey` (DW course catalog entry point). The mission session
// runner lives at `/learn/session/:id` (`learn_routes.dart`, web parity) —
// old `/journey/session` links redirect there via `release_redirect.dart`.
// The `/learn` shell-branch tree (also P3) lives in `learn_routes.dart`
// since it is nested inside the StatefulShellRoute.
//
// Course hub/detail/lesson moved OUT of this file to top-level `/course/*`
// (web parity — see `course_routes.dart`, owned by P11 W3); old
// `/journey/courses*` deep links redirect there via `release_redirect.dart`.

import 'package:go_router/go_router.dart';

import '../../screens/journey/journey_screen.dart';

final List<RouteBase> journeyRoutes = [
  GoRoute(
    path: '/journey',
    builder: (context, state) => const JourneyScreen(),
  ),
];
