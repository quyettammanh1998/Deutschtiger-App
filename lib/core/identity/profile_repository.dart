import '../network/api_client.dart';
import 'app_user.dart';

/// Lấy profile của user hiện tại từ backend (`GET /api/v1/user/profile`).
/// Backend resolve theo JWT sub = profiles.id.
class ProfileRepository {
  ProfileRepository(this._api);

  final ApiClient _api;

  Future<AppUser> fetchMyProfile() async {
    final json = await _api.get<Map<String, dynamic>>('/user/profile');
    return AppUser.fromJson(json);
  }

  /// Cập nhật hồ sơ (`PUT /user/profile`). Chỉ gửi field cần đổi; backend
  /// nhận pointer nullable nên field bỏ qua sẽ không bị ghi đè.
  /// Trả về profile mới sau cập nhật.
  Future<AppUser> updateProfile({String? displayName, String? avatarUrl}) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['display_name'] = displayName;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;
    final json = await _api.put<Map<String, dynamic>>(
      '/user/profile',
      body: body,
    );
    return AppUser.fromJson(json);
  }

  /// Xóa tài khoản (App Store 5.1.1v). Backend cascade xóa toàn bộ data.
  Future<void> deleteAccount() async {
    await _api.delete<dynamic>('/user/account');
  }
}
