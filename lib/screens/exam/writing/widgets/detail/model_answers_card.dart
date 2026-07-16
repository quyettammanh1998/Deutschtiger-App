import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/phrases_samples_models.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import '../../../../../l10n/app_localizations.dart';
import 'vi_translation_toggle.dart';

/// `sec-muster` — tabbed model answers (when >1) + bilingual body +
/// annotations. "Gõ lại" (typing-practice-scoped-to-this-model) button
/// omitted here — the page-level "Bắt đầu gõ →" card already covers all
/// collected sentences including model answers (documented deviation, not a
/// missing feature: same content reachable, fewer entry points).
class WritingModelAnswersCard extends StatefulWidget {
  const WritingModelAnswersCard({super.key, required this.models});

  final List<ModelAnswer> models;

  @override
  State<WritingModelAnswersCard> createState() => _WritingModelAnswersCardState();
}

class _WritingModelAnswersCardState extends State<WritingModelAnswersCard> {
  int _active = 0;
  bool _showVi = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    if (widget.models.isEmpty) return const SizedBox.shrink();
    final model = widget.models[_active.clamp(0, widget.models.length - 1)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.models.length > 1)
          Wrap(
            spacing: 6,
            children: [
              for (var i = 0; i < widget.models.length; i++)
                InkWell(
                  onTap: () => setState(() => _active = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _active == i ? const Color(0xFFF97316) : tokens.muted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${l10n.writingModelTabLabel(i + 1)}${widget.models[i].wordCount != null ? ' (${widget.models[i].wordCount}w)' : ''}',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _active == i ? Colors.white : tokens.mutedForeground),
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(model.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
            ),
            if (model.vi.isNotEmpty) ViTranslationToggle(show: _showVi, onToggle: () => setState(() => _showVi = !_showVi)),
            WritingAudioPlayButton(text: model.de, audioUrl: model.audioUrl),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.de, style: TextStyle(fontSize: 13, color: tokens.foreground, height: 1.6)),
              if (_showVi && model.vi.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(model.vi, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF2563EB))),
              ],
            ],
          ),
        ),
        if (model.annotations.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.writingAnnotationsLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.mutedForeground)),
          for (final a in model.annotations)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('• $a', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
            ),
        ],
      ],
    );
  }
}
