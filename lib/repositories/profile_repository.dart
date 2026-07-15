import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/core/identity/app_user.dart';

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
  Future<AppUser> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['display_name'] = displayName;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;
    final json = await _api.put<Map<String, dynamic>>(
      '/user/profile',
      body: body,
    );
    return AppUser.fromJson(json);
  }
}
