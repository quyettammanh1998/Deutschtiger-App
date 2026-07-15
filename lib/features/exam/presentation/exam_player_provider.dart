// ignore_for_file: prefer_initializing_formals
//
// Exam player state (Riverpod notifier) — GĐ1.
//
// Port logic từ web `hooks/exam/useExamAttempt.ts` + `useExamTimer.ts`:
//   - Timer đếm ngược theo từng section (hoặc toàn đề nếu timed).
//   - Autosave local sau 5s để resume mà không ghi rác vào attempt history.
//   - Practice mode: xem đáp án ngay; Test mode: nộp khi hết giờ / submit.
//   - Review mode: highlight đúng/sai, đọc từ attempt đã nộp.
//   - Hören: enforce max_plays qua [Question.audioPlays] mutable.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../view_models/providers.dart';
import '../data/exam_service.dart';
import '../data/exam_attempt_store.dart';
import '../domain/exam_models.dart';

/// State đầy đủ của player.
@immutable
class ExamPlayerState {
  const ExamPlayerState({
    required this.exam,
    required this.mode,
    required this.timed,
    required this.currentSection,
    required this.currentQuestion,
    required this.answers,
    required this.audioPlays,
    required this.elapsedSeconds,
    required this.startedAt,
    this.draftId,
    this.draftVersion,
    this.submitted = false,
    this.submitting = false,
    this.syncError = false,
    this.lastAutosaveAt,
  });

  final Exam exam;
  final ExamMode mode;
  final bool timed;

  /// Index section hiện tại (0-based).
  final int currentSection;

  /// Index câu hỏi trong section hiện tại (0-based).
  final int currentQuestion;

  /// Map questionId → user answer.
  final Map<String, String> answers;

  /// Map questionId → số lần đã phát audio.
  final Map<String, int> audioPlays;

  /// Tổng giây đã trôi qua kể từ khi bắt đầu.
  final int elapsedSeconds;

  final DateTime startedAt;
  final String? draftId;
  final int? draftVersion;
  final bool submitted;
  final bool submitting;
  final bool syncError;
  final DateTime? lastAutosaveAt;

  ExamSection get currentSectionObj => exam.sections[currentSection];
  ExamQuestion get currentQuestionObj =>
      currentSectionObj.questions[currentQuestion];

  /// Tổng câu đã trả lời (để hiển thị palette).
  int get answeredCount =>
      exam.allQuestions.where((q) => answers.containsKey(q.answerKey)).length;

  /// Tổng câu của đề.
  int get totalQuestions => exam.totalQuestions;

  /// Index tuyệt đối của câu hiện tại trong danh sách allQuestions.
  int get currentGlobalIndex {
    int idx = 0;
    for (var i = 0; i < currentSection; i++) {
      idx += exam.sections[i].questionCount;
    }
    return idx + currentQuestion;
  }

  ExamPlayerState copyWith({
    int? currentSection,
    int? currentQuestion,
    Map<String, String>? answers,
    Map<String, int>? audioPlays,
    int? elapsedSeconds,
    bool? submitted,
    bool? submitting,
    bool? syncError,
    DateTime? lastAutosaveAt,
    String? draftId,
    int? draftVersion,
  }) => ExamPlayerState(
    exam: exam,
    mode: mode,
    timed: timed,
    currentSection: currentSection ?? this.currentSection,
    currentQuestion: currentQuestion ?? this.currentQuestion,
    answers: answers ?? this.answers,
    audioPlays: audioPlays ?? this.audioPlays,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    startedAt: startedAt,
    draftId: draftId ?? this.draftId,
    draftVersion: draftVersion ?? this.draftVersion,
    submitted: submitted ?? this.submitted,
    submitting: submitting ?? this.submitting,
    syncError: syncError ?? this.syncError,
    lastAutosaveAt: lastAutosaveAt ?? this.lastAutosaveAt,
  );
}

/// Notifier chính — lưu state, tick timer, autosave, submit.
class ExamPlayerNotifier extends StateNotifier<ExamPlayerState> {
  ExamPlayerNotifier({
    required Exam exam,
    required ExamMode mode,
    required bool timed,
    required ExamAttemptStore attemptStore,
    ExamProgressSnapshot? progress,
    ExamAttempt? reviewAttempt,
    Duration tickInterval = const Duration(seconds: 1),
    int? timeLimitSeconds,
  }) : _attemptStore = attemptStore,
       _tickInterval = tickInterval,
       _timeLimitSeconds = timeLimitSeconds,
       super(
         ExamPlayerState(
           exam: exam,
           mode: mode,
           timed: timed,
           currentSection: _safeSectionIndex(exam, progress?.currentSection),
           currentQuestion: _safeQuestionIndex(
             exam,
             progress?.currentSection,
             progress?.currentQuestion,
           ),
           answers: reviewAttempt?.answers ?? progress?.answers ?? const {},
           audioPlays: progress?.audioPlays ?? const {},
           elapsedSeconds:
               reviewAttempt?.elapsedSeconds ?? progress?.elapsedSeconds ?? 0,
           startedAt:
               reviewAttempt?.startedAt ??
               progress?.startedAt ??
               DateTime.now(),
           draftId: progress?.draftId,
           draftVersion: progress?.draftVersion,
         ),
       ) {
    if (mode != ExamMode.review) _startTicker();
  }

  final ExamAttemptStore _attemptStore;
  final Duration _tickInterval;
  final int? _timeLimitSeconds;
  Timer? _ticker;
  Timer? _autosaveTimer;
  Future<ExamAttempt>? _submitFuture;

  static const _autosaveDelay = Duration(seconds: 5);

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(_tickInterval, (_) {
      if (!mounted || state.submitted) return;
      final elapsed = state.elapsedSeconds + 1;
      state = state.copyWith(elapsedSeconds: elapsed);
      final limit = _timeLimitSeconds ?? state.exam.totalDurationMinutes * 60;
      if (state.timed && limit > 0 && elapsed >= limit) {
        unawaited(submit());
      }
    });
  }

  void _scheduleAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(_autosaveDelay, _autosave);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _autosaveTimer?.cancel();
    if (!state.submitted && state.mode != ExamMode.review) {
      unawaited(_autosave());
    }
    super.dispose();
  }

  // ===== Navigation =====

  void goToQuestion({int? section, int? question}) {
    final nextSection = _safeSectionIndex(
      state.exam,
      section ?? state.currentSection,
    );
    final nextQuestion = _safeQuestionIndex(
      state.exam,
      nextSection,
      question ?? (section == null ? state.currentQuestion : 0),
    );
    state = state.copyWith(
      currentSection: nextSection,
      currentQuestion: nextQuestion,
    );
    _scheduleAutosave();
  }

  void goToGlobalIndex(int globalIdx) {
    int remaining = globalIdx;
    for (var s = 0; s < state.exam.sections.length; s++) {
      final sec = state.exam.sections[s];
      if (remaining < sec.questionCount) {
        state = state.copyWith(currentSection: s, currentQuestion: remaining);
        _scheduleAutosave();
        return;
      }
      remaining -= sec.questionCount;
    }
  }

  void nextQuestion() {
    final sec = state.currentSectionObj;
    if (state.currentQuestion < sec.questionCount - 1) {
      state = state.copyWith(currentQuestion: state.currentQuestion + 1);
      _scheduleAutosave();
      return;
    }
    if (state.currentSection < state.exam.sections.length - 1) {
      state = state.copyWith(
        currentSection: state.currentSection + 1,
        currentQuestion: 0,
      );
      _scheduleAutosave();
    }
  }

  void previousQuestion() {
    if (state.currentQuestion > 0) {
      state = state.copyWith(currentQuestion: state.currentQuestion - 1);
      _scheduleAutosave();
      return;
    }
    if (state.currentSection > 0) {
      final prevSecIdx = state.currentSection - 1;
      state = state.copyWith(
        currentSection: prevSecIdx,
        currentQuestion: state.exam.sections[prevSecIdx].questionCount - 1,
      );
      _scheduleAutosave();
    }
  }

  // ===== Answer / Audio =====

  void setAnswer(String questionId, String answer) {
    if (state.mode == ExamMode.review || state.submitted) return;
    state = state.copyWith(answers: {...state.answers, questionId: answer});
    _scheduleAutosave();
  }

  void clearAnswer(String questionId) {
    if (state.mode == ExamMode.review || state.submitted) return;
    final next = {...state.answers}..remove(questionId);
    state = state.copyWith(answers: next);
    _scheduleAutosave();
  }

  /// Tăng play count cho Hören. Trả về true nếu được phép play.
  bool registerAudioPlay(String questionId) {
    if (state.mode == ExamMode.review || state.submitted) return false;
    final current = state.audioPlays[questionId] ?? 0;
    final q = state.exam.allQuestions.firstWhere(
      (q) => q.answerKey == questionId,
    );
    if (q.audioMaxPlays > 0 && current >= q.audioMaxPlays) return false;
    state = state.copyWith(
      audioPlays: {...state.audioPlays, questionId: current + 1},
    );
    _scheduleAutosave();
    return true;
  }

  int playsFor(String questionId) => state.audioPlays[questionId] ?? 0;

  Future<void> saveProgressNow() => _autosave();

  // ===== Submit =====

  Future<ExamAttempt> submit() async {
    if (_submitFuture != null) return _submitFuture!;
    _submitFuture = _submitOnce();
    return _submitFuture!;
  }

  Future<ExamAttempt> _submitOnce() async {
    if (state.submitted) return _buildAttempt();
    final attempt = _buildAttempt();
    state = state.copyWith(submitting: true);
    _ticker?.cancel();
    _autosaveTimer?.cancel();
    final outcome = await _attemptStore.submit(
      state.exam,
      attempt,
      draftId: state.draftId,
      draftVersion: state.draftVersion,
    );
    final retryServerSubmit = !outcome.synced && state.draftId != null;
    if (mounted) {
      state = state.copyWith(
        submitting: false,
        submitted: !retryServerSubmit,
        syncError: !outcome.synced,
      );
      if (retryServerSubmit) {
        _submitFuture = null;
        _startTicker();
      }
    }
    return outcome.attempt;
  }

  ExamAttempt _buildAttempt() {
    var score = 0;
    var correctAnswers = 0;
    final sectionCorrect = <String, int>{};
    final sectionPoints = <String, int>{};
    for (final section in state.exam.sections) {
      var correctInSection = 0;
      var pointsInSection = 0;
      for (final question in section.questions) {
        final answer = state.answers[question.answerKey];
        if (answer != null && _isCorrect(question, answer)) {
          correctAnswers++;
          correctInSection++;
          score += question.points;
          pointsInSection += question.points;
        }
      }
      sectionCorrect[section.kind.name] = correctInSection;
      sectionPoints[section.kind.name] = pointsInSection;
    }
    final passedOverall = score >= (state.exam.totalPoints * 0.6).ceil();
    final passedSections =
        state.exam.provider != 'telc' ||
        state.exam.sections.every((section) {
          final max = section.questions.fold<int>(
            0,
            (sum, q) => sum + q.points,
          );
          return max == 0 ||
              (sectionPoints[section.kind.name] ?? 0) >= (max * 0.6).ceil();
        });
    return ExamAttempt(
      examId: state.exam.id,
      mode: state.mode,
      answers: state.answers,
      elapsedSeconds: state.elapsedSeconds,
      startedAt: state.startedAt,
      submittedAt: DateTime.now(),
      score: score,
      maxScore: state.exam.totalPoints,
      passed: passedOverall && passedSections,
      correctAnswers: correctAnswers,
      sectionCorrect: sectionCorrect,
    );
  }

  bool _isCorrect(ExamQuestion q, String userAnswer) {
    switch (q.type) {
      case QuestionType.mc:
      case QuestionType.anzeigen:
        return userAnswer == q.correctOptionId;
      case QuestionType.richtigFalsch:
        return (userAnswer == 'true') == (q.correctBoolean ?? false);
      case QuestionType.sprachbausteine:
        final userIdx = userAnswer
            .split(',')
            .map(int.tryParse)
            .whereType<int>()
            .toList();
        if (userIdx.length != q.gapPositions.length) return false;
        for (var i = 0; i < userIdx.length; i++) {
          if (userIdx[i] != q.gapPositions[i]) return false;
        }
        return true;
      case QuestionType.matching:
        final pairs = userAnswer.split(',');
        if (pairs.length != q.correctMatches.length) return false;
        for (final pair in pairs) {
          final parts = pair.split(':');
          if (parts.length != 2) return false;
          final left = int.tryParse(parts[0]);
          final right = int.tryParse(parts[1]);
          if (left == null || right == null) return false;
          if (q.correctMatches[left] != right) return false;
        }
        return true;
    }
  }

  Future<void> _autosave() async {
    if (state.submitted || state.mode == ExamMode.review) return;
    final saved = await _attemptStore.saveProgress(
      state.exam.id,
      ExamProgressSnapshot(
        answers: state.answers,
        audioPlays: state.audioPlays,
        currentSection: state.currentSection,
        currentQuestion: state.currentQuestion,
        elapsedSeconds: state.elapsedSeconds,
        startedAt: state.startedAt,
        draftId: state.draftId,
        draftVersion: state.draftVersion,
      ),
    );
    if (mounted) {
      state = state.copyWith(
        draftId: saved.draftId,
        draftVersion: saved.draftVersion,
        lastAutosaveAt: DateTime.now(),
      );
    }
  }
}

int _safeSectionIndex(Exam exam, int? requested) {
  if (exam.sections.isEmpty) return 0;
  return (requested ?? 0).clamp(0, exam.sections.length - 1);
}

int _safeQuestionIndex(Exam exam, int? section, int? requested) {
  if (exam.sections.isEmpty) return 0;
  final safeSection = _safeSectionIndex(exam, section);
  final count = exam.sections[safeSection].questionCount;
  if (count == 0) return 0;
  return (requested ?? 0).clamp(0, count - 1);
}

// ===== Providers =====

/// Mode lấy từ queryParam (`?mode=practice|test|review`), mặc định practice.
ExamMode parseMode(String? raw) {
  switch (raw) {
    case 'test':
      return ExamMode.test;
    case 'review':
      return ExamMode.review;
    default:
      return ExamMode.practice;
  }
}

/// Service gọi BE thật (`/exams/{slug}` + `/exams/{slug}/parts/{id}`) và map
/// JSON → [Exam]. Xem `exam_service.dart` cho chi tiết mapping + giới hạn.
final examServiceProvider = Provider<ExamService>((ref) {
  return ExamService(ref.watch(apiClientProvider));
});

/// Provider fetch exam theo slug từ BE thật.
final examByIdProvider = FutureProvider.family<Exam, String>((ref, id) async {
  final service = ref.watch(examServiceProvider);
  return service.fetchExam(id);
});

final examCatalogProvider = FutureProvider<List<ExamCatalogItem>>((ref) {
  return ref.watch(examServiceProvider).listExamSets();
});

final examAttemptStoreProvider = Provider<ExamAttemptStore>((ref) {
  return ExamAttemptStore(ref.watch(apiClientProvider));
});

final examResultProvider = FutureProvider.family<ExamAttempt?, String>((
  ref,
  examId,
) {
  return ref.watch(examAttemptStoreProvider).loadResult(examId);
});

class ExamPlayerBootstrap {
  const ExamPlayerBootstrap({required this.exam, this.progress, this.result});

  final Exam exam;
  final ExamProgressSnapshot? progress;
  final ExamAttempt? result;
}

final examPlayerBootstrapProvider = FutureProvider.autoDispose
    .family<ExamPlayerBootstrap, ExamPlayerKey>((ref, key) async {
      final exam = await ref.watch(examByIdProvider(key.examId).future);
      final store = ref.watch(examAttemptStoreProvider);
      final progress = key.mode == ExamMode.review
          ? null
          : await store.loadProgress(key.examId, mode: key.mode, exam: exam);
      final result = key.mode == ExamMode.review
          ? await store.loadResult(key.examId)
          : null;
      return ExamPlayerBootstrap(
        exam: exam,
        progress: progress,
        result: result,
      );
    });

/// Provider khởi tạo player state cho 1 attempt.
///
/// CHỈ được watch sau khi [examPlayerBootstrapProvider] đã có data (page
/// phải gate loading/error trước) — `requireValue` sẽ throw nếu chưa sẵn
/// sàng, đây là hành vi có chủ đích để tránh silent fallback về dữ liệu giả.
final examPlayerProvider = StateNotifierProvider.autoDispose
    .family<ExamPlayerNotifier, ExamPlayerState, ExamPlayerKey>((ref, key) {
      final bootstrap = ref
          .watch(examPlayerBootstrapProvider(key))
          .requireValue;
      return ExamPlayerNotifier(
        exam: bootstrap.exam,
        mode: key.mode,
        timed: key.timed,
        attemptStore: ref.watch(examAttemptStoreProvider),
        progress: bootstrap.progress,
        reviewAttempt: bootstrap.result,
      );
    });

/// Khóa khởi tạo player.
@immutable
class ExamPlayerKey {
  const ExamPlayerKey({
    required this.examId,
    required this.mode,
    required this.timed,
  });

  final String examId;
  final ExamMode mode;
  final bool timed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamPlayerKey &&
          examId == other.examId &&
          mode == other.mode &&
          timed == other.timed;

  @override
  int get hashCode => Object.hash(examId, mode, timed);
}
