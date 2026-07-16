import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/games/typing_sprint_models.dart';
import '../../view_models/games/typing_sprint_provider.dart';
import '../../widgets/common/async_state_views.dart';
import '../../widgets/common/game_shell.dart';
import 'widgets/typing_sprint_paragraph_view.dart';
import 'widgets/typing_sprint_results_card.dart';

const _kRoundSeconds = 60;

/// Typing Sprint game — gõ câu tiếng Đức trong 60 giây.
///
/// Nguồn câu: `GET /user/typing/sentences` (backend ưu tiên câu cá nhân hoá
/// từ `learning_items` của user, fallback bộ câu B1 tĩnh khi chưa đủ dữ
/// liệu). Kết quả gửi lên `POST /user/typing/results` khi kết thúc phiên —
/// backend tính XP (tối đa 50/phiên, 100/ngày) và trả lại `xpAwarded`.
///
/// P7b: coral theme reskin ([TypingSprintPalette]) + live per-character diff
/// ([TypingSprintParagraphView]) + live WPM chip, matching web's themed
/// typing surface. The underlying mechanic stays sentence-by-sentence (one
/// `TypingSentence` at a time, checked on exact match) rather than web's
/// continuous cross-sentence paragraph stream — the Flutter backend contract
/// serves discrete sentences (`GET /user/typing/sentences`), not a
/// paragraph, so a full monkeytype-style rebuild is out of scope here.
class TypingSprintGameScreen extends ConsumerStatefulWidget {
  const TypingSprintGameScreen({super.key});

  @override
  ConsumerState<TypingSprintGameScreen> createState() =>
      _TypingSprintGameScreenState();
}

class _TypingSprintGameScreenState
    extends ConsumerState<TypingSprintGameScreen> {
  late Future<List<TypingSentence>> _sentencesFuture;

  int _score = 0;
  int _correctWords = 0;
  int _wrongWords = 0;
  int _correctChars = 0;
  int _sentenceIndex = 0;
  int _timeLeft = _kRoundSeconds;
  bool _gameOver = false;
  int? _xpAwarded;
  bool _submitFailed = false;

  List<TypingSentence> _sentences = const [];
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _random = Random();
  Timer? _timer;
  bool _focusRequested = false;

  @override
  void initState() {
    super.initState();
    _sentencesFuture = _loadSentences();
    _controller.addListener(() => setState(() {}));
  }

  Future<List<TypingSentence>> _loadSentences() {
    return ref.read(typingSprintRepositoryProvider).fetchSentences(count: 20);
  }

  void _startTimerIfNeeded() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  TypingSentence get _currentSentence =>
      _sentences[_sentenceIndex % _sentences.length];

  int get _liveWpm {
    final elapsedMin = (_kRoundSeconds - _timeLeft) / 60;
    if (elapsedMin <= 0) return 0;
    return (_correctWords / elapsedMin).round();
  }

  void _checkSentence() {
    final typed = _controller.text.trim();
    final target = _currentSentence.de.trim();
    if (typed.isEmpty) return;
    if (typed.toLowerCase() != target.toLowerCase()) return;

    setState(() {
      _correctWords += _currentSentence.wordCount;
      _correctChars += target.length;
      _score += 10 + (_currentSentence.wordCount * 2);
      _sentenceIndex++;
      _controller.clear();
    });
  }

  void _skipSentence() {
    setState(() {
      _wrongWords += _currentSentence.wordCount;
      _sentenceIndex++;
      _controller.clear();
    });
  }

  Future<void> _endGame() async {
    _timer?.cancel();
    setState(() => _gameOver = true);

    final elapsedSec = (_kRoundSeconds - _timeLeft).clamp(30, 300);
    final totalWords = _correctWords + _wrongWords;
    final accuracy = totalWords > 0 ? (_correctWords / totalWords * 100) : 0.0;
    final minutes = elapsedSec / 60;
    final wpm = minutes > 0 ? (_correctWords / minutes).round() : 0;
    final cpm = minutes > 0 ? (_correctChars / minutes).round() : 0;

    try {
      final result = await ref
          .read(typingSprintRepositoryProvider)
          .submitResult(
            wpm: wpm,
            accuracy: accuracy,
            cpm: cpm,
            correctWords: _correctWords,
            wrongWords: _wrongWords,
            durationSec: elapsedSec,
          );
      if (!mounted) return;
      setState(() => _xpAwarded = result.xpAwarded);
    } catch (_) {
      // Kết quả cục bộ vẫn hiển thị dù ghi nhận backend thất bại.
      if (!mounted) return;
      setState(() => _submitFailed = true);
    }
  }

  void _restart() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _correctWords = 0;
      _wrongWords = 0;
      _correctChars = 0;
      _sentenceIndex = 0;
      _timeLeft = _kRoundSeconds;
      _gameOver = false;
      _xpAwarded = null;
      _submitFailed = false;
      _sentences = List.of(_sentences)..shuffle(_random);
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      final totalWords = _correctWords + _wrongWords;
      final accuracy =
          totalWords > 0 ? (_correctWords / totalWords * 100).round() : 0;
      return GameShell(
        title: 'Typing Sprint',
        exitGuard: false,
        child: TypingSprintResultsCard(
          score: _score,
          wpm: _liveWpm,
          correctWords: _correctWords,
          wrongWords: _wrongWords,
          accuracy: accuracy,
          xpAwarded: _xpAwarded,
          submitFailed: _submitFailed,
          onGoHome: () => Navigator.of(context).pop(),
          onRestart: _restart,
        ),
      );
    }

    return GameShell(
      title: 'Typing Sprint',
      exitGuard: true,
      scrollable: false,
      trailing: _TimerAndWpmChips(timeLeft: _timeLeft, wpm: _liveWpm),
      child: FutureBuilder<List<TypingSentence>>(
        future: _sentencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return ErrorView(
              onRetry: () => setState(() => _sentencesFuture = _loadSentences()),
            );
          }
          final sentences = snapshot.data!;
          if (sentences.isEmpty) {
            return const ErrorView(message: 'Chưa có câu nào để luyện gõ.');
          }
          _sentences = sentences;
          _startTimerIfNeeded();
          if (!_focusRequested) {
            _focusRequested = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _focusNode.requestFocus();
            });
          }
          return _buildGame();
        },
      ),
    );
  }

  Widget _buildGame() {
    final sentence = _currentSentence;
    return DecoratedBox(
      decoration: const BoxDecoration(color: TypingSprintPalette.bgInner),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            sentence.vi,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: TypingSprintPalette.inkDim,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TypingSprintParagraphView(
                  target: sentence.de,
                  typed: _controller.text,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: (event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.enter) {
                  _checkSentence();
                }
              },
              child: TextField(
                key: const Key('typing-sprint-input'),
                controller: _controller,
                autofocus: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TypingSprintPalette.ink,
                ),
                decoration: InputDecoration(
                  hintText: 'Gõ câu ở đây...',
                  filled: true,
                  fillColor: TypingSprintPalette.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: TypingSprintPalette.coralSoft),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: TypingSprintPalette.coral,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) => _checkSentence(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            key: const Key('typing-sprint-skip'),
            onPressed: _skipSentence,
            style: TextButton.styleFrom(foregroundColor: TypingSprintPalette.inkDim),
            child: const Text('Bỏ qua câu này'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TimerAndWpmChips extends StatelessWidget {
  const _TimerAndWpmChips({required this.timeLeft, required this.wpm});

  final int timeLeft;
  final int wpm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: timeLeft <= 10 ? Colors.red.shade50 : TypingSprintPalette.chipBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '${timeLeft}s',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: timeLeft <= 10 ? Colors.red.shade700 : TypingSprintPalette.ink,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: TypingSprintPalette.coralSoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$wpm WPM',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: TypingSprintPalette.coralDeep,
            ),
          ),
        ),
      ],
    );
  }
}
