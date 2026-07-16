import 'package:flutter/widgets.dart';

/// Per-tab bottom-nav accent colors (active state only).
///
/// These are NOT semantic [AppTokens] — the web bottom nav
/// (`components/layout/bottom-nav.tsx`) hardcodes a distinct Tailwind color
/// per tab (amber/indigo/emerald/teal) instead of using the app's primary
/// token, so the exact Tailwind hex values are pinned here rather than added
/// to `AppTokens`. Inactive state uses a single shared slate color instead
/// (see [NavTabAccent.inactiveLight]/[inactiveDark] below).
///
/// Source: web Tailwind default palette, `*-600`/`*-400` (text) on
/// `*-100`/`*-500 @ 20% alpha` (pill background), per
/// `thamkhao/deutschtiger-frontend/src/components/layout/bottom-nav.tsx`.
class NavTabAccent {
  const NavTabAccent({
    required this.lightFg,
    required this.lightBg,
    required this.darkFg,
    required this.darkBg,
  });

  final Color lightFg;
  final Color lightBg;
  final Color darkFg;
  final Color darkBg;

  Color fg(bool isDark) => isDark ? darkFg : lightFg;
  Color bg(bool isDark) => isDark ? darkBg : lightBg;
}

/// Table of the 4 web bottom-nav tab accents + the shared inactive color.
abstract final class NavTabAccents {
  /// Trang chủ — amber.
  static const home = NavTabAccent(
    lightFg: Color(0xFFD97706), // amber-600
    lightBg: Color(0xFFFEF3C7), // amber-100
    darkFg: Color(0xFFFBBF24), // amber-400
    darkBg: Color(0x33F59E0B), // amber-500 @ 20%
  );

  /// Thi — indigo.
  static const exam = NavTabAccent(
    lightFg: Color(0xFF4F46E5), // indigo-600
    lightBg: Color(0xFFE0E7FF), // indigo-100
    darkFg: Color(0xFF818CF8), // indigo-400
    darkBg: Color(0x336366F1), // indigo-500 @ 20%
  );

  /// Học — emerald.
  static const learn = NavTabAccent(
    lightFg: Color(0xFF059669), // emerald-600
    lightBg: Color(0xFFD1FAE5), // emerald-100
    darkFg: Color(0xFF34D399), // emerald-400
    darkBg: Color(0x3310B981), // emerald-500 @ 20%
  );

  /// Hội thoại — teal. Used for tab 4 once
  /// `ReleaseFeatureFlags.speaking` (P10 conversation hub) is live.
  static const conversation = NavTabAccent(
    lightFg: Color(0xFF0D9488), // teal-600
    lightBg: Color(0xFFCCFBF1), // teal-100
    darkFg: Color(0xFF2DD4BF), // teal-400
    darkBg: Color(0x3314B8A6), // teal-500 @ 20%
  );

  /// AI tab — APP-ONLY EXCEPTION, no web equivalent (web bottom nav's 4th
  /// slot is always "Hội thoại"). Shown in tab 4's slot only while
  /// `ReleaseFeatureFlags.speaking` is off (see `app_shell.dart`). Reuses
  /// the blue accent the (now-superseded) web more-sheet used for its
  /// AI-adjacent tiles, so the color still reads as intentional rather than
  /// arbitrary once P10 flips the flag and this branch disappears.
  static const ai = NavTabAccent(
    lightFg: Color(0xFF2563EB), // blue-600
    lightBg: Color(0xFFDBEAFE), // blue-100
    darkFg: Color(0xFF60A5FA), // blue-400
    darkBg: Color(0x333B82F6), // blue-500 @ 20%
  );

  /// Inactive tabs (all tabs, including "Thêm") — web `slate-500`/`slate-400`.
  /// Not per-tab; shared by every slot when unselected.
  static const inactiveLight = Color(0xFF64748B); // slate-500
  static const inactiveDark = Color(0xFF94A3B8); // slate-400
}
