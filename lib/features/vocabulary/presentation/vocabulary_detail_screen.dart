import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../core/release/release_feature_flags.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vocabulary_models.dart';
import 'vocabulary_provider.dart';
import 'widgets/detail_widgets.dart';
import '../../../shared/widgets/tappable_sentence.dart';
import '../../../shared/widgets/word_lookup_sheet.dart';

/// C4 — Vocabulary detail screen (refactor of the older `_WordCard`-based
/// screen; this implementation mirrors web `vocabulary-detail-page.tsx`):
/// hero word, basic metadata, conjugation table, examples, related words,
/// audio via [SpeakButton] (from `lib/shared/widgets/speak_button.dart`).
class VocabularyDetailScreen extends ConsumerWidget {
  const VocabularyDetailScreen({
    super.key,
    required this.topicKey,
    this.level,
    this.itemId,
  });

  final String topicKey;
  final String? level;
  final String? itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(
      topicLevelItemsProvider(
        TopicLevelItemsParams(topic: topicKey, level: level, pageSize: 50),
      ),
    );

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        elevation: 0,
        title: Text(l10n.vocabularyTopicTitle(topicKey)),
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.couldNotLoadVocabulary)),
        data: (result) {
          if (result.items.isEmpty) {
            return Center(child: Text(l10n.noVocabulary));
          }
          return _DetailBody(
            items: result.items,
            itemId: itemId,
            topicKey: topicKey,
          );
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.items,
    required this.itemId,
    required this.topicKey,
  });

  final List<LearningItem> items;
  final String? itemId;
  final String topicKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = itemId == null
        ? items.first
        : items.firstWhere((it) => it.id == itemId, orElse: () => items.first);
    final related = items
        .where((it) => it.id != selected.id && it.level == selected.level)
        .take(6)
        .toList();
    final basicRows = <(String, String)>[
      if (selected.gender != null) (l10n.wordGender, selected.gender!),
      if (selected.plural != null) (l10n.wordPlural, selected.plural!),
      if (selected.wordType != null) (l10n.wordType, selected.wordType!),
      if (selected.auxiliary != null) (l10n.auxiliaryVerb, selected.auxiliary!),
      if (selected.komparativ != null) (l10n.comparative, selected.komparativ!),
      if (selected.superlativ != null) (l10n.superlative, selected.superlativ!),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingSm,
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingLg,
      ),
      children: [
        VocabHeroCard(item: selected),
        if (basicRows.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingMd),
          VocabMetaTable(rows: basicRows),
        ],
        if (selected.conjugation != null) ...[
          const SizedBox(height: DesignTokens.spacingLg),
          VocabConjugationSection(conjugation: selected.conjugation!),
        ],
        if ((selected.meanings ?? const <String>[]).isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingLg),
          _SectionTitle(l10n.wordMeanings),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final m in selected.meanings!)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
              child: Text('• $m', style: Theme.of(context).textTheme.bodyLarge),
            ),
        ],
        if ((selected.examples ?? const <Example>[]).isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingLg),
          _SectionTitle(l10n.wordExamples),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final ex in (selected.examples ?? const <Example>[]).take(3))
            _ExampleCard(de: ex.de, vi: ex.vi),
        ],
        if (related.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingLg),
          _SectionTitle(l10n.relatedWords),
          const SizedBox(height: DesignTokens.spacingSm),
          VocabRelatedChips(items: related),
        ],
        if (ReleaseFeatureFlags.games) ...[
          const SizedBox(height: DesignTokens.spacingLg),
          const VocabPracticeButtons(),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.de, required this.vi});
  final String de;
  final String vi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🇩🇪 '),
              Expanded(
                child: TappableSentence(
                  text: de,
                  style: theme.textTheme.bodyLarge,
                  onWordTap: (word) => showWordLookupSheet(context, word: word),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '🇻🇳 $vi',
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.mutedForeground,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
