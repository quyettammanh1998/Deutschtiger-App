import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/vocab/vocab_models.dart';
import '../../view_models/games/listening_game_provider.dart';
import '../../view_models/providers.dart';
import '../../widgets/common/async_state_views.dart';
import '../../widgets/common/game_shell.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _kMinWordsRequired = 4;

/// Listening game — nghe và chọn nghĩa đúng. Nguồn từ live:
/// `GET /vocabulary/learned` (tái dùng [VocabularyRepository], giống Word
/// Sprint). Audio phát qua [AudioService] (server TTS cache
/// `/user/tts/vocab-cache` → fallback TTS máy) — không còn audio giả lập.
class ListeningGameScreen extends ConsumerStatefulWidget {
  const ListeningGameScreen({super.key});

  @override
  ConsumerState<ListeningGameScreen> createState() =>
      _ListeningGameScreenState();
}

class _ListeningGameScreenState extends ConsumerState<ListeningGameScreen> {
  static const _roundSeconds = 60;

  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = _roundSeconds;
  bool _gameOver = false;
  bool _started = false;
  bool _isPlaying = false;
  String? _selectedAnswer;
  Timer? _timer;

  List<VocabWord> _words = const [];
  final _random = Random();
  List<String> _currentOptions = const [];
  final List<VocabWord> _wrongWords = [];
  bool _retryWrongMode = false;

  void _startGame(List<VocabWord> words) {
    if (_started) return;
    _started = true;
    _words = List.of(words)..shuffle(_random);
    _generateOptions();
    _startTimer();
    _playAudio();
  }

  void _shuffleNow() {
    setState(() {
      _words = List.of(_words)..shuffle(_random);
      _currentIndex = 0;
      _selectedAnswer = null;
    });
    _generateOptions();
    _playAudio();
  }

  void _retryWrong() {
    if (_wrongWords.isEmpty) return;
    setState(() {
      _retryWrongMode = true;
      _words = List.of(_wrongWords);
      _wrongWords.clear();
      _currentIndex = 0;
      _score = 0;
      _correct = 0;
      _total = 0;
      _timeLeft = _roundSeconds;
      _gameOver = false;
      _selectedAnswer = null;
    });
    _generateOptions();
    _startTimer();
    _playAudio();
  }

  void _generateOptions() {
    final correct = _words[_currentIndex % _words.length].translation;
    final wrongOptions = _words
        .where((w) => w.translation != correct)
        .toList()
      ..shuffle(_random);

    final options = [
      correct,
      wrongOptions[0].translation,
      wrongOptions[1].translation,
      wrongOptions[2].translation,
    ];
    options.shuffle(_random);
    setState(() => _currentOptions = options);
  }

  Future<void> _playAudio() async {
    final word = _words[_currentIndex % _words.length];
    setState(() => _isPlaying = true);
    await ref
        .read(audioServiceProvider)
        .play(text: word.word, audioUrl: word.audioUrl);
    if (mounted) setState(() => _isPlaying = false);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;
    final correctAnswer = _words[_currentIndex % _words.length].translation;
    final isCorrect = answer == correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _total++;
      if (isCorrect) {
        _correct++;
        _score += 15;
      } else {
        _wrongWords.add(_words[_currentIndex % _words.length]);
      }
    });

    Future<void>.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted || _gameOver) return;
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
      _generateOptions();
      _playAudio();
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _correct = 0;
      _total = 0;
      _timeLeft = _roundSeconds;
      _gameOver = false;
      _selectedAnswer = null;
      _retryWrongMode = false;
      _wrongWords.clear();
    });
    _words.shuffle(_random);
    _generateOptions();
    _startTimer();
    _playAudio();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return GameShell(
        title: 'Luyện nghe',
        exitGuard: false,
        child: _buildCompletion(),
      );
    }

    final wordsAsync = ref.watch(listeningGameWordsProvider);
    return GameShell(
      title: 'Luyện nghe',
      scrollable: false,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Xáo trộn',
            icon: const Icon(PhosphorIcons.shuffle),
            onPressed: _started ? _shuffleNow : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _timeLeft <= 10 ? Colors.red : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(PhosphorIcons.timer, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${_timeLeft}s',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      child: wordsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(listeningGameWordsProvider),
        ),
        data: (words) {
          if (words.length < _kMinWordsRequired) {
            return const ErrorView(
              message:
                  'Cần học ít nhất 4 từ vựng trước khi chơi Luyện nghe. '
                  'Hãy đánh dấu thêm từ đã học ở phần Từ vựng.',
            );
          }
          _startGame(words);
          return _buildGame();
        },
      ),
    );
  }

  Widget _buildCompletion() {
    final accuracy = _total > 0 ? (_correct / _total * 100).round() : 0;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$_score',
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple)),
              Text(
                _retryWrongMode
                    ? 'Đúng $_correct/$_total (làm lại câu sai)'
                    : 'Đúng $_correct/$_total câu',
                style: TextStyle(color: context.tokens.mutedForeground),
              ),
              Text('$accuracy% chính xác',
                  style: TextStyle(color: context.tokens.mutedForeground)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Về trang chủ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _restart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Chơi lại'),
                    ),
                  ),
                ],
              ),
              if (_wrongWords.isNotEmpty) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _retryWrong,
                  icon: const Icon(PhosphorIcons.arrowCounterClockwise),
                  label: Text('Làm lại ${_wrongWords.length} câu sai'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGame() {
    return SingleChildScrollView(
      child: Column(
        children: [
        LinearProgressIndicator(
          value: (_currentIndex % _words.length + 1) / _words.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(PhosphorIcons.star, color: Colors.purple),
                  const SizedBox(width: 4),
                  Text('$_score',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('Đúng $_correct/$_total', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: _isPlaying ? null : _playAudio,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.purple, width: 3),
                  ),
                  child: Icon(
                    _isPlaying ? PhosphorIcons.speakerHigh : PhosphorIcons.play,
                    size: 48,
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isPlaying ? 'Đang phát...' : 'Nhấn để nghe lại',
                style: TextStyle(fontSize: 16, color: context.tokens.mutedForeground),
              ),
              const SizedBox(height: 8),
              Text(
                'Nghe từ và chọn nghĩa đúng',
                style: TextStyle(fontSize: 14, color: context.tokens.mutedForeground),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: _currentOptions.map((option) {
              final isSelected = _selectedAnswer == option;
              final correctAnswer =
                  _words[_currentIndex % _words.length].translation;
              final isCorrectAnswer = option == correctAnswer;

              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade300;
              if (_selectedAnswer != null) {
                if (isCorrectAnswer) {
                  bgColor = Colors.green.shade50;
                  borderColor = Colors.green;
                } else if (isSelected) {
                  bgColor = Colors.red.shade50;
                  borderColor = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectAnswer(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (_selectedAnswer != null && isCorrectAnswer)
                          const Icon(PhosphorIcons.checkCircle, color: Colors.green),
                        if (_selectedAnswer == option && !isCorrectAnswer)
                          const Icon(PhosphorIcons.xCircle, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
        ],
      ),
    );
  }
}
