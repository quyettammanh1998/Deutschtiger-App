import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../data/writing_draft_store.dart';
import '../data/writing_repository.dart';
import '../domain/schreiben_grading_result.dart';
import 'widgets/practice_editor_card.dart';
import 'widgets/writing_history_sheet.dart';

/// Full writing-practice flow shared by every Schreiben surface (Goethe B1
/// official topics, community topics, telc, "tự nhập" custom prompts, …) —
/// web parity `src/components/writing/writing-practice-panel.tsx`.
///
/// ## Public API (stable — W2/W3/W4 wrap this without touching its internals)
///
/// Required:
/// - [examId]: stable, namespaced persistence key for drafts/submissions/
///   grading-attempt history (e.g. `goethe-b1-writing:teil1:mein-hobby`).
///   Callers own the namespacing scheme; this widget just uses it as an
///   opaque string key for the draft store + `WritingRepository` calls.
/// - [taskPromptDe]: the German task prompt sent to the AI grader.
/// - [writingPoints]: the German bullet points the answer must address
///   (also sent to the AI grader for on-topic rewrite generation).
///
/// Optional (all have web-parity defaults):
/// - [level] (`'B1'`), [provider] (`'goethe'`|`'telc'` — selects the AI
///   grading rubric/grade scale), [teilNum] (1-3, grading context only).
/// - [footer]: extra content rendered below the editor (web: e.g.
///   "Ask AI about this topic" button) — W2+ wrapper pages use this instead
///   of forking the panel.
///
/// Deliberately NOT part of the public API (internal/W1 scope only):
/// save-to-deck wiring, community topic metadata, learning-activity time
/// tracking — none of these exist in the Flutter data layer yet; wrapper
/// pages that need them extend via [footer] rather than new panel params.
class WritingPracticePanel extends ConsumerStatefulWidget {
  const WritingPracticePanel({
    super.key,
    required this.examId,
    required this.taskPromptDe,
    required this.writingPoints,
    this.level = 'B1',
    this.provider = 'goethe',
    this.teilNum,
    this.footer,
  });

  final String examId;
  final String taskPromptDe;
  final List<String> writingPoints;
  final String level;

  /// `'goethe'` | `'telc'` — selects the AI grading rubric/grade scale.
  final String provider;

  /// 1-3 — Teil number for AI grading context, omitted for non-Goethe-B1
  /// writing (e.g. custom prompts, telc).
  final int? teilNum;

  /// Extra content rendered below the editor/history sheet trigger row
  /// (e.g. an "Ask AI about this topic" button in W2+ wrapper pages).
  final Widget? footer;

  @override
  ConsumerState<WritingPracticePanel> createState() => _WritingPracticePanelState();
}

class _WritingPracticePanelState extends ConsumerState<WritingPracticePanel> {
  late final WritingDraftStore _draftStore = WritingDraftStore(widget.examId);

  String _userText = '';
  bool _isSubmitted = false;
  String? _submissionId;
  bool _isSubmitting = false;
  String? _submitError;

  bool _isGrading = false;
  SchreibenGradingResult? _gradingResult;
  String? _gradingError;
  bool _isAiUnavailable = false;
  int _retryCooldown = 0;
  Timer? _cooldownTimer;

  String _rewriteText = '';
  String _rewriteSourceText = '';
  String? _rewriteError;
  bool _isRewriting = false;

  WritingDraft? _draft;
  bool _showRestorePrompt = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDraft());
  }

  Future<void> _loadDraft() async {
    final draft = await _draftStore.load();
    if (!mounted) return;
    setState(() {
      _draft = draft;
      if (draft != null && !_isSubmitted && _userText.isEmpty) _showRestorePrompt = true;
    });
  }

  @override
  void dispose() {
    _draftStore.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  WritingRepository get _repo => ref.read(writingRepositoryProvider);

  void _onTextChange(String text) {
    setState(() => _userText = text);
    if (!_isSubmitted) _draftStore.save(text);
  }

  Future<void> _onSubmit() async {
    if (_isSubmitting) return;
    setState(() {
      _submitError = null;
      _isSubmitting = true;
    });
    try {
      final id = await _repo.createSubmission(
        examId: widget.examId,
        taskPrompt: widget.taskPromptDe,
        studentAnswer: _userText,
      );
      await _draftStore.clear();
      if (!mounted) return;
      setState(() {
        _submissionId = id;
        _isSubmitted = true;
        _showRestorePrompt = false;
        _draft = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitError = _friendlySubmitError(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _friendlySubmitError(Object e) {
    final msg = e.toString();
    if (RegExp('401|403|unauth', caseSensitive: false).hasMatch(msg)) {
      return 'Phiên đăng nhập hết hạn. Đăng nhập lại rồi thử lại.';
    }
    if (RegExp('network|5\\d\\d', caseSensitive: false).hasMatch(msg)) {
      return 'Lỗi kết nối máy chủ. Vui lòng thử lại.';
    }
    return 'Không lưu được bài: $msg';
  }

  void _onEdit() {
    setState(() {
      _isSubmitted = false;
      _submissionId = null;
      _gradingError = null;
      _rewriteError = null;
      _submitError = null;
    });
  }

  Future<void> _onGrade() async {
    if (_userText.trim().isEmpty) return;
    setState(() {
      _isGrading = true;
      _gradingError = null;
      _gradingResult = null;
      _rewriteText = '';
      _rewriteSourceText = '';
      _rewriteError = null;
      _isAiUnavailable = false;
    });
    try {
      final result = await _repo.gradeSchreiben(
        taskPrompt: widget.taskPromptDe,
        writingPoints: widget.writingPoints,
        studentAnswer: _userText,
        level: widget.level,
        examType: widget.provider,
        teil: widget.teilNum,
      );
      if (!mounted) return;
      setState(() => _gradingResult = result);

      try {
        var sid = _submissionId;
        sid ??= await _repo.createSubmission(
          examId: widget.examId,
          taskPrompt: widget.taskPromptDe,
          studentAnswer: _userText,
        );
        await _repo.createGradingAttempt(sid, result);
        if (!mounted) return;
        setState(() => _submissionId = sid);
      } catch (persistErr) {
        if (!mounted) return;
        setState(() => _submitError = 'Đã chấm bài nhưng không lưu được lịch sử: $persistErr');
      }
    } on AiUnavailableException catch (e) {
      if (!mounted) return;
      setState(() {
        _isAiUnavailable = true;
        _gradingError = e.message;
        _retryCooldown = 30;
      });
      _cooldownTimer?.cancel();
      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted || _retryCooldown <= 1) {
          timer.cancel();
          if (mounted) setState(() => _retryCooldown = 0);
          return;
        }
        setState(() => _retryCooldown -= 1);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _gradingError = 'Lỗi chấm bài: $e');
    } finally {
      if (mounted) setState(() => _isGrading = false);
    }
  }

  Future<void> _onRewrite() async {
    if (_userText.trim().isEmpty || _isRewriting) return;
    final regenerate = _rewriteText.trim().isNotEmpty;
    setState(() {
      _isRewriting = true;
      _rewriteError = null;
    });
    try {
      final corrected = await _repo.rewriteSchreiben(
        studentAnswer: _userText,
        level: widget.level,
        taskPrompt: widget.taskPromptDe,
        writingPoints: widget.writingPoints,
        regenerate: regenerate,
      );
      if (!mounted) return;
      setState(() {
        _rewriteText = corrected;
        _rewriteSourceText = _userText;
        if (_gradingResult != null) {
          _gradingResult = _gradingResult!.copyWith(correctedText: corrected);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _rewriteError = e.toString());
    } finally {
      if (mounted) setState(() => _isRewriting = false);
    }
  }

  void _onUseRewrite() {
    if (_rewriteText.trim().isEmpty) return;
    setState(() {
      _userText = _rewriteText;
      _isSubmitted = false;
      _submissionId = null;
      _submitError = null;
      _rewriteError = null;
      _rewriteText = '';
      _rewriteSourceText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              // W1 left this a no-op (no `/luyen-viet` route existed yet);
              // now live per W3 — wiring completes W1 deviation #5.
              onPressed: () => context.push('/luyen-viet'),
              child: Text(
                l10n.writingMyEssaysLink,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ),
            IconButton(
              tooltip: l10n.writingHistoryTooltip,
              icon: Icon(AppPhosphorIcons.clockCounterClockwise, size: 20, color: tokens.mutedForeground),
              onPressed: () => WritingHistorySheet.show(context, examId: widget.examId),
            ),
          ],
        ),
        PracticeEditorCard(
          userText: _userText,
          isSubmitted: _isSubmitted,
          isSubmitting: _isSubmitting,
          isGrading: _isGrading,
          gradingResult: _gradingResult,
          gradingError: _gradingError,
          isAiUnavailable: _isAiUnavailable,
          retryCooldown: _retryCooldown,
          rewriteText: _rewriteText,
          rewriteSourceText: _rewriteSourceText,
          rewriteError: _rewriteError,
          isRewriting: _isRewriting,
          submitError: _submitError,
          draft: _draft,
          showRestorePrompt: _showRestorePrompt,
          onTextChange: _onTextChange,
          onSubmit: _onSubmit,
          onEdit: _onEdit,
          onGrade: _onGrade,
          onRewrite: _onRewrite,
          onUseRewrite: _onUseRewrite,
          onRestoreDraft: () {
            setState(() {
              _userText = _draft!.text;
              _showRestorePrompt = false;
            });
          },
          onDiscardDraft: () {
            unawaited(_draftStore.clear());
            setState(() {
              _draft = null;
              _showRestorePrompt = false;
            });
          },
          onDismissError: () => setState(() => _submitError = null),
          onDismissRewriteError: () => setState(() => _rewriteError = null),
        ),
        if (widget.footer != null) ...[const SizedBox(height: 12), widget.footer!],
      ],
    );
  }
}
