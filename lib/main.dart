import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load env (.env)
  await AppConfig.load();

  // 2. Init Supabase Auth (login + JWT cho Go backend).
  //    KHÔNG dùng Firebase Auth — sub của JWT = profiles.id ở backend.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Firebase chỉ init cho FCM push ở P5 (không phải auth).

  runApp(const ProviderScope(child: DeutschTigerApp()));
}
