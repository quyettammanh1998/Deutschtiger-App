import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

/// Shared score banner — web parity `ExerciseResultBanner`.
class ExerciseResultBanner extends StatelessWidget {
  const ExerciseResultBanner({
    super.key,
    required this.correct,
    required this.total,
    required this.onRetry,
  });

  final int correct;
  final int total;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pct = total == 0 ? 0 : (correct / total * 100).round();
    final (emoji, bg, fg) = switch (pct) {
      >= 80 => ('🎉', const Color(0xFFF0FDF4), const Color(0xFF15803D)),
      >= 50 => ('💪', const Color(0xFFFFFBEB), const Color(0xFFB45309)),
      _ => ('📚', const Color(0xFFFEF2F2), const Color(0xFFDC2626)),
    };
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: fg.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Expanded(
            child: Text('$emoji $correct/$total ${l10n.writingCorrectCount} ($pct%)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
          ),
          TextButton(onPressed: onRetry, child: Text(l10n.writingRetry, style: TextStyle(fontSize: 12, color: fg))),
        ],
      ),
    );
  }
}
