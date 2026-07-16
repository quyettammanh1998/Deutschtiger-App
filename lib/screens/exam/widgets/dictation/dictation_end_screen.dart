import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Shared result screen for cloze / full-sentence dictation — mirrors web
/// `dictation-end-screen.tsx`. No SRS/FSRS push: the app has no
/// `srsService.recordPractice`-equivalent endpoint wired yet (web pushes
/// practiced words into spaced repetition here) — see phase report gap.
class DictationEndScreen extends StatelessWidget {
  const DictationEndScreen({
    super.key,
    required this.title,
    required this.correct,
    required this.total,
    required this.backLabel,
    required this.onRetry,
    required this.onBack,
    this.children = const [],
  });

  final String title;
  final int correct;
  final int total;
  final String backLabel;
  final VoidCallback onRetry;
  final VoidCallback onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final pct = total == 0 ? 0 : ((correct / total) * 100).round();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$pct%',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: tokens.primary,
              ),
            ),
            Text(
              l10n.dictationEndCorrectCount(correct, total),
              style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 20),
            ...children,
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onRetry,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: Center(
                        child: Text(
                          l10n.dictationEndRetry,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: BorderSide(color: tokens.border),
                ),
                child: Text('← $backLabel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
