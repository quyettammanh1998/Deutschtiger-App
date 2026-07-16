// Owner: P12 (social-stats-settings-cleanup) — web-mobile UI fidelity plan.
// `/notifications` (NotificationCenterScreen) isn't itemized separately in
// scanned phase tables; grouped here with `/settings` as closest owner.

import 'package:go_router/go_router.dart';

import '../../screens/settings/delete_account_screen.dart';
import '../../screens/settings/learning_preferences_screen.dart';
import '../../screens/settings/notification_preferences_screen.dart';
import '../../screens/settings/security_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/notifications/notification_center_screen.dart';
import '../../features/premium/presentation/premium_screen.dart';

final List<RouteBase> settingsRoutes = [
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsScreen(),
    routes: [
      GoRoute(
        path: 'security',
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: 'delete-account',
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: 'premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: 'notifications',
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: 'learning-preferences',
        builder: (context, state) => const LearningPreferencesScreen(),
      ),
    ],
  ),
  GoRoute(
    path: '/notifications',
    builder: (context, state) => const NotificationCenterScreen(),
  ),
];
