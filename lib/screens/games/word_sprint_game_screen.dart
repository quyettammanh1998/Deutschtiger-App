import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../data/vocab/vocab_models.dart';
import '../../view_models/games/word_sprint_provider.dart';
import '../../widgets/common/async_state_views.dart';
import '../../widgets/common/game_shell.dart';
import 'widgets/sprint_widgets.dart';

/// Word Sprint (60s quiz) — nguồn từ vựng live: `GET /vocabulary/learned`
/// (tái dùng [VocabularyRepository], không còn dùng danh sách tĩnh cũ).
///
/// Cấu trúc:
///   - Header (close + title + timer)
///   - Progress + stat badges
///   - Word card + 2x2 answer grid
///   - End: `GameCompletionScreen` (score/accuracy + replay/home)
class WordSprintGameScreen extends ConsumerStatefulWidget {
  const WordSprintGameScreen({super.key});

  @override
  ConsumerState<WordSprintGameScreen> createState() =>
      _WordSprintGameScreenState();
}

/// Số từ tối thiểu cần có để tạo 1 câu hỏi (1 đáp án đúng + 3 nhiễu).
const _kMinWordsRequired = 4;

class _WordSprintGameScreenState extends ConsumerState<WordSprintGameScreen> {
  static const _roundSeconds = 60;
  static const _streakBonusThreshold = 3;
  static const _streakBonusScore = 5;

  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _streak = 0;
  int _maxCombo = 0;
  int _timeLeft = _roundSeconds;
  bool _gameOver = false;
  bool _started = false;
  int? _selectedIndex;
  Timer? _timer;

  List<VocabWord> _words = const [];
  final _random = Random();

  List<String> _currentOptions = const [];
  int _correctIndex = 0;

  void _startGame(List<VocabWord> words) {
    if (_started) return;
    _started = true;
    _words = List.of(words)..shuffle(_random);
    _generateOptions();
    _startTimer();
  }

  void _generateOptions() {
    final current = _words[_currentIndex % _words.length];
    final correct = current.translation;

    final wrongOptions = _words
        .where((w) => w.translation != correct)
        .toList()
      ..shuffle(_random);

    final options = [
      correct,
      wrongOptions[0].translation,
      wrongOptions[1].translation,
      wrongOptions[2].translation,
    ];
    options.shuffle(_random);
    _correctIndex = options.indexOf(correct);
    _currentOptions = options;
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

  void _selectAnswer(int index) {
    if (_selectedIndex != null || _gameOver) return;

    final isCorrect = index == _correctIndex;
    setState(() {
      _selectedIndex = index;
      _total++;
      if (isCorrect) {
        _correct++;
        _streak++;
        if (_streak > _maxCombo) _maxCombo = _streak;
        _score += 10 + (_streak > _streakBonusThreshold ? _streakBonusScore : 0);
      } else {
        _streak = 0;
      }
    });

    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
      });
      _generateOptions();
    });
  }

  void _endGame() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() => _gameOver = true);
    GameShell.showCompletion(
      context,
      score: _score,
      total: _roundSeconds,
      onPlayAgain: () {
        Navigator.of(context).pop();
        _restart();
      },
      onGoHome: () {
        Navigator.of(context).pop();
        context.pop();
      },
      completionTitle: 'Hoàn thành Word Sprint!',
      subtitle: 'Đúng $_correct/$_total câu · Combo max x$_maxCombo',
    );
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _correct = 0;
      _total = 0;
      _streak = 0;
      _maxCombo = 0;
      _selectedIndex = null;
      _gameOver = false;
      _timeLeft = _roundSeconds;
    });
    _words.shuffle(_random);
    _generateOptions();
    _startTimer();
  }

  /// "Đổi chủ đề" web action — reshuffles the current word pool without
  /// resetting score/timer (web `ShuffleToggleButton` on `word-sprint-page`).
  void _shuffleTopic() {
    setState(() {
      _words = List.of(_words)..shuffle(_random);
      _currentIndex = 0;
      _selectedIndex = null;
    });
    _generateOptions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordSprintWordsProvider);
    return GameShell(
      title: 'Word Sprint',
      scrollable: false,
      trailing: IconButton(
        tooltip: 'Đổi chủ đề',
        icon: const Icon(Icons.shuffle),
        onPressed: _started ? _shuffleTopic : null,
      ),
      child: wordsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(wordSprintWordsProvider),
        ),
        data: (words) {
          if (words.length < _kMinWordsRequired) {
            return const ErrorView(
              message:
                  'Cần học ít nhất 4 từ vựng trước khi chơi Word Sprint. '
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
    return Column(
      children: [
        SprintProgressBar(
          current: _currentIndex + 1,
          total: _words.length,
          color: DesignTokens.warning,
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        SprintStatRow(
          score: _score,
          correct: _correct,
          streak: _streak,
        ),
        const Spacer(),
        SprintWordCard(
          word: _words[_currentIndex % _words.length].word,
        ),
        const SizedBox(height: DesignTokens.spacingLg),
        Expanded(child: _buildAnswers()),
        const SizedBox(height: DesignTokens.spacingMd),
      ],
    );
  }

  Widget _buildAnswers() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: DesignTokens.spacingSm + 4,
          crossAxisSpacing: DesignTokens.spacingSm + 4,
          childAspectRatio: 2.5,
        ),
        itemCount: _currentOptions.length,
        itemBuilder: (context, index) {
          final state = _resolveState(index);
          return SprintAnswerTile(
            text: _currentOptions[index],
            state: state,
            onTap: () => _selectAnswer(index),
          );
        },
      ),
    );
  }

  SprintAnswerState _resolveState(int index) {
    if (_selectedIndex == null) return SprintAnswerState.idle;
    if (index == _correctIndex) return SprintAnswerState.correct;
    if (index == _selectedIndex) return SprintAnswerState.wrong;
    return SprintAnswerState.idle;
  }
}
