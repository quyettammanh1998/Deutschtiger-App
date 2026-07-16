import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/sticky_cta_bar.dart';

/// Mobile sticky bottom bar — "Học" (guided lesson) / "Chơi" (practice mode
/// chooser). Web parity: `deck-learn-bottom-bar.tsx`.
class DeckLearnBottomBar extends StatelessWidget {
  const DeckLearnBottomBar({
    super.key,
    required this.onLearn,
    required this.onPractice,
  });

  final VoidCallback onLearn;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final darkened = Color.lerp(tokens.primary, Colors.black, 0.2)!;

    return StickyCtaBar(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onPractice,
              icon: Icon(PhosphorIconsBold.gameController, size: 18),
              label: Text(l10n.deckPlayCta),
              style: OutlinedButton.styleFrom(
                foregroundColor: tokens.foreground,
                side: BorderSide(color: tokens.border),
                minimumSize: const Size.fromHeight(46),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [tokens.primary, darkened]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onLearn,
                  child: SizedBox(
                    height: 46,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(PhosphorIconsBold.graduationCap, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          l10n.deckLearnCta,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
