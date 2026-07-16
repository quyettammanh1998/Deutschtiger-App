import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/practice/practice_result.dart';
import '../../data/practice/practice_round_item.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/back_button.dart';
import '../../widgets/common/app_button.dart';
import '../practice/widgets/practice_cloze_view.dart';
import '../practice/widgets/practice_listening_view.dart';
import '../practice/widgets/practice_matching_view.dart';
import '../practice/widgets/practice_mode_selector.dart';
import '../practice/widgets/practice_results_view.dart';
import '../practice/widgets/practice_writing_view.dart';
import 'deck_detail_screen.dart' show deckWordsProvider;

const _batchSize = 7;

/// `/notes/:deckId/lesson` guided lesson. Web parity: `guided-lesson-page.tsx`
/// (`LessonModeSelector` → `LessonRoundManager` → `LessonBatchSummary`). This
/// rebuild batches the deck into groups of [_batchSize] cards and drives each
/// batch through the SAME P4 practice views ([PracticeRoundItem] /
/// `{items, onComplete}` contract) — no bespoke round logic duplicated here.
class GuidedLessonScreen extends ConsumerStatefulWidget {
  const GuidedLessonScreen({super.key, required this.deckId});
  final String deckId;

  @override
  ConsumerState<GuidedLessonScreen> createState() => _GuidedLessonScreenState();
}

class _GuidedLessonScreenState extends ConsumerState<GuidedLessonScreen> {
  PracticeMode? _mode;
  int _batchIndex = 0;
  bool _showingBatchSummary = false;
  final List<PracticeResultEntry> _allResults = [];
  List<PracticeResultEntry>? _lastBatchResults;

  List<List<PracticeRoundItem>> _batches(List<PracticeRoundItem> items) {
    final batches = <List<PracticeRoundItem>>[];
    for (var i = 0; i < items.length; i += _batchSize) {
      batches.add(items.sublist(i, i + _batchSize > items.length ? items.length : i + _batchSize));
    }
    return batches;
  }

  void _selectMode(PracticeMode mode) => setState(() => _mode = mode);

  void _handleBatchComplete(List<PracticeResultEntry> results) {
    setState(() {
      _allResults.addAll(results);
      _lastBatchResults = results;
      _showingBatchSummary = true;
    });
  }

  void _continueToNextBatch() {
    setState(() {
      _batchIndex += 1;
      _showingBatchSummary = false;
      _lastBatchResults = null;
    });
  }

  void _restart() {
    setState(() {
      _mode = null;
      _batchIndex = 0;
      _showingBatchSummary = false;
      _allResults.clear();
      _lastBatchResults = null;
    });
  }

  void _exit() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/notes/${widget.deckId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(deckWordsProvider(widget.deckId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: wordsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: FilledButton(
              onPressed: () => ref.invalidate(deckWordsProvider(widget.deckId)),
              child: Text(l10n.retry),
            ),
          ),
          data: (words) {
            if (words.isEmpty) {
              return Center(child: Text(l10n.emptyDeckCards));
            }
            final items = words.map(PracticeRoundItem.fromDeckWord).toList(growable: false);
            final batches = _batches(items);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      AppBackButton(onPressed: _exit),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.deckLessonTitle,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground),
                            ),
                            if (_mode != null && _batchIndex < batches.length)
                              Text(
                                l10n.deckLessonBatchProgress(_batchIndex + 1, batches.length),
                                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_mode != null)
                  ClipRRect(
                    child: LinearProgressIndicator(
                      value: batches.isEmpty ? 0 : (_batchIndex + (_showingBatchSummary ? 1 : 0)) / batches.length,
                      minHeight: 3,
                      backgroundColor: tokens.muted,
                      color: tokens.primary,
                    ),
                  ),
                Expanded(child: _buildBody(context, l10n, batches)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    List<List<PracticeRoundItem>> batches,
  ) {
    final mode = _mode;
    if (mode == null) {
      return PracticeModeSelector(onSelect: _selectMode);
    }

    if (_batchIndex >= batches.length) {
      return PracticeResultsView(
        results: _allResults,
        onRestart: _restart,
        onBackToDeck: _exit,
        backLabel: l10n.deckBackToDeck,
      );
    }

    if (_showingBatchSummary) {
      final batchResults = _lastBatchResults ?? const <PracticeResultEntry>[];
      final correct = batchResults.where((r) => r.correct).length;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.deckLessonBatchDoneTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(l10n.deckLessonBatchDoneSubtitle(correct, batchResults.length)),
              const SizedBox(height: 24),
              AppButton(
                label: _batchIndex + 1 >= batches.length ? l10n.deckLessonFinish : l10n.deckLessonNextBatch,
                onPressed: _continueToNextBatch,
              ),
            ],
          ),
        ),
      );
    }

    final items = batches[_batchIndex];
    return switch (mode) {
      PracticeMode.cloze => PracticeClozeView(items: items, onComplete: _handleBatchComplete),
      PracticeMode.listening => PracticeListeningView(items: items, onComplete: _handleBatchComplete),
      PracticeMode.matching => PracticeMatchingView(items: items, onComplete: _handleBatchComplete),
      PracticeMode.writing => PracticeWritingView(items: items, onComplete: _handleBatchComplete),
    };
  }
}
