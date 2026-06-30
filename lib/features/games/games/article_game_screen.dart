import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Der/Die/Das article quiz game với UI đẹp.
class ArticleGameScreen extends StatefulWidget {
  const ArticleGameScreen({super.key});

  @override
  State<ArticleGameScreen> createState() => _ArticleGameScreenState();
}

class _ArticleGameScreenState extends State<ArticleGameScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _streak = 0;
  int _maxCombo = 0;
  String? _selectedArticle;
  bool _showResult = false;
  bool _isCorrect = false;
  int _timeLeft = 60;
  Timer? _timer;
  bool _gameOver = false;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Mock words with gender
  final _words = [
    {'word': 'Haus', 'meaning': 'Nhà', 'gender': 'das'},
    {'word': 'Buch', 'meaning': 'Sách', 'gender': 'das'},
    {'word': 'Wasser', 'meaning': 'Nước', 'gender': 'das'},
    {'word': 'Frau', 'meaning': 'Phụ nữ', 'gender': 'die'},
    {'word': 'Mann', 'meaning': 'Đàn ông', 'gender': 'der'},
    {'word': 'Kind', 'meaning': 'Trẻ em', 'gender': 'das'},
    {'word': 'Katze', 'meaning': 'Con mèo', 'gender': 'die'},
    {'word': 'Hund', 'meaning': 'Con chó', 'gender': 'der'},
    {'word': 'Auto', 'meaning': 'Ô tô', 'gender': 'das'},
    {'word': 'Schule', 'meaning': 'Trường học', 'gender': 'die'},
    {'word': 'Tisch', 'meaning': 'Cái bàn', 'gender': 'der'},
    {'word': 'Wasser', 'meaning': 'Nước', 'gender': 'das'},
    {'word': 'Blume', 'meaning': 'Bông hoa', 'gender': 'die'},
    {'word': 'Stuhl', 'meaning': 'Cái ghế', 'gender': 'der'},
    {'word': 'Fenster', 'meaning': 'Cửa sổ', 'gender': 'das'},
  ];

  Map<String, dynamic> get _currentWord => _words[_currentIndex % _words.length];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
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

  void _selectArticle(String article) {
    if (_showResult) return;

    final correct = _currentWord['gender'] == article;

    setState(() {
      _selectedArticle = article;
      _showResult = true;
      _isCorrect = correct;
      _total++;

      if (correct) {
        _correct++;
        _streak++;
        if (_streak > _maxCombo) _maxCombo = _streak;
        _score += 10 + (_streak > 3 ? 5 : 0);
        _bounceController.forward().then((_) => _bounceController.reverse());
      } else {
        _streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (_currentIndex < _words.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedArticle = null;
            _showResult = false;
          });
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
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Custom header
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
          // Back button
          _HeaderButton(
            icon: Icons.close,
            onTap: () => context.pop(),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Der/Die/Das',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  'Đoán mạo từ',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          // Timer
          _TimerBadge(
            seconds: _timeLeft,
            isWarning: _timeLeft <= 10,
          ),
        ],
      ),
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        // Progress bar
        _ProgressBar(
          current: _currentIndex + 1,
          total: _words.length,
          color: const Color(0xFF14B8A6),
        ),

        // Stats row
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
                value: '$_correct/$_total',
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

        // Word card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF14B8A6).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Word
                  Text(
                    _currentWord['word'] ?? '',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentWord['meaning'] ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const Spacer(),

        // Article buttons
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: _ArticleButton(
                  article: 'der',
                  color: Colors.blue,
                  isSelected: _selectedArticle == 'der',
                  isCorrect: _showResult && _currentWord['gender'] == 'der',
                  isWrong: _showResult && _selectedArticle == 'der' && !_isCorrect,
                  onTap: () => _selectArticle('der'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ArticleButton(
                  article: 'die',
                  color: Colors.pink,
                  isSelected: _selectedArticle == 'die',
                  isCorrect: _showResult && _currentWord['gender'] == 'die',
                  isWrong: _showResult && _selectedArticle == 'die' && !_isCorrect,
                  onTap: () => _selectArticle('die'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ArticleButton(
                  article: 'das',
                  color: Colors.green,
                  isSelected: _selectedArticle == 'das',
                  isCorrect: _showResult && _currentWord['gender'] == 'das',
                  isWrong: _showResult && _selectedArticle == 'das' && !_isCorrect,
                  onTap: () => _selectArticle('das'),
                ),
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
              // Trophy
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade400,
                      Colors.amber.shade600,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  accuracy >= 70 ? Icons.emoji_events : Icons.refresh,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Score
              Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14B8A6),
                ),
              ),
              const Text(
                'Điểm',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mutedForeground,
                ),
              ),

              const SizedBox(height: 24),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(
                    label: 'Đúng',
                    value: '$_correct/$_total',
                    color: Colors.green,
                  ),
                  _ResultStat(
                    label: 'Chính xác',
                    value: '$accuracy%',
                    color: accuracy >= 70 ? Colors.green : Colors.orange,
                  ),
                  _ResultStat(
                    label: 'Combo max',
                    value: 'x$_maxCombo',
                    color: Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                        setState(() {
                          _currentIndex = 0;
                          _score = 0;
                          _correct = 0;
                          _total = 0;
                          _streak = 0;
                          _maxCombo = 0;
                          _selectedArticle = null;
                          _showResult = false;
                          _gameOver = false;
                          _timeLeft = 60;
                          _words.shuffle();
                          _startTimer();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B8A6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.foreground),
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.seconds, required this.isWarning});

  final int seconds;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red : const Color(0xFF14B8A6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 18,
            color: isWarning ? Colors.white : Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 6),
          Text(
            '${seconds}s',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.current,
    required this.total,
    required this.color,
  });

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
              Text(
                'Câu $current/$total',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                '${((current / total) * 100).round()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
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
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

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
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleButton extends StatelessWidget {
  const _ArticleButton({
    required this.article,
    required this.color,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  final String article;
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

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: bgColor.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            article,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
