import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/vocabulary_models.dart';

const _kLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _kLevelIcons = ['🌱', '🌿', '🌳', '🎆', '🌴', '👑'];
const _kLevelColors = [
  Color(0xFFA855F7),
  Color(0xFF3B82F6),
  Color(0xFF22C55E),
  Color(0xFFEAB308),
  Color(0xFFEF4444),
  Color(0xFFF59E0B),
];
const _kTopTopicsPerLevel = 6;

/// "🧭 Theo cấp độ" tab — web parity: the `view === 'level'` section
/// (`VocabularyLevelCard` grid, left-border color + top-topic chips).
class VocabularyLevelTab extends StatelessWidget {
  const VocabularyLevelTab({
    super.key,
    required this.levelCounts,
    required this.topicLevelCounts,
  });

  final List<LevelCount> levelCounts;
  final List<TopicLevelCount> topicLevelCounts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final countByLevel = {for (final lc in levelCounts) lc.level: lc.count};
    final topTopicsByLevel = <String, List<TopicLevelCount>>{};
    for (final row in topicLevelCounts) {
      (topTopicsByLevel[row.level] ??= []).add(row);
    }
    for (final list in topTopicsByLevel.values) {
      list.sort((a, b) => b.count.compareTo(a.count));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.vocabularyLevelSectionTitle,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.vocabularyLevelSectionDescription,
          style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _kLevels.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _LevelCard(
              level: _kLevels[i],
              icon: _kLevelIcons[i],
              color: _kLevelColors[i],
              name: _levelName(l10n, i),
              count: countByLevel[_kLevels[i]] ?? 0,
              topTopics: (topTopicsByLevel[_kLevels[i]] ?? const [])
                  .take(_kTopTopicsPerLevel)
                  .toList(growable: false),
            ),
          ),
      ],
    );
  }

  String _levelName(AppLocalizations l10n, int index) => switch (index) {
    0 => l10n.cefrBeginner,
    1 => l10n.cefrPreIntermediate,
    2 => l10n.cefrIntermediate,
    3 => l10n.cefrUpperIntermediate,
    4 => l10n.cefrAdvanced,
    5 => l10n.cefrProficient,
    _ => '',
  };
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.icon,
    required this.color,
    required this.name,
    required this.count,
    required this.topTopics,
  });

  final String level;
  final String icon;
  final Color color;
  final String name;
  final int count;
  final List<TopicLevelCount> topTopics;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push('/vocabulary/level-${level.toLowerCase()}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 20)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(level, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(l10n.cefrLevel(level), style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(name, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                const SizedBox(height: 4),
                Text(l10n.wordsCount(count), style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
              ],
            ),
          ),
          if (topTopics.isNotEmpty) ...[
            const SizedBox(height: 10),
            Divider(height: 1, color: tokens.border),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in topTopics)
                  InkWell(
                    onTap: () => context.push(
                      '/vocabulary/topic-${t.topicKey}?level=$level',
                    ),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tokens.muted,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${t.labelVi} · ${t.count}',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: tokens.mutedForeground),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
