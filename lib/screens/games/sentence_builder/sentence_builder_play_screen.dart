import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/games/sentence_builder_models.dart';
import '../../../data/learn/learn_models.dart';
import '../../../view_models/games/sentence_builder_provider.dart';
import '../../../view_models/learn/learn_provider.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/common/game_shell.dart';
import 'widgets/sentence_builder_play_body.dart';
import 'widgets/sentence_builder_results_view.dart';

/// Phiên chơi Sentence Builder: tạo session live từ topic đã chọn (hoặc chủ
/// đề ngẫu nhiên), chấm từng câu qua `gradeSentence` (tái dùng
/// [LearnRepository] — endpoint `/ai/grade-sentence` dùng chung), rồi
/// `completeSession` khi xong. Route: `/games/sentence-builder/play?level=&topicId=`.
///
/// GameShell adoption (P7b): exit-guard while a session is in progress
/// (web: `usePracticeExitGuard`), confetti completion card
/// ([SentenceBuilderResultsView]) instead of a plain white card.
class SentenceBuilderPlayScreen extends ConsumerStatefulWidget {
  const SentenceBuilderPlayScreen({
    super.key,
    required this.level,
    this.topicId,
  });

  final String level;
  final String? topicId;

  @override
  ConsumerState<SentenceBuilderPlayScreen> createState() =>
      _SentenceBuilderPlayScreenState();
}

class _SentenceBuilderPlayScreenState
    extends ConsumerState<SentenceBuilderPlayScreen> {
  late Future<SentenceBuilderSession> _sessionFuture;
  final _controller = TextEditingController();

  int _index = 0;
  bool _submitting = false;
  bool _submitError = false;
  GradeSentenceResult? _feedback;
  final List<SentenceBuilderResult> _results = [];

  @override
  void initState() {
    super.initState();
    _sessionFuture = _createSession();
  }

  Future<SentenceBuilderSession> _createSession() {
    return ref
        .read(sentenceBuilderRepositoryProvider)
        .createSession(level: widget.level, topicId: widget.topicId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(SentenceBuilderSessionWord word) async {
    final sentence = _controller.text.trim();
    if (_submitting || sentence.length < 3) return;
    setState(() {
      _submitting = true;
      _submitError = false;
    });
    try {
      final result = await ref
          .read(learnRepositoryProvider)
          .gradeSentence(
            promptWord: word.contentDe,
            promptMeaning: word.contentVi,
            userSentence: sentence,
            userLevel: widget.level,
            targetBlocks: const [],
          );
      if (!mounted) return;
      setState(() => _feedback = result);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitError = true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _next(SentenceBuilderSession session) {
    final word = session.words[_index];
    final feedback = _feedback;
    _results.add(
      SentenceBuilderResult(
        itemId: word.id,
        word: word.contentDe,
        score: feedback?.score ?? 0,
        skipped: feedback == null,
      ),
    );
    _controller.clear();
    final isLast = _index + 1 >= session.words.length;
    if (isLast) {
      _completeSession(session);
      setState(() => _index = session.words.length);
    } else {
      setState(() {
        _index++;
        _feedback = null;
        _submitError = false;
      });
    }
  }

  void _completeSession(SentenceBuilderSession session) {
    final graded = _results.where((r) => !r.skipped).toList();
    final avgScore = graded.isEmpty
        ? 0.0
        : graded.map((r) => r.score).reduce((a, b) => a + b) / graded.length;
    ref
        .read(sentenceBuilderRepositoryProvider)
        .completeSession(
          session.sessionId,
          completedWords: graded.length,
          averageScore: avgScore,
        )
        .catchError((_) {
          // Kết quả cục bộ vẫn hiển thị dù ghi nhận backend thất bại.
        });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _feedback = null;
      _submitError = false;
      _results.clear();
      _sessionFuture = _createSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SentenceBuilderSession>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return GameShell(
            title: 'Viết câu AI',
            exitGuard: false,
            child: const LoadingView(),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return GameShell(
            title: 'Viết câu AI',
            exitGuard: false,
            child: ErrorView(
              onRetry: () => setState(() => _sessionFuture = _createSession()),
            ),
          );
        }
        final session = snapshot.data!;
        if (session.words.isEmpty) {
          return GameShell(
            title: 'Viết câu AI',
            exitGuard: false,
            child: const ErrorView(
              message: 'Không có từ nào khả dụng cho chủ đề này.',
            ),
          );
        }
        final finished = _index >= session.words.length;
        return GameShell(
          title: session.topic.labelVi,
          exitGuard: !finished,
          scrollable: false,
          child: finished
              ? SentenceBuilderResultsView(
                  results: _results,
                  topic: session.topic,
                  onPlayAgain: _restart,
                  onBack: () => context.pop(),
                )
              : SentenceBuilderPlayBody(
                  session: session,
                  index: _index,
                  controller: _controller,
                  feedback: _feedback,
                  submitting: _submitting,
                  submitError: _submitError,
                  onSubmit: () => _submit(session.words[_index]),
                  onNext: () => _next(session),
                ),
        );
      },
    );
  }
}
