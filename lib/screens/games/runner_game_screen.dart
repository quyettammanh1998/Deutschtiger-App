import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/games/runner_personal_best.dart';
import '../../data/vocab/vocab_models.dart';
import '../../view_models/games/runner_game_provider.dart';
import '../../widgets/common/async_state_views.dart';
import '../../widgets/common/game_shell.dart';
import 'widgets/runner_answer_panel.dart';
import 'widgets/runner_results_view.dart';
import 'widgets/runner_sprite_stage.dart';

const _kMinWordsRequired = 4;

/// Deutsch Runner — platform-runner với quiz. Nguồn từ live:
/// `GET /vocabulary/learned` (tái dùng [VocabularyRepository], giống Word
/// Sprint). Web (`game-runner-page.tsx`/`use-runner-words.ts`) dùng
/// learning-items pool riêng với 4 kiểu câu hỏi không phụ thuộc giống đực/
/// cái/trung (de-to-vi, vi-to-de, listen-de, listen-vi) — quiz ở đây theo
/// cùng tinh thần "chọn nghĩa đúng" thay vì der/die/das (API vocab học
/// không trả gender). Cơ chế obstacle/lane giữ nguyên như animation gameplay
/// thuần tuý (không phải nội dung học, không cần nguồn dữ liệu).
///
/// P7b: adopts [GameShell] + real tiger-sprite/obstacle assets (P1) via
/// [RunnerSpriteStage], local personal-best record ([RunnerPersonalBest],
/// mirrors web's client-only `localStorage` record — no backend endpoint
/// exists for this), and [RunnerLeaderboardPanel] (reuses the existing live
/// weekly-XP leaderboard, not a new runner-only endpoint).
class RunnerGameScreen extends ConsumerStatefulWidget {
  const RunnerGameScreen({super.key});

  @override
  ConsumerState<RunnerGameScreen> createState() => _RunnerGameScreenState();
}

class _RunnerGameScreenState extends ConsumerState<RunnerGameScreen> {
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _lives = 3;
  int _timeLeft = 60;
  bool _gameOver = false;
  bool _started = false;
  Timer? _gameTimer;
  Timer? _obstacleTimer;

  int _runnerPosition = 1;
  int _obstacleLane = -1;
  bool _obstacleActive = false;
  bool _hit = false;
  int _obstacleSeed = 0;

  List<VocabWord> _words = const [];
  final _random = Random();
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  List<String> _currentOptions = const [];

  RunnerPersonalBest? _personalBest;
  bool _isNewRecord = false;

  @override
  void initState() {
    super.initState();
    loadRunnerPersonalBest().then((best) {
      if (mounted) setState(() => _personalBest = best);
    });
  }

  void _startGame(List<VocabWord> words) {
    if (_started) return;
    _started = true;
    _words = List.of(words)..shuffle(_random);
    _generateOptions();
    _startTimer();
    _startObstacles();
  }

  void _generateOptions() {
    final correct = _words[_currentQuestionIndex % _words.length].translation;
    final wrong = _words.where((w) => w.translation != correct).toList()
      ..shuffle(_random);
    final options = [correct, wrong[0].translation, wrong[1].translation]
      ..shuffle(_random);
    setState(() => _currentOptions = options);
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeLeft > 0 && !_gameOver) {
        setState(() => _timeLeft--);
      } else if (_timeLeft == 0) {
        _endGame();
      }
    });
  }

  void _startObstacles() {
    _obstacleTimer = Timer.periodic(const Duration(milliseconds: 2000), (_) {
      if (!_gameOver && _obstacleActive) {
        if (_runnerPosition == _obstacleLane) {
          _hitObstacle();
        }
        setState(() {
          _obstacleLane = -1;
          _obstacleActive = false;
          _hit = false;
        });
      } else if (!_gameOver) {
        setState(() {
          _obstacleLane = 1 + (DateTime.now().millisecond % 3);
          _obstacleActive = true;
          _obstacleSeed++;
        });
      }
    });
  }

  void _hitObstacle() {
    setState(() {
      _lives--;
      _hit = true;
      _score = (_score - 5).clamp(0, 9999);
    });
    if (_lives <= 0) _endGame();
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;
    final correct = _words[_currentQuestionIndex % _words.length].translation;
    final isCorrect = answer == correct;

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
      _total++;
      if (isCorrect) {
        _correct++;
        _score += 20;
      } else {
        _score = (_score - 5).clamp(0, 9999);
      }
    });

    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _gameOver) return;
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isCorrect = null;
      });
      _generateOptions();
    });
  }

  Future<void> _endGame() async {
    _gameTimer?.cancel();
    _obstacleTimer?.cancel();
    final isNew = await saveRunnerPersonalBestIfRecord(
      score: _score,
      correct: _correct,
      wrong: _total - _correct,
    );
    if (!mounted) return;
    setState(() {
      _gameOver = true;
      _isNewRecord = isNew;
    });
  }

  void _restart() {
    setState(() {
      _score = 0;
      _correct = 0;
      _total = 0;
      _lives = 3;
      _timeLeft = 60;
      _gameOver = false;
      _isNewRecord = false;
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _runnerPosition = 1;
      _obstacleLane = -1;
      _obstacleActive = false;
      _hit = false;
    });
    _words.shuffle(_random);
    _generateOptions();
    _startTimer();
    _startObstacles();
    loadRunnerPersonalBest().then((best) {
      if (mounted) setState(() => _personalBest = best);
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _obstacleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return GameShell(
        title: 'Deutsch Runner',
        exitGuard: false,
        child: _buildResults(),
      );
    }

    final wordsAsync = ref.watch(runnerGameWordsProvider);
    return GameShell(
      title: 'Deutsch Runner',
      exitGuard: _started,
      scrollable: false,
      child: wordsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(runnerGameWordsProvider),
        ),
        data: (words) {
          if (words.length < _kMinWordsRequired) {
            return const ErrorView(
              message:
                  'Cần học ít nhất 4 từ vựng trước khi chơi Deutsch Runner. '
                  'Hãy đánh dấu thêm từ đã học ở phần Từ vựng.',
            );
          }
          _startGame(words);
          return _buildGame();
        },
      ),
    );
  }

  Widget _buildGame() {
    final question = _words[_currentQuestionIndex % _words.length];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RunnerSpriteStage(
            runnerLane: _runnerPosition,
            obstacleLane: _obstacleLane,
            obstacleActive: _obstacleActive,
            obstacleSeed: _obstacleSeed,
            hit: _hit,
            lives: _lives,
            score: _score,
            timeLeft: _timeLeft,
            onLaneTap: (lane) => setState(() => _runnerPosition = lane),
          ),
          const SizedBox(height: 16),
          RunnerAnswerPanel(
            question: question,
            options: _currentOptions,
            selected: _selectedAnswer,
            isCorrect: _isCorrect,
            onSelect: _selectAnswer,
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return RunnerResultsView(
      score: _score,
      correct: _correct,
      total: _total,
      lives: _lives,
      isNewRecord: _isNewRecord,
      personalBest: _personalBest,
      onPlayAgain: _restart,
      onGoHome: () => context.pop(),
    );
  }
}
