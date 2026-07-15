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

  // ===== Common Layout Paddings/Gaps =====
  // Source: web mobile padding patterns (tailwind p-4 = 16, p-5 = 20, gap-6 = 24)
  static const double cardPadding = spacingMd; // p-4 — nội dung card
  static const double sectionGap =
      spacingLg; // gap-6 — khoảng cách giữa các section
  static const double screenHorizontalPadding =
      20; // p-5 — padding ngang screen theo web mobile
  static const double bottomNavHeight =
      56; // h-14 — Material bottom nav standard

  // ===== AppBar / Header Heights =====
  static const double appBarHeight = 56; // h-14 — Material AppBar
  static const double headerHeight = 64; // h-16 — mobile header theo web

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
  // Source: thamkhao/deutschtiger-frontend/src/index.css — banner info, xanh dương nhạt
  static const Color info = Color(0xFF3B82F6);
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
  // Source: thamkhao/deutschtiger-frontend/src/index.css `.dark` selector
  // Bản đầy đủ mapping theo light pattern (muted, muted-foreground, card-foreground,
  // secondary, accent, border) — light bump từng L để pairs (card↔bg, border↔card)
  // đạt ~1.5× contrast. Web dùng HSL: bg=220 13% 9%, card=14%, muted=22%, border=26%.
  static const Color darkBackground = Color(0xFF14171F); // hsl(220, 13%, 9%)
  static const Color darkForeground = Color(0xFFFAFAFA); // hsl(0, 0%, 98%)
  static const Color darkMuted = Color(0xFF383B45); // hsl(220, 13%, 22%)
  static const Color darkMutedForeground = Color(
    0xFFB7BCC4,
  ); // hsl(220, 9%, 72%)
  static const Color darkCard = Color(0xFF1F242E); // hsl(220, 13%, 14%)
  static const Color darkCardBackground = darkCard;
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFF5BB8E6); // hsl(200, 85%, 65%)
  static const Color darkPrimaryForeground = Color(0xFF08131A);
  static const Color darkSecondary = Color(0xFF3A3F4B); // hsl(220, 13%, 24%)
  static const Color darkAccent = Color(
    0xFF5BB8E6,
  ); // hsl(200, 85%, 65%) — same as primary in dark
  static const Color darkBorder = Color(0xFF383F4B); // hsl(220, 13%, 26%)
  static const Color darkRing = darkPrimary;
  static const Color darkDestructive = Color(0xFFF87171);
  static const Color darkSuccess = Color(0xFF4ADE80);
  static const Color darkError = darkDestructive;
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkInfo = Color(0xFF60A5FA);
  static const Color darkBrand = Color(0xFFFBBF24);
  static const Color darkSidebar = Color(0xFF28202A);
  static const Color darkAuthBackground = darkBackground;
  static const Color darkTigerOrange = Color(0xFFFB923C);
  static const Color darkOrange50 = Color(0xFF29170C);
  static const Color darkOrange100 = Color(0xFF431F0A);
  static const Color darkOrange500 = Color(0xFFFB923C);
  static const Color darkOrange600 = Color(0xFFF97316);
  static const Color darkRose600 = Color(0xFFFB7185);

  // ===== Shadow Tokens =====
  // Source: thamkhao/deutschtiger-frontend/src/index.css `.card` / `.card-sm` /
  // `.card-interactive` — map theo Tailwind shadow-sm/md/lg scale.
  // Dùng List<BoxShadow> để áp được cho nhiều Container cùng lúc
  // (Container chỉ nhận 1 BoxShadow, nên cần BoxDecoration với shadows[]).
  static const List<BoxShadow> shadowSm = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08) ~ shadow-sm Tailwind
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowMd = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F000000), // rgba(0,0,0,0.12) ~ shadow-md Tailwind
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F000000), // ~ shadow's 2nd layer
      blurRadius: 2,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowLg = <BoxShadow>[
    BoxShadow(
      color: Color(0x29000000), // rgba(0,0,0,0.16) ~ shadow-lg Tailwind
      blurRadius: 15,
      offset: Offset(0, 10),
    ),
    BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 4)),
  ];

  // Web "card" 2-layer shadow từ index.css `.card`:
  //   0 2px 8px rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.03)
  static const List<BoxShadow> shadowCard = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F000000), // 0.06
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x08000000), // 0.03
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  // ===== Exam Tokens (light) =====
  // Source: thamkhao/deutschtiger-frontend/src/styles/exam-tokens.css
  static const Color examActive = Color(
    0xFF2563EB,
  ); // hsl(217,91%,60%) blue-600
  static const Color examActiveSoft = Color(
    0xFFEFF6FF,
  ); // hsl(214,95%,95%) blue-50
  static const Color examActiveFg = Color(0xFFFFFFFF);
  static const Color examActiveStrong = Color(
    0xFF1D4ED8,
  ); // hsl(221,83%,53%) blue-700

  static const Color examSuccess = Color(
    0xFF059669,
  ); // hsl(160,84%,39%) emerald-600
  static const Color examSuccessSoft = Color(
    0xFFECFDF5,
  ); // hsl(152,81%,96%) emerald-50
  static const Color examSuccessFg = Color(0xFF065F46); // hsl(160,84%,25%)
  static const Color examSuccessBorder = Color(
    0xFF6EE7B7,
  ); // hsl(156,72%,67%) emerald-300

  static const Color examDanger = Color(0xFFDC2626); // hsl(0,72%,51%) red-600
  static const Color examDangerSoft = Color(
    0xFFFEF2F2,
  ); // hsl(0,86%,97%) red-50
  static const Color examDangerFg = Color(0xFF991B1B); // hsl(0,70%,35%)
  static const Color examDangerBorder = Color(
    0xFFFCA5A5,
  ); // hsl(0,94%,82%) red-300

  static const Color examWarnSoft = Color(
    0xFFFFFBEB,
  ); // hsl(48,96%,95%) yellow-50
  static const Color examWarnBorder = Color(
    0xFFFBBF24,
  ); // hsl(45,93%,65%) yellow-400
  static const Color examWarnFg = Color(
    0xFF92400E,
  ); // hsl(35,91%,33%) amber-700

  static const Color examTextPrimary = Color(0xFF1A1A1A); // hsl(0,0%,10%)
  static const Color examTextSecondary = Color(0xFF5A6070); // hsl(220,9%,38%)
  static const Color examTextTertiary = Color(0xFF878D98); // hsl(220,9%,55%)
  static const Color examBorder = Color(0xFFE2E5EC); // hsl(220,13%,91%)

  // ===== Exam Tokens (dark) =====
  static const Color examActiveDark = Color(0xFF3B82F6); // hsl(217,91%,55%)
  static const Color examActiveSoftDark = Color(0xFF0D1F47); // hsl(217,91%,14%)
  static const Color examActiveStrongDark = Color(
    0xFF93C5FD,
  ); // hsl(213,94%,78%) blue-300

  static const Color examSuccessDark = Color(0xFF047857); // hsl(160,70%,38%)
  static const Color examSuccessSoftDark = Color(
    0xFF022C22,
  ); // hsl(160,84%,10%)
  static const Color examSuccessFgDark = Color(0xFF6EE7B7); // hsl(156,72%,75%)
  static const Color examSuccessBorderDark = Color(
    0xFF065F46,
  ); // hsl(160,70%,35%)

  static const Color examDangerDark = Color(0xFFCF1C1C); // hsl(0,72%,48%)
  static const Color examDangerSoftDark = Color(0xFF3F0808); // hsl(0,70%,14%)
  static const Color examDangerFgDark = Color(0xFFFCA5A5); // hsl(0,94%,82%)
  static const Color examDangerBorderDark = Color(0xFF7F1D1D); // hsl(0,70%,38%)

  static const Color examWarnSoftDark = Color(0xFF261C05); // hsl(45,50%,14%)
  static const Color examWarnBorderDark = Color(0xFFD97706); // hsl(45,80%,50%)
  static const Color examWarnFgDark = Color(0xFFFDE68A); // hsl(45,93%,78%)

  static const Color examTextPrimaryDark = Color(0xFFFAFAFA); // hsl(0,0%,98%)
  static const Color examTextSecondaryDark = Color(
    0xFFCBCFD6,
  ); // hsl(220,9%,80%)
  static const Color examTextTertiaryDark = Color(
    0xFF9EA3AC,
  ); // hsl(220,9%,65%)
  static const Color examBorderDark = Color(0xFF2E3340); // hsl(220,13%,24%)

  // ===== Bottom Nav / Tab Colors =====
  // Source: web bottom-nav.tsx — primary active, muted-foreground inactive.
  static const Color tabActiveColor = primary; // orange-500
  static const Color tabInactiveColor = mutedForeground; // hsl(25, 5%, 45%)

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

  // Source: web bottom-nav.tsx — label 12px w500, màu foreground.
  static const TextStyle bottomNavLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
