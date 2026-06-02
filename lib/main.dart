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

  // Firebase init cho FCM push: tách task riêng (chưa config).

  FlutterNativeSplash.remove();
  runApp(const ProviderScope(child: DeutschTigerApp()));
}
