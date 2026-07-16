import 'package:flutter/material.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/flashcard/review_item.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../practice/widgets/practice_cloze_view.dart';
import '../../practice/widgets/practice_listening_view.dart';
import '../../practice/widgets/practice_matching_view.dart';
import '../../practice/widgets/practice_writing_view.dart';
import 'daily_review_round_cards.dart';
import 'daily_review_rounds.dart';

/// Round-based mini-game session — web parity: `DailyReviewPlaylist` →
/// `PracticeSession` (`practice-session.tsx`), scoped to the 4 P4
/// practice-view round types (see [DailyReviewGameType]). Drives
/// intro → playing → summary per round, then reports the whole-session
/// results + XP total via [onComplete] (persistence-agnostic — the caller
/// owns FSRS sync, matching web's `PracticeSession` contract).
class DailyReviewPlaylist extends StatefulWidget {
  const DailyReviewPlaylist({
    super.key,
    required this.items,
    required this.onComplete,
    required this.onExit,
    this.bannerText,
  });

  final List<ReviewItem> items;
  final void Function(List<PracticeResultEntry> results, int xpTotal) onComplete;
  final VoidCallback onExit;

  /// Session-context banner shown above the playlist (web: retry/wrong-answer
  /// mode banner on `/daily-review`).
  final String? bannerText;

  @override
  State<DailyReviewPlaylist> createState() => _DailyReviewPlaylistState();
}

class _DailyReviewPlaylistState extends State<DailyReviewPlaylist> {
  late final List<DailyReviewRound> _rounds = buildDailyReviewRounds(widget.items);
  int _roundIndex = 0;
  bool _playing = false;
  final _allResults = <PracticeResultEntry>[];
  int _xpTotal = 0;
  List<PracticeResultEntry>? _lastRoundResults;

  DailyReviewRound get _currentRound => _rounds[_roundIndex];

  void _startRound() => setState(() => _playing = true);

  void _finishRound(List<PracticeResultEntry> results) {
    final xp = results.where((r) => r.correct).length * 10;
    _allResults.addAll(results);
    _xpTotal += xp;
    setState(() {
      _playing = false;
      _lastRoundResults = results;
    });
  }

  void _continueAfterSummary() {
    if (_roundIndex + 1 < _rounds.length) {
      setState(() {
        _roundIndex++;
        _lastRoundResults = null;
      });
    } else {
      widget.onComplete(_allResults, _xpTotal);
    }
  }

  Widget _buildGame(DailyReviewRound round) {
    final items = round.items.map(roundItemFromReview).toList(growable: false);
    return switch (round.gameType) {
      DailyReviewGameType.matching =>
        PracticeMatchingView(items: items, onComplete: _finishRound),
      DailyReviewGameType.cloze =>
        PracticeClozeView(items: items, onComplete: _finishRound),
      DailyReviewGameType.listening =>
        PracticeListeningView(items: items, onComplete: _finishRound),
      DailyReviewGameType.writing =>
        PracticeWritingView(items: items, onComplete: _finishRound),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final round = _currentRound;
    final lastResults = _lastRoundResults;

    final Widget body;
    if (lastResults != null) {
      body = DailyReviewRoundSummaryCard(
        gameType: round.gameType,
        correct: lastResults.where((r) => r.correct).length,
        total: lastResults.length,
        xpEarned: lastResults.where((r) => r.correct).length * 10,
        isLastRound: _roundIndex + 1 >= _rounds.length,
        totalWordsReviewed: _allResults.length,
        totalWords: widget.items.length,
        onContinue: _continueAfterSummary,
      );
    } else if (_playing) {
      body = _buildGame(round);
    } else {
      body = DailyReviewRoundIntroCard(
        gameType: round.gameType,
        roundIndex: _roundIndex,
        totalRounds: _rounds.length,
        wordCount: round.items.length,
        onStart: _startRound,
      );
    }

    final banner = widget.bannerText;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [_ExitButton(onTap: widget.onExit)],
              ),
            ),
            if (banner != null && banner.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  banner,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.primary,
                  ),
                ),
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _ExitButton extends StatelessWidget {
  const _ExitButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: tokens.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: tokens.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            AppPhosphorIcons.caretLeft,
            size: 20,
            color: tokens.foreground,
            semanticLabel: l10n.dailyReview,
          ),
        ),
      ),
    );
  }
}
