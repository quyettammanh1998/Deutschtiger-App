import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/speaking/speaking_models.dart';
import 'package:deutschtiger/repositories/speaking/speaking_repository.dart';
import 'package:deutschtiger/widgets/speaking/pronunciation_practice_widget.dart';

class SpStTrainerPage extends ConsumerStatefulWidget {
  const SpStTrainerPage({super.key});

  @override
  ConsumerState<SpStTrainerPage> createState() => _SpStTrainerPageState();
}

class _SpStTrainerPageState extends ConsumerState<SpStTrainerPage> {
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
    final spStTrainer = trainers.firstWhere(
      (t) => t.type == 'sp-st',
      orElse: () => trainers.first,
    );
    if (mounted) {
      setState(() => _exercises = spStTrainer.exercises);
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
        title: const Text('Sp-St Trainer'),
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
      color: Colors.teal.withOpacity(0.1),
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
            Colors.teal.withOpacity(0.1),
            Colors.teal.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.school, color: Colors.teal, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'German Sp/St Rule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRuleCard(
            'sp → [ʃp]',
            'Before a vowel, sp sounds like "shp"',
            ['sprechen → [ˈʃpʁɛçən]', 'spielen → [ˈʃpiːlən]', 'Spaß → [ʃpaːs]'],
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildRuleCard(
            'st → [ʃt]',
            'Before a vowel, st sounds like "sht"',
            ['Straße → [ˈʃtʁaːsə]', 'Student → [ʃtuˈdɛnt]', 'stehen → [ˈʃteːən]'],
            Colors.orange,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'At the END of words: sp and st keep their normal sounds!',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(String title, String subtitle, List<String> examples, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: examples
                .map((e) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 11, color: Colors.grey[700], fontFamily: 'monospace'),
                      ),
                    ))
                .toList(),
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
              color: Colors.teal,
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
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
