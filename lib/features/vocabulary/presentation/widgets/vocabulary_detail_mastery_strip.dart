import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/graduation_stats.dart';
import 'vocabulary_detail_item_list.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Mastery strip below the header — web parity: the `masteryTotal > 0` block
/// in `vocabulary-detail-page.tsx` (`DeckMasteryProgressBar` + graduated line
/// + `Danh sách`/`Từ của tôi` tab bar + search/weak-filter row, "Danh sách"
/// tab only).
class VocabularyDetailMasteryStrip extends StatelessWidget {
  const VocabularyDetailMasteryStrip({
    super.key,
    required this.stats,
    required this.tab,
    required this.onTabChanged,
    required this.search,
    required this.onSearchChanged,
    required this.weakOnly,
    required this.onWeakToggled,
  });

  final GraduationStats stats;
  final VocabularyDetailTab tab;
  final ValueChanged<VocabularyDetailTab> onTabChanged;
  final String search;
  final ValueChanged<String> onSearchChanged;
  final bool weakOnly;
  final ValueChanged<bool> onWeakToggled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final graduated = stats.graduated;
    final total = stats.total;
    final percent = total > 0 ? graduated / total : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent.clamp(0, 1),
              minHeight: 6,
              backgroundColor: tokens.muted,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
            ),
          ),
          if (graduated > 0) ...[
            const SizedBox(height: 4),
            Text(
              l10n.vocabularyMasteredCount(graduated, total),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF10B981),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              _TabButton(
                label: l10n.vocabularyTabList,
                selected: tab == VocabularyDetailTab.list,
                onTap: () => onTabChanged(VocabularyDetailTab.list),
              ),
              const SizedBox(width: 16),
              _TabButton(
                label: l10n.vocabularyTabMyWords,
                selected: tab == VocabularyDetailTab.mine,
                onTap: () => onTabChanged(VocabularyDetailTab.mine),
              ),
            ],
          ),
          if (tab == VocabularyDetailTab.list) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      onChanged: onSearchChanged,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: l10n.vocabularySearchHint,
                        prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 16),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: tokens.border),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _WeakFilterButton(
                  active: weakOnly,
                  label: l10n.vocabularyWeakFilter,
                  onTap: () => onWeakToggled(!weakOnly),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? tokens.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? tokens.primary : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}

class _WeakFilterButton extends StatelessWidget {
  const _WeakFilterButton({
    required this.active,
    required this.label,
    required this.onTap,
  });
  final bool active;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? const Color(0xFFFCA5A5) : tokens.border,
          ),
          color: active ? const Color(0xFFFEF2F2) : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xFFEF4444) : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}
