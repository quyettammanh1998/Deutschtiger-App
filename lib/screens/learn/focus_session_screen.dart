import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/learn/learn_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/learn/learn_provider.dart';
import '../../widgets/common/async_state_views.dart';
import '../stats/widgets/error_pattern_labels.dart';

/// "Tập trung hôm nay" — tổng hợp việc cần luyện ngay: thẻ tới hạn, từ thi
/// sai, từ mined từ video, lỗi ngữ pháp hay gặp. `GET /focus-session`.
/// Mirrors web `focus-session-page.tsx` (đọc-only, không có start/stop timer
/// — web thực tế là dashboard hành động, không phải đồng hồ đếm giờ).
class FocusSessionScreen extends ConsumerWidget {
  const FocusSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dataAsync = ref.watch(focusSessionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.focusSessionTitle),
      ),
      body: dataAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(focusSessionProvider),
        ),
        data: (data) {
          if (data.totalActionable == 0) {
            return _EmptyCaughtUp(l10n: l10n);
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(focusSessionProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.focusSessionSummary(data.totalActionable),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.tigerOrangeDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _FocusCard(
                  title: l10n.focusSessionDueWordsTitle,
                  count: data.dueWords.length,
                  emptyLabel: l10n.focusSessionDueWordsEmpty,
                  words: data.dueWords.map((w) => w.contentDe).toList(),
                  actionLabel: l10n.focusSessionReviewNow,
                  onAction: data.dueWords.isEmpty
                      ? null
                      : () => context.push('/daily-review'),
                ),
                const SizedBox(height: 12),
                _FocusCard(
                  title: l10n.focusSessionExamFailTitle,
                  count: data.examFailWords.length,
                  emptyLabel: l10n.focusSessionExamFailEmpty,
                  words: data.examFailWords.map((w) => w.contentDe).toList(),
                  actionLabel: l10n.focusSessionAddToReview,
                  onAction: data.examFailWords.isEmpty
                      ? null
                      : () => context.push('/stats/error-patterns'),
                ),
                const SizedBox(height: 12),
                _FocusCard(
                  title: l10n.focusSessionSubtitleWordsTitle,
                  count: data.subtitleWords.length,
                  emptyLabel: l10n.focusSessionSubtitleWordsEmpty,
                  words: data.subtitleWords.map((w) => w.contentDe).toList(),
                  actionLabel: l10n.focusSessionAddToReview,
                  onAction: data.subtitleWords.isEmpty
                      ? null
                      : () => context.push('/vocabulary'),
                ),
                const SizedBox(height: 12),
                _WeaknessesCard(weaknesses: data.weaknesses, l10n: l10n),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyCaughtUp extends StatelessWidget {
  const _EmptyCaughtUp({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              l10n.focusSessionCaughtUpTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.focusSessionCaughtUpBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({
    required this.title,
    required this.count,
    required this.emptyLabel,
    required this.words,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final int count;
  final String emptyLabel;
  final List<String> words;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        count == 0 ? emptyLabel : '$count',
                        style: const TextStyle(
                          color: AppColors.mutedForeground,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tigerOrange,
                  ),
                ),
              ],
            ),
            if (words.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: words
                    .take(3)
                    .map(
                      (w) => Chip(
                        label: Text(w, style: const TextStyle(fontSize: 12)),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 10),
              FilledButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeaknessesCard extends StatelessWidget {
  const _WeaknessesCard({required this.weaknesses, required this.l10n});

  final List<FocusWeakness> weaknesses;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.focusSessionWeaknessesTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              weaknesses.isEmpty
                  ? l10n.focusSessionWeaknessesEmpty
                  : l10n.focusSessionWeaknessesCount(weaknesses.length),
              style: const TextStyle(
                color: AppColors.mutedForeground,
                fontSize: 12,
              ),
            ),
            if (weaknesses.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...weaknesses.map((w) {
                final config = errorTypeLabel(context, w.errorType);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              config.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: config.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${w.count}×',
                                style: TextStyle(
                                  color: config.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (w.lastExampleOriginal != null &&
                            w.lastExampleCorrected != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            w.lastExampleOriginal!,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.mutedForeground,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            w.lastExampleCorrected!,
                            style: const TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
