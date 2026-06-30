import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/speaking/speaking_models.dart';
import 'package:deutschtiger/repositories/speaking/speaking_repository.dart';
import 'package:deutschtiger/widgets/speaking/pronunciation_practice_widget.dart';

class UmlauteTrainerPage extends ConsumerStatefulWidget {
  const UmlauteTrainerPage({super.key});

  @override
  ConsumerState<UmlauteTrainerPage> createState() => _UmlauteTrainerPageState();
}

class _UmlauteTrainerPageState extends ConsumerState<UmlauteTrainerPage> {
  int _currentExerciseIndex = 0;
  double _totalScore = 0;
  int _attempts = 0;
  List<TrainerExercise> _exercises = [];
  bool _showMinimalPair = false;
  String? _selectedAnswer;
  bool _showResult = false;

  final List<MinimalPair> _minimalPairs = [
    MinimalPair(word1: 'Bäder', word2: 'Bader', meaning: 'baths vs. baker'),
    MinimalPair(word1: 'schön', word2: 'schen', meaning: 'beautiful vs. (invented)'),
    MinimalPair(word1: 'grün', word2: 'gran', meaning: 'green vs. (invented)'),
    MinimalPair(word1: 'Männer', word2: 'anner', meaning: 'men vs. (invented)'),
    MinimalPair(word1: 'Köln', word2: 'Kaln', meaning: 'Cologne vs. (invented)'),
  ];
  int _currentPairIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final repo = SpeakingRepository();
    final trainers = await repo.getPronunciationTrainers();
    final umlautTrainer = trainers.firstWhere(
      (t) => t.type == 'umlaut',
      orElse: () => trainers.first,
    );
    if (mounted) {
      setState(() => _exercises = umlautTrainer.exercises);
    }
  }

  void _onRecordingComplete(double score) {
    setState(() {
      _totalScore += score;
      _attempts++;
    });
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() => _currentExerciseIndex++);
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() => _currentExerciseIndex--);
    }
  }

  void _checkMinimalPairAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });
  }

  void _nextMinimalPair() {
    if (_currentPairIndex < _minimalPairs.length - 1) {
      setState(() {
        _currentPairIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Umlaut Trainer'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.foreground,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Practice'),
              Tab(text: 'Minimal Pairs'),
            ],
            indicatorColor: Colors.purple,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            _buildPracticeTab(),
            _buildMinimalPairTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeTab() {
    if (_exercises.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final exercise = _exercises[_currentExerciseIndex];
    final avgScore = _attempts > 0 ? _totalScore / _attempts : 0.0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.purple.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise ${_currentExerciseIndex + 1}/${_exercises.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (_attempts > 0)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${(avgScore * 100).round()}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: PronunciationPracticeWidget(
              word: exercise.word,
              phonetic: exercise.phonetic,
              translation: exercise.translation,
              onRecordingComplete: _onRecordingComplete,
            ),
          ),
        ),
        _buildNavigationControls(),
      ],
    );
  }

  Widget _buildMinimalPairTab() {
    final pair = _minimalPairs[_currentPairIndex];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.purple.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pair ${_currentPairIndex + 1}/${_minimalPairs.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Listen and identify',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Which word contains the umlaut?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pair.meaning,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMinimalPairButton(
                              pair.word1,
                              _containsUmlaut(pair.word1),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMinimalPairButton(
                              pair.word2,
                              _containsUmlaut(pair.word2),
                            ),
                          ),
                        ],
                      ),
                      if (_showResult) ...[
                        const SizedBox(height: 24),
                        _buildResultMessage(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showResult)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _nextMinimalPair,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentPairIndex < _minimalPairs.length - 1
                    ? 'Next Pair'
                    : 'Complete',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMinimalPairButton(String word, bool hasUmlaut) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = AppColors.foreground;

    if (_showResult) {
      if (_selectedAnswer == word) {
        backgroundColor = hasUmlaut ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
        borderColor = hasUmlaut ? Colors.green : Colors.red;
        textColor = hasUmlaut ? Colors.green : Colors.red;
      } else if (hasUmlaut) {
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
      }
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _showResult ? null : () => _checkMinimalPairAnswer(word),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Column(
            children: [
              Text(
                word,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (_showResult && hasUmlaut)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.check_circle, color: Colors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultMessage() {
    final isCorrect = _containsUmlaut(_selectedAnswer ?? '');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Correct! This word contains the umlaut.'
                  : 'Incorrect. Look for the ä, ö, or ü in the other word.',
              style: TextStyle(
                color: isCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _containsUmlaut(String word) {
    return word.contains('ä') || word.contains('ö') || word.contains('ü');
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: _currentExerciseIndex > 0 ? _previousExercise : null,
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.purple,
            ),
            Expanded(
              child: Text(
                '${_currentExerciseIndex + 1} / ${_exercises.length}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: _currentExerciseIndex < _exercises.length - 1
                  ? _nextExercise
                  : null,
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class MinimalPair {
  final String word1;
  final String word2;
  final String meaning;

  const MinimalPair({
    required this.word1,
    required this.word2,
    required this.meaning,
  });
}
