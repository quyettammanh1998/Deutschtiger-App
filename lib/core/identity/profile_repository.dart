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

  /// Xóa tài khoản (App Store 5.1.1v). Backend cascade xóa toàn bộ data.
  Future<void> deleteAccount() async {
    await _api.delete<dynamic>('/user/account');
  }
}
