// ignore_for_file: prefer_initializing_formals
//
// D4/Wave B — Exam player mobile rebuild (web parity).
//
// Web source of truth: `exam-practice-page.tsx` + `components/exam/mobile/*`
// (`mobile-test-layout.tsx`/`mobile-practice-layout.tsx` "section-screen
// mode" — luôn hiển thị TRỌN 1 Teil trên màn thay vì 1 câu/màn). Shell:
// compact header (progress bar cam, pace dot, "Nộp bài" xanh) → whole-Teil
// scroll body → footer (prev/next 32px xanh + counter pill hổ phách mở nav
// sheet) → nav sheet nhóm theo Teil.
//
// KHÔNG đổi contract draft/attempt (`exam_player_provider.dart`,
// `exam_attempt_store.dart`) — chỉ rebuild UI theo đúng yêu cầu wave B.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/exam_models.dart';
import 'exam_player_provider.dart';
import 'widgets/exam_dialogs.dart';
import 'widgets/mobile_player/exam_practice_header.dart';
import 'widgets/mobile_player/mobile_footer_bar.dart';
import 'widgets/mobile_player/mobile_nav_sheet.dart';
import 'widgets/mobile_player/mobile_question_panel.dart';

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
    final tokens = context.tokens;
    final key = ExamPlayerKey(examId: examId, mode: mode, timed: timed);
    final bootstrap = ref.watch(examPlayerBootstrapProvider(key));
    return bootstrap.when(
      loading: () => Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(
                  l10n.loadingExam,
                  style: TextStyle(color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(child: Center(child: Text(l10n.couldNotLoadExams))),
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
  ExamPlayerKey get _key => ExamPlayerKey(
    examId: widget.examId,
    mode: widget.mode,
    timed: widget.timed,
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
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
    final section = state.currentSectionObj;
    final sectionLabel = '${section.kind.labelDe} · ${section.kind.labelVi}';
    final totalSections = state.exam.sections.length;
    final progressPercent = state.totalQuestions == 0
        ? 0.0
        : state.answeredCount / state.totalQuestions * 100;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _exit(notifier);
      },
      child: Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: Column(
            children: [
              ExamPracticeHeader(
                mode: widget.mode,
                title: sectionLabel,
                progressPercent: progressPercent,
                currentDisplayNumber: state.currentSection + 1,
                answerableCount: totalSections,
                onExit: () => _exit(notifier),
                onBackToResult: widget.mode == ExamMode.review
                    ? () => context.go('/exam/result/${widget.examId}')
                    : null,
                onSubmit: widget.mode == ExamMode.test ? _submit : null,
                elapsedSeconds: state.elapsedSeconds,
                totalDurationSeconds: state.timed
                    ? state.exam.totalDurationMinutes * 60
                    : null,
                currentSectionIndex: state.currentSection,
                totalSections: totalSections,
              ),
              Expanded(
                child: MobileQuestionPanel(
                  key: ValueKey(state.currentSection),
                  section: section,
                  sectionLabel: sectionLabel,
                  sectionOffset: state.currentSectionQuestionOffset,
                  mode: widget.mode,
                  answers: state.answers,
                  audioPlays: state.audioPlays,
                  onAnswer: notifier.setAnswer,
                  onConsumeAudio: notifier.registerAudioPlay,
                  correctByKey: widget.mode == ExamMode.test
                      ? null
                      : state.correctByAnswerKey,
                  commentsExamId: widget.mode == ExamMode.review
                      ? widget.examId
                      : null,
                ),
              ),
              MobileFooterBar(
                canGoPrev: state.currentSection > 0,
                canGoNext: state.currentSection < totalSections - 1,
                currentDisplayNumber: state.currentSection + 1,
                answerableCount: totalSections,
                sectionLabel: sectionLabel,
                onPrev: () => notifier.goToQuestion(
                  section: state.currentSection - 1,
                  question: 0,
                ),
                onNext: () => notifier.goToQuestion(
                  section: state.currentSection + 1,
                  question: 0,
                ),
                onToggleNav: () => showMobileNavSheet(
                  context,
                  sections: state.exam.sections,
                  currentGlobalIndex: state.currentGlobalIndex,
                  answeredKeys: state.answers.keys.toSet(),
                  mode: widget.mode,
                  correctByKey: widget.mode == ExamMode.test
                      ? null
                      : state.correctByAnswerKey,
                  onNavigate: notifier.goToGlobalIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exit(ExamPlayerNotifier notifier) async {
    if (widget.mode != ExamMode.test) {
      if (!mounted) return;
      context.pop();
      return;
    }
    final shouldExit = await showExitExamDialog(context);
    if (!shouldExit) return;
    await notifier.saveProgressNow();
    if (!mounted) return;
    context.pop();
  }

  Future<void> _submit() async {
    final state = ref.read(examPlayerProvider(_key));
    final unanswered = state.exam.totalQuestions - state.answeredCount;
    if (!await showSubmitExamDialog(context, unanswered)) return;
    final notifier = ref.read(examPlayerProvider(_key).notifier);
    await notifier.submit();
  }
}
