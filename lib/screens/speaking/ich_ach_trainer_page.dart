import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/speaking_models.dart';
import '../data/speaking_repository.dart';
import '../widgets/pronunciation_practice_widget.dart';

class IchAchTrainerPage extends ConsumerStatefulWidget {
  const IchAchTrainerPage({super.key});

  @override
  ConsumerState<IchAchTrainerPage> createState() => _IchAchTrainerPageState();
}

class _IchAchTrainerPageState extends ConsumerState<IchAchTrainerPage> {
  int _currentExerciseIndex = 0;
  double _totalScore = 0;
  int _attempts = 0;
  List<TrainerExercise> _exercises = [];
  String? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final repo = SpeakingRepository();
    final trainers = await repo.getPronunciationTrainers();
    final ichAchTrainer = trainers.firstWhere(
      (t) => t.type == 'ich-ach',
      orElse: () => trainers.first,
    );
    if (mounted) {
      setState(() => _exercises = ichAchTrainer.exercises);
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
      setState(() {
        _currentExerciseIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _selectedAnswer = null;
        _showResult = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ich-Ach Trainer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.foreground,
      ),
      body: _exercises.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildProgressHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildExplanationCard(),
                        const SizedBox(height: 24),
                        _buildDistinctionQuiz(),
                        const SizedBox(height: 24),
                        _buildPracticeCard(),
                      ],
                    ),
                  ),
                ),
                _buildNavigationControls(),
              ],
            ),
    );
  }

  Widget _buildProgressHeader() {
    final avgScore = _attempts > 0 ? _totalScore / _attempts : 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.orange.withOpacity(0.1),
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
    );
  }

  Widget _buildExplanationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The "ich" vs "ach" Sound',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSoundBox(
                  'ich [ç]',
                  'Soft palate sound',
                  'mich, dich, sich, Licht',
                  Colors.pink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSoundBox(
                  'ach [x]',
                  'Throat sound',
                  'Buch, Dach, Nacht, noch',
                  Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Rule: After front vowels (e, i, ä, ö, ü, ei, eu) → ich-sound. After back vowels (a, o, u) → ach-sound.',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundBox(String title, String subtitle, String examples, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            examples,
            style: TextStyle(fontSize: 11, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildDistinctionQuiz() {
    final exercise = _exercises[_currentExerciseIndex];
    final isIch = _containsIchSound(exercise.word);
    final options = [
      ('ich-sound [ç]', isIch),
      ('ach-sound [x]', !isIch),
    ]..shuffle();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Quiz: Which sound?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: options.map((option) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildQuizOption(option.$1, option.$2),
                ),
              );
            }).toList(),
          ),
          if (_showResult) ...[
            const SizedBox(height: 12),
            _buildQuizResult(isIch),
          ],
        ],
      ),
    );
  }

  Widget _buildQuizOption(String label, bool isCorrect) {
    Color backgroundColor = Colors.grey[100]!;
    Color borderColor = Colors.grey[300]!;
    Color textColor = AppColors.foreground;

    if (_showResult) {
      if (_selectedAnswer == label) {
        backgroundColor = isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
        borderColor = isCorrect ? Colors.green : Colors.red;
        textColor = isCorrect ? Colors.green : Colors.red;
      } else if (isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
      }
    }

    return GestureDetector(
      onTap: _showResult ? null : () => _checkQuizAnswer(label, isCorrect),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _checkQuizAnswer(String answer, bool isCorrect) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });
  }

  Widget _buildQuizResult(bool isIch) {
    final isCorrect = (_selectedAnswer == 'ich-sound [ç]') == isIch;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Correct!'
                  : 'This word uses the ${isIch ? 'ich' : 'ach'}-sound.',
              style: TextStyle(
                color: isCorrect ? Colors.green : Colors.red,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _containsIchSound(String word) {
    final ichPatterns = ['ich', 'mich', 'dich', 'sich', 'lich', 'nicht', 'Licht', 'recht'];
    return ichPatterns.any((p) => word.toLowerCase().contains(p));
  }

  Widget _buildPracticeCard() {
    final exercise = _exercises[_currentExerciseIndex];
    return PronunciationPracticeWidget(
      key: ValueKey('prac-${exercise.id}'),
      word: exercise.word,
      phonetic: exercise.phonetic,
      translation: exercise.translation,
      onRecordingComplete: _onRecordingComplete,
    );
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
              color: Colors.orange,
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
              onPressed: _currentExerciseIndex < _exercises.length - 1 ? _nextExercise : null,
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
