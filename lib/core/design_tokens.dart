import 'package:flutter/material.dart';

/// Centralized design tokens extracted from app_colors.dart and app_theme.dart.
///
/// Use these tokens instead of hardcoded values to ensure consistency
/// across the codebase and enable centralized theming.
class DesignTokens {
  const DesignTokens._();

  // ===== Spacing =====
  static const double spacingZero = 0;
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // ===== Border Radii =====
  static const double radiusSm = 8;
  static const double radius = 16;
  static const double radiusLg = 24;

  // ===== Animation Durations =====
  static const Duration durationFast = Duration(milliseconds: 120);
  static const Duration durationMedium = Duration(milliseconds: 220);
  static const Duration durationSlow = Duration(milliseconds: 450);

  // ===== Light Theme Colors =====
  static const Color background = Color(0xFFFBF4EF);
  static const Color foreground = Color(0xFF2E2E2E);
  static const Color muted = Color(0xFFF3F1F0);
  static const Color mutedForeground = Color(0xFF76726F);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF5F2EA);
  static const Color cardForeground = Color(0xFF2E2E2E);
  static const Color primary = Color(0xFFFF8FA3);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFFAE0CF);
  static const Color accent = Color(0xFFE8EFC9);
  static const Color border = Color(0xFFE8E4E1);
  static const Color ring = primary;
  static const Color destructive = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color brand = Color(0xFFF59E1B);
  static const Color brandDark = Color(0xFFD9850E);
  static const Color sidebar = Color(0xFFF7DCE2);

  // ===== Auth Colors =====
  static const Color authBackground = Color(0xFFFFFBF5);
  static const Color tigerOrange = Color(0xFFF7931E);
  static const Color tigerOrangeDark = Color(0xFFE07D18);
  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);
  static const Color rose600 = Color(0xFFE11D48);

  // ===== Dark Theme Colors =====
  static const Color darkBackground = Color(0xFF14171F);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkCard = Color(0xFF1F242E);
  static const Color darkPrimary = Color(0xFF5BB8E6);
  static const Color darkBorder = Color(0xFF383F4B);

  // ===== Gradients =====
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [orange500, rose600],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(255, 255, 255, 0.05),
      Color.fromRGBO(255, 255, 255, 0.30),
    ],
  );

  static const LinearGradient authButtonGradient = LinearGradient(
    colors: [tigerOrange, tigerOrangeDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ===== Typography =====
  static const String fontFamily = 'Inter';

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: foreground,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: foreground,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: foreground,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: foreground,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: foreground,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: foreground,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: foreground,
      );

  static const TextStyle buttonText = TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
}
