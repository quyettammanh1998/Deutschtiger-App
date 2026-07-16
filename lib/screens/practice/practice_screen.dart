import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/flashcard/review_item.dart';
import '../../data/practice/practice_result.dart';
import '../../data/practice/practice_round_item.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/flashcard/review_provider.dart';
import '../decks/deck_detail_screen.dart' show deckWordsProvider;
import 'widgets/practice_cloze_view.dart';
import 'widgets/practice_listening_view.dart';
import 'widgets/practice_matching_view.dart';
import 'widgets/practice_mode_selector.dart';
import 'widgets/practice_results_view.dart';
import 'widgets/practice_writing_view.dart';

/// Runner luyện tập theo deck — tương ứng web `practice-page.tsx`. Nguồn dữ
/// liệu là thẻ deck hiện có ([deckWordsProvider], tái dùng từ
/// `DeckDetailScreen`), KHÔNG tạo repo riêng cho practice (DRY). Kết quả
/// được đồng bộ best-effort lên FSRS qua `ReviewRepository.rate` với
/// `source_flashcard_id` = id thẻ deck.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key, required this.deckId});

  final String deckId;

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  PracticeMode? _mode;
  List<PracticeResultEntry>? _results;
  bool _includeGraduated = false;

  void _selectMode(PracticeMode mode) => setState(() => _mode = mode);

  void _changeMode() => setState(() => _mode = null);

  void _handleComplete(List<PracticeResultEntry> results) {
    setState(() => _results = results);
    unawaited(_syncResults(results));
  }

  Future<void> _syncResults(List<PracticeResultEntry> results) async {
    final repo = ref.read(reviewRepositoryProvider);
    for (final result in results) {
      if (result.cardId.isEmpty) continue;
      try {
        await repo.rate(
          ReviewItem(sourceFlashcardId: result.cardId),
          result.correct ? ReviewRating.medium : ReviewRating.forgot,
          responseTime: const Duration(seconds: 5),
          mode: 'flashcard-practice',
        );
      } catch (_) {
        // Đồng bộ best-effort — lỗi mạng không chặn màn kết quả.
      }
    }
  }

  void _restart() => setState(() {
    _mode = null;
    _results = null;
  });

  void _backToDeck() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/decks/${widget.deckId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(deckWordsProvider(widget.deckId));

    return Scaffold(
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

            final results = _results;
            if (results != null) {
              return PracticeResultsView(
                results: results,
                onRestart: _restart,
                onBackToDeck: _backToDeck,
              );
            }

            final activeWords = _includeGraduated
                ? words
                : words.where((w) => !w.isLearned).toList(growable: false);

            final mode = _mode;
            if (mode == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PracticeLinkButton(label: l10n.practiceBackToDeck, onTap: _backToDeck),
                  Expanded(
                    child: PracticeModeSelector(
                      onSelect: _selectMode,
                      cardCount: activeWords.length,
                      includeGraduated: _includeGraduated,
                      onIncludeGraduatedChanged: (v) => setState(() => _includeGraduated = v),
                    ),
                  ),
                ],
              );
            }

            if (activeWords.isEmpty) {
              return Center(child: Text(l10n.emptyDeckCards));
            }

            final items = activeWords.map(PracticeRoundItem.fromDeckWord).toList(growable: false);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PracticeLinkButton(label: l10n.practiceChangeMode, onTap: _changeMode),
                Expanded(
                  child: switch (mode) {
                    PracticeMode.cloze =>
                      PracticeClozeView(items: items, onComplete: _handleComplete),
                    PracticeMode.listening =>
                      PracticeListeningView(items: items, onComplete: _handleComplete),
                    PracticeMode.matching =>
                      PracticeMatchingView(items: items, onComplete: _handleComplete),
                    PracticeMode.writing =>
                      PracticeWritingView(items: items, onComplete: _handleComplete),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Web parity: the "← Quay lại bộ thẻ" / "← Đổi chế độ" text link at the top
/// of the mode-select and active-play screens (no `AppBar` on web).
class _PracticeLinkButton extends StatelessWidget {
  const _PracticeLinkButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppPhosphorIcons.caretLeft, size: 14, color: tokens.mutedForeground),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: tokens.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
