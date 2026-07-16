import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../view_models/providers.dart';

/// Shared "currently playing" token so every [WritingAudioPlayButton] on a
/// page stays mutually exclusive (starting one visually stops the others).
/// [AudioService] itself already stops the previous sound on every `play()`
/// call (shared provider instance) — this token only drives the icon state.
final writingActiveAudioTokenProvider = StateProvider<Object?>((ref) => null);

/// Small icon button that plays [audioUrl] (falls back to on-device TTS of
/// [text]) — web parity `audio-play-btn.tsx`. One of the only 3 phosphor-
/// icon-equivalent controls on the writing-detail reader per the component
/// spec; simplified here to a stateful speaker/pause Material icon (no
/// loading spinner distinction between file vs TTS — acceptable, both paths
/// resolve in well under a second on this app's cached-TTS backend).
class WritingAudioPlayButton extends ConsumerStatefulWidget {
  const WritingAudioPlayButton({super.key, required this.text, this.audioUrl, this.size = 16});

  final String text;
  final String? audioUrl;
  final double size;

  @override
  ConsumerState<WritingAudioPlayButton> createState() => _WritingAudioPlayButtonState();
}

class _WritingAudioPlayButtonState extends ConsumerState<WritingAudioPlayButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final token = ref.watch(writingActiveAudioTokenProvider);
    final isPlaying = identical(token, this);

    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(widget.size + 20, widget.size + 20)),
      icon: _loading
          ? SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: tokens.mutedForeground),
            )
          : Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.volume_up,
              size: widget.size,
              color: isPlaying ? tokens.primary : tokens.mutedForeground,
            ),
      onPressed: widget.text.trim().isEmpty ? null : _toggle,
    );
  }

  Future<void> _toggle() async {
    final audio = ref.read(audioServiceProvider);
    final current = ref.read(writingActiveAudioTokenProvider);
    if (identical(current, this)) {
      await audio.stop();
      if (mounted) ref.read(writingActiveAudioTokenProvider.notifier).state = null;
      return;
    }
    setState(() => _loading = true);
    ref.read(writingActiveAudioTokenProvider.notifier).state = this;
    final started = await audio.play(audioUrl: widget.audioUrl, text: widget.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!started && identical(ref.read(writingActiveAudioTokenProvider), this)) {
      ref.read(writingActiveAudioTokenProvider.notifier).state = null;
    }
  }
}
