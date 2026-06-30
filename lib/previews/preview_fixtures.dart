import 'package:flutter/material.dart';

import '../core/design_tokens.dart';

export 'preview_sample_data.dart';

/// Wraps a widget in a MaterialApp with DesignTokens background.
///
/// Use this for previewing standalone widgets.
Widget previewApp(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: DesignTokens.primary),
      scaffoldBackgroundColor: DesignTokens.background,
    ),
    home: Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: child,
          ),
        ),
      ),
    ),
  );
}

/// Wraps a widget in a dark theme MaterialApp.
///
/// Use this for previewing widgets in dark mode.
Widget previewDarkApp(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignTokens.darkPrimary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: DesignTokens.darkBackground,
    ),
    home: Scaffold(
      backgroundColor: DesignTokens.darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: child,
          ),
        ),
      ),
    ),
  );
}

/// Wraps a widget in a plain MaterialApp without theme overrides.
///
/// Use this for previewing widgets that handle their own theming.
Widget previewPlainApp(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: child,
  );
}

/// No-op callback for previews that don't need interaction.
void previewNoop() {}
