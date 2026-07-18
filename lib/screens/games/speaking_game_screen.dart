import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../widgets/common/game_shell.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Speaking Practice game - Luyện nói với microphone.
///
/// NOTE (P7 web-mobile UI fidelity): web `speaking-practice-page.tsx`'s
/// `?daily=1` mission variant + avg-score completion screen (real AI
/// pronunciation grading) are NOT ported here — that grading pipeline is
/// MASTER P8 (voice/STT/Azure PA wiring), out of this phase's UI-only scope.
/// This screen stays behind the blanket `games` release flag (default off,
/// not in the live-data guard list) — only the GameShell chrome is adopted.
class SpeakingGameScreen extends StatefulWidget {
  const SpeakingGameScreen({super.key});

  @override
  State<SpeakingGameScreen> createState() => _SpeakingGameScreenState();
}

class _SpeakingGameScreenState extends State<SpeakingGameScreen>
    with SingleTickerProviderStateMixin {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  bool _gameOver = false;
  int _currentIndex = 0;
  bool _isRecording = false;
  bool _showResult = false;
  int _currentScore = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Mock sentences for speaking practice
  final _sentences = [
    {'german': 'Guten Morgen', 'vietnamese': 'Chào buổi sáng', 'phonetic': '/ˈɡuːtn̩ ˈmɔʁɡn̩/'},
    {'german': 'Wie geht es Ihnen?', 'vietnamese': 'Bạn khỏe không?', 'phonetic': '/viː ɡeːt ɛs ˈiːnən/'},
    {'german': 'Ich heiße Anna', 'vietnamese': 'Tôi tên là Anna', 'phonetic': '/ɪç ˈhaɪ̯sə ˈʔanːa/'},
    {'german': 'Danke schön', 'vietnamese': 'Cảm ơn nhiều', 'phonetic': '/ˈdaŋkə ʃøːn/'},
    {'german': 'Auf Wiedersehen', 'vietnamese': 'Tạm biệt', 'phonetic': '/ʔaʊ̯f ˈviːdɐˌzeːən/'},
    {'german': 'Entschuldigung', 'vietnamese': 'Xin lỗi', 'phonetic': '/ɛntˈʃʊldɪɡʊŋ/'},
    {'german': 'Ich verstehe nicht', 'vietnamese': 'Tôi không hiểu', 'phonetic': '/ɪç fɛɐˈʃteːə nɪçt/'},
    {'german': 'Sprechen Sie Deutsch?', 'vietnamese': 'Bạn nói tiếng Đức không?', 'phonetic': '/ˈʃpʁɛçn̩ ziː ˈdɔʏ̯tʃ/'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });

    // Simulate recording for 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _showResult = true;
      // Random score between 60-100 for demo
      _currentScore = 60 + (DateTime.now().millisecond % 41);
      _total++;
      
      if (_currentScore >= 70) {
        _correct++;
        _score += _currentScore;
      }
    });

    Timer(const Duration(seconds: 2), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < _sentences.length - 1) {
          setState(() {
            _currentIndex++;
            _showResult = false;
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
  Widget build(BuildContext context) {
    return GameShell(
      title: 'Luyện Nói',
      exitGuard: !_gameOver,
      scrollable: false,
      trailing: !_gameOver
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(PhosphorIcons.star, size: 16, color: Colors.pink),
                  const SizedBox(width: 4),
                  Text('$_score',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.pink)),
                ],
              ),
            )
          : null,
      child: _gameOver ? _buildResults(context) : _buildGame(context),
    );
  }

  Widget _buildGame(BuildContext context) {
    final sentence = _sentences[_currentIndex];

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _sentences.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
        ),

        const Spacer(),

        // Sentence card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(32),
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
              // Vietnamese meaning
              Text(
                sentence['vietnamese'] as String,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: context.tokens.foreground,
                ),
              ),
              const SizedBox(height: 24),

              // German text
              Text(
                sentence['german'] as String,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Phonetic
              Text(
                sentence['phonetic'] as String,
                style: TextStyle(
                  fontSize: 14,
                  color: context.tokens.mutedForeground,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Recording button
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isRecording ? _pulseAnimation.value : 1.0,
              child: GestureDetector(
                onTap: _isRecording ? null : _startRecording,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? Colors.red : Colors.pink,
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording ? Colors.red : Colors.pink).withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: _isRecording ? 10 : 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? PhosphorIcons.stop : PhosphorIcons.microphone,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Recording status
        Text(
          _isRecording ? 'Đang ghi âm...' : 'Nhấn để ghi âm',
          style: TextStyle(
            fontSize: 16,
            color: _isRecording ? Colors.red : context.tokens.mutedForeground,
            fontWeight: _isRecording ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        if (_showResult) ...[
          const SizedBox(height: 24),
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
                  _getScoreLabel(_currentScore),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _currentScore >= 70 ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Điểm: $_currentScore%',
                  style: TextStyle(
                    fontSize: 16,
                    color: _currentScore >= 70 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],

        const Spacer(),
      ],
    );
  }

  String _getScoreLabel(int score) {
    if (score >= 90) return '🌟 Xuất sắc!';
    if (score >= 80) return '✅ Rất tốt!';
    if (score >= 70) return '👍 Tốt lắm!';
    return '💪 Cần luyện thêm';
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
                color: Colors.pink.shade100,
              ),
              child: const Icon(PhosphorIcons.microphone, size: 40, color: Colors.pink),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.pink),
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
                        _showResult = false;
                        _isRecording = false;
                        _sentences.shuffle();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
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
