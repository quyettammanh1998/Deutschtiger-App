import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

/// Preview auth service that simulates authenticated state.
///
/// Use this for widget previews that require auth context.
class PreviewAuthService implements AuthService {
  /// Creates a preview auth service with optional authenticated state.
  PreviewAuthService({this.isAuthenticated = false});

  final bool isAuthenticated;

  @override
  Session? get currentSession => isAuthenticated ? _previewSession : null;

  @override
  User? get currentUser => isAuthenticated ? _previewUser : null;

  @override
  bool get isLoggedIn => isAuthenticated;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  bool get isGoogleSignInAvailable => true;

  @override
  Future<AuthResponse> signInWithGoogle() async {
    throw UnimplementedError('Preview auth service');
  }

  @override
  Future<AuthResponse> signInWithApple() async {
    throw UnimplementedError('Preview auth service');
  }

  @override
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError('Preview auth service');
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    throw UnimplementedError('Preview auth service');
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    throw UnimplementedError('Preview auth service');
  }

  @override
  Future<void> signOut() async {}

  // Placeholder session and user objects for previews
  // ignore: unused_field
  Session? get _previewSession => null;

  // ignore: unused_field
  User? get _previewUser => null;
}
