import 'package:flutter/material.dart';

/// Source-of-truth color/radius tokens mirroring web `src/index.css`
/// `:root` (light) and `.dark` — see `docs/design-tokens-from-web.md`.
///
/// Registered on [ThemeData.extensions] in `app_theme.dart` so widgets read
/// theme-correct colors via `context.tokens` instead of the frozen
/// light-only statics in `DesignTokens`/`AppColors` (both `@Deprecated`).
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.background,
    required this.foreground,
    required this.muted,
    required this.mutedForeground,
    required this.card,
    required this.cardForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.accent,
    required this.accentForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.destructive,
    required this.destructiveForeground,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarActive,
    required this.success,
    required this.successForeground,
    required this.warning,
    required this.warningForeground,
    required this.brand,
    required this.brandDark,
    required this.brandForeground,
    required this.radius,
  });

  final Color background;
  final Color foreground;
  final Color muted;
  final Color mutedForeground;
  final Color card;
  final Color cardForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color accent;
  final Color accentForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color destructive;
  final Color destructiveForeground;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarActive;
  final Color success;
  final Color successForeground;
  final Color warning;
  final Color warningForeground;
  final Color brand;
  final Color brandDark;
  final Color brandForeground;

  /// `--radius: 1rem` — mặc định border-radius toàn app (web).
  final double radius;

  /// Light theme — web `:root`. Primary = cam hổ hsl(32, 93%, 54%).
  static const AppTokens light = AppTokens(
    background: Color(0xFFFBF7F4),
    foreground: Color(0xFF2E2E2E),
    muted: Color(0xFFF4F2F1),
    mutedForeground: Color(0xFF78726D),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF2E2E2E),
    primary: Color(0xFFF7911D),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFFADFCC),
    secondaryForeground: Color(0xFF2E2E2E),
    accent: Color(0xFFE6ECC6),
    accentForeground: Color(0xFF2E2E2E),
    border: Color(0xFFE8E5E3),
    input: Color(0xFFE8E5E3),
    ring: Color(0xFFF7911D),
    destructive: Color(0xFFEF4343),
    destructiveForeground: Color(0xFFFFFFFF),
    sidebar: Color(0xFFF9F3EC),
    sidebarForeground: Color(0xFF2E2E2E),
    sidebarActive: Color(0xFFF7911D),
    success: Color(0xFF21C45D),
    successForeground: Color(0xFFFFFFFF),
    warning: Color(0xFFF59F0A),
    warningForeground: Color(0xFF2E2E2E),
    brand: Color(0xFFF7911D),
    brandDark: Color(0xFFE27D08),
    brandForeground: Color(0xFFFFFFFF),
    radius: 16,
  );

  /// Dark theme — web `.dark`. Primary flips to xanh dương hsl(200, 85%, 65%).
  static const AppTokens dark = AppTokens(
    background: Color(0xFF14161A),
    foreground: Color(0xFFFAFAFA),
    muted: Color(0xFF31363F),
    mutedForeground: Color(0xFFB1B5BE),
    card: Color(0xFF1F2228),
    cardForeground: Color(0xFFFAFAFA),
    primary: Color(0xFF5ABFF2),
    primaryForeground: Color(0xFFFAFAFA),
    secondary: Color(0xFF353B45),
    secondaryForeground: Color(0xFFFAFAFA),
    accent: Color(0xFF5ABFF2),
    accentForeground: Color(0xFFFAFAFA),
    border: Color(0xFF3A3F4B),
    input: Color(0xFF353B45),
    ring: Color(0xFF5ABFF2),
    destructive: Color(0xFF811D1D),
    destructiveForeground: Color(0xFFFAFAFA),
    sidebar: Color(0xFF1B1D23),
    sidebarForeground: Color(0xFFFAFAFA),
    sidebarActive: Color(0xFF5ABFF2),
    success: Color(0xFF21C45D),
    successForeground: Color(0xFFFFFFFF),
    warning: Color(0xFFF59F0A),
    warningForeground: Color(0xFF2E2E2E),
    brand: Color(0xFFF7911D),
    brandDark: Color(0xFFE27D08),
    brandForeground: Color(0xFFFFFFFF),
    radius: 16,
  );

  @override
  AppTokens copyWith({
    Color? background,
    Color? foreground,
    Color? muted,
    Color? mutedForeground,
    Color? card,
    Color? cardForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? accent,
    Color? accentForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? destructive,
    Color? destructiveForeground,
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarActive,
    Color? success,
    Color? successForeground,
    Color? warning,
    Color? warningForeground,
    Color? brand,
    Color? brandDark,
    Color? brandForeground,
    double? radius,
  }) {
    return AppTokens(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      sidebar: sidebar ?? this.sidebar,
      sidebarForeground: sidebarForeground ?? this.sidebarForeground,
      sidebarActive: sidebarActive ?? this.sidebarActive,
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      brand: brand ?? this.brand,
      brandDark: brandDark ?? this.brandDark,
      brandForeground: brandForeground ?? this.brandForeground,
      radius: radius ?? this.radius,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground: Color.lerp(
        primaryForeground,
        other.primaryForeground,
        t,
      )!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground: Color.lerp(
        secondaryForeground,
        other.secondaryForeground,
        t,
      )!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentForeground: Color.lerp(
        accentForeground,
        other.accentForeground,
        t,
      )!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      ring: Color.lerp(ring, other.ring, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveForeground: Color.lerp(
        destructiveForeground,
        other.destructiveForeground,
        t,
      )!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      sidebarForeground: Color.lerp(
        sidebarForeground,
        other.sidebarForeground,
        t,
      )!,
      sidebarActive: Color.lerp(sidebarActive, other.sidebarActive, t)!,
      success: Color.lerp(success, other.success, t)!,
      successForeground: Color.lerp(
        successForeground,
        other.successForeground,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningForeground: Color.lerp(
        warningForeground,
        other.warningForeground,
        t,
      )!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandDark: Color.lerp(brandDark, other.brandDark, t)!,
      brandForeground: Color.lerp(brandForeground, other.brandForeground, t)!,
      radius: (radius + (other.radius - radius) * t),
    );
  }
}

/// Convenience accessor: `context.tokens.primary` etc.
///
/// Falls back to [AppTokens.light] if the current [ThemeData] has no
/// [AppTokens] extension registered (should not happen once `app_theme.dart`
/// wires both light/dark instances, but keeps call sites crash-safe).
extension AppTokensContext on BuildContext {
  AppTokens get tokens =>
      Theme.of(this).extension<AppTokens>() ?? AppTokens.light;
}
