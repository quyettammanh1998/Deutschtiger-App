import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/tappable_sentence.dart';

/// Web parity: `sprechen-instruction-banner.tsx` — amber card with bold
/// "Aufgabe:" (red) and "Hinweis:" (green) lead-ins; German words are
/// tappable for the word-lookup sheet.
class SprechenInstructionBanner extends StatelessWidget {
  const SprechenInstructionBanner({
    super.key,
    required this.aufgabe,
    this.hinweis,
    this.onWordTap,
  });

  final String aufgabe;
  final String? hinweis;
  final ValueChanged<String>? onWordTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: tokens.foreground),
              children: [
                TextSpan(
                  text: 'Aufgabe: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tokens.destructive,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          TappableSentence(
            text: aufgabe,
            onWordTap: onWordTap ?? (_) {},
          ),
          if (hinweis != null && hinweis!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: tokens.foreground),
                children: [
                  TextSpan(
                    text: 'Hinweis: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tokens.success,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            TappableSentence(text: hinweis!, onWordTap: onWordTap ?? (_) {}),
          ],
        ],
      ),
    );
  }
}
