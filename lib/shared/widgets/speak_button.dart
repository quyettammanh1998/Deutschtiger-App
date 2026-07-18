import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../view_models/providers.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Speaker icon button that plays a remote audio URL via [just_audio].
///
/// A single shared [AudioPlayer] is held per widget instance and disposed in
/// [dispose]. Callers may pass a custom [player] for centralised control
/// (e.g. one player per screen) by using the [player] parameter.
class SpeakButton extends ConsumerStatefulWidget {
  const SpeakButton({
    super.key,
    required this.text,
    this.audioUrl,
    this.onTap,
    this.iconSize = 22,
    this.tooltip = 'Nghe phát âm',
  });

  /// German text used by the server and on-device TTS fallbacks.
  final String text;

  /// Remote audio URL. When null, the button renders a disabled state and
  /// tapping it is a no-op.
  final String? audioUrl;

  /// Optional callback fired right before playback starts. Use this for
  /// analytics or to keep an external player in sync.
  final VoidCallback? onTap;

  final double iconSize;
  final String tooltip;

  @override
  ConsumerState<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends ConsumerState<SpeakButton> {
  bool _loading = false;
  Object? _error;

  Future<void> _handleTap() async {
    if (widget.text.trim().isEmpty &&
        (widget.audioUrl == null || widget.audioUrl!.trim().isEmpty)) {
      return;
    }
    if (_loading) return;
    widget.onTap?.call();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final played = await ref
          .read(audioServiceProvider)
          .play(text: widget.text, audioUrl: widget.audioUrl);
      if (!played) throw StateError('Không có nguồn phát âm khả dụng');
    } catch (e) {
      if (mounted) {
        setState(() => _error = e);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled =
        widget.text.trim().isEmpty &&
        (widget.audioUrl == null || widget.audioUrl!.trim().isEmpty);
    return IconButton(
      tooltip: widget.tooltip,
      onPressed: disabled ? null : _handleTap,
      icon: _loading
          ? SizedBox(
              width: widget.iconSize,
              height: widget.iconSize,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              _error != null ? PhosphorIcons.warning : PhosphorIcons.speakerHigh,
              size: widget.iconSize,
              color: _error != null
                  ? DesignTokens.error
                  : DesignTokens.orange500,
            ),
    );
  }
}
