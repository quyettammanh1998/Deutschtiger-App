// Owner: P10 (speech-conversation-pronunciation) — web-mobile UI fidelity plan.

import 'package:go_router/go_router.dart';

import '../../screens/pronunciation/pronunciation_screen.dart';
import '../../screens/speaking/speaking_screen.dart';
import '../../screens/speaking/speaking_hub_screen.dart';
import '../../screens/speaking/shadowing_page.dart';
import '../../screens/speaking/umlaute_trainer_page.dart';
import '../../screens/speaking/r_sound_trainer_page.dart';
import '../../screens/speaking/ich_ach_trainer_page.dart';
import '../../screens/speaking/sp_st_trainer_page.dart';
import '../../screens/speaking/conversation_hub_page.dart';
import '../../screens/speaking/conversation_scenario_page.dart';

final List<RouteBase> speechRoutes = [
  GoRoute(
    path: '/pronunciation',
    builder: (context, state) => const PronunciationScreen(),
  ),
  GoRoute(
    path: '/speaking',
    builder: (context, state) => const SpeakingScreen(),
    routes: [
      GoRoute(
        path: 'hub',
        builder: (context, state) => const SpeakingHubScreen(),
      ),
      GoRoute(
        path: 'shadowing',
        builder: (context, state) => const ShadowingPage(),
      ),
      GoRoute(
        path: 'umlaute',
        builder: (context, state) => const UmlauteTrainerPage(),
      ),
      GoRoute(
        path: 'r-sound',
        builder: (context, state) => const RSoundTrainerPage(),
      ),
      GoRoute(
        path: 'ich-ach',
        builder: (context, state) => const IchAchTrainerPage(),
      ),
      GoRoute(
        path: 'sp-st',
        builder: (context, state) => const SpStTrainerPage(),
      ),
      GoRoute(
        path: 'conversation-hub',
        builder: (context, state) => const ConversationHubPage(),
      ),
      GoRoute(
        path: 'conversation/:conversationId',
        builder: (context, state) => ConversationScenarioPage(
          conversationId: state.pathParameters['conversationId']!,
        ),
      ),
    ],
  ),
];
