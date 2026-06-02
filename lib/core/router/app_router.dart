import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../shared/widgets/app_shell.dart';
import '../../shared/widgets/placeholder_screen.dart';
import '../providers.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Router go_router với ShellRoute 4 tab + redirect theo auth state.
/// Chưa login → /welcome (giới thiệu) → /login|/signup. Đã login → /home.
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    // Rebuild redirect khi auth state đổi.
    refreshListenable: _GoRouterRefresh(authService.authStateChanges),
    redirect: (context, state) {
      final loggedIn = authService.isLoggedIn;
      const publicRoutes = {
        '/welcome',
        '/login',
        '/signup',
        '/forgot-password',
      };
      final atPublic = publicRoutes.contains(state.matchedLocation);
      // Chưa login: cho ở các màn public, mặc định đẩy về /welcome.
      if (!loggedIn) return atPublic ? null : '/welcome';
      // Đã login mà còn ở màn public → vào home.
      if (atPublic) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vocab',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Ôn từ', icon: Icons.style),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lessons',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Bài học',
                  icon: Icons.menu_book,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Hồ sơ', icon: Icons.person),
              ),
            ],
          ),
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
