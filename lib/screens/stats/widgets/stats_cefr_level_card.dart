import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

String _cefrLabel(AppLocalizations l10n, String level) => switch (level) {
  'A1' => l10n.statsCefrA1,
  'A2' => l10n.statsCefrA2,
  'B1' => l10n.statsCefrB1,
  'B2' => l10n.statsCefrB2,
  'C1' => l10n.statsCefrC1,
  'C2' => l10n.statsCefrC2,
  _ => l10n.statsCefrA1,
};

/// "Hồ sơ năng lực" — CEFR level badge card. Mirror web
/// `stats-cefr-level-card.tsx`.
class StatsCefrLevelCard extends StatelessWidget {
  const StatsCefrLevelCard({
    super.key,
    required this.cefrLevel,
    required this.wordsLearned,
  });

  final String cefrLevel;
  final int wordsLearned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final level = cefrLevel.isEmpty ? 'A1' : cefrLevel;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              level,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _cefrLabel(l10n, level),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  l10n.statsCefrWordsLearned(wordsLearned),
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
