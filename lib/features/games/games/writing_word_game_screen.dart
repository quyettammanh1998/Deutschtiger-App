import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Writing Word game - Viết từ tiếng Đức từ nghĩa.
class WritingWordGameScreen extends StatefulWidget {
  const WritingWordGameScreen({super.key});

  @override
  State<WritingWordGameScreen> createState() => _WritingWordGameScreenState();
}

class _WritingWordGameScreenState extends State<WritingWordGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 120;
  bool _gameOver = false;
  int _currentIndex = 0;
  String _userInput = '';
  bool _showResult = false;
  bool _isCorrect = false;
  Timer? _timer;

  // Mock words
  final _words = [
    {'word': 'Haus', 'meaning': 'Nhà'},
    {'word': 'Buch', 'meaning': 'Sách'},
    {'word': 'Wasser', 'meaning': 'Nước'},
    {'word': 'Auto', 'meaning': 'Ô tô'},
    {'word': 'Schule', 'meaning': 'Trường học'},
    {'word': 'Tisch', 'meaning': 'Cái bàn'},
    {'word': 'Stuhl', 'meaning': 'Cái ghế'},
    {'word': 'Fenster', 'meaning': 'Cửa sổ'},
    {'word': 'Katze', 'meaning': 'Con mèo'},
    {'word': 'Hund', 'meaning': 'Con chó'},
    {'word': 'Frau', 'meaning': 'Phụ nữ'},
    {'word': 'Mann', 'meaning': 'Đàn ông'},
    {'word': 'Kind', 'meaning': 'Trẻ em'},
    {'word': 'Apfel', 'meaning': 'Quả táo'},
    {'word': 'Milch', 'meaning': 'Sữa'},
    {'word': 'Brot', 'meaning': 'Bánh mì'},
    {'word': 'Kaffee', 'meaning': 'Cà phê'},
    {'word': 'Tee', 'meaning': 'Trà'},
    {'word': 'Butter', 'meaning': 'Bơ'},
    {'word': 'Käse', 'meaning': 'Phô mai'},
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
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

  void _checkAnswer() {
    final currentWord = _words[_currentIndex]['word'] as String;
    final isCorrect = _userInput.toLowerCase().trim() == currentWord.toLowerCase();

    setState(() {
      _total++;
      _isCorrect = isCorrect;
      _showResult = true;

      if (isCorrect) {
        _correct++;
        _score += 20;
      }
    });

    // Next word after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < _words.length - 1) {
          setState(() {
            _currentIndex++;
            _userInput = '';
            _showResult = false;
          });
        } else {
          _endGame();
        }
      }
    });
  }

  void _skipWord() {
    setState(() {
      _total++;
      _userInput = '';
      _showResult = false;
      if (_currentIndex < _words.length - 1) {
        _currentIndex++;
      } else {
        _endGame();
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
        title: const Text('Viết từ'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _timeLeft <= 30 ? Colors.red : Colors.grey.shade200,
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
    final word = _words[_currentIndex];

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _words.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.green),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                '${_currentIndex + 1}/${_words.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Word card
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
              const Icon(Icons.translate, size: 40, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                word['meaning'] as String,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Viết từ tiếng Đức:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Input field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            decoration: InputDecoration(
              hintText: 'Gõ từ tiếng Đức...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 18),
              filled: true,
              fillColor: _showResult
                  ? (_isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _showResult
                      ? (_isCorrect ? Colors.green : Colors.red)
                      : Colors.green.shade200,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _showResult
                      ? (_isCorrect ? Colors.green : Colors.red)
                      : Colors.green.shade200,
                  width: 2,
                ),
              ),
              suffixIcon: _showResult
                  ? Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: _isCorrect ? Colors.green : Colors.red,
                    )
                  : null,
            ),
            enabled: !_showResult,
            onChanged: (value) => _userInput = value,
            onSubmitted: (_) => _checkAnswer(),
          ),
        ),

        if (_showResult) ...[
          const SizedBox(height: 16),
          Text(
            _isCorrect ? 'Đúng rồi!' : 'Đáp án: ${word['word']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _isCorrect ? Colors.green : Colors.red,
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Action buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _showResult
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _skipWord,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Bỏ qua'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _userInput.isNotEmpty ? _checkAnswer : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Kiểm tra'),
                      ),
                    ),
                  ],
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
                color: Colors.green.shade100,
              ),
              child: const Icon(Icons.edit, size: 40, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
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
                        _score = 0;
                        _correct = 0;
                        _total = 0;
                        _timeLeft = 120;
                        _gameOver = false;
                        _currentIndex = 0;
                        _userInput = '';
                        _showResult = false;
                        _words.shuffle();
                        _startTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
