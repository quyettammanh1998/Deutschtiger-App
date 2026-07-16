import 'package:flutter/material.dart';

/// Maps backend `vocabulary_topics.color` (a Tailwind gradient class string
/// e.g. `"from-blue-400 to-blue-600"`, seeded in
/// `thamkhao/deutschtiger-backend/migrations/041_seed_essential_words_a1.sql`)
/// to a Flutter [Gradient] — Flutter can't consume Tailwind class names
/// directly, so this is a small approximate palette lookup (shade number is
/// ignored; only the base hue matters for the icon tile look).
const _kTailwindHues = {
  'blue': Color(0xFF3B82F6),
  'pink': Color(0xFFEC4899),
  'amber': Color(0xFFF59E0B),
  'indigo': Color(0xFF6366F1),
  'emerald': Color(0xFF10B981),
  'green': Color(0xFF22C55E),
  'cyan': Color(0xFF06B6D4),
  'red': Color(0xFFEF4444),
  'lime': Color(0xFF84CC16),
  'violet': Color(0xFF8B5CF6),
  'teal': Color(0xFF14B8A6),
  'fuchsia': Color(0xFFD946EF),
  'rose': Color(0xFFF43F5E),
  'sky': Color(0xFF0EA5E9),
  'orange': Color(0xFFF97316),
};

/// Parses `"from-<hue>-<shade> to-<hue>-<shade>"` into a start/end
/// [LinearGradient]. Falls back to the app's orange brand gradient when
/// [rawColor] is null/unparseable.
LinearGradient topicTailwindGradient(String? rawColor, Color fallback) {
  if (rawColor == null || rawColor.isEmpty) {
    return LinearGradient(
      colors: [fallback, Color.lerp(fallback, Colors.black, 0.2)!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  final match = RegExp(r'from-([a-z]+)-\d+ to-([a-z]+)-\d+').firstMatch(rawColor);
  final startHue = match != null ? _kTailwindHues[match.group(1)] : null;
  final endHue = match != null ? _kTailwindHues[match.group(2)] : null;
  return LinearGradient(
    colors: [startHue ?? fallback, endHue ?? startHue ?? fallback],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Rounded gradient icon tile — web parity: topic card's
/// `h-10 w-10 rounded-xl bg-gradient-to-br` emoji tile.
class TopicGradientTile extends StatelessWidget {
  const TopicGradientTile({
    super.key,
    required this.icon,
    required this.color,
    required this.fallback,
    this.size = 40,
  });

  final String icon;
  final String? color;
  final Color fallback;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: topicTailwindGradient(color, fallback),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(icon, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}
