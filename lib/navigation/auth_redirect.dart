const publicAuthRoutes = <String>{
  '/welcome',
  '/onboarding',
  '/login',
  '/signup',
  '/forgot-password',
  '/reset-password',
};

/// Prefixes always visible regardless of auth state — unlike
/// [publicAuthRoutes] (auth-flow screens redirected away once logged in),
/// these are content deep-links that stay visible whether or not the user is
/// logged in. `/de-thi` is a public SEO deep-link (mã đề) mirroring the web's
/// public exam registry page.
const alwaysVisibleRoutePrefixes = <String>{'/de-thi'};

bool _isAlwaysVisible(String location) => alwaysVisibleRoutePrefixes.any(
  (prefix) => location == prefix || location.startsWith('$prefix/'),
);

String? resolveAuthRedirect({
  required bool loggedIn,
  required bool onboardingCompleted,
  required String location,
}) {
  if (_isAlwaysVisible(location)) return null;
  final isPublic = publicAuthRoutes.contains(location);
  if (!loggedIn) {
    if (onboardingCompleted &&
        (location == '/welcome' || location == '/onboarding')) {
      return '/login';
    }
    return isPublic ? null : '/welcome';
  }
  // Supabase password-recovery links establish a temporary authenticated
  // session before the user submits the new password. Keep this route visible.
  if (location == '/reset-password') return null;
  return isPublic ? '/home' : null;
}
