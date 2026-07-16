import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/more_features_sheet.dart';
import 'quick_actions_data.dart';

/// "Khám phá" — tabbed feature catalog. Mirrors web `quick-actions.tsx`:
/// a row of category pills (exam-first lead pill highlighted), a 2-column
/// grid of tiles for the active group, and a trailing "Tất cả →" pill that
/// opens the full feature sheet. Replaces the old static 4-tile grid.
class QuickActions extends StatefulWidget {
  const QuickActions({super.key, this.totalWords = 0});

  final int totalWords;

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  String? _activeKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groups = buildExploreGroups(l10n, widget.totalWords);
    if (groups.isEmpty) return const SizedBox.shrink();

    final active = groups.firstWhere(
      (g) => g.key == _activeKey,
      orElse: () => groups.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: DesignTokens.spacingSm,
          runSpacing: DesignTokens.spacingSm,
          children: [
            for (final group in groups)
              _CategoryPill(
                label: group.label,
                lead: group.lead,
                selected: group.key == active.key,
                onTap: () => setState(() => _activeKey = group.key),
              ),
            _CategoryPill(
              label: l10n.qaTabAll,
              lead: false,
              selected: false,
              onTap: () => MoreFeaturesSheet.show(context),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingSm + 4),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = DesignTokens.spacingSm;
            final itemWidth = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final item in active.items)
                  SizedBox(
                    width: itemWidth,
                    child: _ExploreTile(item: item),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.lead,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool lead;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = selected
        ? BoxDecoration(
            gradient: lead
                ? const LinearGradient(
                    colors: [DesignTokens.orange500, DesignTokens.orange600],
                  )
                : null,
            color: lead ? null : DesignTokens.foreground,
            borderRadius: BorderRadius.circular(999),
          )
        : BoxDecoration(
            color: DesignTokens.card,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: DesignTokens.border),
          );
    final textColor = selected ? Colors.white : DesignTokens.mutedForeground;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: decoration,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreTile extends StatelessWidget {
  const _ExploreTile({required this.item});

  final QuickActionCatalogItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${item.title}: ${item.subtitle}',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: () => context.push(item.route),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DesignTokens.card,
              border: Border.all(color: DesignTokens.border),
              borderRadius: BorderRadius.circular(DesignTokens.radius),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(DesignTokens.radius),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 20),
                ),
                const SizedBox(width: DesignTokens.spacingSm + 2),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: DesignTokens.foreground,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
