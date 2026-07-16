// Owner: P12 (social-stats-settings-cleanup) — web-mobile UI fidelity plan.
//
// `/affiliate` isn't itemized in phase-12's route table but is grouped here
// with the social/leaderboard family (closest existing owner) — flag to
// owning agent if a better home is found.
//
// P12 wave B deletion sweep: web has no `/social` hub page and no
// moments/groups/announcements routes — those Flutter-only screens were
// deleted (`social_screen.dart`, `moments_page.dart`, `groups_page.dart`,
// `group_detail_page.dart`, `announcements_page.dart`). The remaining social
// routes are now flat top-level paths (still under the `/social/*` prefix
// for URL stability) instead of children of a deleted `/social` parent.
// `/social` bare-path visits redirect to `/social/friends` (closest hub;
// see `release_redirect.dart`).

import 'package:go_router/go_router.dart';

import '../../screens/social/challenges_page.dart';
import '../../screens/social/duel_lobby_page.dart';
import '../../screens/social/duel_play_page.dart';
import '../../screens/social/messages_page.dart';
import '../../screens/social/chat_page.dart';
import '../../screens/social/friends_page.dart';
import '../../screens/social/profile_page.dart';
import '../../screens/affiliate/affiliate_screen.dart';
import '../../screens/affiliate/affiliate_page.dart';
import '../../screens/affiliate/affiliate_leaderboard_page.dart';

final List<RouteBase> socialRoutes = [
  GoRoute(
    path: '/social/challenges',
    builder: (context, state) => const ChallengesPage(),
  ),
  GoRoute(
    path: '/social/duel/lobby',
    builder: (context, state) => const DuelLobbyPage(),
  ),
  GoRoute(
    path: '/social/duel/play',
    builder: (context, state) => DuelPlayPage(opponent: state.extra),
  ),
  GoRoute(
    path: '/social/messages',
    builder: (context, state) => const MessagesPage(),
  ),
  GoRoute(
    path: '/social/chat/:friendId',
    builder: (context, state) =>
        ChatPage(friendId: state.pathParameters['friendId']!),
  ),
  GoRoute(
    path: '/social/friends',
    builder: (context, state) => const FriendsPage(),
  ),
  GoRoute(
    path: '/social/profile/:userId',
    builder: (context, state) =>
        ProfilePage(userId: state.pathParameters['userId']!),
  ),
  GoRoute(
    path: '/affiliate',
    builder: (context, state) => const AffiliateScreen(),
    routes: [
      GoRoute(
        path: 'leaderboard',
        builder: (context, state) => const AffiliateLeaderboardPage(),
      ),
      GoRoute(
        path: 'detail',
        builder: (context, state) => const AffiliatePage(),
      ),
    ],
  ),
  // Own-profile view: renders the same public-profile UI as `/social/
  // profile/:userId` (web `/u/:id`), resolved to the caller's id. Editing
  // moved into the settings-root profile-edit card (see release_redirect.dart
  // `/profile/edit` → `/settings`).
  GoRoute(path: '/profile', builder: (context, state) => const OwnProfilePage()),
];
