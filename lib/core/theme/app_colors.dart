import 'package:flutter/material.dart';

import '../design_tokens.dart';

/// Palette trích từ web `src/index.css` (xem docs/design-tokens-from-web.md).
///
/// Light = tone hồng/cam ấm (con hổ Đức). V1 chỉ dùng light; dark để sẵn cho sau.
///
/// @deprecated Use [DesignTokens] directly for new code.
/// This class re-exports from DesignTokens for backward compatibility.
class AppColors {
  const AppColors._();

  // ===== Light theme ===== (delegated to DesignTokens)
  static const Color background = DesignTokens.background;
  static const Color foreground = DesignTokens.foreground;
  static const Color muted = DesignTokens.muted;
  static const Color mutedForeground = DesignTokens.mutedForeground;
  static const Color card = DesignTokens.card;
  static const Color cardBackground = DesignTokens.cardBackground;
  static const Color cardForeground = DesignTokens.cardForeground;
  static const Color primary = DesignTokens.primary;
  static const Color primaryForeground = DesignTokens.primaryForeground;
  static const Color secondary = DesignTokens.secondary;
  static const Color accent = DesignTokens.accent;
  static const Color border = DesignTokens.border;
  static const Color ring = DesignTokens.ring;
  static const Color destructive = DesignTokens.destructive;
  static const Color success = DesignTokens.success;
  static const Color error = DesignTokens.error;
  static const Color warning = DesignTokens.warning;
  static const Color info = DesignTokens.info;
  static const Color brand = DesignTokens.brand;
  static const Color brandDark = DesignTokens.brandDark;
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
  static const Color darkBackground = DesignTokens.darkBackground;
  static const Color darkForeground = DesignTokens.darkForeground;
  static const Color darkMuted = DesignTokens.darkMuted;
  static const Color darkMutedForeground = DesignTokens.darkMutedForeground;
  static const Color darkCard = DesignTokens.darkCard;
  static const Color darkCardForeground = DesignTokens.darkCardForeground;
  static const Color darkPrimary = DesignTokens.darkPrimary;
  static const Color darkSecondary = DesignTokens.darkSecondary;
  static const Color darkAccent = DesignTokens.darkAccent;
  static const Color darkBorder = DesignTokens.darkBorder;
}
