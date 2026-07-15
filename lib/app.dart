import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'services/crash_service.dart';
import 'view_models/preferences_provider.dart';
import 'view_models/theme_provider.dart';

/// Root widget — MaterialApp.router với theme + go_router.
class DeutschTigerApp extends ConsumerStatefulWidget {
  const DeutschTigerApp({super.key});

  @override
  ConsumerState<DeutschTigerApp> createState() => _DeutschTigerAppState();
}

class _DeutschTigerAppState extends ConsumerState<DeutschTigerApp> {
  GoRouter? _observedRouter;

  @override
  void dispose() {
    _observedRouter?.routeInformationProvider.removeListener(_recordRoute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = _localeFromCode(ref.watch(appLanguageProvider));
    _observeRouter(router);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }

  void _observeRouter(GoRouter router) {
    if (identical(_observedRouter, router)) return;
    _observedRouter?.routeInformationProvider.removeListener(_recordRoute);
    _observedRouter = router;
    router.routeInformationProvider.addListener(_recordRoute);
    _recordRoute();
  }

  void _recordRoute() {
    final path = _observedRouter?.routeInformationProvider.value.uri.path;
    CrashService.instance.setRoute(path == null || path.isEmpty ? '/' : path);
  }

  Locale _localeFromCode(String languageCode) => switch (languageCode) {
    'en' => const Locale('en'),
    'de' => const Locale('de'),
    _ => const Locale('vi'),
  };
}
