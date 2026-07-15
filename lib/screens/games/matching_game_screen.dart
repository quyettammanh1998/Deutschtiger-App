import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Matching game - Nối từ với UI đẹp.
class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  int _score = 0;
  int _matched = 0;
  int _attempts = 0;
  int _timeLeft = 60;
  bool _gameOver = false;
  Timer? _timer;

  final _allPairs = [
    {'german': 'Haus', 'vietnamese': 'Nhà'},
    {'german': 'Buch', 'vietnamese': 'Sách'},
    {'german': 'Wasser', 'vietnamese': 'Nước'},
    {'german': 'Auto', 'vietnamese': 'Ô tô'},
    {'german': 'Schule', 'vietnamese': 'Trường học'},
    {'german': 'Tisch', 'vietnamese': 'Cái bàn'},
    {'german': 'Stuhl', 'vietnamese': 'Cái ghế'},
    {'german': 'Fenster', 'vietnamese': 'Cửa sổ'},
    {'german': 'Katze', 'vietnamese': 'Con mèo'},
    {'german': 'Hund', 'vietnamese': 'Con chó'},
  ];

  List<Map<String, String>> _germanWords = [];
  List<Map<String, String>> _vietnameseWords = [];
  final Set<int> _matchedGerman = {};
  final Set<int> _matchedVietnamese = {};
  int? _selectedGermanIndex;
  int? _selectedVietnameseIndex;

  @override
  void initState() {
    super.initState();
    _setupGame();
    _startTimer();
  }

  void _setupGame() {
    final pairs = List<Map<String, String>>.from(_allPairs)..shuffle();
    _germanWords = pairs;
    _vietnameseWords = List<Map<String, String>>.from(pairs)..shuffle();
    _vietnameseWords.shuffle();
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

  void _selectGerman(int index) {
    if (_matchedGerman.contains(index)) return;

    setState(() {
      if (_selectedGermanIndex != null && _selectedVietnameseIndex != null) {
        _checkMatch();
      }
      _selectedGermanIndex = index;
    });
  }

  void _selectVietnamese(int index) {
    if (_matchedVietnamese.contains(index)) return;

    setState(() {
      if (_selectedGermanIndex != null && _selectedVietnameseIndex != null) {
        _checkMatch();
      }
      _selectedVietnameseIndex = index;
    });
  }

  void _checkMatch() {
    final germanPair = _germanWords[_selectedGermanIndex!];
    final vietnamesePair = _vietnameseWords[_selectedVietnameseIndex!];

    _attempts++;

    if (germanPair['german'] == vietnamesePair['german']) {
      setState(() {
        _matchedGerman.add(_selectedGermanIndex!);
        _matchedVietnamese.add(_selectedVietnameseIndex!);
        _matched++;
        _score += 20;
        _selectedGermanIndex = null;
        _selectedVietnameseIndex = null;
      });

      if (_matched == _allPairs.length) {
        _endGame();
      }
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _selectedGermanIndex = null;
            _selectedVietnameseIndex = null;
          });
        }
      });
    }
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
      backgroundColor: const Color(0xFFFFF0F5),
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
                  'Nối từ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  'Ghép từ Đức - Việt',
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
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        // Progress
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBadge(
                icon: Icons.star,
                value: '$_score',
                color: Colors.pink,
              ),
              _StatBadge(
                icon: Icons.check_circle,
                value: '$_matched/${_allPairs.length}',
                color: Colors.green,
              ),
              _StatBadge(
                icon: Icons.loop,
                value: '$_attempts',
                color: Colors.blue,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _matched / _allPairs.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
              minHeight: 8,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '🇩🇪 Tiếng Đức',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '🇻🇳 Tiếng Việt',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Matching columns
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // German column
                Expanded(
                  child: ListView.builder(
                    itemCount: _germanWords.length,
                    itemBuilder: (context, index) {
                      final isMatched = _matchedGerman.contains(index);
                      final isSelected = _selectedGermanIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _WordChip(
                          text: _germanWords[index]['german'] ?? '',
                          isMatched: isMatched,
                          isSelected: isSelected,
                          isGerman: true,
                          onTap: () => isMatched ? null : _selectGerman(index),
                        ),
                      );
                    },
                  ),
                ),

                // Connection line
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.pink.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Vietnamese column
                Expanded(
                  child: ListView.builder(
                    itemCount: _vietnameseWords.length,
                    itemBuilder: (context, index) {
                      final isMatched = _matchedVietnamese.contains(index);
                      final isSelected = _selectedVietnameseIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _WordChip(
                          text: _vietnameseWords[index]['vietnamese'] ?? '',
                          isMatched: isMatched,
                          isSelected: isSelected,
                          isGerman: false,
                          onTap: () => isMatched ? null : _selectVietnamese(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final accuracy = _attempts > 0 ? (_matched / _attempts * 100).round() : 0;

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
                    colors: [Colors.pink.shade400, Colors.pink.shade600],
                  ),
                ),
                child: Icon(
                  _matched == _allPairs.length ? Icons.emoji_events : Icons.refresh,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const Text('Điểm', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
              const SizedBox(height: 8),
              Text(
                _matched == _allPairs.length ? 'Hoàn thành!' : 'Hết giờ!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _matched == _allPairs.length ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(label: 'Đã nối', value: '$_matched/${_allPairs.length}', color: Colors.green),
                  _ResultStat(label: 'Lần thử', value: '$_attempts', color: Colors.blue),
                  _ResultStat(label: 'Chính xác', value: '$accuracy%', color: accuracy >= 70 ? Colors.green : Colors.orange),
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
                          _score = 0;
                          _matched = 0;
                          _attempts = 0;
                          _timeLeft = 60;
                          _gameOver = false;
                          _matchedGerman.clear();
                          _matchedVietnamese.clear();
                          _selectedGermanIndex = null;
                          _selectedVietnameseIndex = null;
                          _setupGame();
                          _startTimer();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
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

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.icon, required this.value, required this.color});

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({
    required this.text,
    required this.isMatched,
    required this.isSelected,
    required this.isGerman,
    required this.onTap,
  });

  final String text;
  final bool isMatched;
  final bool isSelected;
  final bool isGerman;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;

    if (isMatched) {
      bgColor = Colors.green.shade100;
      borderColor = Colors.green;
    } else if (isSelected) {
      bgColor = isGerman ? Colors.blue.shade100 : Colors.red.shade100;
      borderColor = isGerman ? Colors.blue : Colors.red;
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey.shade300;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isMatched ? Colors.green.shade700 : AppColors.foreground,
            ),
            textAlign: TextAlign.center,
          ),
        ),
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
