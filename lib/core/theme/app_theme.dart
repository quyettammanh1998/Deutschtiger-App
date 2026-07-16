import 'package:flutter/material.dart';

import '../design_tokens.dart';
import 'app_tokens.dart';

/// ThemeData cho app, dựng từ tokens web (xem app_colors.dart + app_tokens.dart).
///
/// Hỗ trợ cả light và dark mode. Màu sắc thật (nguồn chân lý) nằm trong
/// [AppTokens], được đăng ký vào `ThemeData.extensions` bên dưới — đọc qua
/// `context.tokens`. `DesignTokens`/`AppColors` static chỉ còn giữ layout
/// (spacing/radius/shadow) + màu light-only đã `@Deprecated`.
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppTokens.light.primary,
      primary: AppTokens.light.primary,
      onPrimary: AppTokens.light.primaryForeground,
      secondary: AppTokens.light.brand,
      surface: AppTokens.light.card,
      onSurface: AppTokens.light.cardForeground,
      error: AppTokens.light.destructive,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: DesignTokens.background,
      fontFamily: DesignTokens.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.background,
        foregroundColor: DesignTokens.foreground,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: DesignTokens.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          side: const BorderSide(color: DesignTokens.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: DesignTokens.primaryForeground,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radius),
          ),
          textStyle: DesignTokens.buttonText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          borderSide: const BorderSide(color: DesignTokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          borderSide: const BorderSide(color: DesignTokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          borderSide: const BorderSide(color: DesignTokens.primary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.card,
        selectedItemColor: DesignTokens.primary,
        unselectedItemColor: DesignTokens.mutedForeground,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: DesignTokens.border,
      extensions: const [AppTokens.light],
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppTokens.dark.primary,
      primary: AppTokens.dark.primary,
      onPrimary: AppTokens.dark.primaryForeground,
      secondary: AppTokens.dark.brand,
      surface: AppTokens.dark.card,
      onSurface: AppTokens.dark.cardForeground,
      error: AppTokens.dark.destructive,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: DesignTokens.darkBackground,
      fontFamily: DesignTokens.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.darkBackground,
        foregroundColor: DesignTokens.darkForeground,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: DesignTokens.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          side: const BorderSide(color: DesignTokens.darkBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.darkPrimary,
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radius),
          ),
          textStyle: DesignTokens.buttonText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          borderSide: const BorderSide(color: DesignTokens.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          borderSide: const BorderSide(color: DesignTokens.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          borderSide: const BorderSide(color: DesignTokens.darkPrimary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.darkCard,
        selectedItemColor: DesignTokens.darkPrimary,
        unselectedItemColor: DesignTokens.mutedForeground,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: DesignTokens.darkBorder,
      extensions: const [AppTokens.dark],
    );
  }
}
