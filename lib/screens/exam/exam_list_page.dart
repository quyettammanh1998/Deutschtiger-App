import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/exam/data/exam_service.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/list/exam_list_item.dart';
import 'widgets/list/exam_part_card.dart';
import 'widgets/section/exam_readiness_summary_card.dart';

const _providerLabels = {
  'telc': 'telc Deutsch',
  'goethe': 'Goethe-Zertifikat',
  'osd': 'ÖSD Zertifikat',
};

const _pageSize = 10;

/// Web parity: `exam-list-page.tsx`. Generic list+detail widget reused at
/// several routes (`/exam/:providerLevel` flat fallthrough,
/// `/exam/:providerLevel/:slug` detail, legacy `/exam/goethe-b1/exams`) —
/// mirrors the web component's `provider`/`level`/`slug`/`parentPath` props.
///
/// Premium lock (web: free users see sets 6+ blurred) is NOT implemented —
/// no premium/IAP status provider exists in Flutter yet (MASTER P7 scope);
/// every set is unlocked here until P7 ships a status provider to gate on.
class ExamListPage extends ConsumerWidget {
  const ExamListPage({
    super.key,
    this.provider = 'goethe',
    this.level = 'b1',
    this.slug,
    this.parentPath,
  });

  final String provider;
  final String level;
  final String? slug;
  final String? parentPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(examCatalogProvider);
    return Scaffold(
      backgroundColor: context.tokens.background,
      body: SafeArea(
        child: catalog.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorView(
            message: l10n.couldNotLoadExams,
            onRetry: () => ref.invalidate(examCatalogProvider),
          ),
          data: (items) {
            final scoped = items
                .where(
                  (item) =>
                      item.provider == provider &&
                      item.level.toLowerCase() == level.toLowerCase(),
                )
                .toList();
            if (slug != null) {
              final selected = scoped.where((e) => e.slug == slug).toList();
              return _DetailView(
                item: selected.isEmpty ? null : selected.first,
                onBack: () => context.pop(),
              );
            }
            return _ListView(
              items: scoped,
              provider: provider,
              level: level,
              parentPath: parentPath,
            );
          },
        ),
      ),
    );
  }
}

class _ListView extends ConsumerStatefulWidget {
  const _ListView({
    required this.items,
    required this.provider,
    required this.level,
    required this.parentPath,
  });

  final List<ExamCatalogItem> items;
  final String provider;
  final String level;
  final String? parentPath;

  @override
  ConsumerState<_ListView> createState() => _ListViewState();
}

class _ListViewState extends ConsumerState<_ListView> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final totalPages = (widget.items.length / _pageSize).ceil().clamp(
      1,
      1 << 30,
    );
    final paged = widget.items
        .skip((_page - 1) * _pageSize)
        .take(_pageSize)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => widget.parentPath != null
                  ? context.go(widget.parentPath!)
                  : context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              color: tokens.foreground,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${_providerLabels[widget.provider] ?? widget.provider} ${widget.level.toUpperCase()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: tokens.foreground,
                ),
              ),
            ),
            Text(
              l10n.examSetCount(widget.items.length),
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.items.isNotEmpty) const ExamReadinessSummaryCard(),
        if (widget.items.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.border),
            ),
            child: Column(
              children: [
                const Text('📝', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(
                  l10n.examSetEmptyTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.examSetEmptyBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          )
        else ...[
          Container(
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < paged.length; i++) ...[
                  ExamListItem(
                    item: paged[i],
                    index: (_page - 1) * _pageSize + i,
                    locked: false,
                    onTap: () => context.push(
                      '/exam/${widget.provider}-${widget.level}/${paged[i].slug}',
                    ),
                  ),
                  if (i != paged.length - 1)
                    Divider(height: 1, color: tokens.border),
                ],
              ],
            ),
          ),
          if (totalPages > 1) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _page > 1 ? () => setState(() => _page--) : null,
                  child: Text(l10n.examSetPagePrev),
                ),
                Text(
                  l10n.examSetPageIndicator(_page, totalPages),
                  style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                ),
                TextButton(
                  onPressed: _page < totalPages
                      ? () => setState(() => _page++)
                      : null,
                  child: Text(l10n.examSetPageNext),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.item, required this.onBack});

  final ExamCatalogItem? item;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final set = item;
    if (set == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            Text(
              l10n.examSetEmptyTitle,
              style: TextStyle(color: tokens.mutedForeground),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              color: tokens.foreground,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                set.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: tokens.foreground,
                ),
              ),
            ),
            Text(
              l10n.examPartsCount(set.parts.length),
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < set.parts.length; i++) ...[
                ExamPartCard(slug: set.slug, part: set.parts[i]),
                if (i != set.parts.length - 1)
                  Divider(height: 1, color: tokens.border),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
