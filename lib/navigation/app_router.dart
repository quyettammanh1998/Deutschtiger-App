import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/widgets/common/app_shell.dart';
import '../core/release/release_feature_flags.dart';
import '../view_models/providers.dart';
import 'router_keys.dart';
import 'auth_redirect.dart';
import 'release_redirect.dart';
import 'routes/entry_routes.dart';
import 'routes/vocabulary_routes.dart';
import 'routes/practice_routes.dart';
import 'routes/decks_routes.dart';
import 'routes/journey_routes.dart';
import 'routes/course_routes.dart';
import 'routes/learn_routes.dart';
import 'routes/grammar_routes.dart';
import 'routes/games_routes.dart';
import 'routes/exam_routes.dart';
import 'routes/speech_routes.dart';
import 'routes/media_routes.dart';
import 'routes/social_routes.dart';
import 'routes/ai_routes.dart';
import 'routes/stats_routes.dart';
import 'routes/settings_routes.dart';

/// Root navigator key — exposed để global code (vd. [ApiClient] khi gặp
/// device-kicked 401) có thể push dialog / navigate từ bất kỳ đâu mà không cần
/// BuildContext. Định nghĩa trong `router_keys.dart` để tránh import cycle.
final _rootKey = rootNavigatorKey;

/// Router go_router với ShellRoute 4 tab + redirect theo auth state.
/// Chưa login → /welcome (giới thiệu) → /login|/signup. Đã login → /home.
///
/// Route definitions được tách theo domain vào `routes/*.dart` (xem phase-01
/// foundation plan, workstream E) để mỗi phase implementation sau này chỉ
/// cần sửa file domain của mình, tránh đụng độ file khi chạy song song.
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  final onboardingCompleted =
      ref.watch(onboardingCompletedProvider).value ?? false;

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    // Rebuild redirect khi auth state đổi.
    refreshListenable: _GoRouterRefresh(authService.authStateChanges),
    redirect: (context, state) {
      final authRedirect = resolveAuthRedirect(
        loggedIn: authService.isLoggedIn,
        onboardingCompleted: onboardingCompleted,
        location: state.matchedLocation,
      );
      if (authRedirect != null || !authService.isLoggedIn) {
        return authRedirect;
      }
      return resolveReleaseRedirect(state.uri.path);
    },
    routes: [
      ...entryRoutes,
      ...deThiRoutes,
      ...luyenVietRoutes,
      ...vocabularyRoutes,
      ...decksRoutes,
      ...journeyRoutes,
      ...courseRoutes,
      ...grammarRoutes,
      ...statsRoutes,
      ...learnRoutes,
      ...settingsRoutes,
      ...gamesRoutes,
      ...practiceRoutes,
      ...mediaRoutes,
      ...speechRoutes,
      ...socialRoutes,
      ...aiRoutes,
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // 0 — Trang chủ
          StatefulShellBranch(routes: homeShellRoutes),
          // 1 — Thi
          StatefulShellBranch(routes: examShellRoutes),
          // 2 — Học: B2 Learn Hub với phiên hôm nay từ backend.
          StatefulShellBranch(routes: learnShellRoutes),
          // 3 — Hội thoại (web parity) once `ReleaseFeatureFlags.speaking`
          // (P10 conversation hub) ships; AI tab otherwise. Same branch
          // index either way so `AppShell`'s branch-based active-tab lookup
          // doesn't need to change when this flips. TAB-4 RELEASE SWITCH:
          // flip `ReleaseFeatureFlags.speaking` to move this app to the web
          // bottom-nav layout — see matching comment in
          // `widgets/common/app_shell.dart`.
          StatefulShellBranch(
            routes: ReleaseFeatureFlags.speaking
                ? conversationShellRoutes
                : aiShellRoutes,
          ),
          // Tab "Thêm" (index 4) KHÔNG có branch — AppShell tap thì
          // mở MoreFeaturesSheet thay vì navigate.
        ],
      ),
    ],
  );
});

/// Cầu nối Stream → Listenable cho go_router refreshListenable.
class _GoRouterRefresh extends ChangeNotifier {
  _GoRouterRefresh(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final dynamic _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
