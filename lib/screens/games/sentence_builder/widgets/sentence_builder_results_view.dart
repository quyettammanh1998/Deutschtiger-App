import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/games/sentence_builder_models.dart';
import '../../../../shared/widgets/confetti_overlay.dart';

/// Completion card — confetti burst + amber XP-style stat pill, matches the
/// shared game-completion look used across `/games/*` (web:
/// `ResultsView`/`🎉` card in `sentence-builder/game-page.tsx`).
class SentenceBuilderResultsView extends StatefulWidget {
  const SentenceBuilderResultsView({
    super.key,
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
  State<SentenceBuilderResultsView> createState() =>
      _SentenceBuilderResultsViewState();
}

class _SentenceBuilderResultsViewState
    extends State<SentenceBuilderResultsView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graded = widget.results.where((r) => !r.skipped).toList();
    final avg = graded.isEmpty
        ? 0
        : (graded.map((r) => r.score).reduce((a, b) => a + b) /
                  graded.length)
              .round();
    final goodCount = graded.where((r) => r.score >= 70).length;
    final xp = graded.fold<int>(0, (sum, r) => sum + (r.score ~/ 10));

    return Stack(
      children: [
        Positioned.fill(child: ConfettiOverlay(controller: _confetti)),
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '🎉 Hoàn thành!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Chủ đề: ${widget.topic.labelVi}',
                textAlign: TextAlign.center,
                style: TextStyle(color: tokens.mutedForeground),
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
              const SizedBox(height: 16),
              if (xp > 0)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '⚡ +$xp XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: widget.onPlayAgain,
                child: const Text('Chơi lại'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: widget.onBack,
                child: const Text('Chọn chủ đề khác'),
              ),
            ],
          ),
        ),
      ],
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
        Text(
          label,
          style: TextStyle(color: context.tokens.mutedForeground),
        ),
      ],
    );
  }
}
