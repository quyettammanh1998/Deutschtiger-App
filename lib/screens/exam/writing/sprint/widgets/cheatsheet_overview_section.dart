import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../../l10n/app_localizations.dart';

/// Cheatsheet page 1 — overview of all clusters with pattern DE/VI. Web
/// parity `page-overview.tsx`. No print-CSS equivalent (Flutter has no
/// print pipeline) — this renders as a normal scrollable section instead of
/// a paginated print page; content parity is preserved, layout parity is not
/// (documented deviation, matches the whole cheatsheet screen's approach).
class CheatsheetOverviewSection extends StatelessWidget {
  const CheatsheetOverviewSection({super.key, required this.clusters});

  final List<SprintCluster> clusters;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.writingSprintCheatsheetOverviewTitle(clusters.length),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground),
        ),
        const SizedBox(height: 10),
        for (final c in clusters)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: tokens.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.titleDe, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                          Text(c.titleVi, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(999)),
                      child: Text(l10n.writingSprintCheatsheetTopicCount(c.count), style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final entry in c.byTeil.entries)
                      if (entry.value.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            '${entry.key.replaceFirst('teil', 'T')} (${entry.value.length})',
                            style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                          ),
                        ),
                  ],
                ),
                if ((c.commonPatternDe ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(c.commonPatternDe!, style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: tokens.mutedForeground)),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Cheatsheet Teil table — compact topic list for one Teil. Web parity
/// `page-teil-table.tsx`.
class CheatsheetTeilTable extends StatelessWidget {
  const CheatsheetTeilTable({super.key, required this.teil, required this.topics});

  final int teil;
  final List<SprintTopicData> topics;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final filtered = topics.where((t) => t.teil == teil && t.speedrun != null).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.writingSprintCheatsheetTeilTitle(teil, filtered.length),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tokens.foreground),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < filtered.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            color: i.isOdd ? tokens.muted.withValues(alpha: 0.4) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filtered[i].titleDe, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                Text(filtered[i].titleVi, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                if ((filtered[i].topicCluster ?? '').isNotEmpty)
                  Text(filtered[i].topicCluster!, style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
                if ((filtered[i].speedrun?.outline3.de.firstOrNull ?? '').isNotEmpty)
                  Text(
                    filtered[i].speedrun!.outline3.de.first,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: tokens.foreground),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
