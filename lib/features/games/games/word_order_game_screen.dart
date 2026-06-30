import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Word Order game - Xếp từ đúng thứ tự trong câu.
class WordOrderGameScreen extends StatefulWidget {
  const WordOrderGameScreen({super.key});

  @override
  State<WordOrderGameScreen> createState() => _WordOrderGameScreenState();
}

class _WordOrderGameScreenState extends State<WordOrderGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 120;
  bool _gameOver = false;
  int _currentIndex = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  Timer? _timer;

  // Mock sentences with scrambled words
  final _sentences = [
    {
      'words': ['Ich', 'lerne', 'Deutsch'],
      'answer': 'Ich lerne Deutsch.',
      'meaning': 'Tôi học tiếng Đức',
    },
    {
      'words': ['Das', 'ist', 'ein', 'Buch'],
      'answer': 'Das ist ein Buch.',
      'meaning': 'Đây là một cuốn sách',
    },
    {
      'words': ['Ich', 'trinke', 'Wasser'],
      'answer': 'Ich trinke Wasser.',
      'meaning': 'Tôi uống nước',
    },
    {
      'words': ['Die', 'Frau', 'liest'],
      'answer': 'Die Frau liest.',
      'meaning': 'Người phụ nữ đọc sách',
    },
    {
      'words': ['Ich', 'habe', 'einen', 'Hund'],
      'answer': 'Ich habe einen Hund.',
      'meaning': 'Tôi có một con chó',
    },
    {
      'words': ['Das', 'Kind', 'spielt'],
      'answer': 'Das Kind spielt.',
      'meaning': 'Đứa trẻ chơi',
    },
    {
      'words': ['Ich', 'gehe', 'zur', 'Schule'],
      'answer': 'Ich gehe zur Schule.',
      'meaning': 'Tôi đi đến trường',
    },
    {
      'words': ['Er', 'isst', 'einen', 'Apfel'],
      'answer': 'Er isst einen Apfel.',
      'meaning': 'Anh ấy ăn một quả táo',
    },
    {
      'words': ['Sie', 'trinkt', 'Kaffee'],
      'answer': 'Sie trinkt Kaffee.',
      'meaning': 'Cô ấy uống cà phê',
    },
    {
      'words': ['Das', 'Auto', 'ist', 'rot'],
      'answer': 'Das Auto ist rot.',
      'meaning': 'Chiếc ô tô màu đỏ',
    },
  ];

  List<String> _scrambledWords = [];
  List<String> _userOrder = [];
  List<String> _availableWords = [];

  @override
  void initState() {
    super.initState();
    _loadSentence();
    _startTimer();
  }

  void _loadSentence() {
    final sentence = _sentences[_currentIndex];
    _scrambledWords = List<String>.from(sentence['words'] as List);
    _scrambledWords.shuffle();
    _availableWords = List<String>.from(_scrambledWords);
    _userOrder = [];
    setState(() {});
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

  void _addWord(String word) {
    setState(() {
      _userOrder.add(word);
      _availableWords.remove(word);
    });
  }

  void _removeWord(String word) {
    setState(() {
      _userOrder.remove(word);
      _availableWords.add(word);
    });
  }

  void _checkAnswer() {
    final sentence = _sentences[_currentIndex];
    final correctAnswer = (sentence['answer'] as String).replaceAll('.', '').toLowerCase();
    final userAnswer = _userOrder.join(' ').toLowerCase();
    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      _total++;
      _isCorrect = isCorrect;
      _showResult = true;

      if (isCorrect) {
        _correct++;
        _score += 25;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < _sentences.length - 1) {
          setState(() {
            _currentIndex++;
            _showResult = false;
          });
          _loadSentence();
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
        title: const Text('Wortstellung'),
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
    final sentence = _sentences[_currentIndex];

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _sentences.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                '${_currentIndex + 1}/${_sentences.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        // Meaning hint
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.translate, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sentence['meaning'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // User's answer area
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _showResult
                ? (_isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _showResult
                  ? (_isCorrect ? Colors.green : Colors.red)
                  : Colors.amber.shade200,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Câu của bạn:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              if (_userOrder.isEmpty)
                const Text(
                  'Nhấn vào từ bên dưới để xếp câu',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.mutedForeground,
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _userOrder.asMap().entries.map((entry) {
                    final index = entry.key;
                    final word = entry.value;
                    return GestureDetector(
                      onTap: _showResult ? null : () => _removeWord(word),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          word,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (_showResult && !_isCorrect) ...[
                const Divider(),
                Text(
                  'Đáp án: ${sentence['answer']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Available words
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Chọn từ:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _availableWords.map((word) {
                  return GestureDetector(
                    onTap: _showResult ? null : () => _addWord(word),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(24),
          child: _showResult
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: _userOrder.isNotEmpty ? _checkAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kiểm tra', style: TextStyle(fontSize: 18)),
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
                color: Colors.amber.shade100,
              ),
              child: const Icon(Icons.swap_vert, size: 40, color: Colors.amber),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
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
                        _showResult = false;
                        _sentences.shuffle();
                        _loadSentence();
                        _startTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
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
