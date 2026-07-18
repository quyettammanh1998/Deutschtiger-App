import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/speak_button.dart';
import '../../../../shared/widgets/tappable_sentence.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Web parity: `sprechen-study-panel.tsx` — renders the topic's study
/// markdown (`GET /exams/official/sprechen-content`). Web splits this into
/// per-teil accordions (Redemittel chips, Lesetexte A/B, Musterdialog…);
/// this build renders the markdown as tappable/speakable paragraph blocks
/// split on blank lines, which keeps every line translatable + TTS-able
/// without hand-parsing teil-specific markdown structure — documented
/// deviation, see phase report §per-page table.
class SprechenStudyPanel extends StatelessWidget {
  const SprechenStudyPanel({
    super.key,
    required this.markdown,
    required this.locked,
    this.onWordTap,
  });

  final String markdown;
  final bool locked;
  final ValueChanged<String>? onWordTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (locked) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: tokens.muted,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(PhosphorIcons.lock, color: tokens.warning, size: 28),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).sprechenStudyPanelLocked,
              textAlign: TextAlign.center,
              style: TextStyle(color: tokens.mutedForeground),
            ),
          ],
        ),
      );
    }

    final blocks = markdown
        .split(RegExp(r'\n{2,}'))
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty)
        .toList();

    if (blocks.isEmpty) {
      return Text(
        AppLocalizations.of(context).sprechenStudyPanelEmpty,
        style: TextStyle(color: tokens.mutedForeground),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final block in blocks)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tokens.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TappableSentence(
                      text: block,
                      onWordTap: onWordTap ?? (_) {},
                    ),
                  ),
                  SpeakButton(text: block, iconSize: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
