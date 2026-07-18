import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/vocabulary/domain/vocabulary_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Deterministic gradient palette for the topic icon tile — web reads
/// `topic.color` (a Tailwind gradient class from the DB); Flutter has no
/// Tailwind class parser, so this rotates a fixed palette keyed by the
/// topic id hash instead (same visual language, no backend format coupling).
const _iconGradients = [
  [Color(0xFFF97316), Color(0xFFEA580C)], // orange
  [Color(0xFF0EA5E9), Color(0xFF2563EB)], // sky→blue
  [Color(0xFF10B981), Color(0xFF059669)], // emerald
  [Color(0xFFA855F7), Color(0xFF7C3AED)], // purple→violet
  [Color(0xFFEC4899), Color(0xFFDB2777)], // pink→rose
  [Color(0xFFF59E0B), Color(0xFFD97706)], // amber
];

List<Color> _gradientFor(String id) => _iconGradients[id.hashCode.abs() % _iconGradients.length];

/// Expandable "TopicGroupCard" — gradient icon tile, title + "{label} · N chủ
/// đề" subtitle, rotating caret; expanded grid of sub-topic tiles (emoji,
/// label, ⭐/☆ pin, level pills). Mirrors web `topic-group-card.tsx`.
class TopicGroupCard extends StatefulWidget {
  const TopicGroupCard({
    super.key,
    required this.topic,
    required this.subTopics,
    required this.levelsByTopicId,
    required this.pinnedKeys,
    required this.onTogglePin,
  });

  final VocabularyTopic topic;
  final List<VocabularyTopic> subTopics;
  final Map<String, List<TopicLevelCount>> levelsByTopicId;
  final Set<String> pinnedKeys;
  final void Function(String topicKey) onTogglePin;

  @override
  State<TopicGroupCard> createState() => _TopicGroupCardState();
}

class _TopicGroupCardState extends State<TopicGroupCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final rows = widget.subTopics.isEmpty ? [widget.topic] : widget.subTopics;
    final gradient = _gradientFor(widget.topic.id);

    return AppCard.card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradient),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.topic.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.topic.labelVi,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: tokens.foreground,
                            ),
                          ),
                          Text(
                            l10n.topicGroupSubtitle(
                              widget.topic.label,
                              rows.length,
                            ),
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        PhosphorIcons.caretDown,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.4,
                ),
                itemCount: rows.length,
                itemBuilder: (context, i) => _SubTopicTile(
                  topic: rows[i],
                  counts: widget.levelsByTopicId[rows[i].id] ?? const [],
                  pinned: widget.pinnedKeys.contains(rows[i].key),
                  onTogglePin: () => widget.onTogglePin(rows[i].key),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SubTopicTile extends StatelessWidget {
  const _SubTopicTile({
    required this.topic,
    required this.counts,
    required this.pinned,
    required this.onTogglePin,
  });

  final VocabularyTopic topic;
  final List<TopicLevelCount> counts;
  final bool pinned;
  final VoidCallback onTogglePin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.muted.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/vocabulary/detail/${topic.key}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(topic.icon, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      topic.labelVi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTogglePin,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        pinned ? '⭐' : '☆',
                        style: TextStyle(
                          fontSize: 14,
                          color: pinned
                              ? const Color(0xFFD97706)
                              : tokens.mutedForeground.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (counts.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: counts
                      .map(
                        (c) => Text(
                          '${c.level}·${c.count}',
                          style: TextStyle(
                            fontSize: 9,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
