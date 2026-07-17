import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/games/cases_models.dart';
import '../../../repositories/games/grammar_drill_repository.dart';
import '../../../view_models/games/cases_provider.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/common/game_shell.dart';
import 'widgets/case_quiz_option_grid.dart';
import 'widgets/case_quiz_streak_badge.dart';
import 'widgets/grammar_explain_panel.dart';

const _minItems = 5;
const _itemsPerSession = 10;
const _caseOptions = ['Akkusativ', 'Dativ', 'Genitiv'];

/// Verb-Case Matching — chọn case đúng cho một động từ (helfen → Dativ,
/// sehen → Akkusativ). Mirrors web `src/components/game/verb-case-matcher.tsx`.
class VerbCaseQuizScreen extends ConsumerStatefulWidget {
  const VerbCaseQuizScreen({super.key});

  @override
  ConsumerState<VerbCaseQuizScreen> createState() =>
      _VerbCaseQuizScreenState();
}

class _VerbCaseQuizScreenState extends ConsumerState<VerbCaseQuizScreen> {
  static const _level = 'A2';
  late Future<VerbCaseResponse> _future;

  List<VerbCaseItem> _questions = const [];
  CaseMastery? _mastery;
  int _index = 0;
  String? _selected;
  bool _gameOver = false;
  int _streak = 0;
  final List<GrammarDrillResultInput> _results = [];
  bool _submitFailed = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<VerbCaseResponse> _load() {
    return ref
        .read(casesRepositoryProvider)
        .fetchVerbCase(level: _level, limit: 15);
  }

  void _selectAnswer(VerbCaseItem item, String option) {
    if (_selected != null) return;
    final correct = option == item.caseType;
    setState(() {
      _selected = option;
      _streak = correct ? _streak + 1 : 0;
      _results.add(GrammarDrillResultInput(key: item.id, correct: correct));
    });
  }

  void _next() {
    if (_selected == null) return;
    if (_index + 1 >= _questions.length) {
      _endGame();
      return;
    }
    setState(() {
      _index++;
      _selected = null;
    });
  }

  Future<void> _endGame() async {
    setState(() => _gameOver = true);
    try {
      await ref
          .read(grammarDrillRepositoryProvider)
          .submitResults('verb-case', _results);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitFailed = true);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _selected = null;
      _gameOver = false;
      _streak = 0;
      _submitFailed = false;
      _results.clear();
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameShell(
      title: 'Verb-Case Matching',
      exitGuard: !_gameOver,
      scrollable: false,
      child: _gameOver
          ? _buildResults()
          : FutureBuilder<VerbCaseResponse>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return ErrorView(onRetry: _restart);
                }
                final response = snapshot.data!;
                if (response.items.length < _minItems) {
                  return ErrorView(
                    message:
                        'Cần ít nhất $_minItems động từ để luyện tập '
                        '(hiện có ${response.items.length}).',
                  );
                }
                _questions = response.items.take(_itemsPerSession).toList();
                _mastery = response.mastery;
                return _buildGame();
              },
            ),
    );
  }

  Widget _buildGame() {
    final item = _questions[_index];
    final isCorrect = _selected == item.caseType;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_index + (_selected != null ? 1 : 0)) / _questions.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_index + 1}/${_questions.length}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.tokens.mutedForeground,
                ),
              ),
              Text(
                '${_results.where((r) => r.correct).length} đúng',
                style: TextStyle(color: context.tokens.mutedForeground),
              ),
              CaseQuizStreakBadge(streak: _streak),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.verb,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '(${item.viVerb})',
                        style: TextStyle(color: context.tokens.mutedForeground),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.example,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (_selected != null) ...[
                        const Divider(height: 24),
                        Text(
                          item.viExample,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CaseQuizOptionGrid(
                  options: _caseOptions,
                  correctAnswer: item.caseType,
                  selected: _selected,
                  onSelect: (option) => _selectAnswer(item, option),
                ),
                if (_selected != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isCorrect
                          ? 'Chính xác!'
                          : 'Sai — đáp án đúng: ${item.caseType}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                if (_selected != null && !isCorrect)
                  GrammarExplainPanel(
                    request: GrammarExplainRequest(
                      game: 'verb-case',
                      exerciseKey: item.id,
                      sentence: '${item.verb} (+ ${item.caseType})',
                      options: _caseOptions,
                      correctAnswer: item.caseType,
                      userAnswer: _selected!,
                      caseType: item.caseType,
                      vi: item.viExample,
                      reason: item.example,
                    ),
                    staticReason: item.viExample,
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        if (_selected != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(
                  _index + 1 >= _questions.length ? 'Hoàn thành' : 'Câu tiếp',
                ),
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
              Text(
                '$accuracy%',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              Text('$correct / $total đúng',
                  style: TextStyle(color: context.tokens.mutedForeground)),
              if (_mastery != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Đã thành thạo: ${_mastery!.mastered}/${_mastery!.total}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.tokens.mutedForeground,
                  ),
                ),
              ],
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
