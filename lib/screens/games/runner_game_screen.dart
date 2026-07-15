import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/vocab/vocab_models.dart';
import '../../shared/widgets/game_completion_screen.dart';
import '../../view_models/games/runner_game_provider.dart';
import '../../widgets/common/async_state_views.dart';

const _kMinWordsRequired = 4;

/// Deutsch Runner — platform-runner với quiz. Nguồn từ live:
/// `GET /vocabulary/learned` (tái dùng [VocabularyRepository], giống Word
/// Sprint). Web (`game-runner-page.tsx`/`use-runner-words.ts`) dùng
/// learning-items pool riêng với 4 kiểu câu hỏi không phụ thuộc giống đực/
/// cái/trung (de-to-vi, vi-to-de, listen-de, listen-vi) — quiz ở đây theo
/// cùng tinh thần "chọn nghĩa đúng" thay vì der/die/das (API vocab học
/// không trả gender). Cơ chế obstacle/lane giữ nguyên như animation gameplay
/// thuần tuý (không phải nội dung học, không cần nguồn dữ liệu).
class RunnerGameScreen extends ConsumerStatefulWidget {
  const RunnerGameScreen({super.key});

  @override
  ConsumerState<RunnerGameScreen> createState() => _RunnerGameScreenState();
}

class _RunnerGameScreenState extends ConsumerState<RunnerGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _lives = 3;
  int _timeLeft = 60;
  bool _gameOver = false;
  bool _started = false;
  Timer? _gameTimer;
  Timer? _obstacleTimer;

  int _runnerPosition = 1;
  int _obstacleLane = -1;
  bool _obstacleActive = false;

  List<VocabWord> _words = const [];
  final _random = Random();
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  List<String> _currentOptions = const [];

  void _startGame(List<VocabWord> words) {
    if (_started) return;
    _started = true;
    _words = List.of(words)..shuffle(_random);
    _generateOptions();
    _startTimer();
    _startObstacles();
  }

  void _generateOptions() {
    final correct = _words[_currentQuestionIndex % _words.length].translation;
    final wrong = _words.where((w) => w.translation != correct).toList()
      ..shuffle(_random);
    final options = [correct, wrong[0].translation, wrong[1].translation]
      ..shuffle(_random);
    setState(() => _currentOptions = options);
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeLeft > 0 && !_gameOver) {
        setState(() => _timeLeft--);
      } else if (_timeLeft == 0) {
        _endGame();
      }
    });
  }

  void _startObstacles() {
    _obstacleTimer =
        Timer.periodic(const Duration(milliseconds: 2000), (_) {
      if (!_gameOver && _obstacleActive) {
        if (_runnerPosition == _obstacleLane) {
          _hitObstacle();
        }
        setState(() {
          _obstacleLane = -1;
          _obstacleActive = false;
        });
      } else if (!_gameOver) {
        setState(() {
          _obstacleLane = 1 + (DateTime.now().millisecond % 3);
          _obstacleActive = true;
        });
      }
    });
  }

  void _hitObstacle() {
    setState(() {
      _lives--;
      _score = (_score - 5).clamp(0, 9999);
    });
    if (_lives <= 0) _endGame();
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;
    final correct = _words[_currentQuestionIndex % _words.length].translation;
    final isCorrect = answer == correct;

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
      _total++;
      if (isCorrect) {
        _correct++;
        _score += 20;
      } else {
        _score = (_score - 5).clamp(0, 9999);
      }
    });

    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _gameOver) return;
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isCorrect = null;
      });
      _generateOptions();
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _obstacleTimer?.cancel();
    setState(() => _gameOver = true);
  }

  void _restart() {
    setState(() {
      _score = 0;
      _correct = 0;
      _total = 0;
      _lives = 3;
      _timeLeft = 60;
      _gameOver = false;
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _runnerPosition = 1;
      _obstacleLane = -1;
      _obstacleActive = false;
    });
    _words.shuffle(_random);
    _generateOptions();
    _startTimer();
    _startObstacles();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _obstacleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return GameCompletionScreen(
        score: _score,
        total: _total > 0 ? _total * 20 : 1,
        title: 'Hoàn thành!',
        subtitle: 'Đúng $_correct/$_total · Mạng còn $_lives/3',
        onPlayAgain: _restart,
        onGoHome: () => context.pop(),
      );
    }

    final wordsAsync = ref.watch(runnerGameWordsProvider);
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Deutsch Runner'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: wordsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            onRetry: () => ref.invalidate(runnerGameWordsProvider),
          ),
          data: (words) {
            if (words.length < _kMinWordsRequired) {
              return const ErrorView(
                message:
                    'Cần học ít nhất 4 từ vựng trước khi chơi Deutsch Runner. '
                    'Hãy đánh dấu thêm từ đã học ở phần Từ vựng.',
              );
            }
            _startGame(words);
            return _buildGame();
          },
        ),
      ),
    );
  }

  Widget _buildGame() {
    final question = _words[_currentQuestionIndex % _words.length];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(3, (index) {
                  return Icon(
                    index < _lives ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 28,
                  );
                }),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _timeLeft <= 10 ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_timeLeft}s',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade100, Colors.blue.shade200],
                  ),
                ),
              ),
              for (int i = 0; i < 3; i++)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 80.0 + (i * 100),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.blue.shade300, width: 2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        ['Lane 1', 'Lane 2', 'Lane 3'][i],
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: 50,
                top: 80.0 + ((_runnerPosition - 1) * 100) + 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: const Icon(Icons.directions_run,
                      color: Colors.white, size: 32),
                ),
              ),
              if (_obstacleActive && _obstacleLane > 0)
                Positioned(
                  right: 50,
                  top: 80.0 + ((_obstacleLane - 1) * 100) + 20,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Icon(Icons.warning,
                        color: Colors.white, size: 32),
                  ),
                ),
              Positioned(
                bottom: 200,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _LaneButton(
                      lane: 1,
                      isSelected: _runnerPosition == 1,
                      onTap: () => setState(() => _runnerPosition = 1),
                    ),
                    _LaneButton(
                      lane: 2,
                      isSelected: _runnerPosition == 2,
                      onTap: () => setState(() => _runnerPosition = 2),
                    ),
                    _LaneButton(
                      lane: 3,
                      isSelected: _runnerPosition == 3,
                      onTap: () => setState(() => _runnerPosition = 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                question.word,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground),
              ),
              const SizedBox(height: 8),
              Text(
                'Chọn nghĩa đúng',
                style: TextStyle(fontSize: 16, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (int i = 0; i < _currentOptions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    _AnswerButton(
                      answer: _currentOptions[i],
                      color: [Colors.blue, Colors.pink, Colors.green][i % 3],
                      isSelected: _selectedAnswer == _currentOptions[i],
                      isCorrect: _isCorrect == true &&
                          question.translation == _currentOptions[i],
                      isWrong: _selectedAnswer == _currentOptions[i] &&
                          _isCorrect == false,
                      onTap: () => _selectAnswer(_currentOptions[i]),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LaneButton extends StatelessWidget {
  const _LaneButton({
    required this.lane,
    required this.isSelected,
    required this.onTap,
  });

  final int lane;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Center(
          child: Text(
            '$lane',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.answer,
    required this.color,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  final String answer;
  final Color color;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bgColor = color;
    if (isCorrect) bgColor = Colors.green;
    if (isWrong) bgColor = Colors.red;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              answer,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
