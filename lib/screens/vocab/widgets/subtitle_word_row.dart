import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/vocab/subtitle_word.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import '../../../widgets/common/app_pill.dart';

/// Web parity: `WordRow` in `subtitle-words-page.tsx` — tappable `.card` row
/// with checkbox + ring selection, orange "đã thấy Nx" pill, level/word-type
/// pills, and a 🔊 button.
class SubtitleWordRow extends ConsumerWidget {
  const SubtitleWordRow({
    super.key,
    required this.word,
    required this.selected,
    required this.onToggle,
  });

  final SubtitleWord word;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final radius = BorderRadius.circular(16);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: radius,
            border: Border.all(
              color: selected ? tokens.primary.withValues(alpha: 0.6) : tokens.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Checkbox(
                  value: selected,
                  onChanged: (_) => onToggle(),
                  activeColor: tokens.primary,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          word.contentDe,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: tokens.foreground,
                          ),
                        ),
                        if (word.ipa != null && word.ipa!.isNotEmpty)
                          Text(
                            '[${word.ipa}]',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: tokens.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      word.contentVi,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        AppPill(
                          label: l10n.subtitleWordsSeenCount(word.seenCount),
                          background: const Color(0xFFF97316).withValues(alpha: 0.15),
                          foreground: const Color(0xFFEA580C),
                          fontSize: 10,
                        ),
                        if (word.level != null && word.level!.isNotEmpty)
                          AppPill(label: word.level!, fontSize: 10),
                        if (word.wordType != null && word.wordType!.isNotEmpty)
                          AppPill(label: word.wordType!, fontSize: 10),
                      ],
                    ),
                  ],
                ),
              ),
              if (word.audioUrl != null && word.audioUrl!.isNotEmpty)
                IconButton(
                  icon: Icon(AppPhosphorIcons.speakerHigh, size: 18, color: tokens.mutedForeground),
                  onPressed: () => ref
                      .read(audioServiceProvider)
                      .play(audioUrl: word.audioUrl, text: word.contentDe),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
