import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'dictation_cue.dart';
import 'sentence_gap_text.dart';

/// Active-practice UI for one [DictationCue]: progress header, sentence
/// card, answer input, and check/replay/skip/reveal actions. Pure
/// presentational widget — state machine lives in [ClozePracticeView].
class ClozePracticeCard extends StatelessWidget {
  const ClozePracticeCard({
    super.key,
    required this.cue,
    required this.answeredCount,
    required this.totalCount,
    required this.controller,
    required this.focusNode,
    required this.waitingForInput,
    required this.revealed,
    required this.wrongAttempts,
    required this.onBack,
    required this.onSubmit,
    required this.onReplay,
    required this.onSkip,
    required this.onReveal,
    required this.onChanged,
  });

  final DictationCue cue;
  final int answeredCount;
  final int totalCount;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool waitingForInput;
  final bool revealed;
  final int wrongAttempts;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final VoidCallback onReplay;
  final VoidCallback onSkip;
  final VoidCallback onReveal;
  final ValueChanged<String> onChanged;

  bool get _active => waitingForInput && !revealed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: onBack,
                    child: Text(l10n.dictationBackToSelection),
                  ),
                  Text(
                    l10n.dictationWordCount(answeredCount, totalCount),
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: totalCount == 0 ? 0 : answeredCount / totalCount,
                  minHeight: 6,
                  backgroundColor: tokens.muted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tokens.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SentenceGapText(
                          cue: cue,
                          revealed: revealed,
                          wrongAttempts: wrongAttempts,
                        ),
                        if (cue.sentenceTextVi.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            cue.sentenceTextVi,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: _active,
                  onChanged: onChanged,
                  onSubmitted: (_) => onSubmit(),
                  decoration: InputDecoration(
                    hintText: waitingForInput
                        ? l10n.dictationTypeWordHint
                        : l10n.dictationPlayingAudioHint,
                    filled: true,
                    fillColor: tokens.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _active && controller.text.trim().isNotEmpty
                            ? onSubmit
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: tokens.primary,
                        ),
                        child: Text(l10n.dictationCheckCta),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _active ? onReplay : null,
                      icon: const Icon(Icons.replay),
                      tooltip: l10n.dictationReplaySentenceTooltip,
                    ),
                    IconButton(
                      onPressed: _active ? onSkip : null,
                      icon: const Icon(Icons.skip_next),
                      tooltip: l10n.dictationClozeSkip,
                    ),
                    IconButton(
                      onPressed: _active ? onReveal : null,
                      icon: const Icon(Icons.visibility_outlined),
                      tooltip: l10n.dictationClozeReveal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
