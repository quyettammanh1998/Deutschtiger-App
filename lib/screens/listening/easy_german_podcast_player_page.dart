import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'widgets/podcast_player_bar.dart';
import 'widgets/podcast_player_chrome.dart';
import 'widgets/podcast_transcript_sync.dart';

/// `/listening/podcast/easy_german/:slug` — audio thật (just_audio) + transcript
/// đồng bộ theo timestamp câu/từ. Layout: header → transcript (giữa, cuộn) →
/// player bar dính đáy. Web parity: `easy-german-podcast-player-page.tsx`.
class EasyGermanPodcastPlayerPage extends ConsumerStatefulWidget {
  const EasyGermanPodcastPlayerPage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<EasyGermanPodcastPlayerPage> createState() => _EasyGermanPodcastPlayerPageState();
}

class _EasyGermanPodcastPlayerPageState extends ConsumerState<EasyGermanPodcastPlayerPage> {
  late final AudioPlayer _player;
  final _scrollController = ScrollController();
  final _sentenceKeys = <GlobalKey>[];

  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;
  bool _showTranslation = true;
  double _fontScale = 1.0;
  bool _completedGuard = false;
  String? _loadedSlug;
  int _activeSentenceIdx = 0;

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
        _isLoading = s.processingState == ProcessingState.loading || s.processingState == ProcessingState.buffering;
      });
      if (s.processingState == ProcessingState.completed) _player.pause();
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeMarkComplete(Duration position) {
    if (_completedGuard) return;
    final total = _duration.inMilliseconds;
    if (total <= 0 || position.inMilliseconds / total < 0.9) return;
    _completedGuard = true;
    markPodcastEpisodeComplete(ref, widget.slug).catchError((_) => _completedGuard = false);
  }

  Future<void> _ensureLoaded(String audioUrl) async {
    if (_loadedSlug == widget.slug) return;
    _loadedSlug = widget.slug;
    _completedGuard = false;
    try {
      await _player.setUrl(audioUrl);
      await _player.setSpeed(_playbackSpeed);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).podcastAudioLoadError)),
        );
      }
    }
  }

  Future<void> _togglePlay() async => _isPlaying ? _player.pause() : _player.play();

  Future<void> _seekBy(int deltaSeconds) async {
    final target = _position + Duration(seconds: deltaSeconds);
    await _player.seek(target < Duration.zero ? Duration.zero : (target > _duration ? _duration : target));
  }

  Future<void> _seekToSentence(int idx, List<PodcastSentence> sentences) async {
    await _player.seek(Duration(milliseconds: (sentences[idx].start * 1000).round()));
    await _player.play();
  }

  void _cycleSpeed() {
    final idx = _speeds.indexOf(_playbackSpeed);
    final next = _speeds[(idx + 1) % _speeds.length];
    setState(() => _playbackSpeed = next);
    _player.setSpeed(next);
  }

  int _activeWordIndex(PodcastSentence sentence) =>
      activeWordIndexAt(_position.inMilliseconds / 1000.0, sentence);

  void _updateActiveSentence(List<PodcastSentence> sentences) {
    final found = activeSentenceIndexAt(_position.inMilliseconds / 1000.0, sentences);
    if (found != _activeSentenceIdx) {
      _activeSentenceIdx = found;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || found >= _sentenceKeys.length) return;
        final ctx = _sentenceKeys[found].currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(ctx, alignment: 0.4, duration: const Duration(milliseconds: 300));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final episodeAsync = ref.watch(podcastEpisodeProvider(widget.slug));
    final repo = ref.watch(podcastRepositoryProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: episodeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => PodcastPlayerErrorView(tokens: tokens, onBack: () => context.pop()),
          data: (episode) {
            if (_sentenceKeys.length != episode.sentences.length) {
              _sentenceKeys
                ..clear()
                ..addAll(List.generate(episode.sentences.length, (_) => GlobalKey()));
            }
            _updateActiveSentence(episode.sentences);
            WidgetsBinding.instance.addPostFrameCallback((_) => _ensureLoaded(repo.audioUrl(widget.slug)));
            return Column(
              children: [
                PodcastPlayerHeader(
                  tokens: tokens,
                  title: episode.title,
                  onBack: () => context.pop(),
                  fontScale: _fontScale,
                  showTranslation: _showTranslation,
                  onSettingsSaved: (scale, showVi) => setState(() {
                    _fontScale = scale;
                    _showTranslation = showVi;
                  }),
                ),
                Expanded(
                  child: PodcastTranscriptList(
                    tokens: tokens,
                    episode: episode,
                    scrollController: _scrollController,
                    sentenceKeys: _sentenceKeys,
                    activeSentenceIdx: _activeSentenceIdx,
                    fontScale: _fontScale,
                    showTranslation: _showTranslation,
                    activeWordIndexOf: _activeWordIndex,
                    onSentenceTap: (i) => _seekToSentence(i, episode.sentences),
                  ),
                ),
                PodcastPlayerBar(
                  position: _position,
                  duration: _duration,
                  isPlaying: _isPlaying,
                  isLoading: _isLoading,
                  playbackSpeed: _playbackSpeed,
                  onSeekRatio: (v) => _player.seek(_duration * v),
                  onSeekBy: _seekBy,
                  onTogglePlay: _togglePlay,
                  onCycleSpeed: _cycleSpeed,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
