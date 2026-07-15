import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../repositories/settings/device_session_repository.dart';

final deviceSessionRepositoryProvider = Provider<DeviceSessionRepository>((
  ref,
) {
  return DeviceSessionRepository(ref.watch(apiClientProvider));
});

/// Danh sách thiết bị đang đăng nhập (màn Bảo mật).
/// Tự fetch khi mở màn, hỗ trợ refresh + revoke từng thiết bị.
class DeviceSessionListNotifier
    extends AutoDisposeAsyncNotifier<List<DeviceSession>> {
  @override
  Future<List<DeviceSession>> build() {
    return ref.watch(deviceSessionRepositoryProvider).fetchDevices();
  }

  /// Nạp lại danh sách (pull-to-refresh hoặc sau khi revoke).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(deviceSessionRepositoryProvider).fetchDevices(),
    );
  }

  /// Thu hồi một thiết bị rồi nạp lại danh sách.
  Future<void> revoke(String sessionId) async {
    await ref.read(deviceSessionRepositoryProvider).revoke(sessionId);
    await refresh();
  }

  /// Thu hồi mọi phiên trừ phiên đang dùng, sau đó nạp lại danh sách.
  Future<void> revokeOtherDevices() async {
    await ref.read(deviceSessionRepositoryProvider).revokeOtherDevices();
    await refresh();
  }
}

final deviceSessionListProvider =
    AsyncNotifierProvider.autoDispose<
      DeviceSessionListNotifier,
      List<DeviceSession>
    >(DeviceSessionListNotifier.new);
