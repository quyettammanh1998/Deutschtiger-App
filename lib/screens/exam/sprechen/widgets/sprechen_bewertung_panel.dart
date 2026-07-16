import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/sprechen_chat_models.dart';
import '../../../../l10n/app_localizations.dart';

/// Web parity: `sprechen-bewertung-panel.tsx` — grading card shown below
/// the chat. Category rows (Inhalt / Grammatik & Satzbau / Wortschatz &
/// Flüssigkeit) each score out of `max/3`; GESAMT is the bold total row.
class SprechenBewertungPanel extends StatelessWidget {
  const SprechenBewertungPanel({
    super.key,
    required this.grading,
    required this.isRunning,
  });

  final SprechenGrading? grading;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final grading = this.grading;
    final maxCategory = grading == null ? 0 : grading.max / 3;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '✏ Bewertung / max. ${grading?.max.toInt() ?? '-'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (isRunning) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: tokens.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'LAUFEND',
                  style: TextStyle(fontSize: 10, color: tokens.success),
                ),
              ] else
                Text(
                  'Idle',
                  style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            grading == null ? '- / -' : '${grading.total} / ${grading.max}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: tokens.primary,
            ),
          ),
          if (grading != null) ...[
            const SizedBox(height: 10),
            _CategoryRow(
              label: 'INHALT',
              score: grading.inhalt,
              max: maxCategory,
            ),
            _CategoryRow(
              label: 'GRAMMATIK & SATZBAU',
              score: grading.grammatik,
              max: maxCategory,
            ),
            _CategoryRow(
              label: 'WORTSCHATZ & FLÜSSIGKEIT',
              score: grading.wortschatz,
              max: maxCategory,
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GESAMT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${grading.total}/${grading.max}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (grading.mainErrors.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context).sprechenBewertungMainErrors,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: tokens.warning,
                ),
              ),
              const SizedBox(height: 4),
              for (final e in grading.mainErrors)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '• $e',
                    style: TextStyle(fontSize: 12, color: tokens.foreground),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.label,
    required this.score,
    required this.max,
  });
  final String label;
  final num score;
  final num max;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
          Text('$score/${max.toStringAsFixed(max == max.roundToDouble() ? 0 : 1)}',
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
