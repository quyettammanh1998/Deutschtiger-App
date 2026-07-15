import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/mission_models.dart';

/// `in_practice` step — recall check: reveal the meaning, then user
/// self-grades. Feeds `MissionRoundAnswer.correct` for `completeRound`
/// (mission-native scoring — NOT FSRS rating).
class PracticeView extends StatefulWidget {
  const PracticeView({
    super.key,
    required this.word,
    required this.position,
    required this.total,
    required this.onAnswer,
  });

  final DailyMissionWord word;
  final int position;
  final int total;
  final ValueChanged<bool> onAnswer;

  @override
  State<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends State<PracticeView> {
  bool _revealed = false;

  @override
  void didUpdateWidget(covariant PracticeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.wordId != widget.word.wordId) {
      _revealed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: Text(
          '${l10n.missionPractice} · ${widget.position} / ${widget.total}',
          style: const TextStyle(color: DesignTokens.mutedForeground),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _revealed = true),
                child: Container(
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
                      Text(
                        widget.word.contentDe,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingMd),
                      if (_revealed)
                        Text(
                          widget.word.contentVi,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: DesignTokens.mutedForeground,
                          ),
                        )
                      else
                        Text(
                          l10n.tapToShowMeaning,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: DesignTokens.mutedForeground,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (_revealed)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => widget.onAnswer(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: DesignTokens.destructive,
                          side: const BorderSide(
                            color: DesignTokens.destructive,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: DesignTokens.spacingSm + 6,
                          ),
                        ),
                        child: Text(l10n.notRemembered),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingMd),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => widget.onAnswer(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: DesignTokens.success,
                          foregroundColor: DesignTokens.card,
                          padding: const EdgeInsets.symmetric(
                            vertical: DesignTokens.spacingSm + 6,
                          ),
                        ),
                        child: Text(l10n.rememberedCorrectly),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _revealed = true),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DesignTokens.orange500,
                      side: const BorderSide(color: DesignTokens.orange500),
                      padding: const EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingSm + 6,
                      ),
                    ),
                    child: Text(l10n.showMeaning),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
