import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/mission_models.dart';

/// `in_word_intro` step — shows the word (German + Vietnamese meaning) before
/// the recall practice. One word per screen (mirrors "mỗi mission step = 1
/// widget" from phase-05 §B3).
class WordIntroView extends StatelessWidget {
  const WordIntroView({
    super.key,
    required this.word,
    required this.position,
    required this.total,
    required this.onContinue,
  });

  final DailyMissionWord word;
  final int position;
  final int total;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: Text(
          '$position / $total',
          style: const TextStyle(color: DesignTokens.mutedForeground),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: total > 0 ? position / total : 0,
                backgroundColor: DesignTokens.muted,
                color: DesignTokens.orange500,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacingLg),
                decoration: BoxDecoration(
                  color: DesignTokens.card,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  boxShadow: DesignTokens.shadowMd,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (word.level != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingSm,
                          vertical: DesignTokens.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: DesignTokens.orange50,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusSm,
                          ),
                        ),
                        child: Text(
                          word.level!,
                          style: const TextStyle(
                            color: DesignTokens.tigerOrangeDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: DesignTokens.spacingMd),
                    Text(
                      word.contentDe,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingSm),
                    Text(
                      word.contentVi,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: DesignTokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: DesignTokens.orange500,
                    foregroundColor: DesignTokens.card,
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacingSm + 6,
                    ),
                  ),
                  child: Text(l10n.startPractice),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
