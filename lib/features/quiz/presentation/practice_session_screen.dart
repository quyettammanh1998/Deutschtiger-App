import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/practice_models.dart';

/// Practice Session Screen - Cloze, Listening, Matching, Writing, Translation
class PracticeSessionScreen extends StatefulWidget {
  const PracticeSessionScreen({
    super.key,
    required this.type,
    this.topicId,
    this.level,
  });

  final PracticeType type;
  final String? topicId;
  final String? level;

  @override
  State<PracticeSessionScreen> createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends State<PracticeSessionScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int _totalCount = 0;
  bool _showAnswer = false;
  String _userAnswer = '';
  int _selectedOption = -1;
  Timer? _timer;
  int _timeSpent = 0;
  
  // Mock items - in real app, fetch from API
  late List<PracticeItem> _items;

  @override
  void initState() {
    super.initState();
    _items = _generateMockItems();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _timeSpent++);
    });
  }

  List<PracticeItem> _generateMockItems() {
    // Generate mock practice items based on type
    return List.generate(10, (i) => PracticeItem(
      id: 'item_$i',
      question: _getMockQuestion(i),
      answer: _getMockAnswer(i),
      options: _getMockOptions(i),
      hint: _getMockHint(i),
      explanation: _getMockExplanation(i),
    ));
  }

  String _getMockQuestion(int i) {
    switch (widget.type) {
      case PracticeType.cloze:
        return 'Das ___ ist auf dem Tisch.';
        case PracticeType.listening:
        return 'Hören Sie und wählen Sie die richtige Antwort.';
      case PracticeType.matching:
        return 'Ordnen Sie zu:';
      case PracticeType.writing:
        return 'Schreiben Sie einen Satz mit dem Wort "Haus".';
      case PracticeType.translation:
        return 'Übersetzen Sie ins Deutsche: "Tôi đi học"';
    }
  }

  String _getMockAnswer(int i) {
    switch (widget.type) {
      case PracticeType.cloze:
        return 'Buch';
      case PracticeType.listening:
        return 'Die Schule';
      case PracticeType.matching:
        return 'Haus';
      case PracticeType.writing:
        return 'Ich gehe zum Haus.';
      case PracticeType.translation:
        return 'Ich gehe zur Schule.';
    }
  }

  List<String>? _getMockOptions(int i) {
    if (widget.type == PracticeType.matching || widget.type == PracticeType.listening) {
      return ['Buch', 'Tisch', 'Stuhl', 'Haus'];
    }
    return null;
  }

  String _getMockHint(int i) {
    return 'Denken Sie an das Wort.';
  }

  String _getMockExplanation(int i) {
    return 'Explanation for this question...';
  }

  void _checkAnswer() {
    final currentItem = _items[_currentIndex];
    bool isCorrect = false;

    if (widget.type == PracticeType.writing || widget.type == PracticeType.translation) {
      isCorrect = _userAnswer.trim().toLowerCase() == 
          currentItem.answer.trim().toLowerCase();
    } else if (widget.type == PracticeType.matching || widget.type == PracticeType.listening) {
      isCorrect = _selectedOption == 0; // First option is correct
    }

    setState(() {
      _showAnswer = true;
      _totalCount++;
      if (isCorrect) _correctCount++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _userAnswer = '';
        _selectedOption = -1;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeResultScreen(
          correct: _correctCount,
          total: _totalCount,
          timeSpent: _timeSpent,
          type: widget.type,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _items[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _formatTime(_timeSpent),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _items.length,
          ),
          
          // Question count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Câu ${_currentIndex + 1}/${_items.length}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  'Đúng: $_correctCount',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
          
          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question
                  _buildQuestion(currentItem),
                  
                  const SizedBox(height: 24),
                  
                  // Answer input based on type
                  _buildAnswerInput(currentItem),
                  
                  if (_showAnswer) ...[
                    const SizedBox(height: 24),
                    _buildResultFeedback(currentItem),
                  ],
                ],
              ),
            ),
          ),
          
          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (widget.type) {
      case PracticeType.cloze:
        return '📝 Điền từ';
      case PracticeType.listening:
        return '🎧 Nghe hiểu';
      case PracticeType.matching:
        return '🔗 Nối từ';
      case PracticeType.writing:
        return '✍️ Viết câu';
      case PracticeType.translation:
        return '🔄 Dịch thuật';
    }
  }

  Widget _buildQuestion(PracticeItem item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          item.question,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAnswerInput(PracticeItem item) {
    switch (widget.type) {
      case PracticeType.cloze:
      case PracticeType.writing:
      case PracticeType.translation:
        return _buildTextInput(item);
      case PracticeType.matching:
      case PracticeType.listening:
        return _buildOptions(item);
    }
  }

  Widget _buildTextInput(PracticeItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) => _userAnswer = value,
          enabled: !_showAnswer,
          decoration: InputDecoration(
            hintText: widget.type == PracticeType.cloze 
                ? 'Nhập từ còn thiếu...'
                : 'Nhập câu trả lời...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
          style: const TextStyle(fontSize: 18),
        ),
        if (item.hint != null && !_showAnswer)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'Gợi ý: ${item.hint}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOptions(PracticeItem item) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(item.options?.length ?? 0, (index) {
        final option = item.options![index];
        final isSelected = _selectedOption == index;
        final isCorrect = index == 0;
        
        Color? bgColor;
        Color? borderColor;
        
        if (_showAnswer) {
          if (isCorrect) {
            bgColor = Colors.green.shade100;
            borderColor = Colors.green;
          } else if (isSelected && !isCorrect) {
            bgColor = Colors.red.shade100;
            borderColor = Colors.red;
          }
        } else if (isSelected) {
          bgColor = Colors.blue.shade100;
          borderColor = Colors.blue;
        }

        return InkWell(
          onTap: _showAnswer ? null : () => setState(() => _selectedOption = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor ?? Colors.grey.shade300),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue.shade700 : null,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResultFeedback(PracticeItem item) {
    final isCorrect = widget.type == PracticeType.writing || widget.type == PracticeType.translation
        ? _userAnswer.trim().toLowerCase() == item.answer.trim().toLowerCase()
        : _selectedOption == 0;

    return Card(
      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? 'Đúng!' : 'Sai!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 12),
              Text(
                'Đáp án đúng: ${item.answer}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
            if (item.explanation != null) ...[
              const SizedBox(height: 12),
              Text(
                'Giải thích: ${item.explanation}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!_showAnswer)
            Expanded(
              child: ElevatedButton(
                onPressed: (_userAnswer.isNotEmpty || _selectedOption >= 0) 
                    ? _checkAnswer 
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kiểm tra'),
              ),
            )
          else
            Expanded(
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentIndex < _items.length - 1 ? 'Tiếp theo →' : 'Xem kết quả',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Practice Result Screen
class PracticeResultScreen extends StatelessWidget {
  const PracticeResultScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.timeSpent,
    required this.type,
  });

  final int correct;
  final int total;
  final int timeSpent;
  final PracticeType type;

  @override
  Widget build(BuildContext context) {
    final accuracy = total > 0 ? (correct / total * 100).round() : 0;
    final minutes = timeSpent ~/ 60;
    final seconds = timeSpent % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score circle
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getScoreColor(accuracy).withValues(alpha: 0.1),
                  border: Border.all(
                    color: _getScoreColor(accuracy),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$accuracy%',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(accuracy),
                        ),
                      ),
                      Text(
                        '$correct/$total',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Stats
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _StatRow(
                        icon: Icons.timer,
                        label: 'Thời gian',
                        value: '${minutes}m ${seconds}s',
                      ),
                      const Divider(),
                      _StatRow(
                        icon: Icons.check,
                        label: 'Đúng',
                        value: '$correct',
                        valueColor: Colors.green,
                      ),
                      const Divider(),
                      _StatRow(
                        icon: Icons.close,
                        label: 'Sai',
                        value: '${total - correct}',
                        valueColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Tiếp tục học'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Về trang chủ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
