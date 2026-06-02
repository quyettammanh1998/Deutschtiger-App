import 'package:supabase_flutter/supabase_flutter.dart';

/// Wrapper quanh Supabase Auth — điểm duy nhất feature `auth` chạm tới SDK.
///
/// Dùng Supabase (KHÔNG Firebase Auth) để `sub` của JWT = `profiles.id` ở
/// backend Go → cùng 1 tài khoản web + mobile, zero backend auth change.
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  /// Session hiện tại (null nếu chưa login).
  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  bool get isLoggedIn => currentSession != null;

  /// Stream thay đổi auth state — dùng cho router redirect.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) {
    // Truyền display_name vào user metadata (giống web) để backend seed profile.
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );
  }

  Future<void> resetPasswordForEmail(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() => _client.auth.signOut();
}
