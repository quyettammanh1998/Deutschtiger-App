// ignore_for_file: prefer_initializing_formals
//
// D4 — Exam player (GĐ1: Lesen + Hören).
//
// Player full-screen cho exam practice/test/review với:
//   - Header: mode toggle + timer + close
//   - Section tabs (Lesen / Hören)
//   - Question palette (drawer/scroll)
//   - Audio player (Hören, max_plays enforcement)
//   - Question renderer theo type (MC / matching / richtig-falsch /
//     sprachbausteine / anzeigen)
//   - Explanation (practice/review only)
//   - Navigation bar: prev / next / submit

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/exam_design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/minimal_shell.dart';
import '../domain/exam_models.dart';
import 'exam_player_provider.dart';
import 'widgets/exam_audio_player.dart';
import 'widgets/exam_dialogs.dart';
import 'widgets/exam_explanation_card.dart';
import 'widgets/exam_mode_toggle.dart';
import 'widgets/exam_progress_bar.dart';
import 'widgets/exam_section_tabs.dart';
import 'widgets/exam_timer.dart';
import 'widgets/question_palette.dart';
import 'widgets/question_renderer.dart';

class ExamPracticePage extends ConsumerWidget {
  const ExamPracticePage({
    super.key,
    required this.examId,
    this.timed = false,
    this.mode = ExamMode.practice,
  });

  final String examId;
  final bool timed;
  final ExamMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final key = ExamPlayerKey(examId: examId, mode: mode, timed: timed);
    final bootstrap = ref.watch(examPlayerBootstrapProvider(key));
    return bootstrap.when(
      loading: () => MinimalShell(
        backgroundColor: ExamDesignTokens.examPaperColor,
        title: l10n.loadingExam,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => MinimalShell(
        backgroundColor: ExamDesignTokens.examPaperColor,
        title: l10n.examPractice,
        child: Center(child: Text(l10n.couldNotLoadExams)),
      ),
      data: (_) => _ExamPracticeView(examId: examId, timed: timed, mode: mode),
    );
  }
}

class _ExamPracticeView extends ConsumerStatefulWidget {
  const _ExamPracticeView({
    required this.examId,
    required this.timed,
    required this.mode,
  });

  final String examId;
  final bool timed;
  final ExamMode mode;

  @override
  ConsumerState<_ExamPracticeView> createState() => _ExamPracticeViewState();
}

class _ExamPracticeViewState extends ConsumerState<_ExamPracticeView> {
  bool _paletteOpen = false;

  ExamPlayerKey get _key => ExamPlayerKey(
    examId: widget.examId,
    mode: widget.mode,
    timed: widget.timed,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(examPlayerProvider(_key).select((state) => state.submitted), (
      previous,
      submitted,
    ) {
      if (submitted && previous != true && mounted) {
        ref.invalidate(examResultProvider(widget.examId));
        context.go('/exam/result/${widget.examId}');
      }
    });
    final state = ref.watch(examPlayerProvider(_key));
    final notifier = ref.read(examPlayerProvider(_key).notifier);
    final showCorrectness = widget.mode != ExamMode.test;

    return MinimalShell(
      title: state.exam.title,
      backgroundColor: ExamDesignTokens.examPaperColor,
      actions: [
        IconButton(
          icon: Icon(_paletteOpen ? Icons.grid_off : Icons.grid_on),
          tooltip: l10n.examQuestionPalette,
          onPressed: () => setState(() => _paletteOpen = !_paletteOpen),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.close,
          onPressed: () async {
            final shouldExit = await showExitExamDialog(context);
            if (!shouldExit) return;
            await notifier.saveProgressNow();
            if (!context.mounted) return;
            context.pop();
          },
        ),
      ],
      child: Column(
        children: [
          _TopBar(state: state, onChangeMode: _switchMode),
          ExamSectionTabs(
            sections: state.exam.sections,
            currentSection: state.currentSection,
            answeredIds: state.answers.keys.toSet(),
            onTap: (sectionIdx) => notifier.goToQuestion(section: sectionIdx),
          ),
          Expanded(
            child: Stack(
              children: [
                _QuestionView(
                  state: state,
                  showCorrectness: showCorrectness,
                  onAnswer: notifier.setAnswer,
                  onConsumeAudio: notifier.registerAudioPlay,
                ),
                if (_paletteOpen)
                  _PaletteOverlay(
                    questions: state.exam.allQuestions,
                    answeredIds: state.answers.keys.toSet(),
                    currentGlobalIndex: state.currentGlobalIndex,
                    onPick: (idx) {
                      notifier.goToGlobalIndex(idx);
                      setState(() => _paletteOpen = false);
                    },
                    onClose: () => setState(() => _paletteOpen = false),
                  ),
              ],
            ),
          ),
          _BottomNav(
            state: state,
            onPrev: notifier.previousQuestion,
            onNext: notifier.nextQuestion,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (widget.mode == ExamMode.review) {
      context.go('/exam/result/${widget.examId}');
      return;
    }
    final state = ref.read(examPlayerProvider(_key));
    final unanswered = state.exam.totalQuestions - state.answeredCount;
    if (!await showSubmitExamDialog(context, unanswered)) return;
    final notifier = ref.read(examPlayerProvider(_key).notifier);
    await notifier.submit();
  }

  void _switchMode(ExamMode newMode) {
    if (newMode == widget.mode) return;
    final uri = Uri(
      path: '/exam/practice/${widget.examId}',
      queryParameters: {
        if (widget.timed) 'timed': 'true',
        'mode': newMode.name,
      },
    );
    context.push(uri.toString());
  }
}

// ===== Sub-widgets =====

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.onChangeMode});

  final ExamPlayerState state;
  final ValueChanged<ExamMode> onChangeMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ExamDesignTokens.examPadding,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: ExamDesignTokens.examBorder)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ExamModeToggle(mode: state.mode, onChange: onChangeMode),
              const Spacer(),
              ExamTimer(
                elapsedSeconds: state.elapsedSeconds,
                totalSeconds: state.exam.totalDurationMinutes * 60,
                showCountdown: state.timed && state.mode != ExamMode.review,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          ExamProgressBar(
            answered: state.answeredCount,
            total: state.totalQuestions,
            label: l10n.examQuestionProgress(
              state.currentGlobalIndex + 1,
              state.totalQuestions,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.state,
    required this.showCorrectness,
    required this.onAnswer,
    required this.onConsumeAudio,
  });

  final ExamPlayerState state;
  final bool showCorrectness;
  final void Function(String questionId, String answer) onAnswer;
  final bool Function(String questionId) onConsumeAudio;

  @override
  Widget build(BuildContext context) {
    final q = state.currentQuestionObj;
    final section = state.currentSectionObj;
    final answer = state.answers[q.answerKey];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ExamDesignTokens.examPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (q.hasAudio)
            ExamAudioPlayer(
              key: ValueKey(q.id),
              audioUrl: q.audioUrl!,
              playsUsed: state.audioPlays[q.answerKey] ?? 0,
              maxPlays: q.audioMaxPlays,
              onPlayConsumed: () => onConsumeAudio(q.answerKey),
            ),
          if (q.hasAudio) const SizedBox(height: DesignTokens.spacingMd),
          IgnorePointer(
            ignoring: state.mode == ExamMode.review,
            child: QuestionRenderer(
              question: q,
              questionNumber: state.currentGlobalIndex + 1,
              sectionLabel: '${section.kind.labelDe} · ${section.kind.labelVi}',
              answer: answer,
              onChange: (value) => onAnswer(q.answerKey, value),
              showCorrectness: showCorrectness,
            ),
          ),
          if (showCorrectness && answer != null) ...[
            const SizedBox(height: DesignTokens.spacingMd),
            ExamExplanationCard(question: q, userAnswer: answer),
          ],
          const SizedBox(height: DesignTokens.bottomNavHeight),
        ],
      ),
    );
  }
}

class _PaletteOverlay extends StatelessWidget {
  const _PaletteOverlay({
    required this.questions,
    required this.answeredIds,
    required this.currentGlobalIndex,
    required this.onPick,
    required this.onClose,
  });

  final List<ExamQuestion> questions;
  final Set<String> answeredIds;
  final int currentGlobalIndex;
  final ValueChanged<int> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ExamDesignTokens.examPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(DesignTokens.radiusLg),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.examQuestionPalette,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: ExamDesignTokens.examActiveStrong,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  QuestionPalette(
                    questions: questions,
                    answeredIds: answeredIds,
                    currentGlobalIndex: currentGlobalIndex,
                    onTap: onPick,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.state,
    required this.onPrev,
    required this.onNext,
    required this.onSubmit,
  });

  final ExamPlayerState state;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  bool get _isLastQuestion {
    final sec = state.currentSectionObj;
    return state.currentSection == state.exam.sections.length - 1 &&
        state.currentQuestion == sec.questionCount - 1;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canPrev = state.currentSection > 0 || state.currentQuestion > 0;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ExamDesignTokens.examPadding,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: ExamDesignTokens.examBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canPrev ? onPrev : null,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: Text(l10n.previous),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ExamDesignTokens.examActiveStrong,
                  side: const BorderSide(color: ExamDesignTokens.examBorder),
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: _isLastQuestion
                  ? ElevatedButton.icon(
                      onPressed: onSubmit,
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(
                        state.mode == ExamMode.review
                            ? l10n.done
                            : l10n.submitExam,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ExamDesignTokens.examSuccess,
                        foregroundColor: Colors.white,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: onNext,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(l10n.next),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ExamDesignTokens.examActive,
                        foregroundColor: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
