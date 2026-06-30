import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Cấu hình app load từ `.env` (flutter_dotenv).
///
/// Gọi [AppConfig.load] một lần trong main() trước khi dùng.
class AppConfig {
  const AppConfig._();

  static String get supabaseUrl => _require('SUPABASE_URL');
  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');
  static String get apiBaseUrl => _require('API_BASE_URL');
  static String get webviewBaseUrl => _require('WEBVIEW_BASE_URL');

  /// Load `.env`. Ném lỗi rõ ràng nếu thiếu file để fail-fast khi dev.
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String _require(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env var: $key (kiểm tra file .env)');
    }
    return value;
  }
}
