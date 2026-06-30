import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Daily review widget - sync từ web.
class DailyReview extends StatefulWidget {
  const DailyReview({super.key});

  @override
  State<DailyReview> createState() => _DailyReviewState();
}

class _DailyReviewState extends State<DailyReview> {
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _showAnswer = false;
  String _selectedAnswer = '';

  final _questions = [
    _Question(
      question: 'What does "Haus" mean?',
      options: ['House', 'Car', 'Water', 'Book'],
      correctIndex: 0,
    ),
    _Question(
      question: 'What is the plural of "das Kind"?',
      options: ['die Kinder', 'der Kinder', 'den Kindern', 'die Kind'],
      correctIndex: 0,
    ),
    _Question(
      question: 'How do you say "I am learning German"?',
      options: [
        'Ich lerne Deutsch',
        'Ich spreche Deutsch',
        'Ich bin Deutsch',
        'Ich habe Deutsch'
      ],
      correctIndex: 0,
    ),
    _Question(
      question: 'What gender is "Frau"?',
      options: ['der', 'die', 'das', 'den'],
      correctIndex: 1,
    ),
    _Question(
      question: 'Complete: "Ich ___ müde." (sein)',
      options: ['bin', 'bist', 'ist', 'sind'],
      correctIndex: 0,
    ),
  ];

  void _selectAnswer(int index) {
    if (_showAnswer) return;

    setState(() {
      _selectedAnswer = _questions[_currentIndex].options[index];
      _showAnswer = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _correctCount++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _selectedAnswer = '';
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final score = (_correctCount / _questions.length * 100).round();
    final passed = score >= 70;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: passed ? Colors.green.shade100 : Colors.red.shade100,
              ),
              child: Icon(
                passed ? Icons.celebration : Icons.refresh,
                size: 40,
                color: passed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Score
            Text(
              '$score%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green : Colors.red,
              ),
            ),
            Text(
              passed ? 'Xuất sắc!' : 'Cần ôn tập thêm',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_correctCount/${_questions.length} câu đúng',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Về trang chủ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 0;
                        _correctCount = 0;
                        _showAnswer = false;
                        _selectedAnswer = '';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tigerOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Ôn lại'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1}/${_questions.length}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tigerOrange),
            ),

            const SizedBox(height: 32),

            // Question
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = _selectedAnswer == option;
                  final isCorrect = index == question.correctIndex;
                  final showCorrect = _showAnswer && isCorrect;
                  final showWrong = _showAnswer && isSelected && !isCorrect;

                  Color bgColor = Colors.white;
                  Color borderColor = Colors.grey.shade300;
                  Color textColor = AppColors.foreground;

                  if (showCorrect) {
                    bgColor = Colors.green.shade50;
                    borderColor = Colors.green;
                    textColor = Colors.green.shade700;
                  } else if (showWrong) {
                    bgColor = Colors.red.shade50;
                    borderColor = Colors.red;
                    textColor = Colors.red.shade700;
                  }

                  return GestureDetector(
                    onTap: () => _selectAnswer(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                              color: showCorrect
                                  ? Colors.green
                                  : showWrong
                                      ? Colors.red
                                      : Colors.grey.shade200,
                            ),
                            child: Center(
                              child: showCorrect
                                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                                  : showWrong
                                      ? const Icon(Icons.close, color: Colors.white, size: 18)
                                      : Text(
                                          String.fromCharCode(65 + index),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.foreground,
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
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next button
            if (_showAnswer)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tigerOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _questions.length - 1 ? 'Tiếp tục' : 'Xem kết quả',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  const _Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
