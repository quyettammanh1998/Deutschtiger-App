import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';

/// Controller các thao tác hồ sơ: cập nhật và đăng xuất.
/// State [AsyncValue] để UI hiện loading/error trên nút.
/// Sau khi đổi profile, invalidate [myProfileProvider] để màn refetch.
class ProfileController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Cập nhật tên hiển thị (và avatar nếu có). True nếu thành công.
  Future<bool> updateProfile({String? displayName, String? avatarUrl}) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateProfile(displayName: displayName, avatarUrl: avatarUrl);
      ref.invalidate(myProfileProvider);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Đăng xuất — router tự redirect về /welcome khi auth state đổi.
  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, AsyncValue<void>>(
      ProfileController.new,
    );
