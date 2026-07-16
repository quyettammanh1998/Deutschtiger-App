import 'package:flutter/material.dart';

import '../design_tokens.dart';

/// Palette trích từ web `src/index.css` (xem docs/design-tokens-from-web.md).
///
/// FROZEN 2026-07-17: semantic colors below mirror [DesignTokens]'s light
/// statics and are `@Deprecated` — use `context.tokens` ([AppTokens] in
/// `app_tokens.dart`) for new code; it resolves both light and dark
/// correctly. Layout tokens (shadow/spacing/gradient) stay undeprecated.
///
/// This class re-exports from DesignTokens for backward compatibility.
class AppColors {
  const AppColors._();

  // ===== Light theme ===== (delegated to DesignTokens)
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color background = DesignTokens.background;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color foreground = DesignTokens.foreground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color muted = DesignTokens.muted;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color mutedForeground = DesignTokens.mutedForeground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color card = DesignTokens.card;
  static const Color cardBackground = DesignTokens.cardBackground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color cardForeground = DesignTokens.cardForeground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color primary = DesignTokens.primary;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color primaryForeground = DesignTokens.primaryForeground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color secondary = DesignTokens.secondary;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color accent = DesignTokens.accent;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color border = DesignTokens.border;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color ring = DesignTokens.ring;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color destructive = DesignTokens.destructive;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color success = DesignTokens.success;
  static const Color error = DesignTokens.error;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color warning = DesignTokens.warning;
  static const Color info = DesignTokens.info;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color brand = DesignTokens.brand;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color brandDark = DesignTokens.brandDark;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color sidebar = DesignTokens.sidebar;

  // ===== Shadow tokens (delegated to DesignTokens) =====
  static const List<BoxShadow> shadowSm = DesignTokens.shadowSm;
  static const List<BoxShadow> shadowMd = DesignTokens.shadowMd;
  static const List<BoxShadow> shadowLg = DesignTokens.shadowLg;
  static const List<BoxShadow> shadowCard = DesignTokens.shadowCard;

  // ===== Layout paddings/heights (delegated to DesignTokens) =====
  static const double cardPadding = DesignTokens.cardPadding;
  static const double sectionGap = DesignTokens.sectionGap;
  static const double screenHorizontalPadding = DesignTokens.screenHorizontalPadding;
  static const double bottomNavHeight = DesignTokens.bottomNavHeight;
  static const double appBarHeight = DesignTokens.appBarHeight;
  static const double headerHeight = DesignTokens.headerHeight;

  // ===== Bottom nav (delegated to DesignTokens) =====
  static const Color tabActiveColor = DesignTokens.tabActiveColor;
  static const Color tabInactiveColor = DesignTokens.tabInactiveColor;
  static const TextStyle bottomNavLabel = DesignTokens.bottomNavLabel;

  // ===== Auth colors ===== (delegated to DesignTokens)
  static const Color authBackground = DesignTokens.authBackground;
  static const Color tigerOrange = DesignTokens.tigerOrange;
  static const Color tigerOrangeDark = DesignTokens.tigerOrangeDark;
  static const Color orange50 = DesignTokens.orange50;
  static const Color orange100 = DesignTokens.orange100;
  static const Color orange500 = DesignTokens.orange500;
  static const Color orange600 = DesignTokens.orange600;
  static const Color rose600 = DesignTokens.rose600;

  /// Gradient nút chính: from-orange-500 to-rose-600 (web login button).
  static const LinearGradient primaryGradient = DesignTokens.primaryGradient;

  // ===== Dark theme (delegated to DesignTokens) =====
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkBackground = DesignTokens.darkBackground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkForeground = DesignTokens.darkForeground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkMuted = DesignTokens.darkMuted;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkMutedForeground = DesignTokens.darkMutedForeground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkCard = DesignTokens.darkCard;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkCardForeground = DesignTokens.darkCardForeground;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkPrimary = DesignTokens.darkPrimary;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkSecondary = DesignTokens.darkSecondary;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkAccent = DesignTokens.darkAccent;
  @Deprecated('dùng context.tokens — AppTokens (P1 web fidelity)')
  // ignore: deprecated_member_use_from_same_package
  static const Color darkBorder = DesignTokens.darkBorder;
}
