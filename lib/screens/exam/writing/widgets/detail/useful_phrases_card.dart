import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/phrases_samples_models.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';

/// `sec-redemittel` — one nested collapsible category per group, table of
/// (de, vi) rows inside — "Dùng khi" column dropped on mobile per spec.
class WritingUsefulPhrasesCard extends StatefulWidget {
  const WritingUsefulPhrasesCard({super.key, required this.categories});

  final List<UsefulPhraseCategory> categories;

  @override
  State<WritingUsefulPhrasesCard> createState() => _WritingUsefulPhrasesCardState();
}

class _WritingUsefulPhrasesCardState extends State<WritingUsefulPhrasesCard> {
  final Set<int> _open = {};

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.categories.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(border: Border.all(color: tokens.border), borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(
                    () => _open.contains(i) ? _open.remove(i) : _open.add(i),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(widget.categories[i].category,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                        ),
                        Icon(_open.contains(i) ? Icons.expand_less : Icons.expand_more, size: 16, color: tokens.mutedForeground),
                      ],
                    ),
                  ),
                ),
                if (_open.contains(i))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final row in widget.categories[i].rows)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(row.de, style: TextStyle(fontSize: 12, color: tokens.foreground)),
                                      Text(row.vi, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                                    ],
                                  ),
                                ),
                                WritingAudioPlayButton(text: row.de, audioUrl: row.audioUrl, size: 14),
                              ],
                            ),
                          ),
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
