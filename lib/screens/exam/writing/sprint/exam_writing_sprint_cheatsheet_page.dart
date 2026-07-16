import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../features/writing/data/sprint/sprint_repository.dart';
import '../../../../features/writing/domain/sprint/redemittel_aggregator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/async_state_views.dart';
import 'widgets/cheatsheet_overview_section.dart';
import 'widgets/cheatsheet_redemittel_mistakes_section.dart';

/// Sprint cheatsheet — Redemittel + cluster overview + Teil tables + common
/// mistakes, all on one scrollable page. Web parity
/// `exam-writing-sprint-cheatsheet-page.tsx` MINUS the print-CSS pagination
/// (`window.print()`/`@media print`) — Flutter has no print pipeline, so
/// this ships as a single continuous read-only reference screen instead of
/// paginated A4 sheets. Documented deviation; all 5 content sections (cluster
/// overview, 3 Teil tables, Redemittel top-40, common mistakes) are present.
class ExamWritingSprintCheatsheetPage extends ConsumerWidget {
  const ExamWritingSprintCheatsheetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final clustersAsync = ref.watch(sprintClustersProvider);
    final topicsAsync = ref.watch(sprintTopicsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                  Expanded(
                    child: Text(
                      l10n.writingSprintCheatsheetTitle,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: clustersAsync.when(
                loading: () => const LoadingView(),
                error: (_, _) => ErrorView(message: l10n.couldNotLoadData, onRetry: () => ref.invalidate(sprintClustersProvider)),
                data: (clusters) => topicsAsync.when(
                  loading: () => const LoadingView(),
                  error: (_, _) => ErrorView(message: l10n.couldNotLoadData, onRetry: () => ref.invalidate(sprintTopicsProvider)),
                  data: (topics) {
                    final topRedemittel = aggregateTopRedemittel(topics, topN: 40);
                    final grouped = groupByFunction(topRedemittel);
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.writingSprintCheatsheetSummary(topics.length, clusters.length),
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                          const SizedBox(height: 16),
                          CheatsheetOverviewSection(clusters: clusters),
                          const SizedBox(height: 24),
                          for (final teil in [1, 2, 3]) ...[
                            CheatsheetTeilTable(teil: teil, topics: topics),
                            const SizedBox(height: 24),
                          ],
                          CheatsheetRedemittelSection(grouped: grouped),
                          const SizedBox(height: 24),
                          const CheatsheetMistakesSection(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
