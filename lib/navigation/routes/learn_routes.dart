// Owner: P3 (learn-journey) — web-mobile UI fidelity plan.
//
// Learn extensions (top-level) + the `/learn` shell-branch tree (branch 2 of
// the StatefulShellRoute in `app_router.dart`). `learnShellRoutes` needs
// `parentNavigatorKey: rootNavigatorKey` for its fullscreen sub-routes, same
// as before the split.

import 'package:go_router/go_router.dart';

import '../../features/mission/presentation/mission_session_page.dart';
import '../../screens/journey/journey_screen.dart';
import '../../screens/learn/can_do_practice_screen.dart';
import '../../screens/learn/focus_session_screen.dart';
import '../../screens/learn/learner_model_screen.dart';
import '../../screens/learn/topic_explore_screen.dart';
import '../router_keys.dart';

/// Learn extensions (mirrors web `/learner-model`, `/focus-session`).
final List<RouteBase> learnRoutes = [
  GoRoute(
    path: '/learner-model',
    builder: (context, state) => const LearnerModelScreen(),
  ),
  GoRoute(
    path: '/focus-session',
    builder: (context, state) => const FocusSessionScreen(),
  ),
];

/// Shell branch 2 ("Học") routes — B2 Learn Hub với phiên hôm nay từ backend.
final List<RouteBase> learnShellRoutes = [
  GoRoute(
    path: '/learn',
    builder: (context, state) => const JourneyScreen(),
    routes: [
      // Learn extensions (mirrors web `/learn/topics`,
      // `/learn/can-do/:id/practice`, `/learn/session/:id`) — mount as root
      // navigator routes vì cần fullscreen (không nằm trong shell tab bar).
      GoRoute(
        path: 'topics',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const TopicExploreScreen(),
      ),
      GoRoute(
        path: 'can-do/:canDoId/practice',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CanDoPracticeScreen(
          canDoId: Uri.decodeComponent(state.pathParameters['canDoId']!),
        ),
      ),
      // Mission session runner — mirrors web `/learn/session/:id` (":id" is
      // usually the pseudo-id "today"; the runner always resolves today's
      // mission regardless of the path value).
      GoRoute(
        path: 'session/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MissionSessionPage(),
      ),
    ],
  ),
];
