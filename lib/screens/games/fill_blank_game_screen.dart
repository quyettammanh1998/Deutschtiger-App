import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/games/learning_item_models.dart';
import '../../view_models/games/learning_item_provider.dart';
import '../../widgets/common/async_state_views.dart';

const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _minQuestions = 6;
const _sessionSize = 10;
const _blankRe = '_{2,}';

/// Mạo từ đứng trước danh từ — bỏ đi khi coi 1 item là "1 từ" (đáp án/gợi ý
/// điền từ chỉ là danh từ, không kèm mạo từ).
final _articleRe = RegExp(r'^(der|die|das|ein|eine|einen|einem|einer)\s+', caseSensitive: false);

/// Từ đệm dùng khi pool không đủ từ nhiễu (distractor) cùng category — luôn
/// là từ tiếng Đức thật, mirrors web `PAD_WORDS`
/// (`src/lib/practice/build-cloze-distractors.ts`).
const _padWords = ['machen', 'gehen', 'kaufen', 'sehen', 'kommen', 'finden', 'Haus', 'Zeit', 'Tag'];

String? _asSingleWord(String contentDe) {
  final stripped = contentDe.trim().replaceFirst(_articleRe, '');
  if (stripped.isEmpty || RegExp(r'\s').hasMatch(stripped)) return null;
  return stripped;
}

/// Tìm câu ví dụ có thể tạo cloze (chỗ trống) cho [item] — ưu tiên
/// `example.cloze` có sẵn, nếu không thì tự thay thế từ mục tiêu trong
/// `example.de` bằng chỗ trống. Mirrors web `deriveClozeFromExamples`
/// (`src/lib/vocabulary/vocab-lesson-utils.ts`), rút gọn cho 1 item duy nhất
/// (không cần đường vòng cloze_words phức tạp).
String? _deriveClozePrompt(LearningItem item) {
  final target = item.contentDe.trim();
  if (target.isEmpty) return null;
  final wordRe = RegExp(r'\b' + RegExp.escape(target) + r'\b', caseSensitive: false);

  for (final ex in item.examples) {
    if (ex.cloze != null && ex.cloze!.contains('_')) {
      return ex.cloze!.replaceAll(RegExp(_blankRe), '___');
    }
    if (wordRe.hasMatch(ex.de)) {
      return ex.de.replaceFirst(wordRe, '___');
    }
  }
  return null;
}

List<String> _buildDistractors(LearningItem target, List<LearningItem> pool, {int count = 3}) {
  final answerKey = (_asSingleWord(target.contentDe) ?? target.contentDe).toLowerCase();
  final seen = <String>{answerKey};
  final out = <String>[];

  void push(String? word) {
    if (word == null || out.length >= count) return;
    final key = word.toLowerCase();
    if (seen.contains(key)) return;
    seen.add(key);
    out.add(word);
  }

  final passes = <bool Function(LearningItem)>[
    (i) => i.category == target.category,
    (i) => true,
  ];
  for (final accept in passes) {
    if (out.length >= count) break;
    for (final candidate in pool) {
      if (out.length >= count) break;
      if (candidate.id == target.id || !accept(candidate)) continue;
      push(_asSingleWord(candidate.contentDe));
    }
  }
  for (final pad in _padWords) {
    if (out.length >= count) break;
    push(pad);
  }
  return out.take(count).toList(growable: false);
}

class _FillBlankQuestion {
  const _FillBlankQuestion({
    required this.itemId,
    required this.sentenceWithBlank,
    required this.answer,
    required this.options,
  });

  final String itemId;
  final String sentenceWithBlank;
  final String answer;
  final List<String> options;
}

/// Fill-blank (Điền từ) — nguồn dữ liệu thật `GET
/// /user/learning-items/balanced?type=word`, dựng câu cloze từ `examples`
/// đính kèm mỗi item (mirrors web `FillBlankMiniGame`'s `ClozeMode` +
/// `deriveClozeFromExamples`/`buildClozeDistractors`,
/// `src/components/vocabulary/mini-games/fill-blank-mini-game.tsx`). Web
/// không có trang game độc lập — nó là 1 mini-game bên trong bài học từ
/// vựng; ở mobile đây là 1 game riêng trong Game Hub, dùng cùng nguồn corpus.
/// Item không suy ra được cloze (không câu ví dụ chứa từ mục tiêu) bị bỏ qua.
class FillBlankGameScreen extends ConsumerStatefulWidget {
  const FillBlankGameScreen({super.key});

  @override
  ConsumerState<FillBlankGameScreen> createState() => _FillBlankGameScreenState();
}

class _FillBlankGameScreenState extends ConsumerState<FillBlankGameScreen> {
  String _level = 'A1';
  late Future<List<_FillBlankQuestion>> _future;

  List<_FillBlankQuestion> _questions = const [];
  int _currentIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 60;
  bool _gameOver = false;
  String? _selectedAnswer;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_FillBlankQuestion>> _load() async {
    final items = await ref
        .read(learningItemRepositoryProvider)
        .fetchBalanced(userLevel: _level, type: 'word', limit: 60);
    final questions = _buildQuestions(items);
    if (questions.isNotEmpty && mounted) {
      _questions = questions;
      _startTimer();
    }
    return questions;
  }

  List<_FillBlankQuestion> _buildQuestions(List<LearningItem> items) {
    final questions = <_FillBlankQuestion>[];
    for (final item in items) {
      final prompt = _deriveClozePrompt(item);
      if (prompt == null) continue;
      final distractors = _buildDistractors(item, items);
      if (distractors.length < 3) continue;
      final answer = _asSingleWord(item.contentDe) ?? item.contentDe.trim();
      final options = [answer, ...distractors]..shuffle(Random());
      questions.add(
        _FillBlankQuestion(
          itemId: item.id,
          sentenceWithBlank: prompt,
          answer: answer,
          options: options,
        ),
      );
    }
    questions.shuffle(Random());
    return questions.take(_sessionSize).toList(growable: false);
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

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;

    final correctAnswer = _questions[_currentIndex].answer;
    final isCorrect = answer == correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _total++;
      if (isCorrect) {
        _correct++;
        _score += 15;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (_currentIndex < _questions.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedAnswer = null;
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
      _currentIndex = 0;
      _score = 0;
      _correct = 0;
      _total = 0;
      _timeLeft = 60;
      _gameOver = false;
      _selectedAnswer = null;
      _questions = const [];
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
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Điền từ'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!_gameOver) ...[
            _LevelPicker(
              level: _level,
              onChanged: (v) {
                _level = v;
                _restart();
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16, left: 8),
              decoration: BoxDecoration(
                color: _timeLeft <= 10 ? Colors.red : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 16),
                  const SizedBox(width: 4),
                  Text('${_timeLeft}s', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ],
      ),
      body: _gameOver
          ? _buildResults()
          : FutureBuilder<List<_FillBlankQuestion>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return ErrorView(onRetry: _restart);
                }
                if (_questions.length < _minQuestions) {
                  return ErrorView(
                    message:
                        'Cần ít nhất $_minQuestions câu để luyện tập ở level '
                        '$_level (hiện có ${_questions.length}).',
                    onRetry: _restart,
                  );
                }
                return _buildGame();
              },
            ),
    );
  }

  Widget _buildGame() {
    final question = _questions[_currentIndex];

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.cyan),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${_currentIndex + 1}/${_questions.length}', style: const TextStyle(fontSize: 14)),
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
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 24, color: AppColors.foreground),
              children: _buildSentenceParts(question),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: question.options.map((option) {
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = option == question.answer;

              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade300;

              if (_selectedAnswer != null) {
                if (isCorrectAnswer) {
                  bgColor = Colors.green.shade50;
                  borderColor = Colors.green;
                } else if (isSelected) {
                  bgColor = Colors.red.shade50;
                  borderColor = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectAnswer(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.foreground),
                          ),
                        ),
                        if (_selectedAnswer != null && isCorrectAnswer)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (_selectedAnswer == option && !isCorrectAnswer)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  List<TextSpan> _buildSentenceParts(_FillBlankQuestion question) {
    final parts = <TextSpan>[];
    final matches = RegExp('___').allMatches(question.sentenceWithBlank);
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        parts.add(TextSpan(text: question.sentenceWithBlank.substring(lastEnd, match.start)));
      }

      if (_selectedAnswer != null) {
        final isCorrect = _selectedAnswer == question.answer;
        parts.add(
          TextSpan(
            text: _selectedAnswer ?? '___',
            style: TextStyle(
              color: isCorrect ? Colors.green : Colors.red,
              decoration: isCorrect ? null : TextDecoration.lineThrough,
            ),
          ),
        );
      } else {
        parts.add(
          const TextSpan(text: '___', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
        );
      }
      lastEnd = match.end;
    }

    if (lastEnd < question.sentenceWithBlank.length) {
      parts.add(TextSpan(text: question.sentenceWithBlank.substring(lastEnd)));
    }
    return parts;
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accuracy >= 70 ? Colors.green.shade100 : Colors.grey.shade200,
              ),
              child: Icon(
                accuracy >= 70 ? Icons.emoji_events : Icons.refresh,
                size: 40,
                color: accuracy >= 70 ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text('$_score', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.cyan)),
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
                      backgroundColor: Colors.cyan,
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

class _LevelPicker extends StatelessWidget {
  const _LevelPicker({required this.level, required this.onChanged});

  final String level;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: level,
      underline: const SizedBox.shrink(),
      items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(growable: false),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
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
