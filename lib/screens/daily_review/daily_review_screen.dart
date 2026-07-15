import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/game_completion_screen.dart';
import '../../widgets/common/async_state_views.dart';
import '../../view_models/flashcard/review_provider.dart';
import '../../view_models/providers.dart';
import 'widgets/review_session_view.dart';
import 'widgets/start_widgets.dart';

/// Mode key riêng cho phiên ôn tập từ màn Daily Review (tách khỏi phiên
/// `FlashcardReviewScreen` — mỗi màn tự fetch queue của mình).
const _dailyReviewMode = 'daily_review';
const _dailyReviewScope = ReviewSessionScope(mode: _dailyReviewMode);

/// C5 — Daily Review (FSRS grading). Mirrors web `daily-review-page.tsx`:
/// start screen with streak + today stats + "Bắt đầu ôn tập" → 4-button
/// FSRS grading session (Again / Hard / Good / Easy) → [GameCompletionScreen].
///
/// FSRS tính toàn bộ phía server (`GET /user/srs/queue`, `POST /user/srs/review`)
/// — KHÔNG tính toán FSRS client-side.
class DailyReviewScreen extends ConsumerStatefulWidget {
  const DailyReviewScreen({super.key});

  @override
  ConsumerState<DailyReviewScreen> createState() => _DailyReviewScreenState();
}

class _DailyReviewScreenState extends ConsumerState<DailyReviewScreen> {
  bool _isReviewing = false;

  /// Số thẻ đã ôn trong phiên hiện tại của app (không persist qua restart —
  /// backend chưa có endpoint "reviewed hôm nay" riêng biệt; due-count/streak/XP
  /// hôm nay lấy thật từ `dashboardProvider`).
  int _reviewedThisSession = 0;

  void _startReview() {
    setState(() {
      _isReviewing = true;
    });
  }

  void _onFinish() {
    setState(() => _isReviewing = false);
    ref.invalidate(dashboardProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_isReviewing) {
      return _ReviewingBody(
        onFinish: _onFinish,
        onCardRated: () => setState(() => _reviewedThisSession++),
      );
    }
    final dashAsync = ref.watch(dashboardProvider);
    return dashAsync.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        body: ErrorView(
          message: l10n.couldNotLoadReviewData,
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
      ),
      data: (dash) => _StartScreen(
        streakDays: dash.gamification?.currentStreak ?? 0,
        dueCount: dash.dueReviewCount,
        reviewedToday: _reviewedThisSession,
        xpToday: dash.gamification?.dailyXpToday ?? 0,
        onStart: _startReview,
      ),
    );
  }
}

/// Phiên ôn đang chạy — theo dõi [reviewSessionProvider] cho mode
/// `daily_review`, hiển thị từng thẻ + gửi rating lên server.
class _ReviewingBody extends ConsumerWidget {
  const _ReviewingBody({required this.onFinish, required this.onCardRated});

  final VoidCallback onFinish;
  final VoidCallback onCardRated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(reviewSessionProvider(_dailyReviewScope));
    final l10n = AppLocalizations.of(context);

    return session.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        body: ErrorView(
          message: l10n.couldNotLoadReviewCards,
          onRetry: () => ref
              .read(reviewSessionProvider(_dailyReviewScope).notifier)
              .restart(),
        ),
      ),
      data: (state) {
        if (state.isEmpty) {
          return Scaffold(
            backgroundColor: DesignTokens.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingLg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.noCardsDueToday,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    FilledButton(
                      onPressed: onFinish,
                      child: Text(l10n.backToHome),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state.isFinished) {
          return GameCompletionScreen(
            score: state.correctCount,
            total: state.total,
            onPlayAgain: () {
              ref
                  .read(reviewSessionProvider(_dailyReviewScope).notifier)
                  .restart();
            },
            onGoHome: onFinish,
          );
        }
        return ReviewSessionView(
          position: state.index + 1,
          total: state.total,
          item: state.current!,
          submitting: state.submitting,
          errorMessage: state.error == ReviewSessionError.ratingNotSaved
              ? l10n.couldNotSaveReview
              : null,
          onAnswer: (rating) async {
            final saved = await ref
                .read(reviewSessionProvider(_dailyReviewScope).notifier)
                .rateCurrent(rating);
            if (saved) onCardRated();
          },
        );
      },
    );
  }
}

class _StartScreen extends StatelessWidget {
  const _StartScreen({
    required this.streakDays,
    required this.dueCount,
    required this.reviewedToday,
    required this.xpToday,
    required this.onStart,
  });

  final int streakDays;
  final int dueCount;
  final int reviewedToday;
  final int xpToday;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: Text(
          l10n.dailyReview,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: DesignTokens.tigerOrange,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreakCard(streakDays: streakDays),
            const SizedBox(height: DesignTokens.spacingLg),
            TodayStatsCard(
              dueCount: dueCount,
              reviewedToday: reviewedToday,
              xpToday: xpToday,
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            StartReviewButton(onStart: onStart),
          ],
        ),
      ),
    );
  }
}
