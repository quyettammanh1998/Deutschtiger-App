import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/back_button.dart';
import '../../shared/widgets/page_intro.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/view_models/stats/error_patterns_provider.dart';
import 'widgets/error_pattern_card.dart';

/// Sổ lỗi ngữ pháp — tổng hợp theo loại lỗi từ bài viết/nói/luyện câu.
/// Nguồn: `GET /user/error-patterns/summary`. Web parity:
/// `error-patterns-page.tsx` (PageIntro + per-type drill CTA, no sort menu).
class ErrorPatternsPage extends ConsumerWidget {
  const ErrorPatternsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final patternsAsync = ref.watch(errorPatternsSummaryProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppBackButton(onPressed: () => context.pop()),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.statsErrorPatternsTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: tokens.foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.errorPatternsSubtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PageIntro(
                      pageKey: 'error-patterns',
                      why: l10n.errorPatternsIntroWhy,
                      todo: l10n.errorPatternsIntroTodo,
                      next: l10n.errorPatternsIntroNext,
                      onNextTap: () => context.push('/exam'),
                      nextLabel: l10n.errorPatternsDrillWriting,
                    ),
                  ],
                ),
              ),
            ),
            patternsAsync.when(
              loading: () => const SliverFillRemaining(child: LoadingView()),
              error: (e, _) => SliverFillRemaining(
                child: ErrorView(
                  message: l10n.couldNotLoadData,
                  onRetry: () => ref.invalidate(errorPatternsSummaryProvider),
                ),
              ),
              data: (patterns) {
                if (patterns.isEmpty) {
                  return const SliverFillRemaining(
                    child: ErrorPatternsEmptyState(),
                  );
                }
                final sorted = [...patterns]
                  ..sort((a, b) => b.totalCount.compareTo(a.totalCount));
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: sorted.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        ErrorPatternCard(pattern: sorted[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
