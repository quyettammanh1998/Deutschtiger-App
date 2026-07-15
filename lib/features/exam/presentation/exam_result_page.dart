// ignore_for_file: prefer_initializing_formals
//
// D5 — Exam result screen.
//
// Tính điểm từ attempt đã lưu khi submit và áp dụng ngưỡng từng provider.
//
// UI dùng ExamDesignTokens (xanh/emerald/red/yellow riêng cho exam).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/exam_design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/minimal_shell.dart';
import '../domain/exam_models.dart';
import 'exam_player_provider.dart';

class ExamResultPage extends ConsumerWidget {
  const ExamResultPage({super.key, required this.examId});
  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final examAsync = ref.watch(examByIdProvider(examId));
    final resultAsync = ref.watch(examResultProvider(examId));
    return MinimalShell(
      title: l10n.examResults,
      showBack: false,
      backgroundColor: ExamDesignTokens.examPaperColor,
      actions: [
        TextButton(
          onPressed: () => context.go('/exam'),
          child: Text(l10n.done),
        ),
      ],
      child: examAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.couldNotLoadExamResult)),
        data: (exam) => resultAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.couldNotLoadExamResult)),
          data: (attempt) => attempt == null
              ? Center(child: Text(l10n.noExamResult))
              : _ResultBody(exam: exam, attempt: attempt),
        ),
      ),
    );
  }
}

class _ResultBody extends StatelessWidget {
  const _ResultBody({required this.exam, required this.attempt});

  final Exam exam;
  final ExamAttempt attempt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ExamDesignTokens.examPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OverallCard(
            exam: exam,
            score: attempt.score,
            maxScore: attempt.maxScore,
            passed: attempt.passed,
            answeredCount: attempt.answers.length,
            totalSeconds: attempt.elapsedSeconds,
          ),
          const SizedBox(height: ExamDesignTokens.examSectionGap),
          _SectionBreakdown(exam: exam, attempt: attempt),
          const SizedBox(height: ExamDesignTokens.examSectionGap),
          _Actions(exam: exam),
          const SizedBox(height: ExamDesignTokens.examSectionGap),
        ],
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({
    required this.exam,
    required this.score,
    required this.maxScore,
    required this.passed,
    required this.answeredCount,
    required this.totalSeconds,
  });

  final Exam exam;
  final int score;
  final int maxScore;
  final bool passed;
  final int answeredCount;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ratio = maxScore == 0 ? 0.0 : score / maxScore;
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ExamDesignTokens.examBorder),
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ExamDesignTokens.examTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${exam.provider.toUpperCase()} · ${exam.level.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ExamDesignTokens.examTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingXs,
                ),
                decoration: BoxDecoration(
                  color:
                      (passed
                              ? ExamDesignTokens.examAnswerCorrectColor
                              : ExamDesignTokens.examAnswerWrongColor)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  passed ? l10n.passedExam : l10n.notPassedExam,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: passed
                        ? ExamDesignTokens.examAnswerCorrectColor
                        : ExamDesignTokens.examAnswerWrongColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: CircularProgressIndicator(
                          value: ratio,
                          strokeWidth: 8,
                          backgroundColor: ExamDesignTokens.examBorder,
                          valueColor: AlwaysStoppedAnimation(
                            passed
                                ? ExamDesignTokens.examAnswerCorrectColor
                                : ExamDesignTokens.examAnswerWrongColor,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$score',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: ExamDesignTokens.examTextPrimary,
                              ),
                            ),
                            Text(
                              '/$maxScore',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ExamDesignTokens.examTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spacingLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatLine(
                      icon: Icons.check_circle,
                      label: l10n.examAnswered,
                      value: l10n.examAnsweredQuestions(
                        answeredCount,
                        exam.totalQuestions,
                      ),
                      color: ExamDesignTokens.examActive,
                    ),
                    const SizedBox(height: DesignTokens.spacingSm),
                    _StatLine(
                      icon: Icons.timer_outlined,
                      label: l10n.examTime,
                      value:
                          '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                      color: ExamDesignTokens.examActiveStrong,
                    ),
                    const SizedBox(height: DesignTokens.spacingSm),
                    _StatLine(
                      icon: Icons.percent,
                      label: l10n.examCorrectRate,
                      value: '${(ratio * 100).toStringAsFixed(0)}%',
                      color: passed
                          ? ExamDesignTokens.examAnswerCorrectColor
                          : ExamDesignTokens.examAnswerWrongColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: DesignTokens.spacingSm),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ExamDesignTokens.examTextSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SectionBreakdown extends StatelessWidget {
  const _SectionBreakdown({required this.exam, required this.attempt});
  final Exam exam;
  final ExamAttempt attempt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(ExamDesignTokens.examCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ExamDesignTokens.examBorder),
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.examSectionAnalysis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ExamDesignTokens.examActiveStrong,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          for (final section in exam.sections)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              child: _SectionRow(
                section: section,
                correct: attempt.sectionCorrect[section.kind.name] ?? 0,
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.section, required this.correct});
  final ExamSection section;
  final int correct;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isListening = section.isListening;
    final icon = isListening ? Icons.headphones : Icons.menu_book;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ExamDesignTokens.examActiveSoft,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
          child: Icon(icon, size: 18, color: ExamDesignTokens.examActiveStrong),
        ),
        const SizedBox(width: DesignTokens.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isListening
                    ? l10n.examSectionListening
                    : l10n.examSectionReading,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ExamDesignTokens.examTextPrimary,
                ),
              ),
              Text(
                l10n.examSectionSummary(
                  correct,
                  section.questionCount,
                  section.durationMinutes,
                ),
                style: const TextStyle(
                  fontSize: 11,
                  color: ExamDesignTokens.examTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.exam});
  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                context.push('/exam/practice/${exam.id}?mode=review'),
            icon: const Icon(Icons.replay, size: 16),
            label: Text(l10n.reviewExam),
            style: OutlinedButton.styleFrom(
              foregroundColor: ExamDesignTokens.examActiveStrong,
              side: const BorderSide(color: ExamDesignTokens.examBorder),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () =>
                context.push('/exam/practice/${exam.id}?mode=practice'),
            icon: const Icon(Icons.refresh, size: 16),
            label: Text(l10n.retryExam),
            style: ElevatedButton.styleFrom(
              backgroundColor: ExamDesignTokens.examActive,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
