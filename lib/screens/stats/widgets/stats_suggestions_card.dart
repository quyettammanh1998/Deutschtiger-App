import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

const _suggestionColors = [
  (bg: Color(0xFFFFFBEB), border: Color(0xFFFDE68A), emoji: '💪'),
  (bg: Color(0xFFF0F9FF), border: Color(0xFFBAE6FD), emoji: '🎧'),
  (bg: Color(0xFFFFF1F2), border: Color(0xFFFECDD3), emoji: '🔥'),
];

/// "Gợi ý cải thiện" — up to 3 tips, colored rows. Mirror web
/// `stats-suggestions-card.tsx`. Renders nothing when [suggestions] is empty.
class StatsSuggestionsCard extends StatelessWidget {
  const StatsSuggestionsCard({super.key, required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < suggestions.length; i++)
          Container(
            margin: EdgeInsets.only(
              bottom: i == suggestions.length - 1 ? 0 : 8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _suggestionColors[i % 3].bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _suggestionColors[i % 3].border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _suggestionColors[i % 3].emoji,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    suggestions[i],
                    style: TextStyle(
                      fontSize: 13,
                      color: tokens.foreground.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
