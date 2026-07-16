import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/learn/learn_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/learn/learn_repository.dart';
import '../../view_models/learn/learn_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/can_do_practice_end_states.dart';

const _maxTasks = 5;

/// Một nhiệm vụ viết câu — dựng từ 1 block còn yếu (rung < 2) của can-do.
class _CanDoTask {
  const _CanDoTask({
    required this.instructionKey,
    required this.hintDe,
    required this.promptWord,
    required this.promptMeaning,
    required this.targetBlock,
  });

  /// true = "viết câu dùng cấu trúc X", false = "viết câu dùng từ X".
  final bool instructionKey;
  final String hintDe;
  final String promptWord;
  final String promptMeaning;
  final TargetBlockInput targetBlock;
}

/// Luyện viết có mục tiêu cho các block còn yếu (rung < 2) của một can-do.
/// `/learn/can-do/:id/practice` — mirrors web `can-do-practice-page.tsx` +
/// `can-do-practice-session.tsx`. Chấm câu qua `POST /ai/grade-sentence`
/// (endpoint AI domain đã live trên backend, gọi trực tiếp từ
/// [LearnRepository] — không đụng file AI feature Flutter).
class CanDoPracticeScreen extends ConsumerStatefulWidget {
  const CanDoPracticeScreen({super.key, required this.canDoId});

  final String canDoId;

  @override
  ConsumerState<CanDoPracticeScreen> createState() =>
      _CanDoPracticeScreenState();
}

class _CanDoPracticeScreenState extends ConsumerState<CanDoPracticeScreen> {
  final _controller = TextEditingController();
  int _idx = 0;
  GradeSentenceResult? _result;
  bool _submitting = false;
  bool _hasError = false;
  int _correctCount = 0;
  int? _doneCorrect;
  int? _doneTotal;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_CanDoTask> _buildTasks(CanDo canDo) {
    final laggards = canDo.members.where((m) => m.rung < 2).toList()
      ..sort((a, b) {
        if (a.isStructure == b.isStructure) return 0;
        return a.isStructure ? -1 : 1;
      });
    final picked = laggards.take(_maxTasks);
    return picked.map((m) {
      if (m.isStructure) {
        return _CanDoTask(
          instructionKey: true,
          hintDe: canDo.labelDe,
          promptWord: m.key,
          promptMeaning: m.label,
          targetBlock: TargetBlockInput(
            kind: 'structure',
            ref: m.ref,
            patternKey: m.key,
            label: m.label,
          ),
        );
      }
      return _CanDoTask(
        instructionKey: false,
        hintDe: m.key,
        promptWord: m.key,
        promptMeaning: m.label,
        targetBlock: TargetBlockInput(
          kind: 'vocab',
          ref: m.ref,
          lemma: m.key,
          label: m.label,
        ),
      );
    }).toList(growable: false);
  }

  Future<void> _submit(_CanDoTask task, String userLevel) async {
    final sentence = _controller.text.trim();
    if (_submitting || sentence.length < 3) return;
    setState(() {
      _submitting = true;
      _hasError = false;
    });
    try {
      final result = await ref
          .read(learnRepositoryProvider)
          .gradeSentence(
            promptWord: task.promptWord,
            promptMeaning: task.promptMeaning,
            userSentence: sentence,
            userLevel: userLevel,
            targetBlocks: [task.targetBlock],
          );
      setState(() {
        _result = result;
        if (result.isCorrect) _correctCount++;
      });
    } catch (_) {
      setState(() => _hasError = true);
    } finally {
      setState(() => _submitting = false);
    }
  }

  void _next(int totalTasks) {
    final isLast = _idx == totalTasks - 1;
    _controller.clear();
    setState(() {
      _result = null;
      if (isLast) {
        _doneCorrect = _correctCount;
        _doneTotal = totalTasks;
      } else {
        _idx++;
      }
    });
    if (isLast) {
      ref.invalidate(capabilityMapProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final mapAsync = ref.watch(capabilityMapProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: mapAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            onRetry: () => ref.invalidate(capabilityMapProvider),
          ),
          data: (map) {
            final canDo = map.canDos
                .where((c) => c.id == widget.canDoId)
                .cast<CanDo?>()
                .firstWhere((_) => true, orElse: () => null);

            if (canDo == null) {
              return CanDoPracticeNotFound(l10n: l10n);
            }

            if (_doneCorrect != null) {
              return CanDoPracticeDoneCard(
                correct: _doneCorrect!,
                total: _doneTotal!,
                l10n: l10n,
              );
            }

            final tasks = _buildTasks(canDo);
            if (tasks.isEmpty) {
              return CanDoPracticeAllClear(l10n: l10n);
            }

            final task = tasks[_idx.clamp(0, tasks.length - 1)];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CanDoPracticeBackLink(l10n: l10n),
                const SizedBox(height: 12),
                Text(
                  canDo.labelVi,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${canDo.labelDe} · ${canDo.cefr}',
                  style: TextStyle(color: tokens.mutedForeground),
                ),
                const SizedBox(height: 16),
                AppCard.card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.canDoPracticeProgress(_idx + 1, tasks.length),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: tokens.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          border: Border.all(color: const Color(0xFFFED7AA)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✍️ ${task.instructionKey ? l10n.canDoPracticeInstructionStructure(task.promptMeaning) : l10n.canDoPracticeInstructionVocab(task.promptWord)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.hintDe,
                              style: TextStyle(color: tokens.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _controller,
                        enabled: _result == null && !_submitting,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: l10n.canDoPracticeInputHint,
                          filled: true,
                          fillColor: tokens.muted.withValues(alpha: 0.4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFFB923C),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      if (_hasError) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.canDoPracticeError,
                          style: TextStyle(color: tokens.destructive),
                        ),
                      ],
                      if (_result != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: tokens.muted.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_result!.isCorrect ? '✅' : '❌'} ${_result!.score}/100',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (_result!.correctedSentence.isNotEmpty &&
                                  _result!.correctedSentence !=
                                      _controller.text.trim()) ...[
                                const SizedBox(height: 6),
                                Text(
                                  '${l10n.canDoPracticeCorrectedPrefix}: ${_result!.correctedSentence}',
                                ),
                              ],
                              if (_result!.summaryVi.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  _result!.summaryVi,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: tokens.mutedForeground,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _result != null
                            ? AppGradientButton(
                                label: _idx == tasks.length - 1
                                    ? l10n.canDoPracticeFinish
                                    : l10n.canDoPracticeNext,
                                onPressed: () => _next(tasks.length),
                              )
                            : AppGradientButton(
                                label: _submitting
                                    ? l10n.canDoPracticeSubmitting
                                    : l10n.canDoPracticeSubmit,
                                loading: _submitting,
                                onPressed: _submitting
                                    ? null
                                    : () => _submit(task, canDo.cefr),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
