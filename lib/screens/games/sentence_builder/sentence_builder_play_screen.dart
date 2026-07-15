import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/games/sentence_builder_models.dart';
import '../../../data/learn/learn_models.dart';
import '../../../view_models/games/sentence_builder_provider.dart';
import '../../../view_models/learn/learn_provider.dart';
import '../../../widgets/common/async_state_views.dart';

/// Phiên chơi Sentence Builder: tạo session live từ topic đã chọn (hoặc chủ
/// đề ngẫu nhiên), chấm từng câu qua `gradeSentence` (tái dùng
/// [LearnRepository] — endpoint `/ai/grade-sentence` dùng chung), rồi
/// `completeSession` khi xong. Route: `/games/sentence-builder/play?level=&topicId=`.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Viết câu AI'),
      ),
      body: FutureBuilder<SentenceBuilderSession>(
        future: _sessionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return ErrorView(
              onRetry: () => setState(() => _sessionFuture = _createSession()),
            );
          }
          final session = snapshot.data!;
          if (session.words.isEmpty) {
            return const ErrorView(
              message: 'Không có từ nào khả dụng cho chủ đề này.',
            );
          }
          if (_index >= session.words.length) {
            return _ResultsView(
              results: _results,
              topic: session.topic,
              onPlayAgain: () => setState(() {
                _index = 0;
                _feedback = null;
                _submitError = false;
                _results.clear();
                _sessionFuture = _createSession();
              }),
              onBack: () => context.pop(),
            );
          }
          return _PlayBody(
            session: session,
            index: _index,
            controller: _controller,
            feedback: _feedback,
            submitting: _submitting,
            submitError: _submitError,
            onSubmit: () => _submit(session.words[_index]),
            onNext: () => _next(session),
          );
        },
      ),
    );
  }
}

class _PlayBody extends StatelessWidget {
  const _PlayBody({
    required this.session,
    required this.index,
    required this.controller,
    required this.feedback,
    required this.submitting,
    required this.submitError,
    required this.onSubmit,
    required this.onNext,
  });

  final SentenceBuilderSession session;
  final int index;
  final TextEditingController controller;
  final GradeSentenceResult? feedback;
  final bool submitting;
  final bool submitError;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final word = session.words[index];
    final total = session.words.length;
    final showNext = feedback != null || submitError;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Câu ${index + 1} / $total · ${session.topic.labelVi}',
            style: const TextStyle(color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: index / total,
            color: AppColors.tigerOrange,
            backgroundColor: AppColors.muted,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    word.contentDe,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.contentVi,
                    style: const TextStyle(color: AppColors.mutedForeground),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Viết câu có từ "${word.contentDe}":'),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sentence-builder-input'),
            controller: controller,
            maxLines: 3,
            enabled: feedback == null && !submitting,
            decoration: const InputDecoration(
              hintText: 'Nhập câu tiếng Đức...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          if (submitting)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('Đang chấm...'),
                ],
              ),
            ),
          if (feedback != null) _FeedbackCard(feedback: feedback!),
          if (submitError)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Không thể chấm bài. Vui lòng thử lại.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 16),
          if (!showNext)
            FilledButton(
              onPressed: submitting ? null : onSubmit,
              child: const Text('Kiểm tra'),
            )
          else
            FilledButton(
              key: const Key('sentence-builder-next'),
              onPressed: onNext,
              child: Text(index + 1 >= total ? 'Xem kết quả' : 'Tiếp tục'),
            ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.feedback});

  final GradeSentenceResult feedback;

  @override
  Widget build(BuildContext context) {
    final good = feedback.score >= 70;
    return Card(
      color: good
          ? Colors.green.withValues(alpha: 0.08)
          : Colors.amber.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${feedback.score}/100',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (feedback.summaryVi.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(feedback.summaryVi),
            ],
            if (feedback.correctedSentence.isNotEmpty &&
                !good) ...[
              const SizedBox(height: 6),
              Text(
                '"${feedback.correctedSentence}"',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.results,
    required this.topic,
    required this.onPlayAgain,
    required this.onBack,
  });

  final List<SentenceBuilderResult> results;
  final SentenceBuilderSessionTopic topic;
  final VoidCallback onPlayAgain;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final graded = results.where((r) => !r.skipped).toList();
    final avg = graded.isEmpty
        ? 0
        : (graded.map((r) => r.score).reduce((a, b) => a + b) /
                graded.length)
            .round();
    final goodCount = graded.where((r) => r.score >= 70).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Hoàn thành!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Chủ đề: ${topic.labelVi}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatBox(value: '${graded.length}', label: 'Câu đã làm'),
              _StatBox(value: '$goodCount', label: 'Câu đạt'),
              _StatBox(value: '$avg%', label: 'Điểm TB'),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: onPlayAgain, child: const Text('Chơi lại')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: onBack, child: const Text('Chọn chủ đề khác')),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: AppColors.mutedForeground)),
      ],
    );
  }
}
