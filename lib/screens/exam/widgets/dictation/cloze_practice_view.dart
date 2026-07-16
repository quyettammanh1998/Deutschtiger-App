import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import 'cloze_mistake_list.dart';
import 'cloze_practice_card.dart';
import 'dictation_cue.dart';
import 'dictation_end_screen.dart';

/// Sequential single-word-gap cloze quiz — play audio until the cued word,
/// pause and wait for the learner to type it, then continue. Mirrors web
/// `exam-dictation-practice.tsx` (multi-choice "pick" mode and playback-speed
/// toggle trimmed for scope; core type/check/skip/reveal/replay flow kept).
/// No SRS push — see [DictationEndScreen] doc comment for the gap.
class ClozePracticeView extends StatefulWidget {
  const ClozePracticeView({
    super.key,
    required this.audios,
    required this.selectedWords,
    required this.onBack,
  });

  final List<ExamDictationAudio> audios;
  final Set<String> selectedWords;
  final VoidCallback onBack;

  @override
  State<ClozePracticeView> createState() => _ClozePracticeViewState();
}

class _ClozePracticeViewState extends State<ClozePracticeView> {
  late final List<DictationCue> _cues = buildDictationCues(
    widget.audios,
    widget.selectedWords,
  );
  final List<AudioPlayer?> _players = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  int _index = 0;
  bool _waitingForInput = false;
  bool _revealed = false;
  int _wrongAttempts = 0;
  final List<({DictationCue cue, bool correct})> _results = [];

  @override
  void initState() {
    super.initState();
    _players.addAll(List.filled(widget.audios.length, null));
    if (_cues.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _playFrom(_cues[0].audioIndex, 0),
      );
    }
  }

  @override
  void dispose() {
    for (final p in _players) {
      p?.dispose();
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  AudioPlayer _playerFor(int audioIndex) {
    return _players[audioIndex] ??= AudioPlayer()
      ..setUrl(widget.audios[audioIndex].audioUrl).catchError((_) => null);
  }

  Future<void> _playFrom(int audioIndex, double seconds) async {
    for (var i = 0; i < _players.length; i++) {
      if (i != audioIndex) _players[i]?.pause();
    }
    final player = _playerFor(audioIndex);
    await player.seek(Duration(milliseconds: (seconds * 1000).round()));
    if (!mounted) return;
    unawaited(player.play());
    player.positionStream.listen((pos) {
      if (!mounted || _waitingForInput || _index >= _cues.length) return;
      final cue = _cues[_index];
      if (cue.audioIndex != audioIndex) return;
      if (pos.inMilliseconds / 1000 >= cue.start - 0.3) {
        player.pause();
        if (!mounted) return;
        setState(() => _waitingForInput = true);
        _focusNode.requestFocus();
      }
    });
  }

  void _replaySentence() {
    if (!_waitingForInput) return;
    _playFrom(_cues[_index].audioIndex, _cues[_index].sentenceStart);
  }

  void _advance(DictationCue cue, bool correct) {
    setState(() {
      _results.add((cue: cue, correct: correct));
      _controller.clear();
      _waitingForInput = false;
      _wrongAttempts = 0;
      _revealed = false;
    });
    final next = _index + 1;
    if (next >= _cues.length) {
      for (final p in _players) {
        p?.pause();
      }
      setState(() => _index = next);
      return;
    }
    setState(() => _index = next);
    final nextCue = _cues[next];
    _playFrom(
      nextCue.audioIndex,
      nextCue.audioIndex != cue.audioIndex ? 0 : cue.end,
    );
  }

  void _handleSubmit() {
    if (!_waitingForInput || _revealed) return;
    final cue = _cues[_index];
    if (foldGerman(_controller.text) == foldGerman(cue.clean)) {
      _advance(cue, true);
    } else {
      setState(() => _wrongAttempts++);
    }
  }

  void _handleSkip() {
    if (_waitingForInput && !_revealed) _advance(_cues[_index], false);
  }

  void _handleReveal() {
    if (!_waitingForInput || _revealed) return;
    final cue = _cues[_index];
    setState(() => _revealed = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _advance(cue, false);
    });
  }

  void _retry() {
    for (final p in _players) {
      p?.pause();
    }
    setState(() {
      _index = 0;
      _results.clear();
      _controller.clear();
      _waitingForInput = false;
      _revealed = false;
      _wrongAttempts = 0;
    });
    if (_cues.isNotEmpty) _playFrom(_cues[0].audioIndex, 0);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (_cues.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Không có từ nào để luyện.',
                style: TextStyle(color: tokens.mutedForeground),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: widget.onBack,
                child: const Text('← Quay lại chọn từ'),
              ),
            ],
          ),
        ),
      );
    }

    if (_index >= _cues.length) {
      final correct = _results.where((r) => r.correct).length;
      final mistakeWords = _results
          .where((r) => !r.correct)
          .map((r) => r.cue.word)
          .toList();
      return DictationEndScreen(
        title: 'Kết quả luyện nghe',
        correct: correct,
        total: _cues.length,
        backLabel: 'Chọn từ khác',
        onRetry: _retry,
        onBack: widget.onBack,
        children: mistakeWords.isEmpty
            ? const []
            : [
                ClozeMistakeList(words: mistakeWords),
                const SizedBox(height: 16),
              ],
      );
    }

    return ClozePracticeCard(
      cue: _cues[_index],
      answeredCount: _results.length,
      totalCount: _cues.length,
      controller: _controller,
      focusNode: _focusNode,
      waitingForInput: _waitingForInput,
      revealed: _revealed,
      wrongAttempts: _wrongAttempts,
      onBack: widget.onBack,
      onSubmit: _handleSubmit,
      onReplay: _replaySentence,
      onSkip: _handleSkip,
      onReveal: _handleReveal,
      onChanged: (_) => setState(() {}),
    );
  }
}
