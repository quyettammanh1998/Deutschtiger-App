import 'package:flutter/material.dart';

/// Resolves web Tailwind gradient utility classes (e.g. `from-orange-500`,
/// `to-emerald-600`) stored on [Scenario.gradientFrom]/[gradientTo] into
/// Flutter [Color]s, so the scenario tiles keep their per-topic hue without
/// re-deriving a palette server-side.
class TailwindGradient {
  const TailwindGradient._();

  static const Map<String, int> _palette500 = {
    'amber': 0xFFF59E0B,
    'orange': 0xFFF97316,
    'red': 0xFFEF4444,
    'rose': 0xFFF43F5E,
    'pink': 0xFFEC4899,
    'fuchsia': 0xFFD946EF,
    'purple': 0xFFA855F7,
    'violet': 0xFF8B5CF6,
    'indigo': 0xFF6366F1,
    'blue': 0xFF3B82F6,
    'sky': 0xFF0EA5E9,
    'cyan': 0xFF06B6D4,
    'teal': 0xFF14B8A6,
    'emerald': 0xFF10B981,
    'green': 0xFF22C55E,
    'lime': 0xFF84CC16,
    'yellow': 0xFFEAB308,
    'slate': 0xFF64748B,
    'zinc': 0xFF71717A,
  };

  static const Map<String, int> _palette600 = {
    'amber': 0xFFD97706,
    'orange': 0xFFEA580C,
    'red': 0xFFDC2626,
    'rose': 0xFFE11D48,
    'pink': 0xFFDB2777,
    'fuchsia': 0xFFC026D3,
    'purple': 0xFF9333EA,
    'violet': 0xFF7C3AED,
    'indigo': 0xFF4F46E5,
    'blue': 0xFF2563EB,
    'sky': 0xFF0284C7,
    'cyan': 0xFF0891B2,
    'teal': 0xFF0D9488,
    'emerald': 0xFF059669,
    'green': 0xFF16A34A,
    'lime': 0xFF65A30D,
    'yellow': 0xFFCA8A04,
    'slate': 0xFF475569,
    'zinc': 0xFF3F3F46,
  };

  static final RegExp _classPattern = RegExp(r'^(?:from|to)-([a-z]+)-(\d+)$');

  /// Parses a class like `from-orange-500` into a [Color]; falls back to
  /// [fallback] (orange, the app's primary brand hue) when unrecognized.
  static Color resolve(String tailwindClass, {Color fallback = const Color(0xFFF7911D)}) {
    final match = _classPattern.firstMatch(tailwindClass.trim());
    if (match == null) return fallback;
    final name = match.group(1)!;
    final shade = match.group(2);
    final table = shade == '600' ? _palette600 : _palette500;
    final hex = table[name];
    return hex != null ? Color(hex) : fallback;
  }

  static LinearGradient gradient(String from, String to) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [resolve(from), resolve(to)],
  );
}
