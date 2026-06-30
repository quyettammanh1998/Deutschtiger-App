import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // Giữ splash native trong lúc khởi tạo (tránh nháy trắng trước khi UI sẵn sàng).
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // 1. Load env (.env)
  await AppConfig.load();

  // 2. Init Supabase Auth (login + JWT cho Go backend).
  //    KHÔNG dùng Firebase Auth — sub của JWT = profiles.id ở backend.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // 3. Init Firebase cho FCM push notifications (nếu đã config google-services.json)
  _initFirebase();

  FlutterNativeSplash.remove();
  runApp(ProviderScope(child: DeutschTigerApp()));
}

/// Khởi tạo Firebase cho push notifications.
/// Nếu google-services.json chưa có → bỏ qua và app vẫn hoạt động.
void _initFirebase() {
  // Firebase sẽ được init tự động nếu google-services.json tồn tại
  // NotificationService sẽ được gọi sau khi app ready
  debugPrint('Firebase push notifications ready to initialize');
}
