import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/sticky_cta_bar.dart';
import 'word_selection_clip_card.dart';

/// Prep screen for the cloze activity — tap-to-select transcript words +
/// sticky bottom CTA. Mirrors web `exam-dictation-page.tsx`
/// `DictationTranscriptView` + mobile sticky chip/CTA bar (desktop's
/// `ExamWordSelectionPanel` search sidebar is folded into this single
/// scrollable column since the app is mobile-only).
class WordSelectionPanel extends StatefulWidget {
  const WordSelectionPanel({
    super.key,
    required this.audios,
    required this.words,
    required this.selected,
    required this.onStart,
  });

  final List<ExamDictationAudio> audios;
  final List<ExamContentWord> words;
  final Set<String> selected;
  final VoidCallback onStart;

  @override
  State<WordSelectionPanel> createState() => _WordSelectionPanelState();
}

class _WordSelectionPanelState extends State<WordSelectionPanel> {
  final Set<int> _expanded = {};
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final contentWords = widget.words.map((w) => w.clean).toSet();
    final contentClips = <int>[];
    for (var i = 0; i < widget.audios.length; i++) {
      final hasContent = widget.audios[i].sentences.any(
        (s) => s.words.any((w) => contentWords.contains(w.clean)),
      );
      if (hasContent) contentClips.add(i);
    }
    if (!_initialized && contentClips.isNotEmpty) {
      _expanded.add(contentClips.first);
      _initialized = true;
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    l10n.dictationWordSelectHint,
                    style: TextStyle(fontSize: 11.5, color: tokens.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (final i in contentClips)
                WordSelectionClipCard(
                  audio: widget.audios[i],
                  label: 'Teil ${i + 1}',
                  contentWords: contentWords,
                  expanded: _expanded.contains(i),
                  onToggle: () => setState(() {
                    if (!_expanded.remove(i)) _expanded.add(i);
                  }),
                  selected: widget.selected,
                  onToggleWord: (clean) => setState(() {
                    if (!widget.selected.remove(clean)) {
                      widget.selected.add(clean);
                    }
                  }),
                ),
            ],
          ),
        ),
        StickyCtaBar(
          child: SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: widget.selected.isEmpty
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                      ),
                color: widget.selected.isEmpty ? tokens.muted : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.selected.isEmpty ? null : widget.onStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Center(
                      child: Text(
                        widget.selected.isEmpty
                            ? l10n.dictationWordSelectCtaEmpty
                            : l10n.dictationWordSelectCta(
                                widget.selected.length,
                              ),
                        style: TextStyle(
                          color: widget.selected.isEmpty
                              ? tokens.mutedForeground
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
