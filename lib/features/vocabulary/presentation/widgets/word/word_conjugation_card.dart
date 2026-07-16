import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../domain/vocabulary_models.dart';

const _pronouns = ['ich', 'du', 'er/sie/es', 'wir', 'ihr', 'sie/Sie'];

/// "🔄 Chia động từ" card — web parity `WordConjugationTable`. Handles the
/// two backend shapes: `raw` single-line summary, or `praesens`/
/// `praeteritum` 6-form lists + `perfekt`/`konjunktiv_ii` single strings.
///
/// Only the subset of tenses [ConjugationInfo] carries (praesens/praeteritum/
/// perfekt/konjunktiv_ii/raw) is rendered — the richer web table
/// (plusquamperfekt/futur/konjunktiv_i/…) needs backend+model fields the
/// Flutter domain model does not expose yet (documented deviation).
class WordConjugationCard extends StatelessWidget {
  const WordConjugationCard({
    super.key,
    required this.conjugation,
    this.auxiliary,
    this.isSeparable,
    this.separablePrefix,
  });

  final ConjugationInfo conjugation;
  final String? auxiliary;
  final bool? isSeparable;
  final String? separablePrefix;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final praesens = conjugation.praesens ?? const [];
    final praeteritum = conjugation.praeteritum ?? const [];
    final hasTable = praesens.isNotEmpty || praeteritum.isNotEmpty;
    final displayPrefix = separablePrefix ?? '';
    final displaySeparable = isSeparable ?? displayPrefix.isNotEmpty;

    if (!hasTable && (conjugation.raw ?? '').isNotEmpty) {
      return _RawSummary(
        raw: conjugation.raw!,
        auxiliary: auxiliary,
        isSeparable: displaySeparable,
        separablePrefix: displayPrefix,
      );
    }
    if (!hasTable && (conjugation.perfekt ?? '').isEmpty && (conjugation.konjunktivIi ?? '').isEmpty) {
      return const SizedBox.shrink();
    }

    const violet = Color(0xFF7C3AED);
    return Container(
      decoration: BoxDecoration(
        color: violet.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: violet.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text('🔄 Bảng chia động từ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: violet)),
              if ((auxiliary ?? '').isNotEmpty) _Badge(text: auxiliary!, color: const Color(0xFF3B82F6)),
              if (displaySeparable && displayPrefix.isNotEmpty)
                _Badge(text: 'trennbar: $displayPrefix…', color: const Color(0xFFF59E0B)),
            ],
          ),
          if (hasTable) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 28,
                dataRowMinHeight: 26,
                dataRowMaxHeight: 30,
                columnSpacing: 16,
                columns: [
                  const DataColumn(label: Text('Pronomen', style: TextStyle(fontSize: 11))),
                  if (praesens.isNotEmpty) const DataColumn(label: Text('Präsens', style: TextStyle(fontSize: 11))),
                  if (praeteritum.isNotEmpty) const DataColumn(label: Text('Präteritum', style: TextStyle(fontSize: 11))),
                ],
                rows: [
                  for (var i = 0; i < _pronouns.length; i++)
                    DataRow(
                      cells: [
                        DataCell(Text(_pronouns[i], style: TextStyle(fontSize: 11, color: tokens.mutedForeground))),
                        if (praesens.isNotEmpty) DataCell(Text(i < praesens.length ? praesens[i] : '—', style: const TextStyle(fontSize: 11))),
                        if (praeteritum.isNotEmpty) DataCell(Text(i < praeteritum.length ? praeteritum[i] : '—', style: const TextStyle(fontSize: 11))),
                      ],
                    ),
                ],
              ),
            ),
          ] else ...[
            if ((conjugation.perfekt ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text.rich(TextSpan(children: [
                TextSpan(text: 'Perfekt: ', style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                TextSpan(text: conjugation.perfekt, style: TextStyle(fontSize: 12, color: tokens.foreground)),
              ])),
            ],
            if ((conjugation.konjunktivIi ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text.rich(TextSpan(children: [
                TextSpan(text: 'Konjunktiv II: ', style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                TextSpan(text: conjugation.konjunktivIi, style: TextStyle(fontSize: 12, color: tokens.foreground)),
              ])),
            ],
          ],
        ],
      ),
    );
  }
}

class _RawSummary extends StatelessWidget {
  const _RawSummary({required this.raw, this.auxiliary, required this.isSeparable, required this.separablePrefix});
  final String raw;
  final String? auxiliary;
  final bool isSeparable;
  final String separablePrefix;

  static const _labels = ['Infinitiv', 'Präsens (er)', 'Präteritum', 'Perfekt'];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final parts = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return const SizedBox.shrink();
    const violet = Color(0xFF7C3AED);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: violet.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: violet.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text('🔄 Chia động từ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: violet)),
              if ((auxiliary ?? '').isNotEmpty) _Badge(text: auxiliary!, color: const Color(0xFF3B82F6)),
              if (isSeparable && separablePrefix.isNotEmpty)
                _Badge(text: 'trennbar: $separablePrefix…', color: const Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              for (var i = 0; i < parts.length && i < 4; i++)
                Text.rich(TextSpan(children: [
                  TextSpan(text: '${_labels[i]}: ', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                  TextSpan(text: parts[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.foreground)),
                ])),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}
