import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Color + nhãn tiếng Việt cho mỗi level (A1..C1). Tách riêng để giữ các file
/// màn hình gọn.
class GrammarLevelMeta {
  const GrammarLevelMeta({
    required this.color,
    required this.emoji,
    required this.label,
  });

  final Color color;
  final String emoji;
  final String label;
}

const _levelMeta = <String, GrammarLevelMeta>{
  'A1': GrammarLevelMeta(
    color: Color(0xFF10B981),
    emoji: '🌱',
    label: 'Sơ cấp 1',
  ),
  'A2': GrammarLevelMeta(
    color: Color(0xFF0EA5E9),
    emoji: '🚀',
    label: 'Sơ cấp 2',
  ),
  'B1': GrammarLevelMeta(
    color: Color(0xFF8B5CF6),
    emoji: '🎯',
    label: 'Trung cấp 1',
  ),
  'B2': GrammarLevelMeta(
    color: Color(0xFFF59E0B),
    emoji: '🏆',
    label: 'Trung cấp 2',
  ),
  'C1': GrammarLevelMeta(color: Color(0xFFF43F5E), emoji: '⭐', label: 'Cao cấp'),
};

GrammarLevelMeta grammarLevelMeta(String level) =>
    _levelMeta[level.toUpperCase()] ??
    const GrammarLevelMeta(
      color: AppColors.tigerOrange,
      emoji: '📘',
      label: '',
    );

/// Pill badge hiển thị level ở header + lesson card.
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
