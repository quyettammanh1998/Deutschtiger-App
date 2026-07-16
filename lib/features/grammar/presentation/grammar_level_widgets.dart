import 'package:flutter/material.dart';

/// Màu + nhãn tiếng Việt cho mỗi level (A1..C1) — port `LEVEL_CONFIG`/
/// `LEVEL_THEME` bên web (`grammar-home.tsx`, `grammar-level-detail.tsx`).
/// Per-level accent colors are explicit web-hardcoded hues (Tailwind
/// emerald/sky/violet/amber/rose), not app-wide theme — intentionally not
/// sourced from `context.tokens`.
class GrammarLevelMeta {
  const GrammarLevelMeta({
    required this.color,
    required this.gradientEnd,
    required this.emoji,
    required this.label,
    required this.desc,
    required this.badgeBg,
    required this.badgeFg,
  });

  /// Header gradient start / ring stroke / solo-lesson circle fill.
  final Color color;
  final Color gradientEnd;
  final String emoji;
  final String label;
  final String desc;

  /// Tinted "Xem tất cả" CTA + recommended-lesson numbered chip.
  final Color badgeBg;
  final Color badgeFg;
}

const _levelMeta = <String, GrammarLevelMeta>{
  'A1': GrammarLevelMeta(
    color: Color(0xFF10B981),
    gradientEnd: Color(0xFF059669),
    emoji: '🌱',
    label: 'Sơ cấp 1',
    desc: 'Học những điều đầu tiên!',
    badgeBg: Color(0xFFD1FAE5),
    badgeFg: Color(0xFF047857),
  ),
  'A2': GrammarLevelMeta(
    color: Color(0xFF0EA5E9),
    gradientEnd: Color(0xFF0284C7),
    emoji: '🚀',
    label: 'Sơ cấp 2',
    desc: 'Tiếp tục khám phá!',
    badgeBg: Color(0xFFE0F2FE),
    badgeFg: Color(0xFF0369A1),
  ),
  'B1': GrammarLevelMeta(
    color: Color(0xFF8B5CF6),
    gradientEnd: Color(0xFF7C3AED),
    emoji: '🎯',
    label: 'Trung cấp 1',
    desc: 'Đang giỏi lên rồi!',
    badgeBg: Color(0xFFEDE9FE),
    badgeFg: Color(0xFF6D28D9),
  ),
  'B2': GrammarLevelMeta(
    color: Color(0xFFF59E0B),
    gradientEnd: Color(0xFFD97706),
    emoji: '🏆',
    label: 'Trung cấp 2',
    desc: 'Sắp thành chuyên gia!',
    badgeBg: Color(0xFFFEF3C7),
    badgeFg: Color(0xFFB45309),
  ),
  'C1': GrammarLevelMeta(
    color: Color(0xFFF43F5E),
    gradientEnd: Color(0xFFE11D48),
    emoji: '⭐',
    label: 'Cao cấp',
    desc: 'Đỉnh của đỉnh!',
    badgeBg: Color(0xFFFFE4E6),
    badgeFg: Color(0xFFBE123C),
  ),
};

GrammarLevelMeta grammarLevelMeta(String level) =>
    _levelMeta[level.toUpperCase()] ??
    const GrammarLevelMeta(
      color: Color(0xFFF7911D),
      gradientEnd: Color(0xFFE27D08),
      emoji: '📘',
      label: '',
      desc: '',
      badgeBg: Color(0xFFFADFCC),
      badgeFg: Color(0xFFE27D08),
    );

/// Pill badge hiển thị level ở header + lesson card (web: `bg-primary/10
/// text-primary` cho lesson-page badge).
class GrammarLevelBadge extends StatelessWidget {
  const GrammarLevelBadge({super.key, required this.level});
  final String level;

  @override
  Widget build(BuildContext context) {
    final meta = grammarLevelMeta(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: meta.color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Vòng tròn tiến độ (dùng cho level card + level header).
class GrammarProgressRing extends StatelessWidget {
  const GrammarProgressRing({
    super.key,
    required this.completed,
    required this.total,
    required this.size,
    this.color = Colors.white,
  });

  final int completed;
  final int total;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? completed / total : 0.0;
    final allDone = total > 0 && completed == total;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1,
            strokeWidth: 4,
            color: color.withValues(alpha: 0.25),
          ),
          CircularProgressIndicator(
            value: pct,
            strokeWidth: 4,
            color: color,
            backgroundColor: Colors.transparent,
          ),
          if (allDone)
            Icon(Icons.check, color: color, size: size * 0.4)
          else
            Text(
              '$completed/$total',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.22,
              ),
            ),
        ],
      ),
    );
  }
}
