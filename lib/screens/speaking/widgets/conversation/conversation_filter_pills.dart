import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_display.dart';
import '../../../../l10n/app_localizations.dart';
import 'conversation_topic_icon.dart';
import 'scenario_card.dart';

/// "Hoặc chọn từ thư viện" filter card — category pills (icon + count) and
/// CEFR level pills. Web parity: the `card-sm` filter block in
/// `conversation-hub-page.tsx`.
class ConversationFilterPills extends StatelessWidget {
  const ConversationFilterPills({
    super.key,
    required this.categoryFilter,
    required this.onCategoryChanged,
    required this.levelFilter,
    required this.onLevelChanged,
    required this.categoryCounts,
    required this.presentLevels,
    required this.totalCount,
    required this.resultCount,
  });

  final String categoryFilter; // 'all' | category id
  final ValueChanged<String> onCategoryChanged;
  final String levelFilter; // 'all' | level
  final ValueChanged<String> onLevelChanged;
  final Map<String, int> categoryCounts;
  final List<String> presentLevels;
  final int totalCount;
  final int resultCount;

  bool get _hasFilters => categoryFilter != 'all' || levelFilter != 'all';

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.conversationFilterLibraryTitle,
                  style: TextStyle(fontWeight: FontWeight.w800, color: tokens.foreground),
                ),
              ),
              Text(
                l10n.conversationFilterResultCount(resultCount),
                style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
              ),
              if (_hasFilters) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    onCategoryChanged('all');
                    onLevelChanged('all');
                  },
                  icon: const Icon(PhosphorIcons.x, size: 13),
                  label: Text(l10n.conversationFilterClear, style: const TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          _pillRow(
            context,
            label: l10n.conversationFilterCategory,
            children: [
              _CatPill(
                active: categoryFilter == 'all',
                icon: 'all',
                label: l10n.conversationFilterAll,
                count: totalCount,
                onTap: () => onCategoryChanged('all'),
              ),
              ...conversationCategories.map(
                (c) => _CatPill(
                  active: categoryFilter == c.id,
                  icon: c.icon,
                  label: c.label,
                  count: categoryCounts[c.id] ?? 0,
                  onTap: () => onCategoryChanged(c.id),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: tokens.border),
          const SizedBox(height: 10),
          _pillRow(
            context,
            label: l10n.conversationFilterLevel,
            children: [
              _LevelFilterPill(
                active: levelFilter == 'all',
                label: l10n.conversationFilterAll,
                onTap: () => onLevelChanged('all'),
              ),
              ...presentLevels.map(
                (lv) => _LevelFilterPill(
                  active: levelFilter == lv,
                  label: lv,
                  level: lv,
                  onTap: () => onLevelChanged(levelFilter == lv ? 'all' : lv),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillRow(BuildContext context, {required String label, required List<Widget> children}) {
    final tokens = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: tokens.mutedForeground, letterSpacing: 0.4),
            ),
          ),
        ),
        Expanded(child: Wrap(spacing: 8, runSpacing: 8, children: children)),
      ],
    );
  }
}

class _CatPill extends StatelessWidget {
  const _CatPill({required this.active, required this.icon, required this.label, required this.count, required this.onTap});

  final bool active;
  final String icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? tokens.foreground : tokens.card,
          border: Border.all(color: active ? Colors.transparent : tokens.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConversationTopicIcon(name: icon, size: 15, color: active ? tokens.background : tokens.foreground),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: active ? tokens.background : tokens.foreground)),
            const SizedBox(width: 4),
            Text('$count', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: (active ? tokens.background : tokens.foreground).withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}

class _LevelFilterPill extends StatelessWidget {
  const _LevelFilterPill({required this.active, required this.label, this.level, required this.onTap});

  final bool active;
  final String label;
  final String? level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: level != null && !active
          ? LevelBadge(level: level!)
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: active ? context.tokens.foreground : context.tokens.card,
                border: Border.all(color: active ? Colors.transparent : context.tokens.border),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: active ? context.tokens.background : context.tokens.foreground,
                ),
              ),
            ),
    );
  }
}
