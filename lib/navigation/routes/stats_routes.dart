// Owner: P12 (social-stats-settings-cleanup) — web-mobile UI fidelity plan.
// `/stats/daily-quote` content is also touched by P2 (entry-auth-home-quote,
// `quotes/daily-quote-page.tsx` row) but the route itself nests under
// `/stats`, so it stays in this file together with the rest of the stats
// tree — coordinate with P2 before changing this sub-route.
//
// `/leaderboard` isn't itemized separately in scanned phase tables; grouped
// here with stats as closest owner. `/achievements` (route + screen) was
// deleted in the P12 wave-B sweep — its grid now lives inside Stats
// (`stats_achievements_grid.dart`); `/achievements` deep links always
// redirect to `/stats` (see `release_redirect.dart`).

import 'package:go_router/go_router.dart';

import '../../screens/stats/stats_screen.dart';
import '../../screens/stats/error_patterns_page.dart';
import '../../screens/stats/daily_quote_page.dart';
import '../../screens/leaderboard/leaderboard_screen.dart';

final List<RouteBase> statsRoutes = [
  GoRoute(
    path: '/leaderboard',
    builder: (context, state) => const LeaderboardScreen(),
  ),
  GoRoute(
    path: '/stats',
    builder: (context, state) => const StatsScreen(),
    routes: [
      GoRoute(
        path: 'error-patterns',
        builder: (context, state) => const ErrorPatternsPage(),
      ),
      GoRoute(
        path: 'daily-quote',
        builder: (context, state) => const DailyQuotePage(),
      ),
    ],
  ),
];
