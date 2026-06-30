import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Cases Mastery game - Học các trường hợp của danh từ.
class CasesMasteryGameScreen extends StatefulWidget {
  const CasesMasteryGameScreen({super.key});

  @override
  State<CasesMasteryGameScreen> createState() => _CasesMasteryGameScreenState();
}

class _CasesMasteryGameScreenState extends State<CasesMasteryGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  bool _gameOver = false;
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  String _currentCase = 'Nominativ';

  Timer? _timer;

  // Mock data for cases
  final _questions = [
    {
      'noun': 'der Mann',
      'gender': 'der',
      'meaning': 'người đàn ông',
      'case': 'Nominativ',
      'options': ['der Mann', 'des Mannes', 'dem Mann', 'den Mann'],
      'correct': 0,
    },
    {
      'noun': 'das Kind',
      'gender': 'das',
      'meaning': 'đứa trẻ',
      'case': 'Genitiv',
      'options': ['das Kind', 'des Kindes', 'dem Kind', 'den Kind'],
      'correct': 1,
    },
    {
      'noun': 'die Frau',
      'gender': 'die',
      'meaning': 'người phụ nữ',
      'case': 'Dativ',
      'options': ['die Frau', 'der Frau', 'der Frau', 'die Frau'],
      'correct': 2,
    },
    {
      'noun': 'der Hund',
      'gender': 'der',
      'meaning': 'con chó',
      'case': 'Akkusativ',
      'options': ['der Hund', 'des Hundes', 'dem Hund', 'den Hund'],
      'correct': 3,
    },
    {
      'noun': 'die Katze',
      'gender': 'die',
      'meaning': 'con mèo',
      'case': 'Nominativ',
      'options': ['die Katze', 'der Katze', 'der Katze', 'die Katze'],
      'correct': 0,
    },
    {
      'noun': 'das Buch',
      'gender': 'das',
      'meaning': 'cuốn sách',
      'case': 'Genitiv',
      'options': ['das Buch', 'des Buches', 'dem Buch', 'das Buch'],
      'correct': 1,
    },
    {
      'noun': 'der Tisch',
      'gender': 'der',
      'meaning': 'cái bàn',
      'case': 'Dativ',
      'options': ['der Tisch', 'des Tisches', 'dem Tisch', 'den Tisch'],
      'correct': 2,
    },
    {
      'noun': 'die Schule',
      'gender': 'die',
      'meaning': 'trường học',
      'case': 'Akkusativ',
      'options': ['die Schule', 'der Schule', 'der Schule', 'die Schule'],
      'correct': 3,
    },
  ];

  final _caseColors = {
    'Nominativ': Colors.blue,
    'Genitiv': Colors.purple,
    'Dativ': Colors.green,
    'Akkusativ': Colors.orange,
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
      _currentCase = question['case'] as String;
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
        title: const Text('Cases Mastery'),
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
    final caseColor = _caseColors[_currentCase] ?? Colors.blue;

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(caseColor),
        ),

        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: caseColor.withValues(alpha: 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: caseColor),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              // Case badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: caseColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _currentCase,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '${_currentIndex + 1}/${_questions.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Noun card
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
              Text(
                question['noun'] as String,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: caseColor,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: caseColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Chọn dạng đúng cho $_currentCase',
                  style: TextStyle(
                    fontSize: 14,
                    color: caseColor,
                    fontWeight: FontWeight.w500,
                  ),
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
              Color borderColor = caseColor.withValues(alpha: 0.3);

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
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: borderColor.withValues(alpha: 0.2),
                          ),
                          child: Center(
                            child: Text(
                              ['N', 'G', 'D', 'A'][index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: borderColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                        ),
                        if (_selectedAnswer != null && isCorrectAnswer)
                          const Icon(Icons.check_circle, color: Colors.green),
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
                color: Colors.blue.shade100,
              ),
              child: const Icon(Icons.school, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const Text('Điểm', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
            const SizedBox(height: 16),
            const Text(
              'Cases Mastery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue),
            ),
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
