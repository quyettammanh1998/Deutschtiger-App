import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Word Sprint game - 60 seconds quiz với UI đẹp.
class WordSprintGameScreen extends StatefulWidget {
  const WordSprintGameScreen({super.key});

  @override
  State<WordSprintGameScreen> createState() => _WordSprintGameScreenState();
}

class _WordSprintGameScreenState extends State<WordSprintGameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _streak = 0;
  int _maxCombo = 0;
  int _timeLeft = 60;
  bool _gameOver = false;
  String? _selectedAnswer;
  bool? _isCorrect;
  Timer? _timer;

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
  ];

  List<String> _currentOptions = [];
  int _correctIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateOptions();
    _startTimer();
  }

  void _generateOptions() {
    final current = _words[_currentIndex % _words.length];
    final correct = current['meaning'] as String;

    final wrongOptions = _words
        .where((w) => w['meaning'] != correct)
        .toList()
      ..shuffle();

    final options = [
      correct,
      wrongOptions[0]['meaning'] ?? '',
      wrongOptions[1]['meaning'] ?? '',
      wrongOptions[2]['meaning'] ?? '',
    ];
    options.shuffle();
    _correctIndex = options.indexOf(correct);
    setState(() => _currentOptions = options);
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

  void _selectAnswer(int index) {
    if (_selectedAnswer != null) return;

    final isCorrect = index == _correctIndex;

    setState(() {
      _selectedAnswer = _currentOptions[index];
      _isCorrect = isCorrect;
      _total++;

      if (isCorrect) {
        _correct++;
        _streak++;
        if (_streak > _maxCombo) _maxCombo = _streak;
        _score += 10 + (_streak > 3 ? 5 : 0);
      } else {
        _streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (_currentIndex < _words.length - 1) {
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
      backgroundColor: const Color(0xFFFFF8E6),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_gameOver)
              Expanded(child: _buildResults())
            else
              Expanded(child: _buildGame()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _HeaderButton(
            icon: Icons.close,
            onTap: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Word Sprint',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  '60 giây chinh phục từ vựng',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          _TimerBadge(
            seconds: _timeLeft,
            isWarning: _timeLeft <= 10,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        _ProgressBar(
          current: _currentIndex + 1,
          total: _words.length,
          color: Colors.amber,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatBadge(
                icon: Icons.star,
                value: '$_score',
                color: Colors.amber,
              ),
              _StatBadge(
                icon: Icons.check_circle,
                value: '$_correct',
                color: Colors.green,
              ),
              if (_streak > 0)
                _StatBadge(
                  icon: Icons.local_fire_department,
                  value: 'x$_streak',
                  color: Colors.orange,
                ),
            ],
          ),
        ),

        const Spacer(),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                (_words[_currentIndex % _words.length]['word'] as String?) ?? '',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nghĩa là gì?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: _currentOptions.length,
              itemBuilder: (context, index) {
                final option = _currentOptions.isNotEmpty ? _currentOptions[index] : '';
                final isSelected = _selectedAnswer == option;
                final isCorrectAnswer = index == _correctIndex;

                Color bgColor = Colors.white;
                Color borderColor = Colors.amber.shade200;
                Color textColor = AppColors.foreground;

                if (_selectedAnswer != null) {
                  if (isCorrectAnswer) {
                    bgColor = Colors.green.shade50;
                    borderColor = Colors.green;
                    textColor = Colors.green.shade700;
                  } else if (isSelected) {
                    bgColor = Colors.red.shade50;
                    borderColor = Colors.red;
                    textColor = Colors.red.shade700;
                  }
                }

                return GestureDetector(
                  onTap: () => _selectAnswer(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResults() {
    final accuracy = _total > 0 ? (_correct / _total * 100).round() : 0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.amber.shade600],
                  ),
                ),
                child: const Icon(Icons.emoji_events, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const Text('Điểm', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(label: 'Đúng', value: '$_correct/$_total', color: Colors.green),
                  _ResultStat(label: 'Chính xác', value: '$accuracy%', color: accuracy >= 70 ? Colors.green : Colors.orange),
                  _ResultStat(label: 'Combo max', value: 'x$_maxCombo', color: Colors.orange),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                          _streak = 0;
                          _maxCombo = 0;
                          _selectedAnswer = null;
                          _isCorrect = null;
                          _gameOver = false;
                          _timeLeft = 60;
                          _words.shuffle();
                          _generateOptions();
                          _startTimer();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.foreground),
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.seconds, required this.isWarning, required this.color});

  final int seconds;
  final bool isWarning;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red : color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 18, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text('${seconds}s', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total, required this.color});

  final int current;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Câu $current/$total', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.mutedForeground)),
              Text('${((current / total) * 100).round()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.icon, required this.value, required this.color});

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}
