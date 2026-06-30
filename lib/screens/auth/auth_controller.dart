import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:deutschtiger/view_models/providers.dart';

/// Controller cho các thao tác auth (Riverpod 3 Notifier).
/// State [AsyncValue] để UI hiện loading/error. go_router tự redirect khi auth
/// state đổi (xem app_router.dart).
class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> login(String email, String password) {
    return _run(
      () => ref
          .read(authServiceProvider)
          .signInWithPassword(email: email.trim(), password: password),
    );
  }

  Future<bool> loginWithGoogle() {
    return _run(() => ref.read(authServiceProvider).signInWithGoogle());
  }

  Future<bool> loginWithApple() {
    return _run(() => ref.read(authServiceProvider).signInWithApple());
  }

  Future<bool> signUp(String email, String password, String displayName) {
    return _run(
      () => ref
          .read(authServiceProvider)
          .signUp(
            email: email.trim(),
            password: password,
            displayName: displayName.trim(),
          ),
    );
  }

  Future<bool> resetPassword(String email) {
    return _run(
      () => ref.read(authServiceProvider).resetPasswordForEmail(email.trim()),
    );
  }

  /// Chạy một thao tác auth, set loading/error, trả true nếu thành công.
  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on AuthException catch (e) {
      state = AsyncError(_viMessage(e), StackTrace.current);
      return false;
    } catch (_) {
      state = AsyncError(_genericMessage, StackTrace.current);
      return false;
    }
  }

  static const _genericMessage = 'Có lỗi xảy ra. Vui lòng thử lại.';

  /// Map lỗi Supabase phổ biến sang tiếng Việt.
  String _viMessage(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return 'Email hoặc mật khẩu không đúng.';
    }
    if (msg.contains('already registered') || msg.contains('already exists')) {
      return 'Email này đã được đăng ký.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Vui lòng xác nhận email trước khi đăng nhập.';
    }
    if (msg.contains('password') && msg.contains('least')) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    if (msg.contains('rate limit') || msg.contains('too many')) {
      return 'Bạn thao tác quá nhanh. Vui lòng thử lại sau ít phút.';
    }
    if (msg.contains('google')) {
      return 'Đăng nhập Google thất bại. Vui lòng thử lại.';
    }
    if (msg.contains('apple')) {
      return 'Đăng nhập Apple thất bại. Vui lòng thử lại.';
    }
    if (msg.contains('cancelled')) {
      return 'Đăng nhập đã bị hủy.';
    }
    return e.message;
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);
