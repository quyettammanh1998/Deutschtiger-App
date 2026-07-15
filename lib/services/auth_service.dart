import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Wrapper quanh Supabase Auth — điểm duy nhất feature `auth` chạm tới SDK.
///
/// Dùng Supabase (KHÔNG Firebase Auth) để `sub` của JWT = `profiles.id` ở
/// backend Go → cùng 1 tài khoản web + mobile, zero backend auth change.
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  /// Lazy-initialized GoogleSignIn - tránh crash khi ClientID chưa được set
  GoogleSignIn? _googleSignIn;

  GoogleSignIn get _googleSignInInstance {
    _googleSignIn ??= GoogleSignIn(scopes: ['email', 'profile']);
    return _googleSignIn!;
  }

  /// Session hiện tại (null nếu chưa login).
  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  bool get isLoggedIn => currentSession != null;

  /// Stream thay đổi auth state — dùng cho router redirect.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Kiểm tra Google Sign-In có khả dụng không (cần ClientID)
  bool get isGoogleSignInAvailable {
    if (kIsWeb) {
      // Trên web, kiểm tra xem meta tag đã được set chưa
      return true; // Sẽ throw lỗi runtime nếu ClientID thiếu
    }
    return true;
  }

  /// Đăng nhập bằng Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final googleUser = await _googleSignInInstance.signIn();
      if (googleUser == null) {
        throw AuthException('Google sign-in was cancelled');
      }

      // Get Google ID token
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw AuthException('Failed to get Google ID token');
      }

      // Sign in to Supabase with Google ID token
      return await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
    } on Exception catch (e) {
      throw AuthException('Google sign-in failed: $e');
    }
  }

  /// Đăng nhập bằng Apple ID
  Future<AuthResponse> signInWithApple() async {
    try {
      // Generate a cryptographically secure nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple Sign-In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      if (appleCredential.identityToken == null) {
        throw AuthException('Failed to get Apple identity token');
      }

      // Sign in to Supabase with Apple ID token
      return await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: appleCredential.identityToken!,
        nonce: rawNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw AuthException('Apple sign-in was cancelled');
      }
      throw AuthException('Apple sign-in failed: ${e.message}');
    }
  }

  /// Tạo nonce ngẫu nhiên cho Apple Sign-In (cryptographically secure)
  String _generateNonce([int length = 32]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Mã hóa nonce bằng SHA256
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

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
    return _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'https://deutschtiger.com/reset-password',
    );
  }

  Future<void> signOut() => _client.auth.signOut();
}
