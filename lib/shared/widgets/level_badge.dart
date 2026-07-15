import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// CEFR language level (A1 → C2). The [label] is rendered inside the chip
/// and the [color] is used as the chip background.
enum AppLevel { a1, a2, b1, b2, c1, c2 }

extension on AppLevel {
  String get label {
    switch (this) {
      case AppLevel.a1:
        return 'A1';
      case AppLevel.a2:
        return 'A2';
      case AppLevel.b1:
        return 'B1';
      case AppLevel.b2:
        return 'B2';
      case AppLevel.c1:
        return 'C1';
      case AppLevel.c2:
        return 'C2';
    }
  }

  Color get color {
    switch (this) {
      case AppLevel.a1:
        return const Color(0xFF22C55E);
      case AppLevel.a2:
        return const Color(0xFF84CC16);
      case AppLevel.b1:
        return const Color(0xFFF59E0B);
      case AppLevel.b2:
        return const Color(0xFFF97316);
      case AppLevel.c1:
        return const Color(0xFFEF4444);
      case AppLevel.c2:
        return const Color(0xFF7C3AED);
    }
  }
}

/// Small pill that displays a CEFR level (e.g. `B1`) in a level-specific
/// colour. Use [onLevel] as a click target when the level doubles as a
/// filter chip.
class LevelBadge extends StatelessWidget {
  const LevelBadge({
    super.key,
    required this.level,
    this.onTap,
    this.compact = false,
  });

  /// Accepts the app's [AppLevel] enum or a raw string. The raw string
  /// matching is case-insensitive ("a1", "A1", "B2" all work).
  factory LevelBadge.fromString(
    String? raw, {
    Key? key,
    VoidCallback? onTap,
    bool compact = false,
  }) {
    final normalised = (raw ?? '').toLowerCase();
    final lvl = AppLevel.values.firstWhere(
      (e) => e.name == normalised,
      orElse: () => AppLevel.a1,
    );
    return LevelBadge(level: lvl, onTap: onTap, compact: compact, key: key);
  }

  final AppLevel level;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bg = level.color;
    final hPad = compact ? DesignTokens.spacingSm : 10.0;
    final vPad = compact ? 2.0 : DesignTokens.spacingXs;
    final fontSize = compact ? 11.0 : 12.0;
    final chip = Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          color: DesignTokens.card,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          letterSpacing: 0.4,
        ),
      ),
    );
    if (onTap == null) return chip;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: chip,
    );
  }
}
