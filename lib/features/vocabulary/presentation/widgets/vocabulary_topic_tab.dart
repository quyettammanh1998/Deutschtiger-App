import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/vocabulary_models.dart';

/// "📚 Theo chủ đề" tab — web parity: the `view === 'topic'` section
/// (main-topic `<select>` + sub-topic grid, each sub-topic showing a
/// `L·count` level-chip row).
class VocabularyTopicTab extends StatefulWidget {
  const VocabularyTopicTab({
    super.key,
    required this.topics,
    required this.topicLevelCounts,
  });

  final List<VocabularyTopic> topics;
  final List<TopicLevelCount> topicLevelCounts;

  @override
  State<VocabularyTopicTab> createState() => _VocabularyTopicTabState();
}

class _VocabularyTopicTabState extends State<VocabularyTopicTab> {
  String? _selectedMainId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mainTopics = widget.topics.where((t) => t.parentId == null).toList(growable: false);

    if (mainTopics.isEmpty) {
      return Center(child: Text(l10n.noVocabularyTopics));
    }

    final activeMain = mainTopics.firstWhere(
      (t) => t.id == _selectedMainId,
      orElse: () => mainTopics.first,
    );
    final subTopics = widget.topics
        .where((t) => t.parentId == activeMain.id)
        .toList(growable: false);
    final chipsByTopicId = <String, List<TopicLevelCount>>{};
    for (final row in widget.topicLevelCounts) {
      (chipsByTopicId[row.topicId] ??= []).add(row);
    }
    for (final list in chipsByTopicId.values) {
      list.sort((a, b) => a.level.compareTo(b.level));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.vocabularyTopicSectionTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(l10n.vocabularyTopicSectionDescription, style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground)),
        const SizedBox(height: 12),
        Text(l10n.vocabularyChooseGroupLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        _MainTopicSelect(
          value: activeMain.id,
          topics: mainTopics,
          subCounts: {for (final t in mainTopics) t.id: widget.topics.where((s) => s.parentId == t.id).length},
          onChanged: (id) => setState(() => _selectedMainId = id),
        ),
        const SizedBox(height: 12),
        _SubTopicGrid(subTopics: subTopics, chipsByTopicId: chipsByTopicId),
      ],
    );
  }
}

class _MainTopicSelect extends StatelessWidget {
  const _MainTopicSelect({
    required this.value,
    required this.topics,
    required this.subCounts,
    required this.onChanged,
  });
  final String value;
  final List<VocabularyTopic> topics;
  final Map<String, int> subCounts;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: [
            for (final t in topics)
              DropdownMenuItem(
                value: t.id,
                child: Text(
                  '${t.labelVi} (${subCounts[t.id] ?? 0})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
          ],
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}

class _SubTopicGrid extends StatelessWidget {
  const _SubTopicGrid({required this.subTopics, required this.chipsByTopicId});
  final List<VocabularyTopic> subTopics;
  final Map<String, List<TopicLevelCount>> chipsByTopicId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.border),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final sub in subTopics)
            SizedBox(
              width: (MediaQuery.sizeOf(context).width - 32 - 24 - 8) / 2,
              child: _SubTopicCell(sub: sub, chips: chipsByTopicId[sub.id] ?? const []),
            ),
        ],
      ),
    );
  }
}

class _SubTopicCell extends StatelessWidget {
  const _SubTopicCell({required this.sub, required this.chips});
  final VocabularyTopic sub;
  final List<TopicLevelCount> chips;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.background.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push('/vocabulary/topic-${sub.key}'),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub.icon, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sub.labelVi, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(sub.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 6),
            Divider(height: 1, color: tokens.border),
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final c in chips)
                  InkWell(
                    onTap: () => context.push('/vocabulary/topic-${sub.key}?level=${c.level}'),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(999)),
                      child: Text('${c.level}·${c.count}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: tokens.mutedForeground)),
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
