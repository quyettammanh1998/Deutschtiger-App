import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../domain/schreiben_grading_result.dart';
import '../domain/writing_submission.dart';

/// Live repository backing [WritingPracticePanel] — web parity
/// `schreiben-ai-grading-service.ts` + `use-writing-submissions.ts` +
/// `use-writing-grading-attempts.ts`. Every call goes through [ApiClient]
/// (Bearer auth, device headers, error normalization) — no raw Dio use.
///
/// Contract verified against `thamkhao/deutschtiger-backend`
/// (`internal/shared/aihttp/ai_grading_handler.go`,
/// `internal/feature/exam/exam/exam_user_writing_handler.go`) — see
/// `docs/flutter-api-contract-matrix.md` "Writing / Schreiben".
class WritingRepository {
  const WritingRepository(this._api);

  final ApiClient _api;

  /// `POST /ai/grade-schreiben`. Server bounds the call at 60s; this passes
  /// through [ApiClient]'s default timeout — a hang surfaces as
  /// [AiUnavailableException] like web's client-side 70s ceiling.
  Future<SchreibenGradingResult> gradeSchreiben({
    required String taskPrompt,
    required List<String> writingPoints,
    required String studentAnswer,
    required String level,
    String examType = 'goethe',
    int? teil,
  }) async {
    try {
      final data = await _api.post<Map<String, dynamic>>(
        '/ai/grade-schreiben',
        body: {
          'taskPrompt': taskPrompt,
          'writingPoints': writingPoints,
          'studentAnswer': studentAnswer,
          'level': level,
          'examType': examType,
          if (teil != null) 'teil': teil.toString(),
        },
      );
      final result = SchreibenGradingResult.fromJson(data);
      if (result.summary.isEmpty && result.feedback.isEmpty) {
        throw AiUnavailableException('AI trả về kết quả không hợp lệ');
      }
      return result;
    } on ApiException catch (e) {
      throw _toAiException(e);
    }
  }

  /// `POST /ai/rewrite-schreiben` — full corrected text, fetched lazily.
  Future<String> rewriteSchreiben({
    required String studentAnswer,
    required String level,
    String? taskPrompt,
    List<String>? writingPoints,
    bool regenerate = false,
  }) async {
    try {
      final data = await _api.post<Map<String, dynamic>>(
        '/ai/rewrite-schreiben',
        body: {
          'studentAnswer': studentAnswer,
          'level': level,
          'taskPrompt': ?taskPrompt,
          'writingPoints': ?writingPoints,
          'regenerate': regenerate,
        },
      );
      final correctedText = data['correctedText'];
      if (correctedText is! String) {
        throw AiUnavailableException('AI trả về kết quả không hợp lệ');
      }
      return correctedText;
    } on ApiException catch (e) {
      throw _toAiException(e);
    }
  }

  /// `POST /user/writing-submissions` — returns the new submission id.
  Future<String> createSubmission({
    required String examId,
    required String taskPrompt,
    required String studentAnswer,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/user/writing-submissions',
      body: {
        'exam_id': examId,
        'task_prompt': taskPrompt,
        'student_answer': studentAnswer,
        'ai_score': null,
        'ai_feedback': null,
        'submitted_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
    final id = data['id']?.toString();
    if (id == null || id.isEmpty) {
      throw ApiException('Server không trả về id bài nộp');
    }
    return id;
  }

  /// `GET /user/writing-submissions?exam_id=`.
  Future<List<WritingSubmission>> listSubmissions(String examId) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/user/writing-submissions',
      query: {'exam_id': examId},
    );
    final rows = data['submissions'];
    if (rows is! List) return const [];
    return rows
        .whereType<Map>()
        .map((e) => WritingSubmission.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// `POST /user/writing-submissions/{id}/gradings` — records one grading
  /// attempt (history) and returns its id.
  Future<String> createGradingAttempt(
    String submissionId,
    SchreibenGradingResult result,
  ) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/user/writing-submissions/$submissionId/gradings',
      body: {'ai_score': result.score, 'ai_feedback': result.toJson()},
    );
    final id = data['id']?.toString();
    if (id == null || id.isEmpty) {
      throw ApiException('Server không trả về id lần chấm');
    }
    return id;
  }

  /// `GET /user/writing-submissions/{id}/gradings` — newest first.
  Future<List<WritingGradingAttempt>> listGradingAttempts(
    String submissionId,
  ) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/user/writing-submissions/$submissionId/gradings',
    );
    final rows = data['attempts'];
    if (rows is! List) return const [];
    return rows
        .whereType<Map>()
        .map(
          (e) => WritingGradingAttempt.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  /// Maps a transport-level [ApiException] to [AiUnavailableException] for
  /// timeouts/502/503/`ai_unavailable`, matching web's retry-with-cooldown
  /// branch; everything else stays a plain [ApiException] surfaced as-is.
  Exception _toAiException(ApiException e) {
    final status = e.statusCode;
    final msg = e.message.toLowerCase();
    if (status == 502 ||
        status == 503 ||
        msg.contains('ai_unavailable') ||
        msg.contains('timeout') ||
        msg.contains('quá lâu')) {
      return AiUnavailableException(e.message);
    }
    return e;
  }
}

final writingRepositoryProvider = Provider<WritingRepository>((ref) {
  return WritingRepository(ref.watch(apiClientProvider));
});
