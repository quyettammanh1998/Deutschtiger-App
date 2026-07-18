import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/grammar_wortschatz_mistakes.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../view_models/providers.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _genusColor = {'m': Color(0xFF3B82F6), 'f': Color(0xFFF43F5E), 'n': Color(0xFF10B981)};
const _genusArticle = {'m': 'der', 'f': 'die', 'n': 'das'};

/// `sec-wortschatz` (default closed) — kernwortschatz grouped by genus +
/// chunks + konnektoren, with a legacy `flat[]` fallback.
///
/// DEVIATION: web's filter pills (Tất cả/der/die/das) and per-genus counts
/// are dropped — this renders every genus group directly. "🌐 Dịch ví dụ"
/// is rerouted through the backend `TranslationService`
/// (`POST /ai/translate-sentences`) instead of calling Google Translate
/// client-side, per the plan's explicit guidance for this exact case.
class WritingWortschatzCard extends ConsumerStatefulWidget {
  const WritingWortschatzCard({super.key, required this.box});

  final WortschatzBox box;

  @override
  ConsumerState<WritingWortschatzCard> createState() => _WritingWortschatzCardState();
}

class _WritingWortschatzCardState extends ConsumerState<WritingWortschatzCard> {
  bool _translating = false;
  final Map<String, String> _translatedExamples = {};

  Future<void> _translateMissing(List<KernwortschatzItem> items) async {
    final missing = items
        .where((w) => (w.example ?? '').isNotEmpty && (w.exampleVi ?? '').isEmpty)
        .map((w) => w.example!)
        .toList();
    if (missing.isEmpty || _translating) return;
    setState(() => _translating = true);
    final results = await ref
        .read(translationServiceProvider)
        .translateBatch(texts: missing, targetLang: 'vi', sourceLang: 'de');
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < missing.length; i++) {
        if (results[i].success) _translatedExamples[missing[i]] = results[i].text;
      }
      _translating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final box = widget.box;
    final kernList = box.kernwortschatz.isNotEmpty ? box.kernwortschatz : box.flat;
    final grouped = <String, List<KernwortschatzItem>>{};
    for (final w in kernList) {
      final key = _genusArticle.containsKey(w.genus) ? w.genus! : 'other';
      grouped.putIfAbsent(key, () => []).add(w);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kernList.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text(l10n.writingKernwortschatzTitle(kernList.length),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
              ),
              TextButton.icon(
                onPressed: _translating ? null : () => _translateMissing(kernList),
                icon: _translating
                    ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5))
                    : const Icon(PhosphorIcons.translate, size: 14),
                label: Text(l10n.writingTranslateExamples, style: const TextStyle(fontSize: 11)),
              ),
            ],
          ),
          for (final genus in ['m', 'f', 'n', 'other'])
            if (grouped[genus] != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  genus == 'other' ? l10n.writingGenusOther : '${_genusArticle[genus]} · ${grouped[genus]!.length}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _genusColor[genus] ?? tokens.mutedForeground),
                ),
              ),
              for (final w in grouped[genus]!) _KernwortRow(item: w, color: _genusColor[genus] ?? tokens.mutedForeground, translated: _translatedExamples[w.example]),
            ],
        ],
        if (box.chunks.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.writingChunksTitle(box.chunks.length), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
          for (final c in box.chunks)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0xFFF59E0B), width: 3))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.chunk, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                        Text(c.vi, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                      ],
                    ),
                  ),
                  WritingAudioPlayButton(text: c.chunk, audioUrl: c.audioUrl, size: 14),
                ],
              ),
            ),
        ],
        if (box.konnektoren.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.writingKonnektorenTitle(box.konnektoren.length), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
          for (final k in box.konnektoren)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0xFF8B5CF6), width: 3))),
              child: Row(
                children: [
                  Expanded(child: Text('${k.de} — ${k.vi}', style: TextStyle(fontSize: 12, color: tokens.foreground))),
                  WritingAudioPlayButton(text: k.de, audioUrl: k.audioUrl, size: 14),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _KernwortRow extends StatelessWidget {
  const _KernwortRow({required this.item, required this.color, this.translated});
  final KernwortschatzItem item;
  final Color color;
  final String? translated;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final exampleVi = item.exampleVi ?? translated;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: item.de, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                  TextSpan(text: ' — ${item.vi}', style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                ])),
              ),
              WritingAudioPlayButton(text: item.de, audioUrl: item.audioUrl, size: 14),
            ],
          ),
          if ((item.example ?? '').isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(item.example!, style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: tokens.mutedForeground)),
            ),
            if (exampleVi != null)
              Text('→ $exampleVi', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
          ],
          if ((item.collocation ?? '').isNotEmpty)
            Text('Coll: ${item.collocation}', style: const TextStyle(fontSize: 11, color: Color(0xFFEA580C))),
        ],
      ),
    );
  }
}
