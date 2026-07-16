import 'schreiben_grading_result.dart';

/// One saved writing submission — web parity `WritingSubmission`
/// (`use-writing-submissions.ts`). Backend: `/user/writing-submissions`
/// (`exam_user_writing_handler.go`).
class WritingSubmission {
  const WritingSubmission({
    required this.id,
    required this.examId,
    required this.taskPrompt,
    required this.studentAnswer,
    required this.aiScore,
    required this.aiFeedback,
    required this.submittedAt,
  });

  final String id;
  final String examId;
  final String taskPrompt;
  final String studentAnswer;
  final int? aiScore;
  final SchreibenGradingResult? aiFeedback;
  final DateTime submittedAt;

  factory WritingSubmission.fromJson(Map<String, dynamic> json) {
    final feedback = json['ai_feedback'];
    return WritingSubmission(
      id: json['id']?.toString() ?? '',
      examId: json['exam_id']?.toString() ?? '',
      taskPrompt: json['task_prompt']?.toString() ?? '',
      studentAnswer: json['student_answer']?.toString() ?? '',
      aiScore: json['ai_score'] is num ? (json['ai_score'] as num).round() : null,
      aiFeedback: feedback is Map
          ? SchreibenGradingResult.fromJson(Map<String, dynamic>.from(feedback))
          : null,
      submittedAt:
          DateTime.tryParse(json['submitted_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

/// One AI grading attempt recorded against a [WritingSubmission] — web
/// parity `WritingGradingAttempt` (`use-writing-grading-attempts.ts`).
class WritingGradingAttempt {
  const WritingGradingAttempt({
    required this.id,
    required this.submissionId,
    required this.aiScore,
    required this.aiFeedback,
    required this.gradedAt,
  });

  final String id;
  final String submissionId;
  final int aiScore;
  final SchreibenGradingResult aiFeedback;
  final DateTime gradedAt;

  factory WritingGradingAttempt.fromJson(Map<String, dynamic> json) {
    final feedback = json['ai_feedback'];
    return WritingGradingAttempt(
      id: json['id']?.toString() ?? '',
      submissionId: json['submission_id']?.toString() ?? '',
      aiScore: json['ai_score'] is num ? (json['ai_score'] as num).round() : 0,
      aiFeedback: feedback is Map
          ? SchreibenGradingResult.fromJson(Map<String, dynamic>.from(feedback))
          : const SchreibenGradingResult(
              score: 0,
              grade: '',
              feedback: {},
              corrections: [],
              suggestions: [],
              summary: '',
            ),
      gradedAt: DateTime.tryParse(json['graded_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
