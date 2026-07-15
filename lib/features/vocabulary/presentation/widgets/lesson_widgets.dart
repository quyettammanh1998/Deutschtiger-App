import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/vocabulary_models.dart';

/// A horizontal pill filter chip with "selected" styling for lesson levels.
class LessonLevelChip extends StatelessWidget {
  const LessonLevelChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: DesignTokens.spacingXs + 2),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: DesignTokens.orange50,
        labelStyle: TextStyle(
          color: selected
              ? DesignTokens.tigerOrange
              : DesignTokens.mutedForeground,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(
          color: selected ? DesignTokens.tigerOrange : DesignTokens.border,
        ),
      ),
    );
  }
}

/// Progress header showing learned/total + linear progress bar.
class LessonProgressHeader extends StatelessWidget {
  const LessonProgressHeader({
    super.key,
    required this.total,
    required this.learned,
    required this.progress,
  });

  final int total;
  final int learned;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.lessonProgress(learned, total),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.spacingSm),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: DesignTokens.muted,
              valueColor: const AlwaysStoppedAnimation(
                DesignTokens.tigerOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card showing one word in the lesson list (Word + Vietnamese + level badge).
class LessonWordTile extends StatelessWidget {
  const LessonWordTile({super.key, required this.item, required this.onTap});

  final LearningItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final level = item.level?.name.toUpperCase() ?? 'A1';
    return Material(
      color: DesignTokens.card,
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.cardPadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.contentDe,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: DesignTokens.foreground,
                      ),
                    ),
                    if (item.contentVi != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.contentVi!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingSm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.orange50,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Text(
                  level,
                  style: const TextStyle(
                    color: DesignTokens.tigerOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Filter bar used at the top of [VocabularyLessonScreen]: a search input
/// plus a horizontal scrollable row of level chips.
class LessonFilterBar extends StatelessWidget {
  const LessonFilterBar({
    super.key,
    required this.controller,
    required this.query,
    required this.levelFilter,
    required this.onSearch,
    required this.onLevel,
  });

  final TextEditingController controller;
  final String query;
  final WordLevel? levelFilter;
  final ValueChanged<String> onSearch;
  final ValueChanged<WordLevel?> onLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingSm,
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: l10n.searchLessonVocabulary,
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        controller.clear();
                        onSearch('');
                      },
                    ),
              isDense: true,
              filled: true,
              fillColor: DesignTokens.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radius),
                borderSide: const BorderSide(color: DesignTokens.border),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                LessonLevelChip(
                  label: l10n.allLevels,
                  selected: levelFilter == null,
                  onTap: () => onLevel(null),
                ),
                for (final l in WordLevel.values)
                  LessonLevelChip(
                    label: l.name.toUpperCase(),
                    selected: levelFilter == l,
                    onTap: () => onLevel(l),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
