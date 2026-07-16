// Owner: P12 (social-stats-settings-cleanup) — web-mobile UI fidelity plan.
//
// `/affiliate` isn't itemized in phase-12's route table but is grouped here
// with the social/leaderboard family (closest existing owner) — flag to
// owning agent if a better home is found.

import 'package:go_router/go_router.dart';

import '../../screens/social/social_screen.dart';
import '../../screens/social/moments_page.dart';
import '../../screens/social/groups_page.dart';
import '../../screens/social/group_detail_page.dart';
import '../../screens/social/challenges_page.dart';
import '../../screens/social/duel_lobby_page.dart';
import '../../screens/social/duel_play_page.dart';
import '../../screens/social/messages_page.dart';
import '../../screens/social/chat_page.dart';
import '../../screens/social/friends_page.dart';
import '../../screens/social/profile_page.dart';
import '../../screens/social/announcements_page.dart';
import '../../screens/affiliate/affiliate_screen.dart';
import '../../screens/affiliate/affiliate_page.dart';
import '../../screens/affiliate/affiliate_leaderboard_page.dart';

final List<RouteBase> socialRoutes = [
  GoRoute(
    path: '/social',
    builder: (context, state) => const SocialScreen(),
    routes: [
      GoRoute(path: 'moments', builder: (context, state) => const MomentsPage()),
      GoRoute(path: 'groups', builder: (context, state) => const GroupsPage()),
      GoRoute(
        path: 'group/:groupId',
        builder: (context, state) =>
            GroupDetailPage(groupId: state.pathParameters['groupId']!),
      ),
      GoRoute(
        path: 'challenges',
        builder: (context, state) => const ChallengesPage(),
      ),
      GoRoute(
        path: 'duel/lobby',
        builder: (context, state) => const DuelLobbyPage(),
      ),
      GoRoute(
        path: 'duel/play',
        builder: (context, state) => DuelPlayPage(opponent: state.extra),
      ),
      GoRoute(
        path: 'messages',
        builder: (context, state) => const MessagesPage(),
      ),
      GoRoute(
        path: 'chat/:friendId',
        builder: (context, state) =>
            ChatPage(friendId: state.pathParameters['friendId']!),
      ),
      GoRoute(path: 'friends', builder: (context, state) => const FriendsPage()),
      GoRoute(
        path: 'profile/:userId',
        builder: (context, state) =>
            ProfilePage(userId: state.pathParameters['userId']!),
      ),
      GoRoute(
        path: 'announcements',
        builder: (context, state) => const AnnouncementsPage(),
      ),
    ],
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
