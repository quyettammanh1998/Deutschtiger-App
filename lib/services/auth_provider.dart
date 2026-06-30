import 'package:supabase_flutter/supabase_flutter.dart';

/// Nguồn cung cấp JWT cho network layer — interface để feature code KHÔNG
/// phụ thuộc trực tiếp vào auth SDK. Đổi provider (Supabase ↔ khác) chỉ cần
/// thay implementation, interceptor và feature không đổi.
abstract class TokenProvider {
  /// Access token hiện tại (đã refresh nếu cần), hoặc null nếu chưa login.
  Future<String?> getAccessToken();

  /// Ép refresh session, trả token mới — dùng khi gặp 401.
  Future<String?> refresh();
}

/// Implementation dựa trên Supabase Auth.
class SupabaseTokenProvider implements TokenProvider {
  SupabaseTokenProvider(this._client);

  final SupabaseClient _client;

  @override
  Future<String?> getAccessToken() async {
    return _client.auth.currentSession?.accessToken;
  }

  @override
  Future<String?> refresh() async {
    final res = await _client.auth.refreshSession();
    return res.session?.accessToken;
  }
}
