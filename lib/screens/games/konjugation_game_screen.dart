import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Konjugation Trainer game - Chia động từ.
class KonjugationGameScreen extends StatefulWidget {
  const KonjugationGameScreen({super.key});

  @override
  State<KonjugationGameScreen> createState() => _KonjugationGameScreenState();
}

class _KonjugationGameScreenState extends State<KonjugationGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  bool _gameOver = false;
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  Timer? _timer;

  // Mock conjugation questions
  final _questions = [
    {
      'verb': 'haben',
      'base': 'haben',
      'meaning': 'có',
      'pronoun': 'ich',
      'expected': 'habe',
      'options': ['habe', 'hast', 'hat', 'haben'],
      'correct': 0,
    },
    {
      'verb': 'sein',
      'base': 'sein',
      'meaning': 'là, ở',
      'pronoun': 'du',
      'expected': 'bist',
      'options': ['bin', 'bist', 'ist', 'sind'],
      'correct': 1,
    },
    {
      'verb': 'machen',
      'base': 'machen',
      'meaning': 'làm',
      'pronoun': 'er',
      'expected': 'macht',
      'options': ['mache', 'machst', 'macht', 'machen'],
      'correct': 2,
    },
    {
      'verb': 'spielen',
      'base': 'spielen',
      'meaning': 'chơi',
      'pronoun': 'wir',
      'expected': 'spielen',
      'options': ['spiele', 'spielst', 'spielt', 'spielen'],
      'correct': 3,
    },
    {
      'verb': 'gehen',
      'base': 'gehen',
      'meaning': 'đi',
      'pronoun': 'sie (sie)',
      'expected': 'gehen',
      'options': ['gehe', 'gehst', 'geht', 'gehen'],
      'correct': 3,
    },
    {
      'verb': 'sprechen',
      'base': 'sprechen',
      'meaning': 'nói',
      'pronoun': 'ihr',
      'expected': 'sprecht',
      'options': ['spreche', 'sprichst', 'spricht', 'sprecht'],
      'correct': 3,
    },
    {
      'verb': 'essen',
      'base': 'essen',
      'meaning': 'ăn',
      'pronoun': 'ich',
      'expected': 'esse',
      'options': ['esse', 'isst', 'ißt', 'essen'],
      'correct': 0,
    },
    {
      'verb': 'trinken',
      'base': 'trinken',
      'meaning': 'uống',
      'pronoun': 'er',
      'expected': 'trinkt',
      'options': ['trinke', 'trinkst', 'trinkt', 'trinken'],
      'correct': 2,
    },
  ];

  final _pronounColors = {
    'ich': Colors.blue,
    'du': Colors.green,
    'er': Colors.orange,
    'sie (sie)': Colors.purple,
    'wir': Colors.teal,
    'ihr': Colors.pink,
  };

  @override
  void initState() {
    super.initState();
    _questions.shuffle();
  }

  void _selectAnswer(int index) {
    if (_selectedAnswer != null) return;

    final question = _questions[_currentIndex];
    final correct = index == (question['correct'] as int);

    setState(() {
      _selectedAnswer = (question['options'] as List)[index] as String;
      _isCorrect = correct;
      _total++;

      if (correct) {
        _correct++;
        _score += 20;
      }
    });

    Timer(const Duration(seconds: 1), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < _questions.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedAnswer = null;
            _isCorrect = null;
          });
        } else {
          _endGame();
        }
      }
    });
  }

  void _endGame() {
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
        title: const Text('Konjugationstrainer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _gameOver ? _buildResults() : _buildGame(),
    );
  }

  Widget _buildGame() {
    final question = _questions[_currentIndex];
    final pronounColor = _pronounColors[question['pronoun']] ?? Colors.blue;

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
        ),

        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.teal.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.teal),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                '${_currentIndex + 1}/${_questions.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Question card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
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
            children: [
              // Pronoun badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: pronounColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  question['pronoun'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Verb
              Text(
                question['verb'] as String,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),

              // Meaning
              Text(
                '(${question['meaning'] as String})',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mutedForeground,
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'Chia động từ cho:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Options
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: List.generate(4, (index) {
              final option = (question['options'] as List)[index] as String;
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = index == (question['correct'] as int);

              Color bgColor = Colors.white;
              Color borderColor = Colors.teal.withValues(alpha: 0.3);

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
                  onTap: () => _selectAnswer(index),
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
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
            }),
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
                color: Colors.teal.shade100,
              ),
              child: const Icon(Icons.edit_note, size: 40, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.teal),
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
                        _gameOver = false;
                        _currentIndex = 0;
                        _selectedAnswer = null;
                        _isCorrect = null;
                        _questions.shuffle();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
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
