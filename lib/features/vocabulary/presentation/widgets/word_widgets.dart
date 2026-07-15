import 'package:flutter/material.dart';
import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/speak_button.dart';
import '../../../../shared/widgets/save_card_button.dart';
import '../../../../shared/widgets/tappable_sentence.dart';
import '../../../../shared/widgets/word_lookup_sheet.dart';
import '../../domain/vocabulary_models.dart';
import '../vocabulary_word_screen.dart';

/// Small horizontal pill indicating a queue position (e.g. "3 / 10")
/// with a slim progress bar. Used at the top of [VocabularyWordScreen] when
/// the screen was opened with a queue.
class WordQueueProgress extends StatelessWidget {
  const WordQueueProgress({
    super.key,
    required this.position,
    required this.total,
  });

  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$position / $total',
          style: TextStyle(color: DesignTokens.mutedForeground),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.spacingSm),
          child: LinearProgressIndicator(
            value: position / total,
            minHeight: 6,
            backgroundColor: DesignTokens.muted,
            valueColor: const AlwaysStoppedAnimation(DesignTokens.tigerOrange),
          ),
        ),
      ],
    );
  }
}

/// Card at the top of the word screen showing the headword, gender,
/// phonetic and word-type chip + the SpeakButton.
class WordHeaderCard extends StatelessWidget {
  const WordHeaderCard({super.key, required this.item});
  final LearningItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        boxShadow: DesignTokens.shadowCard,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        item.contentDe,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (item.gender != null) ...[
                      const SizedBox(width: DesignTokens.spacingSm),
                      Text(
                        item.gender!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: DesignTokens.rose600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                if (item.ipa != null)
                  Text(
                    item.ipa!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.mutedForeground,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                if (item.wordType != null)
                  Text(
                    item.wordType!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: DesignTokens.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              SpeakButton(text: item.contentDe, audioUrl: item.audioUrl),
              const SizedBox(height: DesignTokens.spacingXs),
              SaveCardButton(
                wordDe: item.contentDe,
                wordVi: item.contentVi ?? item.meanings?.join(', ') ?? '',
                exampleSentence: item.examples?.firstOrNull?.de,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section listing the meanings of a word (bullet points).
class WordMeanings extends StatelessWidget {
  const WordMeanings({super.key, required this.meanings});
  final List<String> meanings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.wordMeanings,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        for (final m in meanings)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
            child: Text('• $m', style: theme.textTheme.bodyLarge),
          ),
      ],
    );
  }
}

/// Section listing up to 3 example sentences (DE + VI translation).
class WordExamples extends StatelessWidget {
  const WordExamples({super.key, required this.examples});
  final List<Example> examples;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.wordExamples,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        for (final ex in examples.take(3))
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🇩🇪 '),
                    Expanded(
                      child: TappableSentence(
                        text: ex.de,
                        style: theme.textTheme.bodyLarge,
                        onWordTap: (word) =>
                            showWordLookupSheet(context, word: word),
                      ),
                    ),
                  ],
                ),
                Text(
                  '🇻🇳 ${ex.vi}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignTokens.mutedForeground,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Bottom navigation bar for the word screen — "Quay lại" (optional,
/// only when a queue is supplied) and the primary "Tiếp tục" CTA.
class WordNavigationBar extends StatelessWidget {
  const WordNavigationBar({
    super.key,
    required this.hasQueue,
    required this.canPrev,
    required this.onPrev,
    required this.onNext,
  });

  final bool hasQueue;
  final bool canPrev;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        if (hasQueue)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: canPrev ? onPrev : null,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(l10n.previous),
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignTokens.tigerOrange,
                side: const BorderSide(color: DesignTokens.tigerOrange),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        if (hasQueue) const SizedBox(width: DesignTokens.spacingSm + 4),
        Expanded(
          flex: hasQueue ? 2 : 1,
          child: FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(l10n.next),
            style: FilledButton.styleFrom(
              backgroundColor: DesignTokens.tigerOrange,
              foregroundColor: DesignTokens.card,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
