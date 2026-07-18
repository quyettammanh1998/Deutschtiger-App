import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Conversation Practice game - Hội thoại đời thường.
class ConversationGameScreen extends StatefulWidget {
  const ConversationGameScreen({super.key});

  @override
  State<ConversationGameScreen> createState() => _ConversationGameScreenState();
}

class _ConversationGameScreenState extends State<ConversationGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  bool _gameOver = false;
  int _currentIndex = 0;
  String? _selectedAnswer;

  // Mock conversation scenarios
  final _scenarios = [
    {
      'situation': 'Im Restaurant',
      'context': 'Bạn đang ở nhà hàng và muốn gọi món',
      'question': 'Bạn nên nói gì?',
      'options': [
        'Ich möchte bestellen, bitte.',
        'Die Rechnung, bitte.',
        'Wo ist die Toilette?',
        'Auf Wiedersehen!',
      ],
      'correct': 0,
      'meaning': 'Tôi muốn gọi món ạ.',
    },
    {
      'situation': 'Auf der Straße',
      'context': 'Bạn hỏi đường đến nhà ga',
      'question': 'Bạn nên hỏi như thế nào?',
      'options': [
        'Entschuldigung, wo ist der Bahnhof?',
        'Wie viel Uhr ist es?',
        'Wie heißen Sie?',
        'Was kostet das?',
      ],
      'correct': 0,
      'meaning': 'Xin lỗi, nhà ga ở đâu ạ?',
    },
    {
      'situation': 'Im Geschäft',
      'context': 'Bạn muốn hỏi giá của một món đồ',
      'question': 'Bạn nên nói gì?',
      'options': [
        'Was kostet das?',
        'Ich möchte das kaufen.',
        'Haben Sie das in einer anderen Größe?',
        'Die Umkleidekabine, bitte.',
      ],
      'correct': 0,
      'meaning': 'Cái này bao nhiêu tiền?',
    },
    {
      'situation': 'Im Hotel',
      'context': 'Bạn muốn đặt phòng',
      'question': 'Bạn nên nói gì?',
      'options': [
        'Ich möchte ein Zimmer reservieren.',
        'Ich habe schon gebucht.',
        'Die Schlüsselkarte, bitte.',
        'Wann ist Check-out?',
      ],
      'correct': 0,
      'meaning': 'Tôi muốn đặt phòng.',
    },
    {
      'situation': 'Im Café',
      'context': 'Bạn muốn gọi một ly cà phê',
      'question': 'Bạn nên nói gì?',
      'options': [
        'Ich hätte gerne einen Kaffee.',
        'Ich möchte bezahlen.',
        'Die Speisekarte, bitte.',
        'Wo ist die Toilette?',
      ],
      'correct': 0,
      'meaning': 'Tôi muốn gọi một ly cà phê.',
    },
    {
      'situation': 'Am Bahnhof',
      'context': 'Bạn muốn mua vé tàu',
      'question': 'Bạn nên nói gì?',
      'options': [
        'Eine Fahrkarte nach Berlin, bitte.',
        'Wann fährt der Zug?',
        'Ist das der richtige Bahnsteig?',
        'Ich möchte stornieren.',
      ],
      'correct': 0,
      'meaning': 'Một vé đến Berlin ạ.',
    },
    {
      'situation': 'Beim Arzt',
      'context': 'Bạn đau đầu và muốn nói với bác sĩ',
      'question': 'Bạn nên nói gì?',
      'options': [
        'Ich habe Kopfschmerzen.',
        'Ich fühle mich gut.',
        'Ich brauche eine Überweisung.',
        'Ich möchte einen Termin.',
      ],
      'correct': 0,
      'meaning': 'Tôi bị đau đầu.',
    },
    {
      'situation': 'Am Flughafen',
      'context': 'Bạn muốn làm thủ tục check-in',
      'question': 'Bạn nên nói gì?',
      'options': [
        'Ich möchte einchecken.',
        'Ich möchte auschecken.',
        'Wo ist mein Gepäck?',
        'Ich habe meinen Flug verpasst.',
      ],
      'correct': 0,
      'meaning': 'Tôi muốn làm thủ tục check-in.',
    },
  ];

  final _situationColors = {
    'Im Restaurant': Colors.orange,
    'Auf der Straße': Colors.blue,
    'Im Geschäft': Colors.purple,
    'Im Hotel': Colors.teal,
    'Im Café': Colors.brown,
    'Am Bahnhof': Colors.green,
    'Beim Arzt': Colors.red,
    'Am Flughafen': Colors.indigo,
  };

  @override
  void initState() {
    super.initState();
    _scenarios.shuffle();
  }

  void _selectAnswer(int index) {
    if (_selectedAnswer != null) return;

    final scenario = _scenarios[_currentIndex];
    final correct = index == (scenario['correct'] as int);

    setState(() {
      _selectedAnswer = (scenario['options'] as List)[index] as String;
      _total++;

      if (correct) {
        _correct++;
        _score += 25;
      }
    });

    Timer(const Duration(seconds: 2), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < _scenarios.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedAnswer = null;
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
    final background = context.tokens.background;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('Hội thoại'),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.x),
          onPressed: () => context.pop(),
        ),
      ),
      body: _gameOver ? _buildResults(context) : _buildGame(context),
    );
  }

  Widget _buildGame(BuildContext context) {
    final scenario = _scenarios[_currentIndex];
    final situationColor =
        _situationColors[scenario['situation']] ?? Colors.pink;

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _scenarios.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
        ),

        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.pink.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(PhosphorIcons.star, color: Colors.pink),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${_currentIndex + 1}/${_scenarios.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        // Scenario card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: situationColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: situationColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  PhosphorIcons.mapPin,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenario['situation'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: situationColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      scenario['context'] as String,
                      style: TextStyle(
                        color: context.tokens.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Question
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            scenario['question'] as String,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.tokens.foreground,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        // Options
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: (scenario['options'] as List).length,
            itemBuilder: (context, index) {
              final option = (scenario['options'] as List)[index] as String;
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = index == scenario['correct'] as int;

              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade300;

              if (_selectedAnswer != null) {
                if (isCorrectAnswer) {
                  bgColor = Colors.green.shade50;
                  borderColor = Colors.green;
                } else if (isSelected) {
                  bgColor = Colors.red.shade50;
                  borderColor = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectAnswer(index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: borderColor.withValues(alpha: 0.2),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: borderColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_selectedAnswer != null && isCorrectAnswer)
                          const Icon(PhosphorIcons.checkCircle, color: Colors.green),
                        if (_selectedAnswer == option && !isCorrectAnswer)
                          const Icon(PhosphorIcons.xCircle, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Correct answer feedback
        if (_selectedAnswer != null)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(PhosphorIcons.checkCircle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    scenario['meaning'] as String,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
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
                color: Colors.pink.shade100,
              ),
              child: const Icon(PhosphorIcons.chatCircle, size: 40, color: Colors.pink),
            ),
            const SizedBox(height: 16),
            Text(
              '$_score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
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
                        _score = 0;
                        _correct = 0;
                        _total = 0;
                        _gameOver = false;
                        _currentIndex = 0;
                        _selectedAnswer = null;
                        _scenarios.shuffle();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
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
            color: context.tokens.mutedForeground,
          ),
        ),
      ],
    );
  }
}
