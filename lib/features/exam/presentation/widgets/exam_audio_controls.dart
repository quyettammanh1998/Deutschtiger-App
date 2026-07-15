// ignore_for_file: prefer_initializing_formals
//
// Sub-widgets cho ExamAudioPlayer — tách riêng để file chính < 200 dòng.

import 'package:flutter/material.dart';

import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class AudioPlayPauseButton extends StatelessWidget {
  const AudioPlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.canPlayMore,
    required this.onTap,
  });

  final bool isPlaying;
  final bool isLoading;
  final bool canPlayMore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      enabled: canPlayMore,
      label: isPlaying ? l10n.audioPause : l10n.audioPlay,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Material(
          color: canPlayMore
              ? ExamDesignTokens.examActive
              : ExamDesignTokens.examBorder,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: canPlayMore ? onTap : null,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class AudioPlayCounter extends StatelessWidget {
  const AudioPlayCounter({super.key, required this.used, required this.max});
  final int used;
  final int max;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final remaining = max == 0 ? '∞' : '${max - used}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: ExamDesignTokens.examActive,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        l10n.audioPlayCounter(used, max, remaining),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
