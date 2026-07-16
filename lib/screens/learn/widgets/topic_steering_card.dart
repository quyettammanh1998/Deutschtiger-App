import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/vocabulary/domain/vocabulary_models.dart';
import '../../../l10n/app_localizations.dart';

const _goalLabelKeys = {
  'goethe': 'topicSteeringGoalGoethe',
  'communication': 'topicSteeringGoalConversation',
  'medical': 'topicSteeringGoalNursing',
  'work': 'topicSteeringGoalAbroad',
};

/// "Lộ trình đang ưu tiên" — gradient steering card showing the learner's
/// active learning goals (auto) + pinned topics (manual). Mirrors web
/// `topic-explore-page.tsx`'s steering block: `bg-gradient-to-br
/// from-orange-50 to-amber-50`, white/70 goal chips, amber pinned chips.
class TopicSteeringCard extends StatelessWidget {
  const TopicSteeringCard({
    super.key,
    required this.goals,
    required this.pinnedKeys,
    required this.topicByKey,
  });

  final List<String> goals;
  final Set<String> pinnedKeys;
  final Map<String, VocabularyTopic> topicByKey;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goalChips = goals.where(_goalLabelKeys.containsKey).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  tokens.primary.withValues(alpha: 0.1),
                  const Color(0xFFD97706).withValues(alpha: 0.1),
                ]
              : const [Color(0xFFFFF7ED), Color(0xFFFFFBEB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.topicSteeringTitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 8),
          if (goalChips.isEmpty && pinnedKeys.isEmpty)
            Text(
              l10n.topicSteeringEmpty,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final g in goalChips)
                  _Chip(
                    label: _goalLabel(l10n, g),
                    background: Colors.white.withValues(alpha: 0.7),
                    foreground: tokens.foreground,
                  ),
                for (final key in pinnedKeys)
                  _Chip(
                    label:
                        '⭐ ${_pinnedLabel(topicByKey[key], key)}',
                    background: const Color(0xFFFDE68A).withValues(alpha: 0.6),
                    foreground: const Color(0xFF92400E),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          Text(
            l10n.topicSteeringFooterHint,
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
        ],
      ),
    );
  }

  String _goalLabel(AppLocalizations l10n, String goal) {
    return switch (_goalLabelKeys[goal]) {
      'topicSteeringGoalGoethe' => l10n.topicSteeringGoalGoethe,
      'topicSteeringGoalConversation' => l10n.topicSteeringGoalConversation,
      'topicSteeringGoalNursing' => l10n.topicSteeringGoalNursing,
      'topicSteeringGoalAbroad' => l10n.topicSteeringGoalAbroad,
      _ => goal,
    };
  }

  String _pinnedLabel(VocabularyTopic? topic, String key) {
    if (topic == null) return key;
    return '${topic.icon} ${topic.labelVi}';
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
