// Reading-pane translate toggle — web `mobile-reading-pane.tsx` "Dịch đoạn
// văn" button. Simplified vs web: our domain model merges German passage
// text into the question prompt (see `exam_service.dart#_buildPrompt`), so
// this card only shows the Vietnamese translation as a collapsible extra
// block (not a true in-place swap of the German text) — deviation noted in
// the wave B report.
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import 'exam_player_palette.dart';

class ExamReadingTranslateCard extends StatefulWidget {
  const ExamReadingTranslateCard({
    super.key,
    required this.title,
    required this.translation,
  });

  final String title;
  final String translation;

  @override
  State<ExamReadingTranslateCard> createState() =>
      _ExamReadingTranslateCardState();
}

class _ExamReadingTranslateCardState extends State<ExamReadingTranslateCard> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: examIndigoBorder(context), width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: examIndigoText(context),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _show = !_show),
                child: Text(
                  _show
                      ? l10n.examHideTranslation
                      : l10n.examTranslateParagraph,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (_show)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.translation,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: tokens.foreground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
