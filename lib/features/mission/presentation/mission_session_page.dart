import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/game_completion_screen.dart';
import '../../../widgets/common/async_state_views.dart';
import 'mission_session_provider.dart';
import 'widgets/practice_view.dart';
import 'widgets/result_view.dart';
import 'widgets/word_intro_view.dart';

/// B3 — Mission session runner page. Mirrors web `mission-session-page.tsx` +
/// `mission-session-runner.tsx`: fetches today's mission, drives the
/// `idle → starting → in_word_intro → in_practice → between_words →
/// completed` state machine, then hands off to the shared
/// [GameCompletionScreen] before returning to the Learn Hub.
class MissionSessionPage extends ConsumerWidget {
  const MissionSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(missionSessionProvider);
    final l10n = AppLocalizations.of(context);

    return session.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        body: ErrorView(
          message: l10n.couldNotLoadTodayLesson,
          onRetry: () => ref.invalidate(missionSessionProvider),
        ),
      ),
      data: (state) {
        switch (state.status) {
          case MissionRunnerStatus.idle:
          case MissionRunnerStatus.starting:
            return const Scaffold(body: LoadingView());

          case MissionRunnerStatus.inWordIntro:
            final word = state.currentWord;
            if (word == null) {
              return const Scaffold(body: LoadingView());
            }
            return WordIntroView(
              word: word,
              position: state.overallPosition,
              total: state.totalWords,
              onContinue: () =>
                  ref.read(missionSessionProvider.notifier).beginPractice(),
            );

          case MissionRunnerStatus.inPractice:
            final word = state.currentWord;
            if (word == null) {
              return const Scaffold(body: LoadingView());
            }
            return PracticeView(
              word: word,
              position: state.overallPosition,
              total: state.totalWords,
              onAnswer: (correct) => ref
                  .read(missionSessionProvider.notifier)
                  .submitAnswer(correct),
            );

          case MissionRunnerStatus.betweenWords:
            return ResultView(
              correct: state.lastAnswerCorrect ?? false,
              submitting: state.submitting,
              errorMessage: missionSessionErrorMessage(l10n, state.error),
              onContinue: () =>
                  ref.read(missionSessionProvider.notifier).advance(),
            );

          case MissionRunnerStatus.completed:
            if (!state.hasWords) {
              return _EmptyMissionView(onGoHome: () => context.go('/journey'));
            }
            return GameCompletionScreen(
              title: l10n.missionComplete,
              subtitle: state.result != null
                  ? '+${state.result!.xpAwarded} XP'
                  : null,
              score: state.totalCorrect,
              total: state.totalAnswered,
              // A daily mission is single-instance per day — "replay" just
              // returns to the Learn Hub like "home", matching the web
              // runner (no re-run affordance once completed).
              onPlayAgain: () => context.go('/journey'),
              onGoHome: () => context.go('/journey'),
            );
        }
      },
    );
  }
}

String? missionSessionErrorMessage(
  AppLocalizations l10n,
  MissionSessionError? error,
) {
  return switch (error) {
    MissionSessionError.roundNotSaved => l10n.couldNotSaveMissionRound,
    MissionSessionError.missionNotCompleted => l10n.couldNotCompleteMission,
    null => null,
  };
}

class _EmptyMissionView extends StatelessWidget {
  const _EmptyMissionView({required this.onGoHome});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.noMissionRounds,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: DesignTokens.mutedForeground),
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                FilledButton(
                  onPressed: onGoHome,
                  style: FilledButton.styleFrom(
                    backgroundColor: DesignTokens.orange500,
                    foregroundColor: DesignTokens.card,
                  ),
                  child: Text(l10n.backToHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
