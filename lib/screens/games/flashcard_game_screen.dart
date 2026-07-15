import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/flashcard/review_item.dart';
import '../../shared/widgets/game_completion_screen.dart';
import '../../view_models/flashcard/review_provider.dart';
import '../../view_models/providers.dart';
import '../../widgets/common/async_state_views.dart';

/// Flashcard game — lật thẻ học từ, nguồn live: thẻ đến hạn ôn từ
/// `GET /user/srs/queue` (tái dùng [ReviewRepository]/[reviewSessionProvider],
/// giống màn "Ôn từ" ở `flashcard_review_screen.dart`), không còn dùng danh
/// sách 10 từ tĩnh cũ. Đơn giản hoá thang đánh giá FSRS 4 mức (Quên/Khó/
/// Tốt/Dễ) thành 2 nút "Chưa nhớ"/"Nhớ rồi" (map "Quên"/"Tốt") cho đúng
/// trải nghiệm game nhanh — vẫn gửi rating thật lên server để FSRS tính due
/// tiếp theo.
class FlashcardGameScreen extends ConsumerStatefulWidget {
  const FlashcardGameScreen({super.key});

  @override
  ConsumerState<FlashcardGameScreen> createState() =>
      _FlashcardGameScreenState();
}

const _flashcardGameScope = ReviewSessionScope(mode: 'flashcard_game');

class _FlashcardGameScreenState extends ConsumerState<FlashcardGameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _rating = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _rate(ReviewRating rating) async {
    if (_rating) return;
    setState(() => _rating = true);
    await ref
        .read(reviewSessionProvider(_flashcardGameScope).notifier)
        .rateCurrent(rating);
    if (!mounted) return;
    setState(() => _rating = false);
    _flipController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(reviewSessionProvider(_flashcardGameScope));
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text('Flashcards'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: session.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            onRetry: () => ref
                .read(reviewSessionProvider(_flashcardGameScope).notifier)
                .restart(),
          ),
          data: (state) {
            if (state.isEmpty) {
              return const ErrorView(
                message:
                    'Không có thẻ nào đến hạn ôn lúc này. Hãy học thêm từ '
                    'mới hoặc quay lại sau.',
              );
            }
            if (state.isFinished) {
              return GameCompletionScreen(
                score: state.correctCount,
                total: state.total,
                title: 'Hoàn thành!',
                onPlayAgain: () => ref
                    .read(reviewSessionProvider(_flashcardGameScope).notifier)
                    .restart(),
                onGoHome: () => context.pop(),
              );
            }
            return _buildGame(state);
          },
        ),
      ),
    );
  }

  Widget _buildGame(ReviewSessionState state) {
    final item = state.current!;
    final revealed = state.revealed;

    return Column(
      children: [
        LinearProgressIndicator(
          value: (state.index + 1) / state.total,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.style, size: 16, color: Colors.purple),
                  const SizedBox(width: 4),
                  Text(
                    '${state.index + 1}/${state.total}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (revealed) return;
              ref
                  .read(reviewSessionProvider(_flashcardGameScope).notifier)
                  .reveal();
              _flipController.forward();
              ref
                  .read(audioServiceProvider)
                  .play(text: item.displayDe, audioUrl: item.displayAudioUrl);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * 3.14159;
                  final isFront = angle < 1.5708;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isFront ? Colors.white : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color:
                              isFront ? Colors.purple : Colors.purple.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isFront) ...[
                            Text(
                              item.displayDe,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Tap để lật',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ] else ...[
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(3.14159),
                              child: Column(
                                children: [
                                  Text(
                                    item.displayDe,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    item.displayVi,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.foreground,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: revealed
              ? Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _rating ? null : () => _rate(ReviewRating.forgot),
                        icon: const Icon(Icons.close),
                        label: const Text('Chưa nhớ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _rating ? null : () => _rate(ReviewRating.medium),
                        icon: const Icon(Icons.check),
                        label: const Text('Nhớ rồi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    ref
                        .read(
                          reviewSessionProvider(_flashcardGameScope).notifier,
                        )
                        .reveal();
                    _flipController.forward();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 48,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flip),
                      SizedBox(width: 8),
                      Text('Lật thẻ', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
