import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Listening game - Nghe và chọn đáp án.
class ListeningGameScreen extends StatefulWidget {
  const ListeningGameScreen({super.key});

  @override
  State<ListeningGameScreen> createState() => _ListeningGameScreenState();
}

class _ListeningGameScreenState extends State<ListeningGameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 60;
  bool _gameOver = false;
  bool _isPlaying = false;
  String? _selectedAnswer;
  bool? _isCorrect;
  Timer? _timer;

  // Mock questions with audio URLs (using placeholder)
  final _questions = [
    {'word': 'Haus', 'meaning': 'Nhà', 'audio': null},
    {'word': 'Buch', 'meaning': 'Sách', 'audio': null},
    {'word': 'Wasser', 'meaning': 'Nước', 'audio': null},
    {'word': 'Auto', 'meaning': 'Ô tô', 'audio': null},
    {'word': 'Schule', 'meaning': 'Trường học', 'audio': null},
    {'word': 'Tisch', 'meaning': 'Cái bàn', 'audio': null},
    {'word': 'Stuhl', 'meaning': 'Cái ghế', 'audio': null},
    {'word': 'Fenster', 'meaning': 'Cửa sổ', 'audio': null},
  ];

  List<String> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _generateOptions();
    _startTimer();
  }

  void _generateOptions() {
    final correct = _questions[_currentIndex]['meaning'] as String;
    final wrongOptions = _questions
        .where((q) => q['meaning'] != correct)
        .toList()
      ..shuffle();
    
    final options = [correct, wrongOptions[0]['meaning']!, wrongOptions[1]['meaning']!, wrongOptions[2]['meaning']!];
    options.shuffle();
    setState(() => _currentOptions = options);
  }

  void _playAudio() {
    setState(() => _isPlaying = true);
    
    // Simulate audio playback
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;

    final correctAnswer = _questions[_currentIndex]['meaning'] as String;
    final isCorrect = answer == correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
      _total++;

      if (isCorrect) {
        _correct++;
        _score += 15;
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (_currentIndex < _questions.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedAnswer = null;
            _isCorrect = null;
          });
          _generateOptions();
        } else {
          _endGame();
        }
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Luyện nghe'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _timeLeft <= 10 ? Colors.red : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text('${_timeLeft}s', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: _gameOver ? _buildResults() : _buildGame(),
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.purple),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${_currentIndex + 1}/${_questions.length}', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),

        const Spacer(),

        // Audio card
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
              // Play button
              GestureDetector(
                onTap: _playAudio,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.purple, width: 3),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.volume_up : Icons.play_arrow,
                    size: 48,
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isPlaying ? 'Đang phát...' : 'Nhấn để nghe',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nghe từ và chọn nghĩa đúng',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Options
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: _currentOptions.map((option) {
              final isSelected = _selectedAnswer == option;
              final correctAnswer = _questions[_currentIndex]['meaning'] as String;
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
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (_selectedAnswer != null && isCorrectAnswer)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (_selectedAnswer == option && !isCorrectAnswer)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const Spacer(),
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
                color: accuracy >= 70 ? Colors.green.shade100 : Colors.grey.shade200,
              ),
              child: Icon(
                accuracy >= 70 ? Icons.emoji_events : Icons.refresh,
                size: 40,
                color: accuracy >= 70 ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const Text('Điểm', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Đúng', value: '$_correct/$_total', color: Colors.green),
                _StatItem(label: 'Độ chính xác', value: '$accuracy%', color: accuracy >= 70 ? Colors.green : Colors.orange),
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
                        _currentIndex = 0;
                        _score = 0;
                        _correct = 0;
                        _total = 0;
                        _timeLeft = 60;
                        _gameOver = false;
                        _selectedAnswer = null;
                        _isCorrect = null;
                        _questions.shuffle();
                        _generateOptions();
                        _startTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
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
