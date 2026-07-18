// Footer bar — web `mobile-footer-bar.tsx`: section label, 32px blue
// prev/next squares, amber counter pill that opens the nav sheet.
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import 'exam_player_palette.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class MobileFooterBar extends StatelessWidget {
  const MobileFooterBar({
    super.key,
    required this.canGoPrev,
    required this.canGoNext,
    required this.currentDisplayNumber,
    required this.answerableCount,
    required this.onPrev,
    required this.onNext,
    required this.onToggleNav,
    this.sectionLabel,
  });

  final bool canGoPrev;
  final bool canGoNext;
  final int currentDisplayNumber;
  final int answerableCount;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToggleNav;
  final String? sectionLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (sectionLabel != null)
              Flexible(
                child: Text(
                  sectionLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: tokens.mutedForeground.withValues(alpha: 0.7),
                  ),
                ),
              ),
            const Spacer(),
            _SquareButton(
              icon: PhosphorIcons.caretLeft,
              enabled: canGoPrev,
              tooltip: l10n.examNavPrevQuestion,
              onTap: onPrev,
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onToggleNav,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: examAmberSoft(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.squaresFour,
                      size: 14,
                      color: examAmberFg(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$currentDisplayNumber/$answerableCount',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: examAmberFg(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SquareButton(
              icon: PhosphorIcons.caretRight,
              enabled: canGoNext,
              tooltip: l10n.examNavNextQuestion,
              onTap: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.enabled,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? examNavBlue(context) : tokens.muted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: enabled
                ? Colors.white
                : tokens.mutedForeground.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
