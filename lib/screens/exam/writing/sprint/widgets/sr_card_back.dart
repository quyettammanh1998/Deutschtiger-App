import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import '../../../../../l10n/app_localizations.dart';
import 'sr_rating_bar.dart';

/// SR card back face — match result + outline diff + audio + mini-model
/// toggle + redemittel chips + rating bar. Web parity `sr-card-back.tsx`.
class SrCardBack extends StatefulWidget {
  const SrCardBack({
    super.key,
    required this.topic,
    required this.userBullets,
    required this.matchResults,
    required this.mode,
    required this.onRate,
  });

  final SprintTopicData topic;
  final List<String> userBullets;
  final List<bool> matchResults;
  final SRMode mode;
  final ValueChanged<SRRating> onRate;

  @override
  State<SrCardBack> createState() => _SrCardBackState();
}

class _SrCardBackState extends State<SrCardBack> {
  bool _miniModelOpen = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final speedrun = widget.topic.speedrun;
    final outlineDe = speedrun?.outline3.de ?? const [];
    final outlineAudio = speedrun?.outline3Audio ?? const [];
    final miniModel = speedrun?.miniModel;
    final redemittel = (speedrun?.redemittelCore ?? const []).take(5).toList();
    final matchCount = widget.matchResults.where((m) => m).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(
          tokens,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Match: $matchCount/3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground)),
                  const SizedBox(width: 8),
                  for (final m in widget.matchResults)
                    Text(m ? '✓' : '✗', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: m ? tokens.success : tokens.destructive)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                matchCount >= 2 ? l10n.writingSprintMatchGood : l10n.writingSprintMatchWeak,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          tokens,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.writingSprintOutlineAnswerLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground)),
              const SizedBox(height: 8),
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.matchResults[i] ? '✓' : '✗',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: widget.matchResults[i] ? tokens.success : tokens.destructive),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              i < outlineDe.length && outlineDe[i].isNotEmpty ? outlineDe[i] : l10n.writingSprintOutlineMissing(i + 1),
                              style: TextStyle(fontSize: 13, color: tokens.foreground),
                            ),
                          ),
                        ],
                      ),
                      if (widget.userBullets[i].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 2),
                          child: Text(
                            l10n.writingSprintYouWrote(widget.userBullets[i]),
                            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: tokens.mutedForeground),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (outlineAudio.isNotEmpty || (miniModel?.de.isNotEmpty ?? false)) ...[
          const SizedBox(height: 12),
          _card(
            tokens,
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (var i = 0; i < outlineAudio.length; i++)
                  WritingAudioPlayButton(text: i < outlineDe.length ? outlineDe[i] : '', audioUrl: outlineAudio[i]),
                if (miniModel != null && miniModel.de.isNotEmpty)
                  WritingAudioPlayButton(text: miniModel.de, audioUrl: miniModel.audioUrl),
              ],
            ),
          ),
        ],
        if (miniModel != null && miniModel.de.isNotEmpty) ...[
          const SizedBox(height: 12),
          _card(
            tokens,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => setState(() => _miniModelOpen = !_miniModelOpen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.writingSprintMiniModelToggle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground)),
                      Icon(_miniModelOpen ? Icons.expand_less : Icons.expand_more, color: tokens.mutedForeground),
                    ],
                  ),
                ),
                if (_miniModelOpen) ...[
                  const SizedBox(height: 8),
                  Text(miniModel.de, style: TextStyle(fontSize: 13, height: 1.5, color: tokens.foreground)),
                  if (miniModel.vi.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(miniModel.vi, style: TextStyle(fontSize: 12, height: 1.4, color: tokens.mutedForeground)),
                  ],
                ],
              ],
            ),
          ),
        ],
        if (redemittel.isNotEmpty) ...[
          const SizedBox(height: 12),
          _card(
            tokens,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.writingSprintRedemittelLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final r in redemittel)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(r.de, style: TextStyle(fontSize: 12, color: tokens.foreground)),
                            WritingAudioPlayButton(text: r.de, audioUrl: r.audioUrl, size: 14),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        SrRatingBar(mode: widget.mode, onRate: widget.onRate),
      ],
    );
  }

  Widget _card(AppTokens tokens, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: tokens.border)),
      child: child,
    );
  }
}
