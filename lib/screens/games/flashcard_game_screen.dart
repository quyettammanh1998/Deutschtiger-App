import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Flashcard game - Lật thẻ học từ.
class FlashcardGameScreen extends StatefulWidget {
  const FlashcardGameScreen({super.key});

  @override
  State<FlashcardGameScreen> createState() => _FlashcardGameScreenState();
}

class _FlashcardGameScreenState extends State<FlashcardGameScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _correct = 0;
  int _total = 0;
  bool _isFlipped = false;
  bool _gameOver = false;
  Timer? _autoFlip;

  // Mock flashcards
  final _cards = [
    {'word': 'Haus', 'meaning': 'Nhà', 'gender': 'das'},
    {'word': 'Buch', 'meaning': 'Sách', 'gender': 'das'},
    {'word': 'Wasser', 'meaning': 'Nước', 'gender': 'das'},
    {'word': 'Frau', 'meaning': 'Phụ nữ', 'gender': 'die'},
    {'word': 'Mann', 'meaning': 'Đàn ông', 'gender': 'der'},
    {'word': 'Katze', 'meaning': 'Con mèo', 'gender': 'die'},
    {'word': 'Hund', 'meaning': 'Con chó', 'gender': 'der'},
    {'word': 'Auto', 'meaning': 'Ô tô', 'gender': 'das'},
    {'word': 'Schule', 'meaning': 'Trường học', 'gender': 'die'},
    {'word': 'Tisch', 'meaning': 'Cái bàn', 'gender': 'der'},
  ];

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _autoFlip?.cancel();
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) return;

    setState(() => _isFlipped = true);
    _flipController.forward();

    // Auto advance after 2 seconds
    _autoFlip = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _nextCard(isCorrect: true);
      }
    });
  }

  void _markCorrect() {
    _autoFlip?.cancel();
    _flipController.reset();
    _nextCard(isCorrect: true);
  }

  void _markWrong() {
    _autoFlip?.cancel();
    _flipController.reset();
    _nextCard(isCorrect: false);
  }

  void _nextCard({required bool isCorrect}) {
    if (_currentIndex >= _cards.length - 1) {
      setState(() => _gameOver = true);
      return;
    }

    setState(() {
      _currentIndex++;
      _isFlipped = false;
      _total++;
      if (isCorrect) _correct++;
    });
    _flipController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Flashcards'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.style, size: 16, color: Colors.purple),
                const SizedBox(width: 4),
                Text(
                  '${_currentIndex + 1}/${_cards.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
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
    final card = _cards[_currentIndex];

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _cards.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
        ),

        const SizedBox(height: 32),

        // Flashcard
        Expanded(
          child: GestureDetector(
            onTap: _flipCard,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * 3.14159;
                  final isFront = angle < 1.5708;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isFront ? Colors.white : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: isFront ? Colors.purple : Colors.purple.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isFront) ...[
                            // Front side
                            Text(
                              card['gender'] as String,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getGenderColor(card['gender'] as String),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              card['word'] as String,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Tap để lật',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ] else ...[
                            // Back side
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(3.14159),
                              child: Column(
                                children: [
                                  Text(
                                    card['word'] as String,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    card['meaning'] as String,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.foreground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_isFlipped) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _markWrong,
                        icon: const Icon(Icons.close),
                        label: const Text('Chưa nhớ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _markCorrect,
                        icon: const Icon(Icons.check),
                        label: const Text('Nhớ rồi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: _flipCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flip),
                      SizedBox(width: 8),
                      Text('Lật thẻ', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _getGenderColor(String gender) {
    switch (gender) {
      case 'der':
        return Colors.blue;
      case 'die':
        return Colors.pink;
      case 'das':
        return Colors.green;
      default:
        return Colors.grey;
    }
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
                color: Colors.purple.shade100,
              ),
              child: const Icon(Icons.style, size: 40, color: Colors.purple),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hoàn thành!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  label: 'Đã học',
                  value: '${_total}',
                  color: Colors.purple,
                ),
                _StatItem(
                  label: 'Nhớ được',
                  value: '$_correct',
                  color: Colors.green,
                ),
                _StatItem(
                  label: 'Độ chính xác',
                  value: '$accuracy%',
                  color: accuracy >= 70 ? Colors.green : Colors.orange,
                ),
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
                        _correct = 0;
                        _total = 0;
                        _isFlipped = false;
                        _gameOver = false;
                        _cards.shuffle();
                      });
                      _flipController.reset();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Học lại'),
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
          style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}
