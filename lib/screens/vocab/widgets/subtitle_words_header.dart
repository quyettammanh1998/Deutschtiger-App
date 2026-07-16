import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_pill.dart';
import '../subtitle_words_providers.dart';

/// Page header (back + title + subtitle) + level-filter pill row — web
/// parity: `subtitle-words-page.tsx` header block + level pills.
class SubtitleWordsHeader extends ConsumerWidget {
  const SubtitleWordsHeader({
    super.key,
    required this.onBack,
    required this.selectedLevels,
    required this.onSelectAllLevels,
    required this.onToggleLevel,
  });

  final VoidCallback onBack;
  final Set<String> selectedLevels;
  final VoidCallback onSelectAllLevels;
  final ValueChanged<String> onToggleLevel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final countsAsync = ref.watch(subtitleWordsCountsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BackButton(onTap: onBack),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.subtitleWordsTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.subtitleWordsSubtitle,
                    style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        countsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (counts) {
            if (counts.isEmpty) return const SizedBox.shrink();
            final levels = counts.keys.toList()
              ..sort((a, b) => subtitleWordsLevelOrder(a).compareTo(subtitleWordsLevelOrder(b)));
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _LevelPill(
                    label: l10n.subtitleWordsLevelAll,
                    selected: selectedLevels.isEmpty,
                    onTap: onSelectAllLevels,
                  ),
                  for (final level in levels)
                    _LevelPill(
                      label: l10n.subtitleWordsLevelCount(level, counts[level] ?? 0),
                      selected: selectedLevels.contains(level),
                      onTap: () => onToggleLevel(level),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GestureDetector(
      onTap: onTap,
      child: selected
          ? DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tokens.primary, Color.lerp(tokens.primary, Colors.black, 0.15)!],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : AppPill(label: label, fontSize: 12),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: tokens.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(AppPhosphorIcons.caretLeft, size: 20, color: tokens.foreground),
        ),
      ),
    );
  }
}
