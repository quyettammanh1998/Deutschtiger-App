import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Cheap CustomPainter port of `particle-words-canvas.tsx` /
/// `particle-words-engine.ts` — ambient floating dot particles plus a small
/// set of German words cycling through fixed positions, over dark bg
/// `#050118`. No package added; single [AnimationController] repaint tick.
class ParticleWordsCanvas extends StatefulWidget {
  const ParticleWordsCanvas({super.key});

  @override
  State<ParticleWordsCanvas> createState() => _ParticleWordsCanvasState();
}

class _ParticleWordsCanvasState extends State<ParticleWordsCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Dot> _dots;
  final _rng = math.Random(7);

  static const _wordSets = [
    ['Hallo', 'Danke', 'Liebe', 'Freund', 'Sprache', 'Wanderlust'],
    ['Deutsch', 'Lernen', 'Schön', 'Traum', 'Reise', 'Glück'],
    ['Morgen', 'Herz', 'Welt', 'Stern', 'Musik', 'Zukunft'],
  ];
  static const _wordPositions = [
    Offset(0.25, 0.10),
    Offset(0.75, 0.10),
    Offset(0.25, 0.88),
    Offset(0.75, 0.88),
  ];
  static const _colors = [
    Color(0xFFF97316),
    Color(0xFF38BDF8),
    Color(0xFFFB7185),
    Color(0xFF34D399),
    Color(0xFFA78BFA),
    Color(0xFF67E8F9),
  ];

  @override
  void initState() {
    super.initState();
    _dots = List.generate(48, (i) {
      return _Dot(
        pos: Offset(_rng.nextDouble(), _rng.nextDouble()),
        velocity: Offset((_rng.nextDouble() - 0.5) * 0.02, (_rng.nextDouble() - 0.5) * 0.02),
        size: 1 + _rng.nextDouble() * 2,
        color: _colors[i % _colors.length],
        alpha: 0.2 + _rng.nextDouble() * 0.4,
      );
    });
    // ~18s loop: 3 word sets x 5s morph + fade time — cheap single
    // repeating controller drives both dot drift and word cross-fade.
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticlePainter(
            t: _controller.value,
            dots: _dots,
            wordSets: _wordSets,
            wordPositions: _wordPositions,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Dot {
  _Dot({required this.pos, required this.velocity, required this.size, required this.color, required this.alpha});
  Offset pos;
  final Offset velocity;
  final double size;
  final Color color;
  final double alpha;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.t, required this.dots, required this.wordSets, required this.wordPositions});

  final double t;
  final List<_Dot> dots;
  final List<List<String>> wordSets;
  final List<Offset> wordPositions;

  @override
  void paint(Canvas canvas, Size size) {
    // Ambient dots drift with wrap-around; positions are fractional and
    // advanced deterministically by `t` so no per-frame mutation is needed.
    for (final dot in dots) {
      final dx = (dot.pos.dx + dot.velocity.dx * t * 60) % 1.0;
      final dy = (dot.pos.dy + dot.velocity.dy * t * 60) % 1.0;
      final p = Offset(dx * size.width, dy * size.height);
      canvas.drawCircle(p, dot.size, Paint()..color = dot.color.withValues(alpha: dot.alpha));
    }

    // 3 word sets cycle every 1/3 of the loop, with a short cross-fade.
    final setCount = wordSets.length;
    final segment = 1.0 / setCount;
    final rawIndex = t / segment;
    final currentIndex = rawIndex.floor() % setCount;
    final localT = rawIndex - rawIndex.floor();
    final fadeOpacity = localT > 0.85 ? (1 - (localT - 0.85) / 0.15) : 1.0;

    final words = wordSets[currentIndex];
    for (var i = 0; i < wordPositions.length && i < words.length; i++) {
      final pos = wordPositions[i];
      final textPainter = TextPainter(
        text: TextSpan(
          text: words[i],
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55 * fadeOpacity),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final center = Offset(pos.dx * size.width, pos.dy * size.height);
      textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => oldDelegate.t != t;
}
