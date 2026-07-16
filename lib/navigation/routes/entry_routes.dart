// Owner: P2 (entry-auth-home-quote) — web-mobile UI fidelity plan.
//
// Auth/entry flow, legal pages, and the shell "home" branch. Split out of
// `app_router.dart` (pure structural move, no behavior change — see phase-01
// foundation plan).

import 'package:go_router/go_router.dart';

import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/onboarding_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/legal/privacy_policy_screen.dart';
import '../../screens/legal/terms_of_service_screen.dart';
import '../../features/landing/presentation/landing_screen.dart' as landing;

/// Top-level entry/auth/legal routes (outside the tabbed shell).
final List<RouteBase> entryRoutes = [
  GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
  GoRoute(
    path: '/forgot-password',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: '/reset-password',
    builder: (context, state) => const ResetPasswordScreen(),
  ),
  GoRoute(
    path: '/landing',
    builder: (context, state) => const landing.LandingScreen(),
  ),
  GoRoute(
    path: '/welcome-full',
    builder: (context, state) => const landing.WelcomeScreen(),
  ),
  GoRoute(
    path: '/privacy-policy',
    builder: (context, state) => const PrivacyPolicyScreen(),
  ),
  GoRoute(
    path: '/terms-of-service',
    builder: (context, state) => const TermsOfServiceScreen(),
  ),
];

/// Shell branch 0 ("Trang chủ") routes — mounted inside the
/// `StatefulShellRoute` in `app_router.dart`.
final List<RouteBase> homeShellRoutes = [
  GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
];
