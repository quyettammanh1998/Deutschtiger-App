import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/sprechen_models.dart';
import '../../../../widgets/common/app_card.dart';

/// Shared tag-group card used by both Goethe and TELC topic-list pages
/// (`goethe-sprechen-topic-list-page.tsx` / `sprechen-topic-list-page.tsx`,
/// scout §B.2/§B.10) — collapsible group header + numbered topic rows with
/// lock/done/circle trailing icon.
class SprechenTopicGroupCard extends StatelessWidget {
  const SprechenTopicGroupCard({
    super.key,
    required this.tagId,
    required this.tag,
    required this.topics,
    required this.doneSlugs,
    required this.expanded,
    required this.onToggle,
    required this.onTopicTap,
  });

  final String tagId;
  final SprechenTag? tag;
  final List<SprechenTopic> topics;
  final Set<String> doneSlugs;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<SprechenTopic> onTopicTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final done = topics.where((t) => doneSlugs.contains(t.slug)).length;
    return AppCard.card(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(tag?.emoji ?? '📁'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tag?.label ?? tagId,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '$done/${topics.length}',
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.mutedForeground,
                    ),
                  ),
                  Icon(
                    expanded
                        ? AppPhosphorIcons.caretUp
                        : AppPhosphorIcons.caretDown,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            for (var i = 0; i < topics.length; i++)
              SprechenTopicRow(
                index: i + 1,
                topic: topics[i],
                done: doneSlugs.contains(topics[i].slug),
                onTap: () => onTopicTap(topics[i]),
              ),
        ],
      ),
    );
  }
}

class SprechenTopicRow extends StatelessWidget {
  const SprechenTopicRow({
    super.key,
    required this.index,
    required this.topic,
    required this.done,
    required this.onTap,
  });
  final int index;
  final SprechenTopic topic;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: tokens.muted,
              child: Text('$index', style: const TextStyle(fontSize: 10)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                topic.slug.replaceAll('-', ' '),
                style: TextStyle(
                  color: done ? tokens.mutedForeground : tokens.foreground,
                  decoration: done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (topic.isPremium)
              Icon(AppPhosphorIcons.lock, size: 16, color: tokens.warning)
            else if (done)
              Icon(
                AppPhosphorIcons.checkCircle,
                size: 16,
                color: tokens.success,
              )
            else
              Icon(
                AppPhosphorIcons.circle,
                size: 16,
                color: tokens.mutedForeground,
              ),
          ],
        ),
      ),
    );
  }
}
