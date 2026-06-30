import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:deutschtiger/view_models/flashcard/review_provider.dart';
import 'widgets/flashcard_view.dart';
import 'widgets/rating_bar.dart';

/// Màn ôn từ (tab "Ôn từ"): trượt qua các thẻ đến hạn, lật → đánh giá.
class FlashcardReviewScreen extends ConsumerWidget {
  const FlashcardReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(reviewSessionProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Ôn từ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: session.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: 'Không tải được thẻ ôn tập.',
            onRetry: () => ref.read(reviewSessionProvider.notifier).restart(),
          ),
          data: (state) => _SessionBody(state: state),
        ),
      ),
    );
  }
}

class _SessionBody extends ConsumerWidget {
  const _SessionBody({required this.state});
  final ReviewSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isEmpty) {
      return const _DoneView(message: 'Hôm nay không có thẻ nào đến hạn 🎉');
    }
    if (state.isFinished) {
      return _DoneView(
        message: 'Đã ôn xong ${state.total} thẻ! 🐯',
        onRestart: () => ref.read(reviewSessionProvider.notifier).restart(),
      );
    }

    final notifier = ref.read(reviewSessionProvider.notifier);
    final item = state.current!;

    void playAudio(String text, String? audioUrl) {
      ref.read(audioServiceProvider).play(text: text, audioUrl: audioUrl);
    }

    return Column(
      children: [
        _ProgressBar(done: state.ratedCount, total: state.total),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FlashcardView(
              key: ValueKey(item.id),
              item: item,
              revealed: state.revealed,
              onReveal: notifier.reveal,
              onPlayAudio: playAudio,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: state.revealed
              ? RatingBar(
                  enabled: !state.submitting,
                  onRate: notifier.rateCurrent,
                )
              : GradientButton(
                  label: 'Xem nghĩa',
                  onPressed: notifier.reveal,
                ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.done, required this.total});
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final value = total == 0 ? 0.0 : done / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AppColors.orange100,
              valueColor: const AlwaysStoppedAnimation(AppColors.tigerOrange),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$done / $total',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.message, this.onRestart});
  final String message;
  final VoidCallback? onRestart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.celebration_rounded,
              size: 56,
              color: AppColors.tigerOrange,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            if (onRestart != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.refresh),
                label: const Text('Ôn tiếp'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
