import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';

/// Web parity: post-submit "Dịch tiếng Việt" / "Giải thích" toggle links and
/// their reveal panels in `de-thi-question-card.tsx`.
class DeThiToggleLink extends StatelessWidget {
  const DeThiToggleLink({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class DeThiTranslationBlock extends StatelessWidget {
  const DeThiTranslationBlock({super.key, required this.question});

  final DeThiQuestion question;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final blue = const Color(0xFF2563EB);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: blue.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BẢN DỊCH TIẾNG VIỆT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            question.questionVi,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 6),
          for (final key in question.optionsVi.keys)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$key) ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: blue,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      question.optionsVi[key] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class DeThiExplanationBlock extends StatelessWidget {
  const DeThiExplanationBlock({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final sky = const Color(0xFF0284C7);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sky.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: sky, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppPhosphorIcons.lightbulb, size: 18, color: sky),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giải thích',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    color: sky,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(fontSize: 13, height: 1.4, color: sky),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
