import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import 'clip_tab_bar.dart';
import 'dictation_diff.dart';
import 'dictation_end_screen.dart';
import 'full_practice_sentence_card.dart';
import 'timed_clip.dart';

/// Per-sentence full-sentence dictation — play the sentence, type it back,
/// grade with a word-level diff, next. Mirrors web
/// `exam-dictation-full-practice.tsx` (playback-speed toggle trimmed).
class FullPracticeView extends StatefulWidget {
  const FullPracticeView({
    super.key,
    required this.audios,
    required this.onBack,
  });

  final List<ExamDictationAudio> audios;
  final VoidCallback onBack;

  @override
  State<FullPracticeView> createState() => _FullPracticeViewState();
}

class _FullPracticeViewState extends State<FullPracticeView> {
  late final List<TimedClip> _clips = buildTimedClips(widget.audios);
  final List<AudioPlayer?> _players = [];
  final TextEditingController _controller = TextEditingController();

  int _clipIdx = 0;
  int _sentenceIdx = 0;
  List<WordDiff>? _diff;
  int _correct = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _players.addAll(List.filled(widget.audios.length, null));
    if (_clips.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playCurrent());
    }
  }

  @override
  void dispose() {
    for (final p in _players) {
      p?.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  AudioPlayer _playerFor(int audioIndex) {
    return _players[audioIndex] ??= AudioPlayer()
      ..setUrl(widget.audios[audioIndex].audioUrl).catchError((_) => null);
  }

  void _playCurrent() {
    if (_diff != null || _clips.isEmpty) return;
    final clip = _clips[_clipIdx];
    final sentence = clip.sentences[_sentenceIdx];
    for (var i = 0; i < _players.length; i++) {
      if (i != clip.audioIndex) _players[i]?.pause();
    }
    final player = _playerFor(clip.audioIndex);
    player.seek(Duration(milliseconds: (sentence.start * 1000).round()));
    unawaited(player.play());
    late final StreamSubscription<Duration> sub;
    sub = player.positionStream.listen((pos) {
      if (pos.inMilliseconds / 1000 >= sentence.end) {
        player.pause();
        sub.cancel();
      }
    });
  }

  void _submit() {
    if (_diff != null || _clips.isEmpty) return;
    final sentence = _clips[_clipIdx].sentences[_sentenceIdx];
    final result = diffSentence(_controller.text, sentence.text);
    setState(() {
      _diff = result;
      if (isAllCorrect(result)) _correct++;
    });
    for (final p in _players) {
      p?.pause();
    }
  }

  void _next() {
    final clip = _clips[_clipIdx];
    final nextIdx = _sentenceIdx + 1;
    setState(() {
      _diff = null;
      _controller.clear();
    });
    if (nextIdx >= clip.sentences.length) {
      setState(() => _done = true);
    } else {
      setState(() => _sentenceIdx = nextIdx);
      _playCurrent();
    }
  }

  void _startClip(int clipIdx) {
    for (final p in _players) {
      p?.pause();
    }
    setState(() {
      _clipIdx = clipIdx;
      _sentenceIdx = 0;
      _diff = null;
      _controller.clear();
      _correct = 0;
      _done = false;
    });
    _playCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (_clips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bài nghe này chưa có dữ liệu chấm chính tả.',
                textAlign: TextAlign.center,
                style: TextStyle(color: tokens.mutedForeground),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: widget.onBack,
                child: const Text('← Quay lại'),
              ),
            ],
          ),
        ),
      );
    }

    final clip = _clips[_clipIdx];
    final labels = [for (final c in _clips) c.label];

    if (_done) {
      return Column(
        children: [
          ClipTabBar(
            labels: labels,
            activeIndex: _clipIdx,
            onSelect: _startClip,
          ),
          Expanded(
            child: DictationEndScreen(
              title: 'Kết quả chép chính tả',
              correct: _correct,
              total: clip.sentences.length,
              backLabel: 'Chọn bài',
              onRetry: () => _startClip(_clipIdx),
              onBack: widget.onBack,
              children: _clipIdx + 1 < _clips.length
                  ? [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: tokens.primary,
                          ),
                          onPressed: () => _startClip(_clipIdx + 1),
                          child: const Text('Bài tiếp theo →'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ]
                  : const [],
            ),
          ),
        ],
      );
    }

    return FullPracticeSentenceCard(
      labels: labels,
      clipIdx: _clipIdx,
      onSelectClip: _startClip,
      sentence: clip.sentences[_sentenceIdx],
      sentenceIdx: _sentenceIdx,
      sentenceCount: clip.sentences.length,
      correctCount: _correct,
      controller: _controller,
      diff: _diff,
      onReplay: _playCurrent,
      onSubmit: _submit,
      onNext: _next,
    );
  }
}
