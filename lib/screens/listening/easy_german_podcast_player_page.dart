import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';

/// Easy German Podcast Player — audio thật (just_audio, foreground-only) +
/// transcript đồng bộ theo timestamp câu/từ.
class EasyGermanPodcastPlayerPage extends ConsumerStatefulWidget {
  const EasyGermanPodcastPlayerPage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<EasyGermanPodcastPlayerPage> createState() =>
      _EasyGermanPodcastPlayerPageState();
}

class _EasyGermanPodcastPlayerPageState
    extends ConsumerState<EasyGermanPodcastPlayerPage> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;
  bool _showTranslation = true;
  bool _completedGuard = false;
  String? _loadedSlug;

  static const _speeds = [0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.durationStream.listen((d) {
      if (mounted && d != null) setState(() => _duration = d);
    });
    _player.positionStream.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
      _maybeMarkComplete(p);
    });
    _player.playerStateStream.listen((s) {
      if (!mounted) return;
      setState(() {
        _isPlaying = s.playing;
        _isLoading = s.processingState == ProcessingState.loading ||
            s.processingState == ProcessingState.buffering;
      });
      if (s.processingState == ProcessingState.completed) {
        _player.pause();
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _maybeMarkComplete(Duration position) {
    if (_completedGuard) return;
    final total = _duration.inMilliseconds;
    if (total <= 0) return;
    if (position.inMilliseconds / total < 0.9) return;
    _completedGuard = true;
    markPodcastEpisodeComplete(ref, widget.slug).catchError((_) {
      _completedGuard = false;
    });
  }

  Future<void> _ensureLoaded(String audioUrl) async {
    if (_loadedSlug == widget.slug) return;
    _loadedSlug = widget.slug;
    _completedGuard = false;
    try {
      await _player.setUrl(audioUrl);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải âm thanh. Vui lòng thử lại.')),
        );
      }
    }
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _seekBy(int deltaSeconds) async {
    final target = _position + Duration(seconds: deltaSeconds);
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > _duration ? _duration : target);
    await _player.seek(clamped);
  }

  Future<void> _seekToSentence(PodcastSentence sentence) async {
    await _player.seek(Duration(milliseconds: (sentence.start * 1000).round()));
    await _player.play();
  }

  void _cycleSpeed() {
    final idx = _speeds.indexOf(_playbackSpeed);
    final next = _speeds[(idx + 1) % _speeds.length];
    setState(() => _playbackSpeed = next);
    _player.setSpeed(next);
  }

  String _formatTime(Duration d) {
    final mins = d.inMinutes;
    final secs = d.inSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  int _activeSentenceIndex(List<PodcastSentence> sentences) {
    final t = _position.inMilliseconds / 1000.0;
    var found = 0;
    for (var i = 0; i < sentences.length; i++) {
      if (sentences[i].start <= t) {
        found = i;
      } else {
        break;
      }
    }
    return found;
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(podcastRepositoryProvider);
    final episodeAsync = ref.watch(podcastEpisodeProvider(widget.slug));

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: episodeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _buildError(context),
          data: (episode) {
            final audioUrl = repo.audioUrl(widget.slug);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _ensureLoaded(audioUrl);
            });
            return Column(
              children: [
                _buildHeader(context, episode),
                _buildPlayerBar(),
                _buildControls(),
                Expanded(child: _buildTranscript(episode)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Không thể tải tập podcast.', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Quay lại danh sách'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PodcastEpisodeDetail episode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.foreground),
                ),
                Text('Easy German Podcast', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _showTranslation ? Icons.translate : Icons.translate_outlined,
              color: _showTranslation ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => setState(() => _showTranslation = !_showTranslation),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBar() {
    final hasProgress = _duration.inMilliseconds > 0;
    final progress = hasProgress ? _position.inMilliseconds / _duration.inMilliseconds : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              activeTrackColor: AppColors.tigerOrange,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.tigerOrange,
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: hasProgress
                  ? (v) => _player.seek(_duration * v)
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatTime(_position), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(_formatTime(_duration), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _cycleSpeed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                '${_playbackSpeed}x',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.replay_10),
            iconSize: 32,
            color: AppColors.foreground,
            onPressed: () => _seekBy(-10),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _togglePlay,
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.tigerOrange]),
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 34, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.forward_10),
            iconSize: 32,
            color: AppColors.foreground,
            onPressed: () => _seekBy(10),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscript(PodcastEpisodeDetail episode) {
    if (episode.sentences.isEmpty) {
      return Center(
        child: Text('Chưa có transcript cho tập này.', style: TextStyle(color: Colors.grey[600])),
      );
    }
    final activeIdx = _activeSentenceIndex(episode.sentences);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: episode.sentences.length,
      itemBuilder: (context, i) {
        final sentence = episode.sentences[i];
        final isActive = i == activeIdx;
        return GestureDetector(
          onTap: () => _seekToSentence(sentence),
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.tigerOrange.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sentence.text,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: AppColors.foreground,
                  ),
                ),
                if (_showTranslation && sentence.textVi.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      sentence.textVi,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
