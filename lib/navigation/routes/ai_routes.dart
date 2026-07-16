// Owner: P12 (social-stats-settings-cleanup) — web-mobile UI fidelity plan.

import 'package:go_router/go_router.dart';

import '../../screens/ai/ai_chat_page.dart';
import '../../screens/ai/ai_writing_practice_page.dart';
import '../../screens/ai/ai_settings_page.dart';

final List<RouteBase> aiRoutes = [
  GoRoute(
    path: '/ai-tutor',
    // Canonical Tiger AI chat surface is `screens/ai/` (unified with the
    // former `screens/ai_tutor/` mock duplicate — see phase-01 plan).
    // `/ai-tutor` and its `chat`/`chat-new` sub-routes all resolve to the
    // same live streaming chat page to preserve existing deep links
    // (home/settings/more-sheet still push these paths).
    builder: (context, state) => const AIChatPage(),
    routes: [
      GoRoute(path: 'chat', builder: (context, state) => const AIChatPage()),
      GoRoute(
        path: 'chat-new',
        builder: (context, state) => const AIChatPage(),
      ),
      GoRoute(
        path: 'writing',
        builder: (context, state) => const AIWritingPracticePage(),
      ),
      GoRoute(
        path: 'settings',
        builder: (context, state) => const AISettingsPage(),
      ),
    ],
  ),
];

/// Shell branch 3 ("AI") routes.
final List<RouteBase> aiShellRoutes = [
  GoRoute(path: '/ai', builder: (context, state) => const AIChatPage()),
];
