// ignore_for_file: prefer_initializing_formals
//
// Audio player cho Hören — dùng `just_audio` (đã có trong pubspec).
//
// max_plays/audio_plays enforcement:
//   - `canPlay` = false khi playsUsed >= maxPlays.
//   - Sau khi play thành công, [onPlayConsumed] được gọi để provider tăng
//     counter (persist trong state.exam attempt).
//   - Hiển thị badge "1/2" để user biết còn bao nhiêu lượt.
//   - Lỗi audio không crash — fallback snackbar + disable nút.

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'exam_audio_controls.dart';

class ExamAudioPlayer extends StatefulWidget {
  const ExamAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.playsUsed,
    required this.maxPlays,
    required this.onPlayConsumed,
  });

  final String audioUrl;
  final int playsUsed;
  final int maxPlays;
  final VoidCallback onPlayConsumed;

  @override
  State<ExamAudioPlayer> createState() => _ExamAudioPlayerState();
}

class _ExamAudioPlayerState extends State<ExamAudioPlayer> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool get _canPlayMore =>
      widget.maxPlays == 0 || widget.playsUsed < widget.maxPlays;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.durationStream.listen((d) {
      if (mounted && d != null) setState(() => _duration = d);
    });
    _player.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.playerStateStream.listen((s) {
      if (!mounted) return;
      setState(() {
        _isPlaying = s.playing;
        _isLoading =
            s.processingState == ProcessingState.loading ||
            s.processingState == ProcessingState.buffering;
      });
      if (s.processingState == ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isLoading) return;
    if (_isPlaying) {
      await _player.pause();
      return;
    }
    if (!_canPlayMore) return;
    setState(() => _isLoading = true);
    try {
      if (_duration == Duration.zero) {
        await _player.setUrl(widget.audioUrl);
      }
      widget.onPlayConsumed();
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).couldNotPlayAudio),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasProgress = _duration.inMilliseconds > 0;
    final progress = hasProgress
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: ExamDesignTokens.examActiveSoft,
        border: Border.all(color: ExamDesignTokens.examActive),
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.headphones,
                color: ExamDesignTokens.examActive,
                size: 20,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Text(
                l10n.examListeningAudio,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ExamDesignTokens.examActiveStrong,
                ),
              ),
              const Spacer(),
              AudioPlayCounter(used: widget.playsUsed, max: widget.maxPlays),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              AudioPlayPauseButton(
                isPlaying: _isPlaying,
                isLoading: _isLoading,
                canPlayMore: _canPlayMore,
                onTap: _togglePlay,
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: hasProgress ? progress.clamp(0, 1) : null,
                        minHeight: 6,
                        backgroundColor: ExamDesignTokens.examBorder,
                        valueColor: const AlwaysStoppedAnimation(
                          ExamDesignTokens.examActive,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_position.inMinutes.toString().padLeft(2, '0')}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: ExamDesignTokens.examTextSecondary,
                          ),
                        ),
                        Text(
                          '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: ExamDesignTokens.examTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!_canPlayMore)
            Padding(
              padding: EdgeInsets.only(top: DesignTokens.spacingSm),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: ExamDesignTokens.examWarnFg,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      l10n.audioPlayLimitReached,
                      style: const TextStyle(
                        fontSize: 11,
                        color: ExamDesignTokens.examWarnFg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
