import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/view_models/stats/error_patterns_provider.dart';
import 'widgets/error_pattern_labels.dart';

enum _SortMode { recent, count }

/// Sổ lỗi ngữ pháp — tổng hợp theo loại lỗi từ bài viết/nói/luyện câu.
/// Nguồn: `GET /user/error-patterns/summary`.
class ErrorPatternsPage extends ConsumerStatefulWidget {
  const ErrorPatternsPage({super.key});

  @override
  ConsumerState<ErrorPatternsPage> createState() => _ErrorPatternsPageState();
}

class _ErrorPatternsPageState extends ConsumerState<ErrorPatternsPage> {
  _SortMode _sortBy = _SortMode.count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final patternsAsync = ref.watch(errorPatternsSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(
          l10n.statsErrorPatternsTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        actions: [
          PopupMenuButton<_SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: (mode) => setState(() => _sortBy = mode),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _SortMode.count,
                child: Text(l10n.errorPatternsSortCount),
              ),
              PopupMenuItem(
                value: _SortMode.recent,
                child: Text(l10n.errorPatternsSortRecent),
              ),
            ],
          ),
        ],
      ),
      body: patternsAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: l10n.couldNotLoadData,
          onRetry: () => ref.invalidate(errorPatternsSummaryProvider),
        ),
        data: (patterns) {
          if (patterns.isEmpty) {
            return _EmptyState(l10n: l10n);
          }
          final sorted = [...patterns];
          switch (_sortBy) {
            case _SortMode.count:
              sorted.sort((a, b) => b.totalCount.compareTo(a.totalCount));
            case _SortMode.recent:
              sorted.sort((a, b) {
                final aTime = a.lastSeen ?? DateTime(2000);
                final bTime = b.lastSeen ?? DateTime(2000);
                return bTime.compareTo(aTime);
              });
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(errorPatternsSummaryProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sorted.length,
              itemBuilder: (context, index) =>
                  _ErrorPatternDetailCard(pattern: sorted[index]),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📝', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              l10n.errorPatternsEmptyTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.errorPatternsEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorPatternDetailCard extends StatelessWidget {
  const _ErrorPatternDetailCard({required this.pattern});

  final ErrorPatternSummary pattern;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = errorTypeLabel(context, pattern.errorType);
    final hasExample =
        pattern.exampleOriginal != null || pattern.exampleCorrected != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: config.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: config.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    config.label,
                    style: TextStyle(
                      color: config.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: config.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.errorPatternsTimesCount(pattern.totalCount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (hasExample) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.errorPatternsExample,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    if (pattern.exampleOriginal != null)
                      TextSpan(
                        text: pattern.exampleOriginal,
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    if (pattern.exampleOriginal != null &&
                        pattern.exampleCorrected != null)
                      const TextSpan(text: '  →  '),
                    if (pattern.exampleCorrected != null)
                      TextSpan(
                        text: pattern.exampleCorrected,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (pattern.sources.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pattern.sources
                    .map(
                      (s) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          errorSourceLabel(context, s),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
