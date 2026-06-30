import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'view_models/theme_provider.dart';

/// Root widget — MaterialApp.router với theme + go_router.
class DeutschTigerApp extends ConsumerWidget {
  const DeutschTigerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'DeutschTiger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
