import 'package:flutter/material.dart';

/// Palette trích từ web `src/index.css` (xem docs/design-tokens-from-web.md).
///
/// Light = tone hồng/cam ấm (con hổ Đức). V1 chỉ dùng light; dark để sẵn cho sau.
class AppColors {
  const AppColors._();

  // ===== Light theme =====
  static const background = Color(0xFFFBF4EF); // hsl(25,47%,97%)
  static const foreground = Color(0xFF2E2E2E); // hsl(0,0%,18%)
  static const muted = Color(0xFFF3F1F0); // hsl(25,10%,95%)
  static const mutedForeground = Color(0xFF76726F); // hsl(25,5%,45%)
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF2E2E2E);
  static const primary = Color(0xFFFF8FA3); // hsl(351,100%,78%) hồng
  static const primaryForeground = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFFAE0CF); // hsl(25,82%,89%)
  static const accent = Color(0xFFE8EFC9); // hsl(70,50%,85%)
  static const border = Color(0xFFE8E4E1); // hsl(25,10%,90%)
  static const ring = primary;
  static const destructive = Color(0xFFEF4444); // hsl(0,84%,60%)
  static const success = Color(0xFF22C55E); // hsl(142,71%,45%)
  static const warning = Color(0xFFF59E0B); // hsl(38,92%,50%)
  static const brand = Color(0xFFF59E1B); // hsl(32,93%,54%) cam hổ
  static const brandDark = Color(0xFFD9850E); // hsl(32,93%,46%)
  static const sidebar = Color(0xFFF7DCE2); // hsl(351,60%,92%)

  // ===== UI thật từ web login (src/pages/auth/login-page.tsx) =====
  static const authBackground = Color(0xFFFFFBF5); // bg-[#FFFBF5] kem ấm
  static const tigerOrange = Color(0xFFF7931E); // màu cam logo hổ
  static const tigerOrangeDark = Color(0xFFE07D18);
  static const orange50 = Color(0xFFFFF7ED); // input bg orange-50
  static const orange100 = Color(0xFFFFEDD5); // border orange-100
  static const orange500 = Color(0xFFF97316); // gradient start, accent text
  static const orange600 = Color(0xFFEA580C);
  static const rose600 = Color(0xFFE11D48); // gradient end

  /// Gradient nút chính: from-orange-500 to-rose-600 (web login button).
  static const primaryGradient = LinearGradient(
    colors: [orange500, rose600],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ===== Dark theme (để sẵn cho version sau) =====
  static const darkBackground = Color(0xFF14171F); // hsl(220,13%,9%)
  static const darkForeground = Color(0xFFFAFAFA); // hsl(0,0%,98%)
  static const darkCard = Color(0xFF1F242E); // hsl(220,13%,14%)
  static const darkPrimary = Color(0xFF5BB8E6); // hsl(200,85%,65%) xanh
  static const darkBorder = Color(0xFF383F4B); // hsl(220,13%,26%)
}
