import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

enum DictationActivity { menu, cloze, fullDictation, karaoke }

/// 3-activity picker — mirrors web `exam-dictation-page.tsx` activity menu.
class DictationActivityMenu extends StatelessWidget {
  const DictationActivityMenu({super.key, required this.onSelect});

  final ValueChanged<DictationActivity> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.dictationActivityMenuPrompt,
          style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
        ),
        const SizedBox(height: 16),
        _ActivityCard(
          emoji: '🧩',
          title: l10n.dictationActivityClozeTitle,
          desc: l10n.dictationActivityClozeDesc,
          onTap: () => onSelect(DictationActivity.cloze),
        ),
        const SizedBox(height: 12),
        _ActivityCard(
          emoji: '✍️',
          title: l10n.dictationActivityFullTitle,
          desc: l10n.dictationActivityFullDesc,
          onTap: () => onSelect(DictationActivity.fullDictation),
        ),
        const SizedBox(height: 12),
        _ActivityCard(
          emoji: '🎧',
          title: l10n.dictationActivityKaraokeTitle,
          desc: l10n.dictationActivityKaraokeDesc,
          onTap: () => onSelect(DictationActivity.karaoke),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String desc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(tokens.radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: tokens.foreground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
