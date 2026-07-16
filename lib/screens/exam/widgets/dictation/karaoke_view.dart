import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import 'clip_tab_bar.dart';
import 'karaoke_sentence_list.dart';

/// Read-along activity — per-clip play/pause with a synced sentence list.
/// Mirrors web `exam-karaoke-view.tsx` (word-level tap-to-translate
/// highlight trimmed to sentence-level — see [KaraokeSentenceList] doc).
class KaraokeView extends StatefulWidget {
  const KaraokeView({super.key, required this.audios, required this.onBack});

  final List<ExamDictationAudio> audios;
  final VoidCallback onBack;

  @override
  State<KaraokeView> createState() => _KaraokeViewState();
}

class _KaraokeViewState extends State<KaraokeView> {
  final List<AudioPlayer?> _players = [];
  int _activeClip = 0;
  double _position = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _players.addAll(List.filled(widget.audios.length, null));
  }

  @override
  void dispose() {
    for (final p in _players) {
      p?.dispose();
    }
    super.dispose();
  }

  AudioPlayer _playerFor(int index) {
    return _players[index] ??= AudioPlayer()
      ..setUrl(widget.audios[index].audioUrl).catchError((_) => null)
      ..positionStream.listen((pos) {
        if (mounted) setState(() => _position = pos.inMilliseconds / 1000);
      })
      ..playerStateStream.listen((s) {
        if (mounted) setState(() => _isPlaying = s.playing);
      });
  }

  void _switchClip(int index) {
    for (var i = 0; i < _players.length; i++) {
      if (i != index) _players[i]?.pause();
    }
    setState(() {
      _activeClip = index;
      _position = 0;
    });
  }

  void _togglePlay() {
    final player = _playerFor(_activeClip);
    if (_isPlaying) {
      player.pause();
    } else {
      for (var i = 0; i < _players.length; i++) {
        if (i != _activeClip) _players[i]?.pause();
      }
      player.play();
    }
  }

  void _seek(double seconds) {
    final player = _playerFor(_activeClip);
    for (var i = 0; i < _players.length; i++) {
      if (i != _activeClip) _players[i]?.pause();
    }
    player.seek(Duration(milliseconds: (seconds * 1000).round()));
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final audio = widget.audios[_activeClip];
    final timed = audio.sentences.any((s) => s.start < s.end);
    final labels = [
      for (var i = 0; i < widget.audios.length; i++) 'Teil ${i + 1}',
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: widget.onBack,
              child: const Text('← Chọn hoạt động'),
            ),
          ),
        ),
        ClipTabBar(
          labels: labels,
          activeIndex: _activeClip,
          onSelect: _switchClip,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bấm ▶ để nghe — phụ đề tự chạy theo audio. Chạm vào câu để nghe lại từ đó.',
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tokens.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton.filled(
                              onPressed: _togglePlay,
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: _isPlaying
                                    ? tokens.destructive
                                    : tokens.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: tokens.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                child: Text(
                                  labels[_activeClip],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: tokens.primary,
                                  ),
                                ),
                              ),
                            ),
                            if (!timed) ...[
                              const SizedBox(width: 6),
                              Text(
                                '(không có phụ đề đồng bộ)',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: tokens.mutedForeground,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (timed)
                          KaraokeSentenceList(
                            sentences: audio.sentences,
                            currentSeconds: _position,
                            onSeek: _seek,
                          )
                        else
                          for (final s in audio.sentences)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                s.text,
                                style: TextStyle(color: tokens.foreground),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _activeClip > 0
                            ? () => _switchClip(_activeClip - 1)
                            : null,
                        child: const Text('◀ Bài trước'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _activeClip < widget.audios.length - 1
                            ? () => _switchClip(_activeClip + 1)
                            : null,
                        child: const Text('Bài sau ▶'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
