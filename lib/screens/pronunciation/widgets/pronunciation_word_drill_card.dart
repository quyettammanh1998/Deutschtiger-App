import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../view_models/providers.dart' show audioServiceProvider;

/// "Phát âm" drill card — web parity: word card (4xl word + IPA + VI
/// meaning), amber "Mẹo phát âm:" hint, gradient "Nghe phát âm" button
/// (delegates playback to the app's shared `AudioService` TTS pipeline — no
/// recorder), and a gradient/disabled "Tôi đã đọc →" advance button. Shared
/// by all four trainers, only the badge/gradient colors differ per module.
class PronunciationWordDrillCard extends ConsumerStatefulWidget {
  const PronunciationWordDrillCard({
    super.key,
    required this.progressLabel,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.word,
    required this.ipa,
    required this.meaning,
    required this.hintLabel,
    required this.hint,
    required this.gradient,
    required this.playLabel,
    required this.played,
    required this.onPlayed,
    required this.nextLabel,
    required this.onNext,
    this.compareLabel,
  });

  final String progressLabel;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  final String word;
  final String ipa;
  final String meaning;

  /// "So sánh: `minimal_pair`" — Ich-/Ach-laut only.
  final String? compareLabel;

  final String hintLabel;
  final String hint;

  final List<Color> gradient;
  final String playLabel;

  /// Whether the word has been played at least once this round — gates the
  /// advance button, matching web's `disabled={!read}`.
  final bool played;

  /// Called right after playback has started, so the caller can flip its
  /// `read` flag (matches web's `speakDe(word); setRead(true)`).
  final VoidCallback onPlayed;

  final String nextLabel;
  final VoidCallback onNext;

  @override
  ConsumerState<PronunciationWordDrillCard> createState() =>
      _PronunciationWordDrillCardState();
}

class _PronunciationWordDrillCardState
    extends ConsumerState<PronunciationWordDrillCard> {
  bool _playing = false;

  Future<void> _handlePlay() async {
    if (_playing) return;
    setState(() => _playing = true);
    try {
      await ref.read(audioServiceProvider).play(text: widget.word);
      widget.onPlayed();
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.progressLabel,
              style: TextStyle(color: tokens.mutedForeground, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: widget.badgeColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                widget.badgeLabel,
                style: TextStyle(
                  color: widget.badgeTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            children: [
              Text(
                widget.word,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '[${widget.ipa}]',
                style: TextStyle(color: tokens.mutedForeground, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                widget.meaning,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
              ),
              if (widget.compareLabel != null &&
                  widget.compareLabel!.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  widget.compareLabel!,
                  style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            // Amber callout: keep the warm cream tint in light mode; in dark
            // mode use a translucent amber surface with light amber text so the
            // hint stays readable against the dark background.
            final hintBackground = isDark
                ? const Color(0x33F59E0B)
                : const Color(0xFFFFFBEB);
            final hintTextColor = isDark
                ? const Color(0xFFFCD34D)
                : const Color(0xFF78350F);
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: hintBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: hintTextColor,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: '${widget.hintLabel} ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: widget.hint),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.gradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _playing ? null : _handlePlay,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_playing)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      widget.playLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: widget.played
                ? const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF0D9488)],
                  )
                : null,
            color: widget.played ? null : tokens.muted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.played ? widget.onNext : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  widget.nextLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: widget.played
                        ? Colors.white
                        : tokens.mutedForeground,
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
