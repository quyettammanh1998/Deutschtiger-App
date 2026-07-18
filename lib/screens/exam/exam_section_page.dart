import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/async_state_views.dart';
import 'exam_list_page.dart';
import 'widgets/section/exam_bundle_row.dart';
import 'widgets/section/exam_readiness_summary_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _providerLabels = {
  'telc': 'telc Deutsch',
  'goethe': 'Goethe-Zertifikat',
  'osd': 'ÖSD Zertifikat',
};

/// Web parity: `exam-section-page.tsx`. TELC B1 gets the hardcoded bundle
/// chooser (`TELC_BUNDLES`); every other provider/level falls straight
/// through to the flat set list (web's "no books → flat list" branch — the
/// book-cover grid branch is skipped here: the live BE contract has no
/// `book_slug` field populated yet, confirmed via
/// `thamkhao/deutschtiger-backend` grep, so there is nothing to group by).
class ExamSectionPage extends ConsumerWidget {
  const ExamSectionPage({super.key, required this.providerLevel});

  final String providerLevel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parts = providerLevel.split('-');
    final provider = parts.isNotEmpty ? parts.first : 'telc';
    final level = parts.length > 1 ? parts.sublist(1).join('-') : 'b1';
    final isTelcB1 = provider == 'telc' && level == 'b1';

    if (isTelcB1) {
      return _TelcB1BundleChooser(providerLevel: providerLevel);
    }
    return ExamListPage(provider: provider, level: level);
  }
}

class _TelcB1BundleChooser extends StatelessWidget {
  const _TelcB1BundleChooser({required this.providerLevel});

  final String providerLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(PhosphorIcons.arrowLeft),
                  color: tokens.foreground,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_providerLabels['telc']} B1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                      Text(
                        l10n.examSectionBundleCount(2),
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ExamReadinessSummaryCard(),
            Container(
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tokens.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ExamBundleRow(
                    emoji: '📚',
                    title: l10n.examBundleArapTitle,
                    desc: l10n.examBundleArapDesc,
                    onTap: () => context.push('/exam/$providerLevel/a-rap'),
                  ),
                  Divider(height: 1, color: tokens.border),
                  ExamBundleRow(
                    emoji: '🎤',
                    title: l10n.examBundleSpeakingTitle,
                    desc: l10n.examBundleSpeakingDesc,
                    comingSoonLabel: l10n.examBundleComingSoon,
                    // Sprechen hub is P10 (speech phase) scope — gated off
                    // here rather than routing to a non-existent screen.
                    onTap: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `/exam/telc-b1/a-rap` — web special-cases this to the flat TELC-B1 set
/// list (all TELC B1 sets ARE the "A-RAP" set per the code comment in
/// `exam-list-page.tsx`: "A-RAP = all TELC B1 exams").
class ExamArapListPage extends ConsumerWidget {
  const ExamArapListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(examCatalogProvider);
    return catalog.when(
      loading: () => Scaffold(
        backgroundColor: context.tokens.background,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: context.tokens.background,
        body: ErrorView(
          message: AppLocalizations.of(context).couldNotLoadExams,
          onRetry: () => ref.invalidate(examCatalogProvider),
        ),
      ),
      data: (_) => const ExamListPage(
        provider: 'telc',
        level: 'b1',
        parentPath: '/exam/telc-b1',
      ),
    );
  }
}
