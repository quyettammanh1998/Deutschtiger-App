import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/games/cases_models.dart';
import '../../../repositories/games/grammar_drill_repository.dart';
import '../../../view_models/games/cases_provider.dart';
import '../../../widgets/common/async_state_views.dart';

const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _minItems = 10;
const _itemsPerSession = 10;

/// 3 game cloze của Cases Mastery Hub dùng chung 1 màn hình — chỉ khác
/// endpoint (`akk-dat`/`adjektiv`/`wechselprep`) và tiêu đề. Mirrors web
/// `src/components/game/case-cloze-quiz.tsx` + 3 page riêng
/// (akkusativ-dativ/adjektivendungen/wechselpraeposition-page.tsx).
class CaseClozeQuizScreen extends ConsumerStatefulWidget {
  const CaseClozeQuizScreen({
    super.key,
    required this.game,
    required this.title,
  });

  /// `akk-dat` | `adjektiv` | `wechselprep`
  final String game;
  final String title;

  @override
  ConsumerState<CaseClozeQuizScreen> createState() =>
      _CaseClozeQuizScreenState();
}

class _CaseClozeQuizScreenState extends ConsumerState<CaseClozeQuizScreen> {
  String _level = 'A2';
  late Future<CaseExercisesResponse> _future;

  List<CaseExercise> _questions = const [];
  CaseMastery? _mastery;
  int _index = 0;
  String? _selected;
  bool _gameOver = false;
  final List<GrammarDrillResultInput> _results = [];
  bool _submitFailed = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<CaseExercisesResponse> _load() {
    final repo = ref.read(casesRepositoryProvider);
    switch (widget.game) {
      case 'adjektiv':
        return repo.fetchAdjektiv(level: _level);
      case 'wechselprep':
        return repo.fetchWechselprep(level: _level);
      case 'akk-dat':
      default:
        return repo.fetchAkkDat(level: _level);
    }
  }

  void _selectAnswer(CaseExercise question, String option) {
    if (_selected != null) return;
    final correct = option == question.answer;
    setState(() {
      _selected = option;
      _results.add(
        GrammarDrillResultInput(key: question.id, correct: correct),
      );
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
          .submitResults(widget.game, _results);
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
      _submitFailed = false;
      _results.clear();
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _gameOver
          ? _buildResults()
          : FutureBuilder<CaseExercisesResponse>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return ErrorView(onRetry: _restart);
                }
                final response = snapshot.data!;
                if (response.exercises.length < _minItems) {
                  return ErrorView(
                    message:
                        'Cần ít nhất $_minItems câu để luyện tập (hiện có '
                        '${response.exercises.length}).',
                  );
                }
                _questions = response.exercises.take(_itemsPerSession).toList();
                _mastery = response.mastery;
                return _buildGame();
              },
            ),
    );
  }

  Widget _buildGame() {
    final question = _questions[_index];
    final isCorrect = _selected == question.answer;
    final parts = question.sentence.split('___');

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_index + (_selected != null ? 1 : 0)) / _questions.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.tigerOrange,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_index + 1}/${_questions.length}'),
              _LevelPicker(
                level: _level,
                onChanged: (v) {
                  _level = v;
                  _restart();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 8),
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
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground,
                          ),
                          children: [
                            TextSpan(text: parts.isNotEmpty ? parts[0] : ''),
                            TextSpan(
                              text: _selected != null
                                  ? question.answer
                                  : '____',
                              style: TextStyle(
                                color: _selected != null
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : AppColors.mutedForeground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: parts.length > 1 ? parts[1] : '',
                            ),
                          ],
                        ),
                      ),
                      if (_selected != null) ...[
                        const Divider(height: 24),
                        Text(
                          question.reason,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        Text(
                          question.vi,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...question.options.map((option) {
                  final selected = _selected == option;
                  final isAnswer = option == question.answer;
                  Color bg = Colors.white;
                  Color border = AppColors.tigerOrange.withValues(alpha: 0.4);
                  if (_selected != null) {
                    if (isAnswer) {
                      bg = Colors.green.shade50;
                      border = Colors.green;
                    } else if (selected) {
                      bg = Colors.red.shade50;
                      border = Colors.red;
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => _selectAnswer(question, option),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border, width: 2),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (_selected != null && isAnswer)
                              const Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                if (_selected != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
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
                          ? 'Chính xác! — ${question.caseType}'
                          : 'Sai — đáp án đúng: ${question.answer} (${question.caseType})',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
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
                  color: AppColors.tigerOrange,
                ),
              ),
              Text('$correct / $total đúng',
                  style: const TextStyle(color: AppColors.mutedForeground)),
              if (_mastery != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Đã thành thạo: ${_mastery!.mastered}/${_mastery!.total}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
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
                        backgroundColor: AppColors.tigerOrange,
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

class _LevelPicker extends StatelessWidget {
  const _LevelPicker({required this.level, required this.onChanged});

  final String level;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: level,
      underline: const SizedBox.shrink(),
      items: _levels
          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
          .toList(growable: false),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
