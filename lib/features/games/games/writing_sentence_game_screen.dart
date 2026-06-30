import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Writing Sentence game - Viết câu hoàn chỉnh.
class WritingSentenceGameScreen extends StatefulWidget {
  const WritingSentenceGameScreen({super.key});

  @override
  State<WritingSentenceGameScreen> createState() => _WritingSentenceGameScreenState();
}

class _WritingSentenceGameScreenState extends State<WritingSentenceGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 180;
  bool _gameOver = false;
  int _currentIndex = 0;
  String _userInput = '';
  bool _showResult = false;
  int _currentScore = 0;
  Timer? _timer;

  // Mock sentences with hints
  final _sentences = [
    {
      'prompt': 'Tôi đi đến trường',
      'answer': 'Ich gehe zur Schule',
      'hint': 'Ich + gehen + zur + Schule',
    },
    {
      'prompt': 'Anh ấy uống cà phê',
      'answer': 'Er trinkt Kaffee',
      'hint': 'Er + trinken (trinkt) + Kaffee',
    },
    {
      'prompt': 'Người phụ nữ đọc sách',
      'answer': 'Die Frau liest ein Buch',
      'hint': 'Die + Frau + lesen (liest) + ein + Buch',
    },
    {
      'prompt': 'Tôi có một con chó',
      'answer': 'Ich habe einen Hund',
      'hint': 'Ich + haben (habe) + einen + Hund',
    },
    {
      'prompt': 'Đứa trẻ chơi ở công viên',
      'answer': 'Das Kind spielt im Park',
      'hint': 'Das + Kind + spielen (spielt) + im + Park',
    },
    {
      'prompt': 'Chúng tôi học tiếng Đức',
      'answer': 'Wir lernen Deutsch',
      'hint': 'Wir + lernen + Deutsch',
    },
    {
      'prompt': 'Cô ấy làm việc ở bệnh viện',
      'answer': 'Sie arbeitet im Krankenhaus',
      'hint': 'Sie + arbeiten (arbeitet) + im + Krankenhaus',
    },
    {
      'prompt': 'Tôi ăn bánh mì và uống sữa',
      'answer': 'Ich esse Brot und trinke Milch',
      'hint': 'Ich + essen (esse) + Brot + und + trinken (trinke) + Milch',
    },
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
    final sentence = _sentences[_currentIndex];
    final correctAnswer = (sentence['answer'] as String).toLowerCase().trim();
    final userAnswer = _userInput.toLowerCase().trim();

    // Calculate similarity score
    int score = _calculateSimilarity(userAnswer, correctAnswer);
    bool isCorrect = score >= 70;

    setState(() {
      _total++;
      _currentScore = score;
      _showResult = true;

      if (isCorrect) {
        _correct++;
        _score += score;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < _sentences.length - 1) {
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

  int _calculateSimilarity(String a, String b) {
    if (a == b) return 100;
    
    List<String> aWords = a.split(' ');
    List<String> bWords = b.split(' ');
    
    int matches = 0;
    for (String word in aWords) {
      if (bWords.contains(word)) matches++;
    }
    
    double ratio = matches / bWords.length;
    return (ratio * 100).round();
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
        title: const Text('Viết câu'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _timeLeft <= 60 ? Colors.red : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 16),
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
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.indigo),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${_currentIndex + 1}/${_sentences.length}', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),

        const Spacer(),

        // Prompt card
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
              const Icon(Icons.edit_note, size: 40, color: Colors.indigo),
              const SizedBox(height: 16),
              Text(
                'Viết câu tiếng Đức:',
                style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 8),
              Text(
                sentence['prompt'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Hint
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.indigo.shade400, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        sentence['hint'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Input field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Viết câu tiếng Đức...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: _showResult ? Colors.grey.shade100 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.indigo.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.indigo.shade200),
              ),
            ),
            enabled: !_showResult,
            onChanged: (value) => _userInput = value,
            onSubmitted: (_) => _checkAnswer(),
          ),
        ),

        if (_showResult) ...[
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _currentScore >= 70 ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Điểm: $_currentScore%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _currentScore >= 70 ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đáp án: ${sentence['answer']}',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
          ),
        ],

        const Spacer(),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(24),
          child: _showResult
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: _userInput.isNotEmpty ? _checkAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                color: Colors.indigo.shade100,
              ),
              child: const Icon(Icons.edit_note, size: 40, color: Colors.indigo),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.indigo),
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
                        _timeLeft = 180;
                        _gameOver = false;
                        _currentIndex = 0;
                        _userInput = '';
                        _showResult = false;
                        _sentences.shuffle();
                        _startTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
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
