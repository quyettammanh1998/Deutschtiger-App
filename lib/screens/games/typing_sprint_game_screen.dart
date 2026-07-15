import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/games/typing_sprint_models.dart';
import '../../view_models/games/typing_sprint_provider.dart';
import '../../widgets/common/async_state_views.dart';

/// Typing Sprint game — gõ câu tiếng Đức trong 60 giây.
///
/// Nguồn câu: `GET /user/typing/sentences` (backend ưu tiên câu cá nhân hoá
/// từ `learning_items` của user, fallback bộ câu B1 tĩnh khi chưa đủ dữ
/// liệu). Kết quả gửi lên `POST /user/typing/results` khi kết thúc phiên —
/// backend tính XP (tối đa 50/phiên, 100/ngày) và trả lại `xpAwarded`.
class TypingSprintGameScreen extends ConsumerStatefulWidget {
  const TypingSprintGameScreen({super.key});

  @override
  ConsumerState<TypingSprintGameScreen> createState() =>
      _TypingSprintGameScreenState();
}

const _kRoundSeconds = 60;

class _TypingSprintGameScreenState
    extends ConsumerState<TypingSprintGameScreen> {
  late Future<List<TypingSentence>> _sentencesFuture;

  int _score = 0;
  int _correctWords = 0;
  int _wrongWords = 0;
  int _correctChars = 0;
  int _sentenceIndex = 0;
  int _timeLeft = _kRoundSeconds;
  bool _gameOver = false;
  int? _xpAwarded;
  bool _submitFailed = false;

  List<TypingSentence> _sentences = const [];
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _random = Random();
  Timer? _timer;
  bool _focusRequested = false;

  @override
  void initState() {
    super.initState();
    _sentencesFuture = _loadSentences();
  }

  Future<List<TypingSentence>> _loadSentences() {
    return ref.read(typingSprintRepositoryProvider).fetchSentences(count: 20);
  }

  void _startTimerIfNeeded() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });
  }

  TypingSentence get _currentSentence =>
      _sentences[_sentenceIndex % _sentences.length];

  void _checkSentence() {
    final typed = _controller.text.trim();
    final target = _currentSentence.de.trim();
    if (typed.isEmpty) return;
    if (typed.toLowerCase() != target.toLowerCase()) return;

    setState(() {
      _correctWords += _currentSentence.wordCount;
      _correctChars += target.length;
      _score += 10 + (_currentSentence.wordCount * 2);
      _sentenceIndex++;
      _controller.clear();
    });
  }

  void _skipSentence() {
    setState(() {
      _wrongWords += _currentSentence.wordCount;
      _sentenceIndex++;
      _controller.clear();
    });
  }

  Future<void> _endGame() async {
    _timer?.cancel();
    setState(() => _gameOver = true);

    final elapsedSec = (_kRoundSeconds - _timeLeft).clamp(30, 300);
    final totalWords = _correctWords + _wrongWords;
    final accuracy =
        totalWords > 0 ? (_correctWords / totalWords * 100) : 0.0;
    final minutes = elapsedSec / 60;
    final wpm = minutes > 0 ? (_correctWords / minutes).round() : 0;
    final cpm = minutes > 0 ? (_correctChars / minutes).round() : 0;

    try {
      final result = await ref
          .read(typingSprintRepositoryProvider)
          .submitResult(
            wpm: wpm,
            accuracy: accuracy,
            cpm: cpm,
            correctWords: _correctWords,
            wrongWords: _wrongWords,
            durationSec: elapsedSec,
          );
      if (!mounted) return;
      setState(() => _xpAwarded = result.xpAwarded);
    } catch (_) {
      // Kết quả cục bộ vẫn hiển thị dù ghi nhận backend thất bại.
      if (!mounted) return;
      setState(() => _submitFailed = true);
    }
  }

  void _restart() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _correctWords = 0;
      _wrongWords = 0;
      _correctChars = 0;
      _sentenceIndex = 0;
      _timeLeft = _kRoundSeconds;
      _gameOver = false;
      _xpAwarded = null;
      _submitFailed = false;
      _sentences = List.of(_sentences)..shuffle(_random);
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Typing Sprint'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _gameOver
          ? _buildResults()
          : FutureBuilder<List<TypingSentence>>(
              future: _sentencesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return ErrorView(
                    onRetry: () =>
                        setState(() => _sentencesFuture = _loadSentences()),
                  );
                }
                final sentences = snapshot.data!;
                if (sentences.isEmpty) {
                  return const ErrorView(
                    message: 'Chưa có câu nào để luyện gõ.',
                  );
                }
                _sentences = sentences;
                _startTimerIfNeeded();
                if (!_focusRequested) {
                  _focusRequested = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _focusNode.requestFocus();
                  });
                }
                return _buildGame();
              },
            ),
    );
  }

  Widget _buildGame() {
    final sentence = _currentSentence;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.lightBlue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.lightBlue),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeLeft <= 10 ? Colors.red : Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${_timeLeft}s',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$_correctWords',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                sentence.vi,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'gõ tiếng Đức:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                sentence.de,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.tigerOrange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: KeyboardListener(
            focusNode: _focusNode,
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                _checkSentence();
              }
            },
            child: TextField(
              key: const Key('typing-sprint-input'),
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Gõ câu ở đây...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.lightBlue.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.lightBlue.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: Colors.lightBlue, width: 2),
                ),
              ),
              onSubmitted: (_) => _checkSentence(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          key: const Key('typing-sprint-skip'),
          onPressed: _skipSentence,
          child: const Text('Bỏ qua câu này'),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildResults() {
    final totalWords = _correctWords + _wrongWords;
    final accuracy =
        totalWords > 0 ? (_correctWords / totalWords * 100).round() : 0;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlue.shade100,
                ),
                child: const Icon(Icons.keyboard,
                    size: 40, color: Colors.lightBlue),
              ),
              const SizedBox(height: 16),
              Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
              const Text('Điểm',
                  style: TextStyle(
                      fontSize: 16, color: AppColors.mutedForeground)),
              if (_xpAwarded != null && _xpAwarded! > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '+$_xpAwarded XP',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
              if (_submitFailed) ...[
                const SizedBox(height: 8),
                const Text(
                  'Không thể ghi nhận kết quả lên server.',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                      label: 'Đúng',
                      value: '$_correctWords',
                      color: Colors.green),
                  _StatItem(
                      label: 'Sai', value: '$_wrongWords', color: Colors.red),
                  _StatItem(
                    label: 'Độ chính xác',
                    value: '$accuracy%',
                    color: accuracy >= 70 ? Colors.green : Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Về trang chủ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _restart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Chơi lại'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}
