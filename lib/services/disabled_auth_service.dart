import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';

/// Disabled auth service for offline/demo mode.
///
/// Use this service when:
/// - App is in offline mode (no network)
/// - Running in demo mode (no backend)
/// - User wants to preview app without signing in
///
/// Sign-in methods throw [AuthException], and currentSession/currentUser
/// always return null.
class DisabledAuthService implements AuthService {
  /// Creates a disabled auth service.
  ///
  /// The [client] parameter is accepted for interface compatibility but
  /// is not used for any operations.
  // ignore: unused_field - kept for interface compatibility
  DisabledAuthService([SupabaseClient? client]) : _client = client;

  // ignore: unused_field
  final SupabaseClient? _client;

  @override
  Session? get currentSession => null;

  @override
  User? get currentUser => null;

  @override
  bool get isLoggedIn => false;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  bool get isGoogleSignInAvailable => false;

  @override
  Future<AuthResponse> signInWithGoogle() async {
    throw const AuthException(
      'Sign-in is disabled. '
      'This feature requires an active network connection.',
    );
  }

  @override
  Future<AuthResponse> signInWithApple() async {
    throw const AuthException(
      'Sign-in is disabled. '
      'This feature requires an active network connection.',
    );
  }

  @override
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    throw const AuthException(
      'Sign-in is disabled. '
      'This feature requires an active network connection.',
    );
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    throw const AuthException(
      'Sign-up is disabled. '
      'This feature requires an active network connection.',
    );
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    throw const AuthException(
      'Password reset is disabled. '
      'This feature requires an active network connection.',
    );
  }

  @override
  Future<void> signOut() async {
    // No-op: already in disabled/guest state
  }
}
