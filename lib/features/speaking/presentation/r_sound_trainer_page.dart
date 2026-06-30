import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/speaking_models.dart';
import '../data/speaking_repository.dart';
import '../widgets/pronunciation_practice_widget.dart';

class RSoundTrainerPage extends ConsumerStatefulWidget {
  const RSoundTrainerPage({super.key});

  @override
  ConsumerState<RSoundTrainerPage> createState() => _RSoundTrainerPageState();
}

class _RSoundTrainerPageState extends ConsumerState<RSoundTrainerPage> {
  int _currentExerciseIndex = 0;
  double _totalScore = 0;
  int _attempts = 0;
  List<TrainerExercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final repo = SpeakingRepository();
    final trainers = await repo.getPronunciationTrainers();
    final rTrainer = trainers.firstWhere(
      (t) => t.type == 'r-sound',
      orElse: () => trainers.first,
    );
    if (mounted) {
      setState(() => _exercises = rTrainer.exercises);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('R-Sound Trainer'),
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
      color: Colors.blue.withOpacity(0.1),
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
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'German R Sound',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'The German "R" is a guttural/uvular sound produced in the back of the throat.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for pronunciation:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                SizedBox(height: 8),
                Text('• Make a gargling sound in the back of your throat', style: TextStyle(fontSize: 13)),
                Text('• The tongue does not touch the roof of your mouth', style: TextStyle(fontSize: 13)),
                Text('• Practice with words starting with "R"', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard() {
    final exercise = _exercises[_currentExerciseIndex];
    return PronunciationPracticeWidget(
      key: ValueKey(exercise.id),
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
              color: Colors.blue,
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
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
