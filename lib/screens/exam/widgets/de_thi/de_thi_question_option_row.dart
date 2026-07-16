import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';

/// Web parity: single option row inside `de-thi-question-card.tsx` — visual
/// states for selected / correct / wrong / dimmed (post-submit review).
class DeThiQuestionOptionRow extends StatelessWidget {
  const DeThiQuestionOptionRow({
    super.key,
    required this.optionKey,
    required this.label,
    required this.selected,
    required this.isCorrect,
    required this.isWrong,
    required this.dimmed,
    required this.onTap,
  });

  final String optionKey;
  final String label;
  final bool selected;
  final bool isCorrect;
  final bool isWrong;
  final bool dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final emerald = const Color(0xFF10B981);
    final rose = const Color(0xFFE11D48);
    final blue = const Color(0xFF3B82F6);

    Color border = tokens.border.withValues(alpha: 0.6);
    Color badgeBg = tokens.muted;
    Color badgeFg = tokens.mutedForeground;
    Color textColor = tokens.foreground;
    Color rowBg = Colors.transparent;
    Widget? icon;
    var opacity = 1.0;

    if (isCorrect) {
      rowBg = emerald.withValues(alpha: 0.1);
      border = emerald.withValues(alpha: 0.5);
      badgeBg = emerald.withValues(alpha: 0.15);
      badgeFg = emerald;
      textColor = emerald;
      icon = Icon(AppPhosphorIcons.checkCircle, size: 16, color: emerald);
    } else if (isWrong) {
      rowBg = rose.withValues(alpha: 0.08);
      border = rose.withValues(alpha: 0.5);
      badgeBg = rose.withValues(alpha: 0.15);
      badgeFg = rose;
      textColor = rose;
      icon = Icon(AppPhosphorIcons.xCircle, size: 16, color: rose);
    } else if (dimmed) {
      opacity = 0.55;
    } else if (selected) {
      rowBg = blue.withValues(alpha: 0.08);
      border = blue;
      badgeBg = blue;
      badgeFg = Colors.white;
      textColor = blue;
    }

    return Opacity(
      opacity: opacity,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: rowBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              if (icon != null) ...[icon, const SizedBox(width: 8)],
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  optionKey,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: badgeFg,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: selected && !isCorrect && !isWrong
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
