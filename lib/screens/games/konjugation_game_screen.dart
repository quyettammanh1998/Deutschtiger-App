import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/games/conjugation_models.dart';
import '../../repositories/games/grammar_drill_repository.dart';
import '../../view_models/games/cases_provider.dart';
import '../../view_models/games/conjugation_provider.dart';
import '../../widgets/common/async_state_views.dart';

const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _minItems = 5;
const _itemsPerSession = 10;

/// Konjugation Trainer — chia động từ, gõ đáp án. Mirrors backend
/// `internal/feature/learning/conjugation/conjugation_handler.go`
/// (`GET /user/conjugation/exercise`) và web
/// `src/components/game/conjugation-input-card.tsx`. Khi user có đủ vốn từ
/// (verb) học rồi, backend tự trộn câu hỏi cá nhân hoá — kết quả gửi kèm
/// `learning_item_id` để backend ghi thêm 1 FSRS review.
class KonjugationGameScreen extends ConsumerStatefulWidget {
  const KonjugationGameScreen({super.key});

  @override
  ConsumerState<KonjugationGameScreen> createState() =>
      _KonjugationGameScreenState();
}

class _KonjugationGameScreenState
    extends ConsumerState<KonjugationGameScreen> {
  String _level = 'A2';
  late Future<List<ConjugationExercise>> _future;

  List<ConjugationExercise> _questions = const [];
  int _index = 0;
  final _controller = TextEditingController();
  bool _submitted = false;
  bool _isCorrect = false;
  bool _gameOver = false;
  final List<GrammarDrillResultInput> _results = [];
  bool _submitFailed = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ConjugationExercise>> _load() {
    return ref
        .read(conjugationRepositoryProvider)
        .fetchExercises(level: _level);
  }

  bool _matches(String userAnswer, ConjugationExercise q) {
    final normalized = userAnswer.trim().toLowerCase();
    if (normalized == q.expected.trim().toLowerCase()) return true;
    return q.alternatives.any((alt) => normalized == alt.trim().toLowerCase());
  }

  void _submit() {
    if (_submitted || _controller.text.trim().isEmpty) return;
    final question = _questions[_index];
    final correct = _matches(_controller.text, question);
    setState(() {
      _submitted = true;
      _isCorrect = correct;
      _results.add(
        GrammarDrillResultInput(
          key: question.key,
          correct: correct,
          learningItemId: question.learningItemId,
        ),
      );
    });
  }

  void _next() {
    if (!_submitted) return;
    if (_index + 1 >= _questions.length) {
      _endGame();
      return;
    }
    setState(() {
      _index++;
      _controller.clear();
      _submitted = false;
      _isCorrect = false;
    });
  }

  Future<void> _endGame() async {
    setState(() => _gameOver = true);
    try {
      await ref
          .read(grammarDrillRepositoryProvider)
          .submitResults('konjugation', _results);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitFailed = true);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _controller.clear();
      _submitted = false;
      _isCorrect = false;
      _gameOver = false;
      _submitFailed = false;
      _results.clear();
      _future = _load();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Konjugationstrainer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _gameOver
          ? _buildResults()
          : FutureBuilder<List<ConjugationExercise>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return ErrorView(onRetry: _restart);
                }
                final exercises = snapshot.data!;
                if (exercises.length < _minItems) {
                  return ErrorView(
                    message:
                        'Cần ít nhất $_minItems câu để luyện tập (hiện có '
                        '${exercises.length}).',
                  );
                }
                _questions = exercises.take(_itemsPerSession).toList();
                return _buildGame();
              },
            ),
    );
  }

  Widget _buildGame() {
    final question = _questions[_index];

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_index + (_submitted ? 1 : 0)) / _questions.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_index + 1}/${_questions.length}'),
              DropdownButton<String>(
                value: _level,
                underline: const SizedBox.shrink(),
                items: _levels
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(growable: false),
                onChanged: (v) {
                  if (v == null) return;
                  _level = v;
                  _restart();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          question.person,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question.infinitive,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '(${question.viVerb})',
                        style: TextStyle(color: AppColors.mutedForeground),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.tense,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  key: const Key('konjugation-input'),
                  controller: _controller,
                  autofocus: true,
                  enabled: !_submitted,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Chia động từ...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: _submitted
                            ? (_isCorrect ? Colors.green : Colors.red)
                            : Colors.teal.shade200,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: _submitted
                            ? (_isCorrect ? Colors.green : Colors.red)
                            : Colors.teal.shade200,
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                if (!_submitted)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Kiểm tra'),
                    ),
                  ),
                if (_submitted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _isCorrect
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isCorrect
                          ? 'Chính xác! — ${question.expected}'
                          : 'Sai — đáp án đúng: ${question.expected}'
                            '${question.alternatives.isNotEmpty ? ' (hoặc: ${question.alternatives.join(', ')})' : ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  '${question.type} · ${question.level}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.mutedForeground,
                  ),
                ),
                if (_submitted) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: Text(
                        _index + 1 >= _questions.length
                            ? 'Hoàn thành'
                            : 'Câu tiếp',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final correct = _results.where((r) => r.correct).length;
    final total = _results.length;
    final accuracy = total > 0 ? (correct / total * 100).round() : 0;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.shade100,
                ),
                child: const Icon(Icons.edit_note, size: 40, color: Colors.teal),
              ),
              const SizedBox(height: 16),
              Text(
                '$accuracy%',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              Text(
                '$correct / $total đúng',
                style: const TextStyle(color: AppColors.mutedForeground),
              ),
              if (_submitFailed) ...[
                const SizedBox(height: 8),
                const Text(
                  'Không thể ghi nhận kết quả lên server.',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Về trang chủ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _restart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Chơi lại'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
