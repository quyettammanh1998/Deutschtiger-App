import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/speak_button.dart';
import '../../../../shared/widgets/save_card_button.dart';
import '../../domain/vocabulary_models.dart';
import '../vocabulary_word_screen.dart';

/// Hero card at the top of vocabulary detail — headword + IPA + Vietnamese
/// translation + SpeakButton.
class VocabHeroCard extends StatefulWidget {
  const VocabHeroCard({super.key, required this.item});
  final LearningItem item;

  @override
  State<VocabHeroCard> createState() => _VocabHeroCardState();
}

class _VocabHeroCardState extends State<VocabHeroCard> {
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final item = widget.item;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: context.tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        boxShadow: DesignTokens.shadowCard,
      ),
      child: AnimatedSwitcher(
        duration: DesignTokens.durationMedium,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: _showBack
            ? Row(
                key: const ValueKey('back'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.contentVi ??
                              item.meanings?.firstOrNull ??
                              l10n.noMeaning,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if ((item.meanings ?? const <String>[]).length > 1)
                          for (final meaning in item.meanings!.skip(1).take(3))
                            Text('• $meaning'),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _showBack = false),
                    tooltip: l10n.flipVocabularyCard,
                    icon: const Icon(Icons.flip),
                  ),
                ],
              )
            : Row(
                key: const ValueKey('front'),
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
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (item.gender != null) ...[
                              const SizedBox(width: DesignTokens.spacingSm),
                              Text(
                                item.gender!,
                                style: theme.textTheme.titleMedium?.copyWith(
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
                              color: context.tokens.mutedForeground,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (item.contentVi != null) ...[
                          const SizedBox(height: DesignTokens.spacingXs + 2),
                          Text(
                            item.contentVi!,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _showBack = true),
                        tooltip: l10n.flipVocabularyCard,
                        icon: const Icon(Icons.flip),
                      ),
                      SpeakButton(
                        text: item.contentDe,
                        audioUrl: item.audioUrl,
                        iconSize: 26,
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      SaveCardButton(
                        wordDe: item.contentDe,
                        wordVi:
                            item.contentVi ?? item.meanings?.join(', ') ?? '',
                        exampleSentence: item.examples?.firstOrNull?.de,
                        variant: SaveCardButtonVariant.star,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

/// Two-column metadata table (label / value) shared by the basic info
/// section and the conjugation table.
class VocabMetaTable extends StatelessWidget {
  const VocabMetaTable({super.key, required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: context.tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            _MetaRow(
              label: rows[i].$1,
              value: rows[i].$2,
              isLast: i == rows.length - 1,
            ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
    required this.isLast,
  });
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: context.tokens.border, width: 0.5),
              ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.cardPadding,
        vertical: DesignTokens.spacingSm + 2,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.tokens.mutedForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

/// "Chia động từ" section: title + metadata table for the conjugation info.
class VocabConjugationSection extends StatelessWidget {
  const VocabConjugationSection({super.key, required this.conjugation});
  final ConjugationInfo conjugation;

  List<(String, String)> _rows(AppLocalizations l10n) => [
    if (conjugation.praesens != null && conjugation.praesens!.isNotEmpty)
      ('Präsens', conjugation.praesens!.join(', ')),
    if (conjugation.praeteritum != null && conjugation.praeteritum!.isNotEmpty)
      ('Präteritum', conjugation.praeteritum!.join(', ')),
    if (conjugation.perfekt != null) ('Perfekt', conjugation.perfekt!),
    if (conjugation.konjunktivIi != null)
      ('Konjunktiv II', conjugation.konjunktivIi!),
    if (conjugation.raw != null) (l10n.principalForms, conjugation.raw!),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final rows = _rows(l10n);
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.verbConjugation,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        VocabMetaTable(rows: rows),
      ],
    );
  }
}

/// "Từ liên quan" — horizontal wrap of chip-buttons; tapping pushes the
/// detail for that word.
class VocabRelatedChips extends StatelessWidget {
  const VocabRelatedChips({super.key, required this.items});
  final List<LearningItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: DesignTokens.spacingSm,
      runSpacing: DesignTokens.spacingSm,
      children: [
        for (final it in items)
          Material(
            color: DesignTokens.orange50,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VocabularyWordScreen(item: it),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
                child: Text(
                  it.contentDe,
                  style: const TextStyle(
                    color: DesignTokens.tigerOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Footer with Flashcard / Luyện tập CTAs pointing at game routes.
class VocabPracticeButtons extends StatelessWidget {
  const VocabPracticeButtons({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/games/flashcards'),
            icon: const Icon(Icons.style),
            label: Text(l10n.flashcardPractice),
            style: OutlinedButton.styleFrom(
              foregroundColor: DesignTokens.tigerOrange,
              side: const BorderSide(color: DesignTokens.tigerOrange),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm + 4),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.push('/games/word-sprint'),
            icon: const Icon(Icons.speed),
            label: Text(l10n.practice),
            style: FilledButton.styleFrom(
              backgroundColor: DesignTokens.tigerOrange,
              foregroundColor: context.tokens.card,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
