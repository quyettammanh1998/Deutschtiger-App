// Whole-Teil scroll body — web `mobile-question-panel.tsx` (section-screen
// mode): renders ALL questions of the CURRENT Teil in one scrollable column,
// instead of 1-question-per-screen. Reading-pane translate toggle + comments
// (review mode) live here too.
import 'package:flutter/material.dart';

import '../../../../../core/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/exam_models.dart';
import '../exam_audio_player.dart';
import '../exam_explanation_card.dart';
import '../question_renderer.dart';
import 'exam_reading_translate_card.dart';
import 'exam_comment_section.dart';

class MobileQuestionPanel extends StatelessWidget {
  const MobileQuestionPanel({
    super.key,
    required this.section,
    required this.sectionLabel,
    required this.sectionOffset,
    required this.mode,
    required this.answers,
    required this.audioPlays,
    required this.onAnswer,
    required this.onConsumeAudio,
    this.correctByKey,
    this.commentsExamId,
  });

  final ExamSection section;
  final String sectionLabel;
  final int sectionOffset;
  final ExamMode mode;
  final Map<String, String> answers;
  final Map<String, int> audioPlays;
  final void Function(String questionId, String answer) onAnswer;
  final bool Function(String questionId) onConsumeAudio;

  /// Chỉ có ở review mode — dùng cho border đúng/sai + explanation card.
  final Map<String, bool>? correctByKey;

  /// Khi non-null (review mode), gắn `CommentSection` cuối Teil.
  final String? commentsExamId;

  bool get _showCorrectness => mode != ExamMode.test;
  bool get _readOnly => mode == ExamMode.review;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < section.questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
              child: _QuestionBlock(
                question: section.questions[i],
                questionNumber: sectionOffset + i + 1,
                sectionLabel: sectionLabel,
                answer: answers[section.questions[i].answerKey],
                onChange: (v) => onAnswer(section.questions[i].answerKey, v),
                onConsumeAudio: onConsumeAudio,
                playsUsed: audioPlays[section.questions[i].answerKey] ?? 0,
                showCorrectness: _showCorrectness,
                readOnly: _readOnly,
                isCorrect: correctByKey?[section.questions[i].answerKey],
              ),
            ),
          if (commentsExamId != null) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            ExamCommentSection(examId: commentsExamId!),
          ],
          const SizedBox(height: DesignTokens.bottomNavHeight),
        ],
      ),
    );
  }
}

class _QuestionBlock extends StatelessWidget {
  const _QuestionBlock({
    required this.question,
    required this.questionNumber,
    required this.sectionLabel,
    required this.answer,
    required this.onChange,
    required this.onConsumeAudio,
    required this.playsUsed,
    required this.showCorrectness,
    required this.readOnly,
    this.isCorrect,
  });

  final ExamQuestion question;
  final int questionNumber;
  final String sectionLabel;
  final String? answer;
  final ValueChanged<String> onChange;
  final bool Function(String questionId) onConsumeAudio;
  final int playsUsed;
  final bool showCorrectness;
  final bool readOnly;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (question.descriptionVi != null)
          ExamReadingTranslateCard(
            title: l10n.examReadingPaneTitle,
            translation: question.descriptionVi!,
          ),
        if (question.hasAudio) ...[
          ExamAudioPlayer(
            key: ValueKey(question.id),
            audioUrl: question.audioUrl!,
            playsUsed: playsUsed,
            maxPlays: question.audioMaxPlays,
            onPlayConsumed: () => onConsumeAudio(question.answerKey),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],
        IgnorePointer(
          ignoring: readOnly,
          child: QuestionRenderer(
            question: question,
            questionNumber: questionNumber,
            sectionLabel: sectionLabel,
            answer: answer,
            onChange: onChange,
            showCorrectness: showCorrectness,
          ),
        ),
        if (showCorrectness && answer != null) ...[
          const SizedBox(height: DesignTokens.spacingMd),
          ExamExplanationCard(question: question, userAnswer: answer!),
        ],
      ],
    );
  }
}
