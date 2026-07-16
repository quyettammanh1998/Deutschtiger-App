import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../features/writing/data/sprint/sprint_repository.dart';
import '../../../../features/writing/data/sprint/sr_queue_store.dart';
import '../../../../features/writing/domain/sprint/sr_card_queue.dart';
import '../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/async_state_views.dart';
import 'widgets/essay_input.dart';
import 'widgets/essay_result_card.dart';

/// Sprint v2 standalone mini practice-exam page — 3 essays (1/Teil),
/// AI-graded via `POST /sprint/grade-essay`. Route segment is `thi-thu`
/// (Vietnamese "trial exam") rather than web's literal URL segment — see
/// `docs/api-changelog.md` for the naming-collision reason.
class ExamWritingSprintMockPage extends ConsumerStatefulWidget {
  const ExamWritingSprintMockPage({super.key});

  @override
  ConsumerState<ExamWritingSprintMockPage> createState() => _ExamWritingSprintMockPageState();
}

class _ExamWritingSprintMockPageState extends ConsumerState<ExamWritingSprintMockPage> {
  final _store = SrQueueStore();
  SRQueue? _queue;
  bool _queueChecked = false;
  List<SprintTopicData>? _pickedTopics;
  int _currentIdx = 0;
  final Map<String, SprintEssayResult> _localResults = {};
  final Map<String, String> _localDrafts = {};
  bool _isGrading = false;
  String? _gradeError;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    final queue = await _store.load();
    if (!mounted) return;
    setState(() {
      _queue = queue;
      _queueChecked = true;
      if (queue != null) _localDrafts.addAll(queue.essayDrafts);
    });
  }

  /// Picks the 3 mini-exam topics once topics are available. Called from
  /// `build()` — deliberately mutates fields WITHOUT `setState` (illegal
  /// mid-build) and relies on the fact that this same build pass reads
  /// `_pickedTopics` right after the call, so the picked value is visible
  /// immediately without needing a second frame.
  void _pickTopics(List<SprintTopicData> topics) {
    if (_pickedTopics != null || topics.isEmpty) return;
    final queue = _queue;
    List<SprintTopicData> picked;
    if (queue != null) {
      picked = pickSprintEssayTopics(queue, topics);
    } else {
      final rng = Random();
      picked = [1, 2, 3]
          .map((teil) {
            final candidates = topics.where((t) => t.teil == teil && t.speedrun != null).toList();
            return candidates.isEmpty ? null : candidates[rng.nextInt(candidates.length)];
          })
          .whereType<SprintTopicData>()
          .toList();
    }
    _pickedTopics = picked;
    if (queue != null) _localResults.addAll(queue.essayResults);
  }

  Future<void> _persistEssayResult(String slug, SprintEssayResult result) async {
    var queue = _queue;
    if (queue == null) return;
    queue = setSprintEssayResult(queue, slug, result);
    _queue = queue;
    await _store.save(queue);
  }

  Future<void> _persistDraft(String slug, String text) async {
    var queue = _queue;
    if (queue == null) return;
    queue = setEssayDraft(queue, slug, text);
    _queue = queue;
    await _store.save(queue);
  }

  Future<void> _submit(SprintTopicData topic, String essay) async {
    setState(() {
      _isGrading = true;
      _gradeError = null;
    });
    try {
      final result = await ref.read(sprintGradingRepositoryProvider).grade(
            SprintGradeRequest(
              teil: topic.teil,
              taskPrompt: topic.taskDe,
              points: topic.taskAnalysisPoints.map((p) => p.de).toList(),
              studentEssay: essay,
              topicSlug: topic.slug,
            ),
          );
      if (!mounted) return;
      setState(() => _localResults[topic.slug] = result);
      await _persistEssayResult(topic.slug, result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _gradeError = e.toString());
    } finally {
      if (mounted) setState(() => _isGrading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topicsAsync = ref.watch(sprintTopicsProvider);

    if (!_queueChecked) {
      return Scaffold(backgroundColor: tokens.background, body: const LoadingView());
    }

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: topicsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(message: l10n.couldNotLoadData, onRetry: () => ref.invalidate(sprintTopicsProvider)),
          data: (topics) {
            _pickTopics(topics);
            final picked = _pickedTopics ?? const <SprintTopicData>[];
            final allDone = picked.isNotEmpty && picked.every((t) => _localResults.containsKey(t.slug));

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: tokens.border))),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => context.go('/exam/goethe-b1/writing/sprint'),
                        child: Text('← ${l10n.writingSprintTitle}', style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
                      ),
                      Expanded(
                        child: Text(l10n.writingSprintMockCta, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < picked.length; i++)
                            GestureDetector(
                              onTap: () => setState(() => _currentIdx = i),
                              child: Container(
                                margin: const EdgeInsets.only(left: 4),
                                width: 22,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: i == _currentIdx
                                      ? tokens.primary
                                      : (_localResults.containsKey(picked[i].slug) ? tokens.primary.withValues(alpha: 0.4) : tokens.muted),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: allDone
                        ? _buildAllDone(context, picked)
                        : (picked.isEmpty
                            ? Padding(padding: const EdgeInsets.symmetric(vertical: 48), child: Center(child: Text(l10n.writingSprintNoMockTopics, style: TextStyle(color: tokens.mutedForeground))))
                            : _buildCurrent(context, picked[_currentIdx])),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAllDone(BuildContext context, List<SprintTopicData> picked) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final avg = picked.isEmpty
        ? 0
        : (picked.map((t) => _localResults[t.slug]?.total ?? 0).reduce((a, b) => a + b) / picked.length).round();
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: tokens.border)),
          child: Column(
            children: [
              Text('$avg/100', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: tokens.foreground)),
              Text(l10n.writingSprintMockAverageLabel, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
            ],
          ),
        ),
        for (final t in picked) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.writingSprintTeilTopicLabel(t.teil, t.titleDe), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
          ),
          const SizedBox(height: 8),
          if (_localResults[t.slug] != null)
            EssayResultCard(
              result: _localResults[t.slug]!,
              essayText: _localDrafts[t.slug] ?? '',
              onRegrade: () => _submit(t, _localDrafts[t.slug] ?? ''),
              regradeDisabled: _isGrading,
            ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => GoRouter.of(context).go('/exam/goethe-b1/writing/sprint'),
            style: ElevatedButton.styleFrom(backgroundColor: tokens.primary, foregroundColor: tokens.primaryForeground, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text(l10n.writingSprintBackToSprint),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrent(BuildContext context, SprintTopicData topic) {
    final tokens = context.tokens;
    final result = _localResults[topic.slug];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_gradeError != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: tokens.destructive.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
            child: Text(_gradeError!, style: TextStyle(fontSize: 12, color: tokens.destructive)),
          ),
        if (result != null)
          Column(
            children: [
              EssayResultCard(
                result: result,
                essayText: _localDrafts[topic.slug] ?? '',
                onRegrade: () => _submit(topic, _localDrafts[topic.slug] ?? ''),
                regradeDisabled: _isGrading,
              ),
              if (_pickedTopics != null && _currentIdx < _pickedTopics!.length - 1) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _currentIdx++),
                    style: ElevatedButton.styleFrom(backgroundColor: tokens.primary, foregroundColor: tokens.primaryForeground, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(AppLocalizations.of(context).writingSprintNextEssay),
                  ),
                ),
              ],
            ],
          )
        else
          EssayInput(
            teil: topic.teil,
            taskDe: topic.taskDe,
            initialValue: _localDrafts[topic.slug] ?? '',
            disabled: _isGrading,
            onSave: (text) {
              _localDrafts[topic.slug] = text;
              unawaited(_persistDraft(topic.slug, text));
            },
            onSubmit: (text) => _submit(topic, text),
          ),
        if (_isGrading)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context).writingSprintGradingLong, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
