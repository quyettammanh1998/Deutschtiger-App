import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Web parity: amber disclaimer strip + progress strip in
/// `de-thi-practice-page.tsx` — before submit: passage progress bar; after
/// submit: score chip + "Làm lại" (retry) button.
class DeThiPracticeDisclaimer extends StatelessWidget {
  const DeThiPracticeDisclaimer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final amber = const Color(0xFFF59F0A);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: amber.withValues(alpha: 0.08),
        border: Border(bottom: BorderSide(color: amber.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          Icon(AppPhosphorIcons.warning, size: 14, color: amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeThiPracticeProgressStrip extends StatelessWidget {
  const DeThiPracticeProgressStrip({
    super.key,
    required this.submitted,
    required this.passageIndex,
    required this.totalPassages,
    required this.passageAnswered,
    required this.passageTotal,
    required this.correctCount,
    required this.totalQuestions,
    required this.score,
    required this.onRetry,
  });

  final bool submitted;
  final int passageIndex;
  final int totalPassages;
  final int passageAnswered;
  final int passageTotal;
  final int correctCount;
  final int totalQuestions;
  final double score;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: tokens.muted.withValues(alpha: 0.4),
      child: submitted
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    '$correctCount/$totalQuestions câu đúng',
                    style: TextStyle(
                      fontSize: 14,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$score điểm',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: tokens.primaryForeground,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onRetry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: tokens.border),
                    ),
                    child: Text(
                      l10n.retryExam,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Đoạn ${passageIndex + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tokens.foreground,
                    ),
                    children: [
                      TextSpan(
                        text: '/$totalPassages',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: passageTotal > 0
                          ? passageAnswered / passageTotal
                          : 0,
                      minHeight: 8,
                      backgroundColor: tokens.muted,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFF97316),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$passageAnswered/$passageTotal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.mutedForeground,
                  ),
                ),
              ],
            ),
    );
  }
}
