import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../features/exam/presentation/widgets/exam_catalog_list.dart';
import '../../features/exam/presentation/widgets/exam_provider_cards.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/async_state_views.dart';

class ExamScreen extends ConsumerStatefulWidget {
  const ExamScreen({super.key});

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  String? _provider;
  String? _level;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(examCatalogProvider);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(l10n.examPractice)),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.couldNotLoadExams,
          onRetry: () => ref.invalidate(examCatalogProvider),
        ),
        data: (items) {
          final providers = items.map((item) => item.provider).toSet().toList()
            ..sort();
          final levels = items.map((item) => item.level).toSet().toList()
            ..sort();
          final filtered = items.where((item) {
            return (_provider == null || item.provider == _provider) &&
                (_level == null || item.level == _level);
          }).toList();
          // Web parity (exam-landing-page.tsx mobile view): buddy finder CTA
          // + provider/level cards sit above the exam catalog, all in one
          // scroll view. Tapping a level pill sets the filter below instead
          // of navigating (no per-provider results route exists yet in
          // Flutter — later wave owns that page).
          return ExamCatalogList(
            items: filtered,
            onRefresh: () async {
              ref.invalidate(examCatalogProvider);
              await ref.read(examCatalogProvider.future);
            },
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExamProviderCards(
                  onLevelSelected: (provider, level) => setState(() {
                    _provider = provider;
                    _level = level;
                  }),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                _CatalogFilters(
                  providers: providers,
                  levels: levels,
                  provider: _provider,
                  level: _level,
                  onProvider: (value) => setState(() => _provider = value),
                  onLevel: (value) => setState(() => _level = value),
                ),
              ],
            ),
            footer: const _MoreExamToolsLinks(),
          );
        },
      ),
    );
  }
}

/// Secondary entry points not shown on the web landing (community exams,
/// dictation) but with no other Flutter surface pointing at them — kept as
/// a compact links row below the catalog so the features stay reachable.
/// Readiness + buddy schedule already have their own dedicated spots
/// (home `ExamCornerCard` and the buddy-finder CTA above) so they are not
/// duplicated here.
class _MoreExamToolsLinks extends StatelessWidget {
  const _MoreExamToolsLinks();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: DesignTokens.spacingSm),
      child: Wrap(
        spacing: DesignTokens.spacingSm,
        runSpacing: DesignTokens.spacingXs,
        children: [
          ActionChip(
            avatar: const Icon(Icons.forum_outlined, size: 16),
            label: Text(l10n.communityExamsTitle),
            onPressed: () => context.push('/exam/community'),
          ),
          ActionChip(
            avatar: const Icon(Icons.headphones_outlined, size: 16),
            label: Text(l10n.examDictationTitle),
            onPressed: () => context.push('/exam/dictation'),
          ),
        ],
      ),
    );
  }
}

class _CatalogFilters extends StatelessWidget {
  const _CatalogFilters({
    required this.providers,
    required this.levels,
    required this.provider,
    required this.level,
    required this.onProvider,
    required this.onLevel,
  });

  final List<String> providers;
  final List<String> levels;
  final String? provider;
  final String? level;
  final ValueChanged<String?> onProvider;
  final ValueChanged<String?> onLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingSm),
      child: Wrap(
        spacing: DesignTokens.spacingSm,
        runSpacing: DesignTokens.spacingXs,
        children: [
          ChoiceChip(
            label: Text(l10n.allFilters),
            selected: provider == null && level == null,
            onSelected: (_) {
              onProvider(null);
              onLevel(null);
            },
          ),
          for (final value in providers)
            ChoiceChip(
              label: Text(value.toUpperCase()),
              selected: provider == value,
              onSelected: (selected) => onProvider(selected ? value : null),
            ),
          for (final value in levels)
            ChoiceChip(
              label: Text(value),
              selected: level == value,
              onSelected: (selected) => onLevel(selected ? value : null),
            ),
        ],
      ),
    );
  }
}
