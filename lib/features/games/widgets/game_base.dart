import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/games/game_models.dart';

/// Base class cho các game widgets.
class GameBase extends StatefulWidget {
  const GameBase({
    super.key,
    required this.gameType,
    required this.onComplete,
    required this.questions,
    this.timeLimit,
    this.showTimer = true,
  });

  final GameType gameType;
  final List<GameQuestion> questions;
  final void Function(GameResult) onComplete;
  final int? timeLimit;
  final bool showTimer;

  @override
  State<GameBase> createState() => _GameBaseState();
}

class _GameBaseState extends State<GameBase> {
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _streak = 0;
  int _maxCombo = 0;
  final List<String> _wrongIds = [];
  Timer? _timer;
  int _timeLeft = 0;
  bool _gameOver = false;
  DateTime? _startTime;
  String? _feedback;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _timeLeft = widget.timeLimit ?? 0;
    if (widget.timeLimit != null && widget.timeLimit! > 0) {
      _startTimer();
    }
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

  void _checkAnswer(int selectedIndex, int correctIndex, String itemId) {
    if (_gameOver) return;

    final isCorrect = selectedIndex == correctIndex;
    
    setState(() {
      _total++;
      _isCorrect = isCorrect;
      
      if (isCorrect) {
        _correct++;
        _streak++;
        if (_streak > _maxCombo) _maxCombo = _streak;
        _score += _calculateScore();
        _feedback = _getFeedback(isCorrect: true);
      } else {
        _streak = 0;
        _wrongIds.add(itemId);
        _feedback = _getFeedback(isCorrect: false);
      }
    });

    // Move to next after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < widget.questions.length - 1) {
          setState(() {
            _currentIndex++;
            _feedback = null;
            _isCorrect = null;
          });
        } else {
          _endGame();
        }
      }
    });
  }

  int _calculateScore() {
    // Base score + streak bonus
    final baseScore = 10;
    final streakBonus = _streak > 3 ? 5 : (_streak > 1 ? 2 : 0);
    return baseScore + streakBonus;
  }

  String _getFeedback({required bool isCorrect}) {
    if (isCorrect) {
      if (_streak >= 5) return '🔥 Tuyệt vời!';
      if (_streak >= 3) return '⭐ Tốt lắm!';
      return '✓ Đúng rồi!';
    } else {
      return '✗ Sai rồi!';
    }
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);
    
    final result = GameResult(
      type: widget.gameType,
      score: _score,
      correct: _correct,
      total: _total,
      xpEarned: _score ~/ 10,
      maxCombo: _maxCombo,
      timeSpent: DateTime.now().difference(_startTime!),
      wrongItemIds: _wrongIds,
      playedAt: DateTime.now(),
    );
    
    widget.onComplete(result);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return _buildResults();
    }
    
    return Column(
      children: [
        // Header với timer
        if (widget.showTimer)
          _buildHeader(),
        
        // Progress
        _buildProgress(),
        
        // Question content - override in child
        Expanded(
          child: _buildQuestion(),
        ),
        
        // Feedback
        if (_feedback != null)
          _buildFeedback(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.tigerOrange.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.tigerOrange, size: 20),
              const SizedBox(width: 4),
              Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.tigerOrange,
                ),
              ),
            ],
          ),
          
          // Timer or question number
          if (widget.timeLimit != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _timeLeft <= 10 ? Colors.red : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: _timeLeft <= 10 ? Colors.white : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_timeLeft}s',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 10 ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              '${_currentIndex + 1}/${widget.questions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          
          // Streak
          Row(
            children: [
              if (_streak > 0) ...[
                const Text('🔥', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text(
                  'x$_streak',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final progress = widget.questions.isNotEmpty
        ? (_currentIndex + 1) / widget.questions.length
        : 0.0;
    
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey.shade200,
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tigerOrange),
    );
  }

  Widget _buildQuestion() {
    // Override in child class
    return const SizedBox.shrink();
  }

  Widget _buildFeedback() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect == true ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isCorrect == true ? Colors.green : Colors.red,
        ),
      ),
      child: Text(
        _feedback!,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _isCorrect == true ? Colors.green : Colors.red,
        ),
        textAlign: TextAlign.center,
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
            // Trophy icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accuracy >= 70 ? Colors.amber.shade100 : Colors.grey.shade200,
              ),
              child: Icon(
                accuracy >= 70 ? Icons.emoji_events : Icons.refresh,
                size: 40,
                color: accuracy >= 70 ? Colors.amber : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            
            // Score
            Text(
              '$_score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.tigerOrange,
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
            
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  label: 'Đúng',
                  value: '$_correct/$_total',
                  color: Colors.green,
                ),
                _StatItem(
                  label: 'Độ chính xác',
                  value: '$accuracy%',
                  color: accuracy >= 70 ? Colors.green : Colors.orange,
                ),
                _StatItem(
                  label: 'Combo max',
                  value: 'x$_maxCombo',
                  color: Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                      // Restart game
                      setState(() {
                        _currentIndex = 0;
                        _score = 0;
                        _correct = 0;
                        _total = 0;
                        _streak = 0;
                        _maxCombo = 0;
                        _wrongIds.clear();
                        _gameOver = false;
                        _startTime = DateTime.now();
                        _timeLeft = widget.timeLimit ?? 0;
                        if (widget.timeLimit != null) {
                          _timer?.cancel();
                          _startTimer();
                        }
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
  const _StatItem({
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
