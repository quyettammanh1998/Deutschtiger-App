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
  static final Color background = DesignTokens.background;
  static final Color foreground = DesignTokens.foreground;
  static final Color muted = DesignTokens.muted;
  static final Color mutedForeground = DesignTokens.mutedForeground;
  static final Color card = DesignTokens.card;
  static final Color cardBackground = DesignTokens.cardBackground;
  static final Color cardForeground = DesignTokens.cardForeground;
  static final Color primary = DesignTokens.primary;
  static final Color primaryForeground = DesignTokens.primaryForeground;
  static final Color secondary = DesignTokens.secondary;
  static final Color accent = DesignTokens.accent;
  static final Color border = DesignTokens.border;
  static final Color ring = DesignTokens.ring;
  static final Color destructive = DesignTokens.destructive;
  static final Color success = DesignTokens.success;
  static final Color error = DesignTokens.error;
  static final Color warning = DesignTokens.warning;
  static final Color brand = DesignTokens.brand;
  static final Color brandDark = DesignTokens.brandDark;
  static final Color sidebar = DesignTokens.sidebar;

  // ===== Auth colors ===== (delegated to DesignTokens)
  static final Color authBackground = DesignTokens.authBackground;
  static final Color tigerOrange = DesignTokens.tigerOrange;
  static final Color tigerOrangeDark = DesignTokens.tigerOrangeDark;
  static final Color orange50 = DesignTokens.orange50;
  static final Color orange100 = DesignTokens.orange100;
  static final Color orange500 = DesignTokens.orange500;
  static final Color orange600 = DesignTokens.orange600;
  static final Color rose600 = DesignTokens.rose600;

  /// Gradient nút chính: from-orange-500 to-rose-600 (web login button).
  static final LinearGradient primaryGradient = DesignTokens.primaryGradient;

  // ===== Dark theme (delegated to DesignTokens) =====
  static final Color darkBackground = DesignTokens.darkBackground;
  static final Color darkForeground = DesignTokens.darkForeground;
  static final Color darkCard = DesignTokens.darkCard;
  static final Color darkPrimary = DesignTokens.darkPrimary;
  static final Color darkBorder = DesignTokens.darkBorder;
}
