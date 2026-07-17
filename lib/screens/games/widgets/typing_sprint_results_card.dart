import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'typing_sprint_paragraph_view.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Coral-themed results card — web parity: `ResultsModal`.
class TypingSprintResultsCard extends StatelessWidget {
  const TypingSprintResultsCard({
    super.key,
    required this.score,
    required this.wpm,
    required this.correctWords,
    required this.wrongWords,
    required this.accuracy,
    required this.xpAwarded,
    required this.submitFailed,
    required this.onGoHome,
    required this.onRestart,
  });

  final int score;
  final int wpm;
  final int correctWords;
  final int wrongWords;
  final int accuracy;
  final int? xpAwarded;
  final bool submitFailed;
  final VoidCallback onGoHome;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    // Card + neutral text follow the theme in dark mode; light mode keeps the
    // original coral-on-white result surface.
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? tokens.card : TypingSprintPalette.card;
    final inkColor = isDark ? tokens.foreground : TypingSprintPalette.ink;
    final inkDimColor =
        isDark ? tokens.mutedForeground : TypingSprintPalette.inkDim;
    final outlineColor = isDark ? tokens.border : TypingSprintPalette.inkFaint;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: TypingSprintPalette.coralSoft,
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 36,
                  color: TypingSprintPalette.coral,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$wpm WPM',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: TypingSprintPalette.coral,
                ),
              ),
              Text(
                'Tốc độ gõ',
                style: TextStyle(fontSize: 14, color: inkDimColor),
              ),
              if (xpAwarded != null && xpAwarded! > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '+$xpAwarded XP',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
              if (submitFailed) ...[
                const SizedBox(height: 8),
                const Text(
                  'Không thể ghi nhận kết quả lên server.',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(label: 'Điểm', value: '$score', color: TypingSprintPalette.coralDeep),
                  _StatItem(label: 'Đúng', value: '$correctWords', color: Colors.green),
                  _StatItem(label: 'Sai', value: '$wrongWords', color: Colors.red),
                  _StatItem(
                    label: 'Chính xác',
                    value: '$accuracy%',
                    color: accuracy >= 70 ? Colors.green : Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onGoHome,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: inkColor,
                        side: BorderSide(color: outlineColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Về trang chủ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onRestart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TypingSprintPalette.coral,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Chơi lại'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? context.tokens.mutedForeground : TypingSprintPalette.inkDim;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: labelColor),
        ),
      ],
    );
  }
}
