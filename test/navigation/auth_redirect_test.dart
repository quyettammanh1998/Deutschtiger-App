import 'package:deutschtiger/navigation/auth_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('allows an unauthenticated password-reset deep link', () {
    expect(
      resolveAuthRedirect(
        loggedIn: false,
        onboardingCompleted: true,
        location: '/reset-password',
      ),
      isNull,
    );
  });

  test('keeps reset screen open for an authenticated recovery session', () {
    expect(
      resolveAuthRedirect(
        loggedIn: true,
        onboardingCompleted: true,
        location: '/reset-password',
      ),
      isNull,
    );
  });

  test('skips welcome after onboarding has completed', () {
    expect(
      resolveAuthRedirect(
        loggedIn: false,
        onboardingCompleted: true,
        location: '/welcome',
      ),
      '/login',
    );
  });

  test('does not repeat onboarding after it has completed', () {
    expect(
      resolveAuthRedirect(
        loggedIn: false,
        onboardingCompleted: true,
        location: '/onboarding',
      ),
      '/login',
    );
  });

  test('protects app routes from unauthenticated users', () {
    expect(
      resolveAuthRedirect(
        loggedIn: false,
        onboardingCompleted: false,
        location: '/home',
      ),
      '/welcome',
    );
  });

  test('de-thi public deep link stays visible when logged out', () {
    expect(
      resolveAuthRedirect(
        loggedIn: false,
        onboardingCompleted: true,
        location: '/de-thi/1525',
      ),
      isNull,
    );
  });

  test('de-thi public deep link stays visible when logged in (no /home bounce)', () {
    expect(
      resolveAuthRedirect(
        loggedIn: true,
        onboardingCompleted: true,
        location: '/de-thi/1525',
      ),
      isNull,
    );
  });

  test('de-thi list root is also always visible', () {
    expect(
      resolveAuthRedirect(
        loggedIn: false,
        onboardingCompleted: true,
        location: '/de-thi',
      ),
      isNull,
    );
  });
}
