import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/games/learning_item_models.dart';
import '../../view_models/games/learning_item_provider.dart';
import '../../widgets/common/app_pill.dart';
import '../../widgets/common/async_state_views.dart';
import '../../widgets/common/game_shell.dart';

// See `article_game_screen.dart` for why this is a fixed default rather
// than wired to `learningPreferencesProvider` (AutoDispose + bare `ref.read`
// race).
const _kDefaultLevel = 'A1';
const _minSentences = 3;
const _sessionSize = 15;

/// Số từ tối thiểu/tối đa mỗi câu theo level — mirrors web `wordCountRange`
/// (`src/pages/game/wortstellung-page.tsx`).
({int min, int max}) _wordCountRange(String level) {
  if (level == 'A1' || level == 'A2') return (min: 3, max: 7);
  return (min: 5, max: 12);
}

class _Sentence {
  const _Sentence({required this.itemId, required this.words, required this.meaning});

  final String itemId;
  final List<String> words;
  final String meaning;

  String get answer => words.join(' ');
}

/// Word Order / Wortstellung — nguồn dữ liệu thật `GET
/// /user/learning-items/balanced?type=sentence` (mirrors web
/// `WortstellungPage` + `WortstellungPuzzle`,
/// `src/pages/game/wortstellung-page.tsx`). Lọc câu theo số từ phù hợp level,
/// tối đa 15 câu/phiên (giống `SESSION_SIZE` bên web).
class WordOrderGameScreen extends ConsumerStatefulWidget {
  const WordOrderGameScreen({super.key});

  @override
  ConsumerState<WordOrderGameScreen> createState() => _WordOrderGameScreenState();
}

class _WordOrderGameScreenState extends ConsumerState<WordOrderGameScreen> {
  late Future<List<_Sentence>> _future;

  List<_Sentence> _sentences = const [];
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 120;
  bool _gameOver = false;
  int _currentIndex = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  Timer? _timer;

  List<String> _availableWords = [];
  List<String> _userOrder = [];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  String get _level => _kDefaultLevel;

  Future<List<_Sentence>> _load() async {
    final items = await ref
        .read(learningItemRepositoryProvider)
        .fetchBalanced(userLevel: _level, type: 'sentence', limit: 60);
    final sentences = _buildSentences(items);
    if (sentences.isNotEmpty && mounted) {
      _sentences = sentences;
      _loadCurrentSentence();
      _startTimer();
    }
    return sentences;
  }

  List<_Sentence> _buildSentences(List<LearningItem> items) {
    final range = _wordCountRange(_level);
    final filtered = items.where((i) {
      final words = i.contentDe.trim().split(RegExp(r'\s+'));
      return words.length >= range.min && words.length <= range.max;
    }).toList();
    filtered.shuffle(Random());
    return filtered
        .take(_sessionSize)
        .map(
          (i) => _Sentence(
            itemId: i.id,
            words: i.contentDe.trim().replaceAll('.', '').split(RegExp(r'\s+')),
            meaning: i.contentVi ?? '',
          ),
        )
        .toList(growable: false);
  }

  void _loadCurrentSentence() {
    final words = List<String>.from(_sentences[_currentIndex].words);
    words.shuffle(Random());
    _availableWords = words;
    _userOrder = [];
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  void _addWord(String word) {
    setState(() {
      _userOrder.add(word);
      _availableWords.remove(word);
    });
  }

  void _removeWord(String word) {
    setState(() {
      _userOrder.remove(word);
      _availableWords.add(word);
    });
  }

  void _checkAnswer() {
    final sentence = _sentences[_currentIndex];
    final correctAnswer = sentence.answer.toLowerCase();
    final userAnswer = _userOrder.join(' ').toLowerCase();
    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      _total++;
      _isCorrect = isCorrect;
      _showResult = true;
      if (isCorrect) {
        _correct++;
        _score += 25;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && !_gameOver) {
        if (_currentIndex < _sentences.length - 1) {
          setState(() {
            _currentIndex++;
            _showResult = false;
            _loadCurrentSentence();
          });
        } else {
          _endGame();
        }
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);
  }

  void _restart() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _correct = 0;
      _total = 0;
      _timeLeft = 120;
      _gameOver = false;
      _currentIndex = 0;
      _showResult = false;
      _sentences = const [];
      _future = _load();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameShell(
      title: 'Wortstellung',
      exitGuard: !_gameOver,
      scrollable: false,
      trailing: !_gameOver
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppPill(label: _level),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _timeLeft <= 30 ? Colors.red : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer, size: 16),
                      const SizedBox(width: 4),
                      Text('${_timeLeft}s', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            )
          : null,
      child: _gameOver
          ? _buildResults()
          : FutureBuilder<List<_Sentence>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return ErrorView(onRetry: _restart);
                }
                if (_sentences.length < _minSentences) {
                  return ErrorView(
                    message:
                        'Cần ít nhất $_minSentences câu để luyện tập ở level '
                        '$_level (hiện có ${_sentences.length}).',
                    onRetry: _restart,
                  );
                }
                return _buildGame();
              },
            ),
    );
  }

  Widget _buildGame() {
    final sentence = _sentences[_currentIndex];

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _sentences.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${_currentIndex + 1}/${_sentences.length}', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.translate, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sentence.meaning,
                  style: TextStyle(fontSize: 14, color: Colors.amber.shade800),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _showResult
                ? (_isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _showResult
                  ? (_isCorrect ? Colors.green : Colors.red)
                  : Colors.amber.shade200,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Câu của bạn:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 8),
              if (_userOrder.isEmpty)
                const Text(
                  'Nhấn vào từ bên dưới để xếp câu',
                  style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.mutedForeground),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _userOrder.map((word) {
                    return GestureDetector(
                      onTap: _showResult ? null : () => _removeWord(word),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(word, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
              if (_showResult && !_isCorrect) ...[
                const Divider(),
                Text(
                  'Đáp án: ${sentence.answer}',
                  style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Chọn từ:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _availableWords.map((word) {
                  return GestureDetector(
                    onTap: _showResult ? null : () => _addWord(word),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: _showResult
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: _userOrder.isNotEmpty ? _checkAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kiểm tra', style: TextStyle(fontSize: 18)),
                ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final accuracy = _total > 0 ? (_correct / _total * 100).round() : 0;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber.shade100),
              child: const Icon(Icons.swap_vert, size: 40, color: Colors.amber),
            ),
            const SizedBox(height: 16),
            Text('$_score', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.amber)),
            const Text('Điểm', style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Đúng', value: '$_correct/$_total', color: Colors.green),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Về trang chủ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _restart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
  const _StatItem({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}
