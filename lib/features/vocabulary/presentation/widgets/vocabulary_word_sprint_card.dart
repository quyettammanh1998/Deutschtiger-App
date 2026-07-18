import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// "⚡ Luyện tập với chủ đề" card — web parity: `WordSprintWidget`'s idle
/// state (start button gradient `from-amber-500 to-orange-600`). The actual
/// 60s game already exists as a full-screen route (`/games/word-sprint`,
/// `WordSprintGameScreen`, owned by P7) — this card is the vocabulary-page
/// entry point into it, not a re-implementation of the game.
class VocabularyWordSprintCard extends StatelessWidget {
  const VocabularyWordSprintCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.wordSprintSectionTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEA580C)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/games/word-sprint'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.wordSprintStart, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                        Text(l10n.wordSprintDescription, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
                      ],
                    ),
                  ),
                  const Icon(PhosphorIcons.arrowRight, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
