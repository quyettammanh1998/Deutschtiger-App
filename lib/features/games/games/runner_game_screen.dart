import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Deutsch Runner game - Platform-style runner với quiz.
class RunnerGameScreen extends StatefulWidget {
  const RunnerGameScreen({super.key});

  @override
  State<RunnerGameScreen> createState() => _RunnerGameScreenState();
}

class _RunnerGameScreenState extends State<RunnerGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _lives = 3;
  int _timeLeft = 60;
  bool _gameOver = false;
  bool _isRunning = true;
  Timer? _gameTimer;
  Timer? _obstacleTimer;

  // Runner position (0 = safe zone, 1-3 = obstacles)
  int _runnerPosition = 1;
  int _obstacleLane = -1;

  // Mock questions
  final _questions = [
    {'word': 'Haus', 'meaning': 'Nhà', 'correct': 'das'},
    {'word': 'Buch', 'meaning': 'Sách', 'correct': 'das'},
    {'word': 'Wasser', 'meaning': 'Nước', 'correct': 'das'},
    {'word': 'Frau', 'meaning': 'Phụ nữ', 'correct': 'die'},
    {'word': 'Mann', 'meaning': 'Đàn ông', 'correct': 'der'},
    {'word': 'Katze', 'meaning': 'Con mèo', 'correct': 'die'},
    {'word': 'Hund', 'meaning': 'Con chó', 'correct': 'der'},
    {'word': 'Auto', 'meaning': 'Ô tô', 'correct': 'das'},
    {'word': 'Schule', 'meaning': 'Trường học', 'correct': 'die'},
    {'word': 'Tisch', 'meaning': 'Cái bàn', 'correct': 'der'},
  ];

  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  bool _obstacleActive = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startObstacles();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_gameOver) {
        setState(() => _timeLeft--);
      } else if (_timeLeft == 0) {
        _endGame();
      }
    });
  }

  void _startObstacles() {
    _obstacleTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (!_gameOver && _obstacleActive) {
        // Check if runner is in same lane as obstacle
        if (_runnerPosition == _obstacleLane) {
          _hitObstacle();
        }
        setState(() {
          _obstacleLane = -1;
          _obstacleActive = false;
        });
      } else if (!_gameOver) {
        // Spawn new obstacle
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

    if (_lives <= 0) {
      _endGame();
    }
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;

    final question = _questions[_currentQuestionIndex];
    final correct = question['correct'] as String;
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

    // Next question after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && !_gameOver) {
        setState(() {
          _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
          _selectedAnswer = null;
          _isCorrect = null;
        });
      }
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _obstacleTimer?.cancel();
    setState(() {
      _gameOver = true;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _obstacleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: _gameOver ? _buildResults() : _buildGame(),
    );
  }

  Widget _buildGame() {
    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        // Header stats
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lives
              Row(
                children: List.generate(3, (index) {
                  return Icon(
                    index < _lives ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 28,
                  );
                }),
              ),
              // Score
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _timeLeft <= 10 ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_timeLeft}s',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Runner track
        Expanded(
          child: Stack(
            children: [
              // Track background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade100,
                      Colors.blue.shade200,
                    ],
                  ),
                ),
              ),

              // Lanes
              for (int i = 0; i < 3; i++)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 80.0 + (i * 100),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.blue.shade300, width: 2),
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

              // Runner
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
                  child: const Icon(Icons.directions_run, color: Colors.white, size: 32),
                ),
              ),

              // Obstacle
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
                    child: const Icon(Icons.warning, color: Colors.white, size: 32),
                  ),
                ),

              // Lane buttons
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

        // Quiz card
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
                question['word'] as String,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question['meaning'] as String,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _AnswerButton(
                    answer: 'der',
                    color: Colors.blue,
                    isSelected: _selectedAnswer == 'der',
                    isCorrect: _isCorrect == true && question['correct'] == 'der',
                    isWrong: _selectedAnswer == 'der' && _isCorrect == false,
                    onTap: () => _selectAnswer('der'),
                  ),
                  const SizedBox(width: 12),
                  _AnswerButton(
                    answer: 'die',
                    color: Colors.pink,
                    isSelected: _selectedAnswer == 'die',
                    isCorrect: _isCorrect == true && question['correct'] == 'die',
                    isWrong: _selectedAnswer == 'die' && _isCorrect == false,
                    onTap: () => _selectAnswer('die'),
                  ),
                  const SizedBox(width: 12),
                  _AnswerButton(
                    answer: 'das',
                    color: Colors.green,
                    isSelected: _selectedAnswer == 'das',
                    isCorrect: _isCorrect == true && question['correct'] == 'das',
                    isWrong: _selectedAnswer == 'das' && _isCorrect == false,
                    onTap: () => _selectAnswer('das'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final accuracy = _total > 0 ? (_correct / _total * 100).round() : 0;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              child: const Icon(Icons.directions_run, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text('Điểm', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Đúng', value: '$_correct/$_total', color: Colors.green),
                _StatItem(label: 'Độ chính xác', value: '$accuracy%', color: accuracy >= 70 ? Colors.green : Colors.orange),
                _StatItem(label: 'Mạng', value: '$_lives/3', color: Colors.red),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Về trang chủ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _score = 0;
                        _correct = 0;
                        _total = 0;
                        _lives = 3;
                        _timeLeft = 60;
                        _gameOver = false;
                        _isRunning = true;
                        _currentQuestionIndex = 0;
                        _selectedAnswer = null;
                        _isCorrect = null;
                        _runnerPosition = 1;
                        _obstacleLane = -1;
                        _obstacleActive = false;
                      });
                      _startTimer();
                      _startObstacles();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Chơi lại'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 18,
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

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}
