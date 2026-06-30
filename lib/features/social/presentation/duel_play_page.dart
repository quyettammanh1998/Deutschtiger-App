import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class DuelPlayPage extends StatefulWidget {
  final dynamic opponent;

  const DuelPlayPage({super.key, this.opponent});

  @override
  State<DuelPlayPage> createState() => _DuelPlayPageState();
}

class _DuelPlayPageState extends State<DuelPlayPage> with TickerProviderStateMixin {
  int _countdown = 3;
  int _currentQuestion = 0;
  int _playerScore = 0;
  int _opponentScore = 0;
  int _selectedAnswer = -1;
  bool _answered = false;
  bool _gameStarted = false;
  bool _gameEnded = false;
  Timer? _countdownTimer;
  Timer? _questionTimer;
  late AnimationController _pulseController;

  final List<_DuelQuestion> _questions = _generateQuestions();

  static List<_DuelQuestion> _generateQuestions() {
    final vocab = [
      {'german': 'Haus', 'english': 'House', 'options': ['House', 'Car', 'Tree', 'Book']},
      {'german': 'Buch', 'english': 'Book', 'options': ['Water', 'Book', 'Table', 'Chair']},
      {'german': 'Wasser', 'english': 'Water', 'options': ['Fire', 'Water', 'Earth', 'Air']},
      {'german': 'Apfel', 'english': 'Apple', 'options': ['Apple', 'Orange', 'Banana', 'Grape']},
      {'german': 'Katze', 'english': 'Cat', 'options': ['Dog', 'Cat', 'Bird', 'Fish']},
      {'german': 'Hund', 'english': 'Dog', 'options': ['Cat', 'Dog', 'Mouse', 'Rabbit']},
      {'german': 'Blume', 'english': 'Flower', 'options': ['Flower', 'Leaf', 'Root', 'Seed']},
      {'german': 'Sonne', 'english': 'Sun', 'options': ['Moon', 'Star', 'Sun', 'Cloud']},
      {'german': 'Mond', 'english': 'Moon', 'options': ['Sun', 'Moon', 'Planet', 'Comet']},
      {'german': 'Wasser', 'english': 'Water', 'options': ['Milk', 'Juice', 'Water', 'Soda']},
    ];

    return List.generate(
      10,
      (i) {
        final q = vocab[i % vocab.length];
        final correct = q['english'] as String;
        final options = q['options'] as List<String>;
        return _DuelQuestion(
          german: q['german'] as String,
          correctAnswer: correct,
          options: options..shuffle(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _questionTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        setState(() {
          _gameStarted = true;
          _currentQuestion = 0;
        });
        _simulateOpponent();
      }
    });
  }

  void _simulateOpponent() {
    final delay = 1500 + Random().nextInt(2000);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted && _gameStarted && !_gameEnded && _currentQuestion < _questions.length) {
        setState(() => _opponentScore++);
        _simulateOpponent();
      }
    });
  }

  void _selectAnswer(int index) {
    if (_answered || _gameEnded) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (_questions[_currentQuestion].options[index] == _questions[_currentQuestion].correctAnswer) {
        _playerScore++;
      }
    });

    _questionTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _selectedAnswer = -1;
          _answered = false;
        });
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    setState(() => _gameEnded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: _gameEnded
            ? _buildResultScreen()
            : _gameStarted
                ? _buildGameScreen()
                : _buildCountdownScreen(),
      ),
    );
  }

  Widget _buildCountdownScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Get Ready!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.tigerOrange,
            ),
          ),
          const SizedBox(height: 32),
          ScaleTransition(
            scale: _pulseController,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.tigerOrange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Your opponent: ${widget.opponent?.name ?? 'Unknown'}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    final question = _questions[_currentQuestion];
    return Column(
      children: [
        _buildScoreHeader(),
        _buildProgressBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  'Translate to English:',
                  style: TextStyle(fontSize: 16, color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    question.german,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tigerOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: List.generate(
                      question.options.length,
                      (i) => _buildOptionButton(question.options[i], i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.muted,
                  child: const Text('Y', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('You', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('$_playerScore', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.tigerOrange)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentQuestion + 1}/${_questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.opponent?.name ?? 'Opp', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('$_opponentScore', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.muted,
                  child: Text((widget.opponent?.name ?? 'O')[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_currentQuestion + 1) / _questions.length,
      backgroundColor: AppColors.border,
      valueColor: const AlwaysStoppedAnimation(AppColors.tigerOrange),
      minHeight: 4,
    );
  }

  Widget _buildOptionButton(String text, int index) {
    Color bgColor = Colors.white;
    Color textColor = AppColors.foreground;
    Color borderColor = AppColors.border;

    if (_answered) {
      if (text == _questions[_currentQuestion].correctAnswer) {
        bgColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        borderColor = AppColors.success;
      } else if (index == _selectedAnswer) {
        bgColor = AppColors.destructive.withValues(alpha: 0.1);
        textColor = AppColors.destructive;
        borderColor = AppColors.destructive;
      }
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _answered ? null : () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final won = _playerScore > _opponentScore;
    final draw = _playerScore == _opponentScore;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              won ? Icons.emoji_events : (draw ? Icons.handshake : Icons.sentiment_dissatisfied),
              size: 80,
              color: won ? Colors.amber : (draw ? AppColors.mutedForeground : AppColors.destructive),
            ),
            const SizedBox(height: 24),
            Text(
              draw ? "It's a Draw!" : (won ? 'You Won!' : 'You Lost'),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: won ? AppColors.success : (draw ? AppColors.mutedForeground : AppColors.destructive),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Final Score',
              style: TextStyle(fontSize: 16, color: AppColors.mutedForeground),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ScoreBox(label: 'You', score: _playerScore, isWinner: won),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'vs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mutedForeground),
                  ),
                ),
                _ScoreBox(label: widget.opponent?.name ?? 'Opp', score: _opponentScore, isWinner: !won && !draw),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    won ? '+50 XP' : '+25 XP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Back to Lobby'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      context.pushReplacement('/social/duel/lobby');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tigerOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Play Again'),
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

class _DuelQuestion {
  final String german;
  final String correctAnswer;
  final List<String> options;

  _DuelQuestion({required this.german, required this.correctAnswer, required this.options});
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int score;
  final bool isWinner;

  const _ScoreBox({required this.label, required this.score, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: AppColors.mutedForeground)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isWinner ? AppColors.success.withValues(alpha: 0.1) : AppColors.muted,
            borderRadius: BorderRadius.circular(12),
            border: isWinner ? Border.all(color: AppColors.success, width: 2) : null,
          ),
          child: Text(
            '$score',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isWinner ? AppColors.success : AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }
}
