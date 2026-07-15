import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// `between_words` step — brief correct/incorrect feedback, then continue to
/// the next word (or round/mission finalize, handled by the notifier).
class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.correct,
    required this.onContinue,
    this.submitting = false,
    this.errorMessage,
  });

  final bool correct;
  final VoidCallback onContinue;
  final bool submitting;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final color = correct ? DesignTokens.success : DesignTokens.destructive;
    final icon = correct ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final label = correct
        ? l10n.missionAnswerCorrect
        : l10n.missionAnswerTryAgain;

    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 72, color: color),
              const SizedBox(height: DesignTokens.spacingMd),
              Text(
                label,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXl),
              if (errorMessage != null) ...[
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: DesignTokens.destructive),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: submitting ? null : onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: DesignTokens.orange500,
                    foregroundColor: DesignTokens.card,
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacingSm + 6,
                    ),
                  ),
                  child: Text(submitting ? l10n.saving : l10n.continueAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
