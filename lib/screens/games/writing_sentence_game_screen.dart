import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/learn/learn_models.dart';
import '../../data/vocab/vocab_models.dart';
import '../../shared/widgets/game_completion_screen.dart';
import '../../view_models/games/word_writing_provider.dart';
import '../../view_models/learn/learn_provider.dart';
import '../../widgets/common/async_state_views.dart';

const _kMinWordsRequired = 1;
const _levels = ['A1', 'A2', 'B1', 'B2'];

/// Writing Sentence game — viết câu tiếng Đức có dùng 1 từ đã học. Nguồn từ
/// live: `GET /vocabulary/learned` (tái dùng [VocabularyRepository], giống
/// Word Sprint/Writing Word). Chấm qua `POST /ai/grade-sentence` (tái dùng
/// [LearnRepository.gradeSentence] — cùng endpoint Sentence Builder dùng),
/// KHÔNG sửa domain `learn` (chỉ import read-only).
class WritingSentenceGameScreen extends ConsumerStatefulWidget {
  const WritingSentenceGameScreen({super.key});

  @override
  ConsumerState<WritingSentenceGameScreen> createState() =>
      _WritingSentenceGameScreenState();
}

class _WritingSentenceGameScreenState
    extends ConsumerState<WritingSentenceGameScreen> {
  static const _totalSeconds = 180;

  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = _totalSeconds;
  bool _gameOver = false;
  bool _started = false;
  int _currentIndex = 0;
  String _userInput = '';
  bool _showResult = false;
  bool _grading = false;
  bool _gradeFailed = false;
  GradeSentenceResult? _feedback;
  String _level = 'A1';
  Timer? _timer;

  List<VocabWord> _words = const [];

  void _startGame(List<VocabWord> words) {
    if (_started) return;
    _started = true;
    _words = List.of(words)..shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  Future<void> _checkAnswer() async {
    if (_grading || _showResult) return;
    final sentence = _userInput.trim();
    if (sentence.length < 3) return;
    final word = _words[_currentIndex % _words.length];
    setState(() {
      _grading = true;
      _gradeFailed = false;
    });
    try {
      final result = await ref.read(learnRepositoryProvider).gradeSentence(
            promptWord: word.word,
            promptMeaning: word.translation,
            userSentence: sentence,
            userLevel: _level,
            targetBlocks: const [],
          );
      if (!mounted) return;
      setState(() {
        _total++;
        _feedback = result;
        _showResult = true;
        _grading = false;
        if (result.isCorrect) {
          _correct++;
          _score += result.score;
        }
      });
      _scheduleNext();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _grading = false;
        _gradeFailed = true;
      });
    }
  }

  void _scheduleNext() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted || _gameOver) return;
      setState(() {
        _currentIndex++;
        _userInput = '';
        _showResult = false;
        _feedback = null;
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);
  }

  void _restart() {
    setState(() {
      _score = 0;
      _correct = 0;
      _total = 0;
      _timeLeft = _totalSeconds;
      _gameOver = false;
      _currentIndex = 0;
      _userInput = '';
      _showResult = false;
      _gradeFailed = false;
      _feedback = null;
    });
    _words.shuffle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return GameCompletionScreen(
        score: _score,
        total: _total > 0 ? _total * 100 : 1,
        title: 'Hoàn thành!',
        subtitle: 'Đúng $_correct/$_total câu',
        onPlayAgain: _restart,
        onGoHome: () => context.pop(),
      );
    }

    final wordsAsync = ref.watch(writingWordWordsProvider);
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Viết câu'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _timeLeft <= 60 ? Colors.red : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${_timeLeft}s',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: wordsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            onRetry: () => ref.invalidate(writingWordWordsProvider),
          ),
          data: (words) {
            if (words.length < _kMinWordsRequired) {
              return const ErrorView(
                message:
                    'Cần học ít nhất 1 từ vựng trước khi chơi. Hãy đánh dấu '
                    'thêm từ đã học ở phần Từ vựng.',
              );
            }
            _startGame(words);
            return _buildGame();
          },
        ),
      ),
    );
  }

  Widget _buildGame() {
    final word = _words[_currentIndex % _words.length];
    final feedback = _feedback;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex % _words.length + 1) / _words.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.indigo),
                  const SizedBox(width: 4),
                  Text('$_score',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              _LevelSelector(
                level: _level,
                onChanged: _showResult
                    ? null
                    : (v) => setState(() => _level = v),
              ),
            ],
          ),
        ),
        const Spacer(),
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
              const Icon(Icons.edit_note, size: 40, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(
                'Viết câu tiếng Đức có dùng từ:',
                style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 8),
              Text(
                '${word.word} (${word.translation})',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            key: ValueKey(_currentIndex),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Viết câu tiếng Đức...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: _showResult ? Colors.grey.shade100 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.indigo.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.indigo.shade200),
              ),
            ),
            enabled: !_showResult && !_grading,
            onChanged: (value) => _userInput = value,
            onSubmitted: (_) => _checkAnswer(),
          ),
        ),
        if (_grading) ...[
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 10),
              Text('Đang chấm...'),
            ],
          ),
        ],
        if (_gradeFailed) ...[
          const SizedBox(height: 16),
          const Text(
            'Không thể chấm bài. Vui lòng thử lại.',
            style: TextStyle(color: Colors.red),
          ),
        ],
        if (feedback != null) ...[
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: feedback.isCorrect
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Điểm: ${feedback.score}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: feedback.isCorrect ? Colors.green : Colors.orange,
                  ),
                ),
                if (feedback.summaryVi.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    feedback.summaryVi,
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (feedback.correctedSentence.isNotEmpty &&
                    !feedback.isCorrect) ...[
                  const SizedBox(height: 8),
                  Text(
                    '"${feedback.correctedSentence}"',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: _showResult
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: _userInput.trim().length >= 3 && !_grading
                      ? _checkAnswer
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kiểm tra', style: TextStyle(fontSize: 18)),
                ),
        ),
      ],
    );
  }
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({required this.level, required this.onChanged});

  final String level;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: level,
      underline: const SizedBox.shrink(),
      items: _levels
          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
          .toList(),
      onChanged: onChanged == null
          ? null
          : (v) {
              if (v != null) onChanged!(v);
            },
    );
  }
}
