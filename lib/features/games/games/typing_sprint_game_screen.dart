import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Typing Sprint game - Gõ từ trong 60 giây.
class TypingSprintGameScreen extends StatefulWidget {
  const TypingSprintGameScreen({super.key});

  @override
  State<TypingSprintGameScreen> createState() => _TypingSprintGameScreenState();
}

class _TypingSprintGameScreenState extends State<TypingSprintGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 60;
  bool _gameOver = false;
  String _currentWord = '';
  String _currentMeaning = '';
  String _userInput = '';
  int _currentIndex = 0;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
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
    _loadWord();
    _startTimer();
    _focusNode.requestFocus();
  }

  void _loadWord() {
    if (_currentIndex >= _words.length) {
      _words.shuffle();
      _currentIndex = 0;
    }
    setState(() {
      _currentWord = _words[_currentIndex]['word'] as String;
      _currentMeaning = _words[_currentIndex]['meaning'] as String;
      _userInput = '';
      _controller.clear();
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

  void _checkWord() {
    if (_userInput.toLowerCase().trim() == _currentWord.toLowerCase()) {
      // Correct!
      setState(() {
        _correct++;
        _total++;
        _score += 15 + (_currentWord.length * 2);
        _currentIndex++;
      });
      _loadWord();
    }
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);
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
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Typing Sprint'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _gameOver ? _buildResults() : _buildGame(),
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        // Progress header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.lightBlue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Score
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.lightBlue),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeLeft <= 10 ? Colors.red : Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${_timeLeft}s',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Correct count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$_correct',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
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
              Text(
                _currentMeaning,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'gõ tiếng Đức:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _currentWord,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.tigerOrange,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Input field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: KeyboardListener(
            focusNode: _focusNode,
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                _checkWord();
              }
            },
            child: TextField(
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: 'Gõ từ ở đây...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 18,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.lightBlue.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.lightBlue.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() => _userInput = value);
                if (value.toLowerCase() == _currentWord.toLowerCase()) {
                  _checkWord();
                }
              },
              onSubmitted: (_) => _checkWord(),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Hint keyboard
        _buildKeyboardHint(),

        const Spacer(),
      ],
    );
  }

  Widget _buildKeyboardHint() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Gợi ý phím:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: _currentWord.split('').map((char) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  char,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
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
                color: Colors.lightBlue.shade100,
              ),
              child: const Icon(Icons.keyboard, size: 40, color: Colors.lightBlue),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
            const Text('Điểm', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Đúng', value: '$_correct', color: Colors.green),
                _StatItem(label: 'Tổng', value: '$_total', color: Colors.blue),
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
                        _timeLeft = 60;
                        _gameOver = false;
                        _currentIndex = 0;
                        _words.shuffle();
                        _loadWord();
                        _startTimer();
                        _focusNode.requestFocus();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
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
