import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/phrases_samples_models.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import 'vi_translation_toggle.dart';

/// `sec-beispiele` — groups of sample sentences per writing point.
class WritingSampleSentencesCard extends StatefulWidget {
  const WritingSampleSentencesCard({super.key, required this.groups});

  final List<SampleSentenceGroup> groups;

  @override
  State<WritingSampleSentencesCard> createState() => _WritingSampleSentencesCardState();
}

class _WritingSampleSentencesCardState extends State<WritingSampleSentencesCard> {
  final Set<int> _showVi = {};

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.groups.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.groups[i].point,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                    ),
                    ViTranslationToggle(
                      show: _showVi.contains(i),
                      onToggle: () => setState(
                        () => _showVi.contains(i) ? _showVi.remove(i) : _showVi.add(i),
                      ),
                    ),
                  ],
                ),
                Divider(height: 8, color: tokens.border),
                for (final s in widget.groups[i].sentences)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.de, style: TextStyle(fontSize: 12, color: tokens.foreground)),
                              if (_showVi.contains(i) && s.vi.isNotEmpty)
                                Text(s.vi, style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF2563EB))),
                            ],
                          ),
                        ),
                        WritingAudioPlayButton(text: s.de, audioUrl: s.audioUrl, size: 14),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
