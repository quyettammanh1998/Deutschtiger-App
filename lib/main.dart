import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'screens/system/force_update_screen.dart';
import 'services/config/app_config.dart';
import 'services/crash_service.dart';
import 'services/force_update_service.dart';
import 'services/secure_auth_storage.dart';

/// Top-level error guard — mirror Phase 13 §1 yêu cầu "mọi zone error đều
/// report". Đặt ngoài main để `runZonedGuarded` có thể capture lỗi trong
/// cả quá trình khởi tạo.
Future<void> main() async {
  runZonedGuarded<Future<void>>(_bootstrap, (error, stack) {
    CrashService.instance.logError(error, stack);
  });
}

Future<void> _bootstrap() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // Giữ splash native trong lúc khởi tạo (tránh nháy trắng trước khi UI sẵn sàng).
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // 1. Crash hooks FIRST — FlutterError + PlatformDispatcher được gắn trước
  //    khi bất kỳ thứ gì khác có thể throw (theo Phase 13 §1).
  CrashService.instance.init();

  // 2. Load .env (supabase/api/webview URLs).
  await AppConfig.load();

  // 3. Init Firebase core + Crashlytics remote reporting. Nếu platform config
  //    chưa có thì app vẫn chạy và local error hooks vẫn hoạt động.
  await _initFirebase();

  // 4. Init Supabase Auth (login + JWT cho Go backend).
  //    KHÔNG dùng Firebase Auth — sub của JWT = profiles.id ở backend.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: kIsWeb ? null : SecureAuthStorage(),
      pkceAsyncStorage: kIsWeb ? null : SecurePkceStorage(),
    ),
  );

  // 5. Force-update gate — Phase 13 §"Force-update path". Khi quyết định
  //    required=true → swap root widget thành ForceUpdateScreen (chặn user).
  final forceUpdate = await ForceUpdateService().check();
  final initialWidget = forceUpdate.required
      ? ForceUpdateScreen(
          storeUrl: forceUpdate.storeUrl,
          message: forceUpdate.message,
          latestVersion: forceUpdate.latestVersion,
        )
      : const DeutschTigerApp();

  FlutterNativeSplash.remove();
  runApp(ProviderScope(child: _BootstrapGate(child: initialWidget)));
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp();
    await CrashService.instance.enableRemoteReporting();
    CrashService.instance.log('firebase_initialized');
  } catch (_) {
    // Thiếu google-services.json / GoogleService-Info.plist — app vẫn chạy.
    CrashService.instance.log('firebase_init_skipped');
  }
}

/// Giữ chỗ cho Phase 13 route breadcrumbs — set route khi GoRouter đổi
/// location. Hiện tại DeutschTigerApp tự quản lý qua router; nếu sau này
/// muốn centralize có thể wrap MaterialApp.router.
class _BootstrapGate extends StatelessWidget {
  const _BootstrapGate({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}
