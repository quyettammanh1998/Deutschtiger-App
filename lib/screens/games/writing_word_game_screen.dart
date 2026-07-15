import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/vocab/vocab_models.dart';
import '../../shared/widgets/game_completion_screen.dart';
import '../../view_models/games/word_writing_provider.dart';
import '../../widgets/common/async_state_views.dart';

const _kMinWordsRequired = 1;

/// Writing Word game — viết từ tiếng Đức từ nghĩa. Nguồn từ live:
/// `GET /vocabulary/learned` (tái dùng [VocabularyRepository], giống Word
/// Sprint). Chấm bằng AI qua `POST /ai/grade-word-writing` (tái dùng, đã
/// live cho thẻ viết từ ở bài học từ vựng) thay vì so khớp chuỗi cứng —
/// chấp nhận chính tả gần đúng/umlaut theo AI.
class WritingWordGameScreen extends ConsumerStatefulWidget {
  const WritingWordGameScreen({super.key});

  @override
  ConsumerState<WritingWordGameScreen> createState() =>
      _WritingWordGameScreenState();
}

class _WritingWordGameScreenState
    extends ConsumerState<WritingWordGameScreen> {
  static const _totalSeconds = 120;

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
  bool? _isCorrect;
  String? _suggestion;
  String? _hint;
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
    final word = _words[_currentIndex % _words.length];
    setState(() {
      _grading = true;
      _gradeFailed = false;
    });
    try {
      final result = await ref.read(wordWritingRepositoryProvider).gradeWord(
            userInput: _userInput,
            targetWord: word.word,
            targetVi: word.translation,
            level: word.cefrLevel.isNotEmpty ? word.cefrLevel : 'A1',
          );
      if (!mounted) return;
      setState(() {
        _total++;
        _isCorrect = result.correct;
        _hint = result.hint;
        _suggestion = result.suggestion;
        _showResult = true;
        _grading = false;
        if (result.correct) {
          _correct++;
          _score += 20;
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
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted || _gameOver) return;
      setState(() {
        _currentIndex++;
        _userInput = '';
        _showResult = false;
        _isCorrect = null;
        _hint = null;
        _suggestion = null;
      });
    });
  }

  void _skipWord() {
    setState(() {
      _total++;
      _userInput = '';
      _showResult = false;
      _currentIndex++;
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
      _isCorrect = null;
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
        total: _total > 0 ? _total * 20 : 1,
        title: 'Hoàn thành!',
        subtitle: 'Đúng $_correct/$_total từ',
        onPlayAgain: _restart,
        onGoHome: () => context.pop(),
      );
    }

    final wordsAsync = ref.watch(writingWordWordsProvider);
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Viết từ'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _timeLeft <= 30 ? Colors.red : Colors.grey.shade200,
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

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex % _words.length + 1) / _words.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text('Đúng $_correct/$_total', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const Spacer(),
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
              const Icon(Icons.translate, size: 40, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                word.translation,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Viết từ tiếng Đức:',
                style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            key: ValueKey(_currentIndex),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
            decoration: InputDecoration(
              hintText: 'Gõ từ tiếng Đức...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 18),
              filled: true,
              fillColor: _showResult
                  ? ((_isCorrect ?? false) ? Colors.green.shade50 : Colors.red.shade50)
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _showResult
                      ? ((_isCorrect ?? false) ? Colors.green : Colors.red)
                      : Colors.green.shade200,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _showResult
                      ? ((_isCorrect ?? false) ? Colors.green : Colors.red)
                      : Colors.green.shade200,
                  width: 2,
                ),
              ),
              suffixIcon: _showResult
                  ? Icon(
                      (_isCorrect ?? false) ? Icons.check_circle : Icons.cancel,
                      color: (_isCorrect ?? false) ? Colors.green : Colors.red,
                    )
                  : null,
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
        if (_showResult) ...[
          const SizedBox(height: 16),
          Text(
            (_isCorrect ?? false) ? 'Đúng rồi!' : 'Đáp án: $_suggestion',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: (_isCorrect ?? false) ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          if ((_hint ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _hint!,
                style: TextStyle(fontSize: 13, color: AppColors.mutedForeground),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _showResult
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _grading ? null : _skipWord,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Bỏ qua'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _userInput.isNotEmpty && !_grading
                            ? _checkAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Kiểm tra'),
                      ),
                    ),
                  ],
                ),
        ),
        const Spacer(),
      ],
    );
  }
}
