import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/app_card.dart';

/// Web parity: `de-thi-passage-panel.tsx` — passage text, per-passage
/// answered-count badge, and a translate toggle unlocked only after submit.
class DeThiPassagePanel extends StatefulWidget {
  const DeThiPassagePanel({
    super.key,
    required this.passage,
    required this.index,
    required this.answeredCount,
    required this.totalCount,
    required this.submitted,
  });

  final DeThiPassage passage;
  final int index;
  final int answeredCount;
  final int totalCount;
  final bool submitted;

  @override
  State<DeThiPassagePanel> createState() => _DeThiPassagePanelState();
}

class _DeThiPassagePanelState extends State<DeThiPassagePanel> {
  bool _showVi = false;

  @override
  void didUpdateWidget(covariant DeThiPassagePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.passage.id != widget.passage.id) {
      _showVi = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final emerald = const Color(0xFF10B981);
    final blue = const Color(0xFF2563EB);
    final done = widget.answeredCount == widget.totalCount;

    return AppCard.card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.deThiPassageLabel(widget.index + 1),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: tokens.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.passage.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: tokens.foreground,
                      ),
                    ),
                    if (widget.passage.source != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          widget.passage.source!,
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: done ? emerald.withValues(alpha: 0.15) : tokens.muted,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.deThiPassageAnsweredCount(
                    widget.answeredCount,
                    widget.totalCount,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: done ? emerald : tokens.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            widget.passage.textDe,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: tokens.foreground,
            ),
          ),
          if (widget.passage.textVi.isNotEmpty) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: widget.submitted
                  ? () => setState(() => _showVi = !_showVi)
                  : null,
              child: Opacity(
                opacity: widget.submitted ? 1 : 0.5,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: blue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        AppPhosphorIcons.translate,
                        size: 14,
                        color: blue,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _showVi ? l10n.deThiHideTranslation : l10n.deThiTranslatePassage,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.submitted ? blue : tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showVi && widget.submitted) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: blue.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: blue, width: 2)),
                ),
                child: Text(
                  widget.passage.textVi,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: tokens.foreground,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
