import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';

const podcastPurple600 = Color(0xFF9333EA);

/// Thanh player dính đáy (seek bar + play/±10s + tốc độ) cho podcast player.
/// Tách khỏi `EasyGermanPodcastPlayerPage` để giữ file trang chính gọn hơn.
class PodcastPlayerBar extends StatelessWidget {
  const PodcastPlayerBar({
    super.key,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isLoading,
    required this.playbackSpeed,
    required this.onSeekRatio,
    required this.onSeekBy,
    required this.onTogglePlay,
    required this.onCycleSpeed,
  });

  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isLoading;
  final double playbackSpeed;
  final ValueChanged<double> onSeekRatio;
  final void Function(int deltaSeconds) onSeekBy;
  final VoidCallback onTogglePlay;
  final VoidCallback onCycleSpeed;

  String _formatTime(Duration d) {
    final mins = d.inMinutes;
    final secs = d.inSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasProgress = duration.inMilliseconds > 0;
    final progress = hasProgress ? position.inMilliseconds / duration.inMilliseconds : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(color: tokens.card, border: Border(top: BorderSide(color: tokens.border))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(_formatTime(position), style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    activeTrackColor: podcastPurple600,
                    inactiveTrackColor: tokens.muted,
                    thumbColor: podcastPurple600,
                  ),
                  child: Slider(
                    value: progress.clamp(0.0, 1.0),
                    onChanged: hasProgress ? onSeekRatio : null,
                  ),
                ),
              ),
              Text(_formatTime(duration), style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.replay_10), iconSize: 28, onPressed: () => onSeekBy(-10)),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: isLoading ? null : onTogglePlay,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(color: podcastPurple600, shape: BoxShape.circle),
                      child: isLoading
                          ? const Padding(padding: EdgeInsets.all(18), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 32, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(icon: const Icon(Icons.forward_10), iconSize: 28, onPressed: () => onSeekBy(10)),
                ],
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: onCycleSpeed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: playbackSpeed != 1.0 ? podcastPurple600.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${playbackSpeed}x',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: playbackSpeed != 1.0 ? podcastPurple600 : tokens.mutedForeground),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
