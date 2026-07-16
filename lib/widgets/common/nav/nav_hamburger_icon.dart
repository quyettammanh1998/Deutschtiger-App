import 'package:flutter/widgets.dart';

/// "Thêm" tab glyph — 3 horizontal rounded-cap strokes, ported 1:1 from web
/// `bottom-nav.tsx`'s inline SVG (`viewBox="0 0 24 24"`,
/// `d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"`, `strokeWidth="2"`,
/// round caps). No matching glyph exists in [AppIcons] (bespoke feature
/// icons) or the Phosphor lookup — Phosphor's closest ("list") renders with
/// bullet dots, not plain lines — so this is a small local painter instead
/// of a shared icon (kept out of `lib/core/icons/` per this phase's file
/// ownership boundary).
class NavHamburgerIcon extends StatelessWidget {
  const NavHamburgerIcon({super.key, this.size = 20, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HamburgerPainter(color: color),
    );
  }
}

class _HamburgerPainter extends CustomPainter {
  const _HamburgerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Web SVG is a 24x24 viewBox; scale strokes/positions proportionally.
    final scale = size.width / 24;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    final xStart = 3.75 * scale;
    final xEnd = 20.25 * scale;
    for (final y in [6.75, 12.0, 17.25]) {
      final scaledY = y * scale;
      canvas.drawLine(
        Offset(xStart, scaledY),
        Offset(xEnd, scaledY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HamburgerPainter oldDelegate) =>
      oldDelegate.color != color;
}
