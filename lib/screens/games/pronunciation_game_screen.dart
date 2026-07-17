import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';

/// Pronunciation Practice game - Luyện phát âm.
class PronunciationGameScreen extends StatefulWidget {
  const PronunciationGameScreen({super.key});

  @override
  State<PronunciationGameScreen> createState() => _PronunciationGameScreenState();
}

class _PronunciationGameScreenState extends State<PronunciationGameScreen>
    with SingleTickerProviderStateMixin {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  bool _gameOver = false;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  // Mock pronunciation challenges
  final _challenges = [
    {
      'word': 'Übung',
      'type': 'Umlaut',
      'phonetic': '/ˈyːbʊŋ/',
      'description': 'Ü như "oo" môi tròn',
      'audio': null,
    },
    {
      'word': 'Österreich',
      'type': 'Umlaut',
      'phonetic': '/ˈøːstɐaɪ̯ç/',
      'description': 'Ö giữa O và E',
      'audio': null,
    },
    {
      'word': 'Auge',
      'type': 'Diphthong',
      'phonetic': '/ˈʔaʊ̯ɡə/',
      'description': 'Au đọc như "ao"',
      'audio': null,
    },
    {
      'word': 'Ei',
      'type': 'Diphthong',
      'phonetic': '/ʔaɪ̯/',
      'description': 'Ei đọc như "ai"',
      'audio': null,
    },
    {
      'word': 'Ich',
      'type': 'Ich-Laut',
      'phonetic': '/ɪç/',
      'description': 'ch sau i, ü, e mềm',
      'audio': null,
    },
    {
      'word': 'Bach',
      'type': 'Ach-Laut',
      'phonetic': '/bax/',
      'description': 'ch sau a, o, u mạnh',
      'audio': null,
    },
    {
      'word': 'Sprechen',
      'type': 'R-Sound',
      'phonetic': '/ˈʃpʁɛçn̩/',
      'description': 'r mạnh ở cuối',
      'audio': null,
    },
    {
      'word': 'das Mädchen',
      'type': 'Ä',
      'phonetic': '/ˈmɛːtçən/',
      'description': 'Ä đọc như "e"',
      'audio': null,
    },
  ];

  final _typeColors = {
    'Umlaut': Colors.purple,
    'Diphthong': Colors.blue,
    'Ich-Laut': Colors.green,
    'Ach-Laut': Colors.orange,
    'R-Sound': Colors.red,
    'Ä': Colors.pink,
  };

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 4).animate(_waveController);
    _challenges.shuffle();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _playAudio() {
    setState(() => _isPlaying = true);
    _waveController.repeat();

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isPlaying = false);
        _waveController.stop();
        _waveController.reset();
      }
    });
  }

  void _markCorrect() {
    setState(() {
      _total++;
      _correct++;
      _score += 15;
    });
    _nextChallenge();
  }

  void _markWrong() {
    setState(() {
      _total++;
    });
    _nextChallenge();
  }

  void _nextChallenge() {
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        if (_currentIndex < _challenges.length - 1) {
          setState(() => _currentIndex++);
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
  Widget build(BuildContext context) {
    final background = context.tokens.background;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('Luyện phát âm'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _gameOver ? _buildResults(context) : _buildGame(context),
    );
  }

  Widget _buildGame(BuildContext context) {
    final challenge = _challenges[_currentIndex];
    final typeColor = _typeColors[challenge['type']] ?? Colors.deepPurple;

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _challenges.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),

        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.deepPurple.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.deepPurple),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                '${_currentIndex + 1}/${_challenges.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Challenge card
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
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  challenge['type'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Word
              Text(
                challenge['word'] as String,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),

              // Phonetic
              Text(
                challenge['phonetic'] as String,
                style: TextStyle(
                  fontSize: 16,
                  color: context.tokens.mutedForeground,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: typeColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        challenge['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: typeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Play button with wave animation
        GestureDetector(
          onTap: _playAudio,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.withValues(alpha: 0.1),
              border: Border.all(color: Colors.deepPurple, width: 3),
            ),
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wave rings
                    for (int i = 0; i < _waveAnimation.value.floor(); i++)
                      Container(
                        width: 80 - (i * 20),
                        height: 80 - (i * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.deepPurple.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                      ),
                    // Icon
                    Icon(
                      _isPlaying ? Icons.volume_up : Icons.play_arrow,
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),
        Text(
          _isPlaying ? 'Đang phát...' : 'Nhấn để nghe',
          style: TextStyle(
            color: _isPlaying
                ? Colors.deepPurple
                : context.tokens.mutedForeground,
          ),
        ),

        const Spacer(),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _markWrong,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close),
                      SizedBox(width: 8),
                      Text('Chưa đúng'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _markCorrect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 8),
                      Text('Đúng rồi'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
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
                color: Colors.deepPurple.shade100,
              ),
              child: const Icon(Icons.record_voice_over, size: 40, color: Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            Text(
              'Điểm',
              style: TextStyle(
                fontSize: 16,
                color: context.tokens.mutedForeground,
              ),
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
                        _challenges.shuffle();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
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
        Text(
          label,
          style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground),
        ),
      ],
    );
  }
}
