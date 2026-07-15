import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../services/api_client.dart';
import '../domain/exam_models.dart';

class ExamProgressSnapshot {
  const ExamProgressSnapshot({
    required this.answers,
    required this.audioPlays,
    required this.currentSection,
    required this.currentQuestion,
    required this.elapsedSeconds,
    required this.startedAt,
    this.draftId,
    this.draftVersion,
  });

  final Map<String, String> answers;
  final Map<String, int> audioPlays;
  final int currentSection;
  final int currentQuestion;
  final int elapsedSeconds;
  final DateTime startedAt;
  final String? draftId;
  final int? draftVersion;

  Map<String, dynamic> toJson() => {
    'answers': answers,
    'audio_plays': audioPlays,
    'current_section': currentSection,
    'current_question': currentQuestion,
    'elapsed_seconds': elapsedSeconds,
    'started_at': startedAt.toIso8601String(),
    'draft_id': draftId,
    'draft_version': draftVersion,
  };

  factory ExamProgressSnapshot.fromJson(Map<String, dynamic> json) {
    return ExamProgressSnapshot(
      answers: _stringMap(json['answers']),
      audioPlays: _intMap(json['audio_plays']),
      currentSection: _int(json['current_section']),
      currentQuestion: _int(json['current_question']),
      elapsedSeconds: _int(json['elapsed_seconds']),
      startedAt:
          DateTime.tryParse(json['started_at']?.toString() ?? '') ??
          DateTime.now(),
      draftId: (json['draft_id'] ?? json['id']) as String?,
      draftVersion: (json['draft_version'] ?? json['version']) is num
          ? ((json['draft_version'] ?? json['version']) as num).toInt()
          : int.tryParse(
              (json['draft_version'] ?? json['version'])?.toString() ?? '',
            ),
    );
  }

  ExamProgressSnapshot copyWith({String? draftId, int? draftVersion}) =>
      ExamProgressSnapshot(
        answers: answers,
        audioPlays: audioPlays,
        currentSection: currentSection,
        currentQuestion: currentQuestion,
        elapsedSeconds: elapsedSeconds,
        startedAt: startedAt,
        draftId: draftId ?? this.draftId,
        draftVersion: draftVersion ?? this.draftVersion,
      );
}

class ExamSubmitOutcome {
  const ExamSubmitOutcome({required this.attempt, required this.synced});

  final ExamAttempt attempt;
  final bool synced;
}

class ExamAttemptStore {
  const ExamAttemptStore(this._api);

  final ApiClient _api;

  static String _progressKey(String examId) => 'exam-progress-$examId';
  static String _resultKey(String examId) => 'exam-result-$examId';

  Future<ExamProgressSnapshot?> loadProgress(
    String examId, {
    ExamMode? mode,
    Exam? exam,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final local = _decode(
      prefs.getString(_progressKey(examId)),
      ExamProgressSnapshot.fromJson,
      onCorrupt: () => prefs.remove(_progressKey(examId)),
    );
    if (mode == null) return _reconcileAndPersist(examId, local, exam);
    try {
      final draft = await _api.post<Map<String, dynamic>>(
        '/user/exam-drafts',
        body: {'exam_id': examId, 'mode': mode.name},
      );
      final remote = ExamProgressSnapshot.fromJson(draft);
      final restored = remote.answers.isEmpty && local != null
          ? local.copyWith(
              draftId: remote.draftId,
              draftVersion: remote.draftVersion,
            )
          : remote;
      final reconciled = _reconcileProgress(restored, exam);
      await prefs.setString(
        _progressKey(examId),
        jsonEncode(reconciled.toJson()),
      );
      return reconciled;
    } catch (_) {
      return _reconcileAndPersist(examId, local, exam);
    }
  }

  Future<ExamProgressSnapshot?> _reconcileAndPersist(
    String examId,
    ExamProgressSnapshot? snapshot,
    Exam? exam,
  ) async {
    if (snapshot == null) return null;
    final reconciled = _reconcileProgress(snapshot, exam);
    if (!identical(reconciled, snapshot)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _progressKey(examId),
        jsonEncode(reconciled.toJson()),
      );
    }
    return reconciled;
  }

  /// Migrates old display-id maps to canonical content references. A display
  /// id reused across sections is deliberately dropped rather than guessing.
  ExamProgressSnapshot _reconcileProgress(
    ExamProgressSnapshot snapshot,
    Exam? exam,
  ) {
    if (exam == null) return snapshot;
    final questionsById = <String, List<ExamQuestion>>{};
    final validKeys = <String>{};
    for (final question in exam.allQuestions) {
      validKeys.add(question.answerKey);
      questionsById.putIfAbsent(question.id, () => []).add(question);
    }

    Map<String, T> reconcileMap<T>(Map<String, T> source) {
      final reconciled = <String, T>{};
      for (final entry in source.entries) {
        if (validKeys.contains(entry.key)) {
          reconciled[entry.key] = entry.value;
          continue;
        }
        final matches = questionsById[entry.key];
        if (matches?.length == 1) {
          reconciled[matches!.single.answerKey] = entry.value;
        }
      }
      return reconciled;
    }

    final answers = reconcileMap(snapshot.answers);
    final audioPlays = reconcileMap(snapshot.audioPlays);
    if (_mapsEqual(answers, snapshot.answers) &&
        _mapsEqual(audioPlays, snapshot.audioPlays)) {
      return snapshot;
    }
    return ExamProgressSnapshot(
      answers: answers,
      audioPlays: audioPlays,
      currentSection: snapshot.currentSection,
      currentQuestion: snapshot.currentQuestion,
      elapsedSeconds: snapshot.elapsedSeconds,
      startedAt: snapshot.startedAt,
      draftId: snapshot.draftId,
      draftVersion: snapshot.draftVersion,
    );
  }

  Future<ExamProgressSnapshot> saveProgress(
    String examId,
    ExamProgressSnapshot snapshot,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey(examId), jsonEncode(snapshot.toJson()));
    if (snapshot.draftId == null || snapshot.draftVersion == null) {
      return snapshot;
    }
    try {
      final draft = await _api.patch<Map<String, dynamic>>(
        '/user/exam-drafts/${snapshot.draftId}',
        body: {
          'version': snapshot.draftVersion,
          'mutation_id': Uuid().v4(),
          'answers': snapshot.answers,
          'audio_plays': snapshot.audioPlays,
          'current_section': snapshot.currentSection,
          'current_question': snapshot.currentQuestion,
          'elapsed_seconds': snapshot.elapsedSeconds,
        },
      );
      final synced = ExamProgressSnapshot.fromJson(draft);
      await prefs.setString(_progressKey(examId), jsonEncode(synced.toJson()));
      return synced;
    } catch (_) {
      return snapshot;
    }
  }

  Future<void> clearProgress(String examId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey(examId));
  }

  Future<ExamAttempt?> loadResult(String examId) async {
    final prefs = await SharedPreferences.getInstance();
    final local = _decode(
      prefs.getString(_resultKey(examId)),
      ExamAttempt.fromJson,
      onCorrupt: () => prefs.remove(_resultKey(examId)),
    );
    if (local != null) return local;

    try {
      final rows = await _api.get<List<dynamic>>(
        '/user/exam-attempts',
        query: {'exam_id': examId, 'limit': 1},
      );
      if (rows.isEmpty || rows.first is! Map) return null;
      final attempt = _attemptFromServer(
        Map<String, dynamic>.from(rows.first as Map),
      );
      await prefs.setString(_resultKey(examId), jsonEncode(attempt.toJson()));
      return attempt;
    } catch (_) {
      return null;
    }
  }

  /// Prefers the server-owned draft submit path. Old local snapshots retain the
  /// legacy writes until the additive draft endpoint has been deployed.
  Future<ExamSubmitOutcome> submit(
    Exam exam,
    ExamAttempt attempt, {
    String? draftId,
    int? draftVersion,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (draftId != null && draftVersion != null) {
      try {
        final response = await _api.post<Map<String, dynamic>>(
          '/user/exam-drafts/$draftId/submit',
          body: {'version': draftVersion, 'mutation_id': Uuid().v4()},
        );
        final serverAttempt = _attemptFromServer(response);
        await prefs.setString(
          _resultKey(exam.id),
          jsonEncode(serverAttempt.toJson()),
        );
        await prefs.remove(_progressKey(exam.id));
        return ExamSubmitOutcome(attempt: serverAttempt, synced: true);
      } catch (_) {
        // Preserve the local snapshot; the user can retry server submission.
        return ExamSubmitOutcome(attempt: attempt, synced: false);
      }
    }

    await prefs.setString(_resultKey(exam.id), jsonEncode(attempt.toJson()));
    await prefs.remove(_progressKey(exam.id));

    final body = _submissionBody(exam, attempt);
    var synced = true;
    try {
      await _api.post<Map<String, dynamic>>(
        '/user/exam-attempts',
        body: {...body, 'mode': attempt.mode.name},
      );
    } catch (_) {
      synced = false;
    }
    try {
      await _api.post<Map<String, dynamic>>('/user/exam-results', body: body);
    } catch (_) {
      synced = false;
    }
    return ExamSubmitOutcome(attempt: attempt, synced: synced);
  }

  Map<String, dynamic> _submissionBody(Exam exam, ExamAttempt attempt) {
    final total = exam.totalQuestions;
    final unanswered = (total - attempt.answers.length).clamp(0, total);
    final wrong = (total - attempt.correctAnswers - unanswered).clamp(0, total);
    final percent = attempt.maxScore == 0
        ? 0
        : ((attempt.score / attempt.maxScore) * 100).round();
    return {
      'exam_id': attempt.examId,
      'total_questions': total,
      'correct_answers': attempt.correctAnswers,
      'wrong_answers': wrong,
      'unanswered': unanswered,
      'score': percent,
      'time_taken': attempt.elapsedSeconds,
      'answers': attempt.answers,
      'submitted_at': attempt.submittedAt!.toUtc().toIso8601String(),
    };
  }

  ExamAttempt _attemptFromServer(Map<String, dynamic> json) {
    final scorePercent = _int(json['score']).clamp(0, 100);
    return ExamAttempt(
      examId: json['exam_id'] as String? ?? '',
      mode: ExamMode.values.firstWhere(
        (mode) => mode.name == json['mode'],
        orElse: () => ExamMode.test,
      ),
      answers: _stringMap(json['answers']),
      elapsedSeconds: _int(json['time_taken']),
      startedAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.tryParse(json['submitted_at']?.toString() ?? '') ??
          DateTime.now(),
      submittedAt: DateTime.tryParse(json['submitted_at']?.toString() ?? ''),
      score: scorePercent,
      maxScore: 100,
      passed: scorePercent >= 60,
      correctAnswers: _int(json['correct_answers']),
    );
  }
}

T? _decode<T>(
  String? raw,
  T Function(Map<String, dynamic>) parser, {
  required void Function() onCorrupt,
}) {
  if (raw == null) return null;
  try {
    return parser(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    onCorrupt();
    return null;
  }
}

Map<String, String> _stringMap(Object? raw) => raw is Map
    ? raw.map((key, value) => MapEntry(key.toString(), value.toString()))
    : {};

Map<String, int> _intMap(Object? raw) => raw is Map
    ? raw.map((key, value) => MapEntry(key.toString(), _int(value)))
    : {};

int _int(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _mapsEqual<T>(Map<String, T> left, Map<String, T> right) {
  if (left.length != right.length) return false;
  for (final entry in left.entries) {
    if (right[entry.key] != entry.value) return false;
  }
  return true;
}
