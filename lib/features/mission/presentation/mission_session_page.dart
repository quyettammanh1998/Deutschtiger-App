import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/learn/learn_provider.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/async_state_views.dart';
import 'mission_session_provider.dart';
import 'widgets/mission_complete_overlay.dart';
import 'widgets/mission_round_view.dart';
import 'widgets/resume_pre_step_view.dart';

/// B3 — Mission session runner page. Mirrors web `mission-session-page.tsx` +
/// `mission-session-runner.tsx`: fetches today's mission, drives the
/// `resumePreStep → inRound → completed` engine (whole rounds, dispatched to
/// the shared P4 practice views), then shows [MissionCompleteOverlay] before
/// returning to the Learn Hub. No AppBar — web runs this as a bare
/// full-screen scroll surface with in-engine progress UI only.
class MissionSessionPage extends ConsumerWidget {
  const MissionSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(missionSessionProvider);
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return session.when(
      loading: () => Scaffold(
        backgroundColor: tokens.background,
        body: const LoadingView(),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: tokens.background,
        body: ErrorView(
          message: l10n.couldNotLoadTodayLesson,
          onRetry: () => ref.invalidate(missionSessionProvider),
        ),
      ),
      data: (state) {
        switch (state.status) {
          case MissionRunnerStatus.resumePreStep:
            return ResumePreStepView(
              items: state.mission.resumeItems,
              onContinue: () =>
                  ref.read(missionSessionProvider.notifier).completeResumeStep(),
            );

          case MissionRunnerStatus.inRound:
            final items = state.currentRoundItems;
            final game = state.currentGame;
            if (items.isEmpty || game == null) {
              return _EmptyMissionView(onGoHome: () => context.go('/learn'));
            }
            return Scaffold(
              backgroundColor: tokens.background,
              body: SafeArea(
                child: Stack(
                  children: [
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.destructive.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            missionSessionErrorMessage(l10n, state.error) ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: tokens.destructive,
                            ),
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: MissionRoundView(
                        key: ValueKey(state.roundIndex),
                        items: items,
                        game: game,
                        onComplete: (results) => ref
                            .read(missionSessionProvider.notifier)
                            .submitRoundResults(results),
                      ),
                    ),
                    if (state.submitting)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 24,
                        child: Center(
                          child: Text(
                            l10n.saving,
                            style: TextStyle(
                              fontSize: 12,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );

          case MissionRunnerStatus.completed:
            if (!state.hasRounds && state.result == null) {
              return _EmptyMissionView(onGoHome: () => context.go('/learn'));
            }
            final result = state.result;
            final climbedAsync = ref.watch(weeklyRecapProvider);
            return Scaffold(
              backgroundColor: tokens.background,
              body: MissionCompleteOverlay(
                xpEarned: result?.xpAwarded ?? state.mission.xpEarned,
                streakUpdated: result?.streakUpdated ?? false,
                climbed: climbedAsync.maybeWhen(
                  data: (recap) => recap.climbed
                      .map(
                        (c) => MissionClimbedEntry(
                          label: c.label,
                          isStructure: c.kind == 'structure',
                          fromRung: c.fromRung,
                          toRung: c.toRung,
                        ),
                      )
                      .toList(),
                  orElse: () => const [],
                ),
                onDone: () => context.go('/learn'),
              ),
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
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.noMissionRounds,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: tokens.mutedForeground),
                ),
                const SizedBox(height: 16),
                AppButton(label: l10n.backToHome, onPressed: onGoHome),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
