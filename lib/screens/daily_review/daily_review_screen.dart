import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/release/release_feature_flags.dart';
import '../../data/flashcard/review_item.dart';
import '../../data/practice/practice_result.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/flashcard/review_provider.dart';
import '../../view_models/providers.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/daily_review_done.dart';
import 'widgets/daily_review_playlist.dart';
import 'widgets/daily_review_rounds.dart';

/// Mode key riêng cho phiên ôn tập từ màn Daily Review — mỗi scope
/// (mode + deckId) tự fetch queue độc lập trong [reviewSessionProvider].
const _dailyReviewMode = 'daily_review';
const _dailyReviewScope = ReviewSessionScope(mode: _dailyReviewMode);

/// Web parity ceiling matching `GET /user/srs/queue?limit=` default and
/// web's `MAX_REVIEW_SESSION_LIMIT` — used only to guess whether more due
/// words likely remain after this batch (`DailyReviewResult.hasMore`).
const _kSessionLimit = 50;

/// C5 — Daily Review (FSRS grading). Mirrors web `daily-review-page.tsx`:
/// loads straight into the mini-game playlist (no bespoke start screen) →
/// [DailyReviewPlaylist] (round-based cloze/listening/matching/writing, P4
/// round types) → [DailyReviewDoneScreen] (accuracy/XP/weak words).
///
/// FSRS tính toàn bộ phía server (`GET /user/srs/queue`, `POST /user/srs/
/// review`) — KHÔNG tính toán FSRS client-side; kết quả mỗi từ được gửi
/// best-effort sau khi cả phiên hoàn thành (giống `PracticeScreen._syncResults`).
class DailyReviewScreen extends ConsumerStatefulWidget {
  const DailyReviewScreen({super.key});

  @override
  ConsumerState<DailyReviewScreen> createState() => _DailyReviewScreenState();
}

class _DailyReviewScreenState extends ConsumerState<DailyReviewScreen> {
  List<ReviewItem>? _retryItems;
  bool _isRetry = false;
  List<ReviewItem> _lastWeakItems = const [];
  DailyReviewResult? _doneResult;

  Future<void> _persist(
    List<ReviewItem> sourceItems,
    List<PracticeResultEntry> results,
  ) async {
    final repo = ref.read(reviewRepositoryProvider);
    for (final result in results) {
      ReviewItem? item;
      for (final candidate in sourceItems) {
        if (candidate.id == result.cardId) {
          item = candidate;
          break;
        }
      }
      if (item == null) continue;
      try {
        await repo.rate(
          item,
          result.correct ? ReviewRating.medium : ReviewRating.forgot,
          responseTime: const Duration(seconds: 5),
          mode: _dailyReviewMode,
        );
      } catch (_) {
        // Đồng bộ best-effort — lỗi mạng không chặn màn kết quả.
      }
    }
    ref.invalidate(dashboardProvider);
  }

  void _handleComplete(
    List<ReviewItem> sourceItems,
    List<PracticeResultEntry> results,
    int xp,
  ) {
    unawaited(_persist(sourceItems, results));
    final weakIds = results.where((r) => !r.correct).map((r) => r.cardId).toSet();
    final weakItems = sourceItems
        .where((i) => weakIds.contains(i.id))
        .toList(growable: false);
    setState(() {
      _lastWeakItems = weakItems;
      _doneResult = DailyReviewResult(
        totalCount: results.length,
        correctCount: results.length - weakItems.length,
        xpEarned: xp,
        weakWords: weakItems
            .map((i) => DailyReviewWeakWord(contentDe: i.displayDe, contentVi: i.displayVi))
            .toList(growable: false),
        hasMore: !_isRetry && sourceItems.length >= _kSessionLimit,
      );
    });
  }

  void _startRetryWeak() {
    if (_lastWeakItems.isEmpty) return;
    setState(() {
      _retryItems = _lastWeakItems;
      _isRetry = true;
      _doneResult = null;
    });
  }

  void _continueMore() {
    setState(() {
      _retryItems = null;
      _isRetry = false;
      _doneResult = null;
    });
    ref.invalidate(reviewSessionProvider(_dailyReviewScope));
  }

  void _goHome() {
    // Web: retry sessions navigate(-1) instead of home.
    if (_isRetry && context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  void _goToVocabulary() => context.go('/vocabulary');

  void _goToListening() => context.go('/games/flashcards');

  void _askAi() => context.go('/ai-tutor');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final doneResult = _doneResult;
    if (doneResult != null) {
      return DailyReviewDoneScreen(
        result: doneResult,
        onGoHome: _goHome,
        onContinueLearning: _goToVocabulary,
        onRetryWeakWords: _lastWeakItems.isNotEmpty ? _startRetryWeak : null,
        onContinue: doneResult.hasMore ? _continueMore : null,
        onListenPractice: _goToListening,
        onAskAi: ReleaseFeatureFlags.aiTutor && doneResult.weakWords.isNotEmpty
            ? _askAi
            : null,
      );
    }

    final retry = _retryItems;
    if (retry != null) {
      return DailyReviewPlaylist(
        items: retry,
        bannerText: l10n.dailyReviewRetryBanner,
        onComplete: (results, xp) => _handleComplete(retry, results, xp),
        onExit: _goHome,
      );
    }

    final session = ref.watch(reviewSessionProvider(_dailyReviewScope));
    return session.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        body: ErrorView(
          message: l10n.couldNotLoadReviewData,
          onRetry: () => ref.invalidate(reviewSessionProvider(_dailyReviewScope)),
        ),
      ),
      data: (state) {
        if (state.isEmpty) {
          return DailyReviewDoneScreen(
            result: const DailyReviewResult.empty(),
            onGoHome: _goHome,
            onContinueLearning: _goToVocabulary,
          );
        }
        return DailyReviewPlaylist(
          items: state.items,
          onComplete: (results, xp) => _handleComplete(state.items, results, xp),
          onExit: _goHome,
        );
      },
    );
  }
}
