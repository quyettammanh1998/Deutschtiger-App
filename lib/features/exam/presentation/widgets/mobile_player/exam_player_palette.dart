// Brightness-aware color helpers cho mobile player shell (header / footer /
// nav sheet / reading pane). Web dùng Tailwind literal colors
// (`blue-500`, `amber-100`, `green-500`, `indigo-400`, ...) không map thẳng
// vào `AppTokens` (theme semantic) — nên định nghĩa riêng ở đây, tương tự
// cách `ExamDesignTokens` định nghĩa light+dark const nhưng KHÔNG có accessor
// theo `Brightness` (gap đã ghi trong scout report). File này KHÔNG sửa
// `lib/core/**` (ngoài phạm vi sở hữu) — chỉ cung cấp helper cục bộ cho
// widgets trong `mobile_player/`.
import 'package:flutter/material.dart';

/// Web `blue-500` / `blue-500` dark (không đổi qua dark mode trên web).
Color examNavBlue(BuildContext context) => const Color(0xFF3B82F6);

/// Web `blue-50` (light) / `blue-950/30` (dark) — trạng thái "đã trả lời".
Color examNavBlueSoft(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? const Color(0xFF1E2A4A) : const Color(0xFFEFF6FF);
}

/// Web `blue-400` (light) / `blue-500` (dark) border cho ô "đã trả lời".
Color examNavBlueBorder(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? const Color(0xFF3B82F6) : const Color(0xFF60A5FA);
}

/// Web `green-500` (review đúng) / `green-400` dark border.
Color examNavGreen(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? const Color(0xFF4ADE80) : const Color(0xFF22C55E);
}

/// Web `red-500` (review sai) / `red-400` dark border.
Color examNavRed(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
}

/// Web `amber-100`/`amber-700` (light) → `amber-500/20`/`amber-300` (dark) —
/// footer counter pill + nav-toggle.
Color examAmberSoft(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark
      ? const Color(0xFF3D2E0A).withValues(alpha: 0.6)
      : const Color(0xFFFEF3C7);
}

Color examAmberFg(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
}

/// Web `indigo-400` reading-pane left border + `indigo-600`/`indigo-400`
/// heading text.
Color examIndigoBorder(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? const Color(0xFF818CF8) : const Color(0xFF818CF8);
}

Color examIndigoText(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5);
}

/// Pace dot — web `green-500`/`amber-500`/`red-500`, không đổi theo dark.
const examPaceOnTrack = Color(0xFF22C55E);
const examPaceSlow = Color(0xFFF59E0B);
const examPaceBehind = Color(0xFFEF4444);

/// Web orange gradient progress bar (`from-orange-500 to-orange-600`).
const examProgressGradient = LinearGradient(
  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
);

/// 4 màu highlight tối giản cho toolbar (approx web highlight-paint palette).
const List<Color> examHighlightColors = [
  Color(0xFFFDE047), // yellow
  Color(0xFF86EFAC), // green
  Color(0xFF93C5FD), // blue
  Color(0xFFF9A8D4), // pink
];
