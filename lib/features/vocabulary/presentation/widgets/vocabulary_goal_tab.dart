import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/goal_vocab_path.dart';
import '../../domain/vocabulary_models.dart';

/// "🎯 Theo mục tiêu" tab — web parity: the `view === 'goal'` section of
/// `vocabulary-page.tsx` (goal `<select>` + active-goal topic-chip card).
class VocabularyGoalTab extends StatefulWidget {
  const VocabularyGoalTab({super.key, required this.topicLevelCounts});
  final List<TopicLevelCount> topicLevelCounts;

  @override
  State<VocabularyGoalTab> createState() => _VocabularyGoalTabState();
}

class _VocabularyGoalTabState extends State<VocabularyGoalTab> {
  String _selectedId = kGoalVocabPaths.first.id;

  Map<String, int> get _topicTotals {
    final map = <String, int>{};
    for (final row in widget.topicLevelCounts) {
      final current = map[row.topicKey] ?? 0;
      map[row.topicKey] = row.totalCount != null
          ? (row.totalCount! > current ? row.totalCount! : current)
          : current + row.count;
    }
    return map;
  }

  Map<String, String> get _topicLabels {
    final map = <String, String>{};
    for (final row in widget.topicLevelCounts) {
      map[row.topicKey] = row.labelVi;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totals = _topicTotals;

    // Only goals whose topics actually have data (matches web `.filter`).
    final available = kGoalVocabPaths
        .map((goal) {
          final topics = goal.topicKeys
              .where((k) => (totals[k] ?? 0) > 0)
              .toList(growable: false);
          return (goal: goal, topics: topics);
        })
        .where((e) => e.topics.isNotEmpty)
        .toList(growable: false);

    if (available.isEmpty) {
      return Center(child: Text(l10n.noVocabularyTopics));
    }

    final active = available.firstWhere(
      (e) => e.goal.id == _selectedId,
      orElse: () => available.first,
    );
    final total = active.topics.fold(0, (sum, k) => sum + (totals[k] ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.vocabularyChooseGroupLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        _GroupSelect(
          value: active.goal.id,
          items: [
            for (final e in available)
              (id: e.goal.id, label: '${e.goal.title(l10n)} (${e.topics.length})'),
          ],
          onChanged: (id) => setState(() => _selectedId = id),
        ),
        const SizedBox(height: 12),
        _ActiveGoalCard(
          goal: active.goal,
          topicKeys: active.topics,
          topicLabels: _topicLabels,
          total: total,
          l10n: l10n,
        ),
      ],
    );
  }
}

class _GroupSelect extends StatelessWidget {
  const _GroupSelect({required this.value, required this.items, required this.onChanged});
  final String value;
  final List<({String id, String label})> items;
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
            for (final item in items)
              DropdownMenuItem(value: item.id, child: Text(item.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
          ],
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}

class _ActiveGoalCard extends StatelessWidget {
  const _ActiveGoalCard({
    required this.goal,
    required this.topicKeys,
    required this.topicLabels,
    required this.total,
    required this.l10n,
  });
  final GoalVocabPath goal;
  final List<String> topicKeys;
  final Map<String, String> topicLabels;
  final int total;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(goal.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(goal.title(l10n), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              Text(l10n.wordsCount(total), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(goal.description, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in topicKeys)
                _TopicChip(topicKey: key, label: topicLabels[key] ?? key),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.topicKey, required this.label});
  final String topicKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: () => context.push('/vocabulary/topic-$topicKey'),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: tokens.background.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: tokens.border),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
