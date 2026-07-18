import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/exam/exam_ecosystem_providers.dart';
import '../../../../widgets/common/async_state_views.dart';
import 'buddy_card.dart';
import 'schedule_pill_tabs.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _pageSize = 12;
const _examTypeOptions = ['goethe', 'telc', 'osd', 'testdaf_dsh', 'ecl'];
const _examTypeLabels = {
  'goethe': 'Goethe',
  'telc': 'telc',
  'osd': 'ÖSD',
  'testdaf_dsh': 'TestDaF/DSH',
  'ecl': 'ECL',
};
const _examLevelOptions = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/// "Danh sách bạn ôn thi" tab — status tabs + filters + paginated directory.
/// Mirrors web `ExamBuddyList` (contact reveal + messaging intentionally
/// omitted — known backend gap, see [BuddyCard] doc comment).
class BuddyDirectoryTab extends ConsumerStatefulWidget {
  const BuddyDirectoryTab({super.key});

  @override
  ConsumerState<BuddyDirectoryTab> createState() => _BuddyDirectoryTabState();
}

class _BuddyDirectoryTabState extends ConsumerState<BuddyDirectoryTab> {
  String _status = 'upcoming';
  String _search = '';
  String _examType = 'all';
  String _level = 'all';
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final buddies = ref.watch(examBuddiesProvider);

    return buddies.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        message: l10n.couldNotLoadData,
        onRetry: () => ref.invalidate(examBuddiesProvider),
      ),
      data: (all) {
        if (all.isEmpty) {
          return Center(
            child: Text(
              l10n.examBuddyListEmpty,
              style: TextStyle(color: tokens.mutedForeground),
            ),
          );
        }

        final upcoming = all.where((b) => b.daysUntil >= 0).length;
        final past = all.length - upcoming;
        final statusScoped = all
            .where(
              (b) => _status == 'upcoming' ? b.daysUntil >= 0 : b.daysUntil < 0,
            )
            .toList();
        final query = _search.trim().toLowerCase();
        final filtered = statusScoped.where((b) {
          if (_examType != 'all' && b.examType != _examType) return false;
          if (_level != 'all' && b.examLevel != _level) return false;
          if (query.isNotEmpty &&
              !(b.displayName.toLowerCase().contains(query) ||
                  b.location.toLowerCase().contains(query) ||
                  (_examTypeLabels[b.examType] ?? '').toLowerCase().contains(
                    query,
                  ))) {
            return false;
          }
          return true;
        }).toList();

        final totalPages = (filtered.length / _pageSize).ceil().clamp(
          1,
          1 << 30,
        );
        final page = _page.clamp(1, totalPages);
        final start = (page - 1) * _pageSize;
        final pageItems = filtered.skip(start).take(_pageSize).toList();

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(examBuddiesProvider);
            await ref.read(examBuddiesProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              SchedulePillTabs<String>(
                value: _status,
                onChanged: (v) => setState(() {
                  _status = v;
                  _page = 1;
                }),
                tabs: [
                  SchedulePillTab(
                    value: 'upcoming',
                    label: l10n.scheduleStatusUpcomingCount(upcoming),
                  ),
                  SchedulePillTab(
                    value: 'past',
                    label: l10n.scheduleStatusPastCount(past),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.scheduleSearchHint,
                  isDense: true,
                  prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 18),
                  filled: true,
                  fillColor: tokens.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: tokens.border),
                  ),
                ),
                onChanged: (v) => setState(() {
                  _search = v;
                  _page = 1;
                }),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _examType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text(l10n.scheduleFilterAllExamTypes),
                        ),
                        for (final t in _examTypeOptions)
                          DropdownMenuItem(
                            value: t,
                            child: Text(_examTypeLabels[t] ?? t),
                          ),
                      ],
                      onChanged: (v) => setState(() {
                        _examType = v ?? 'all';
                        _page = 1;
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _level,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text(l10n.scheduleFilterAllLevels),
                        ),
                        for (final lvl in _examLevelOptions)
                          DropdownMenuItem(value: lvl, child: Text(lvl)),
                      ],
                      onChanged: (v) => setState(() {
                        _level = v ?? 'all';
                        _page = 1;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _status == 'upcoming'
                    ? l10n.scheduleResultCountUpcoming(filtered.length)
                    : l10n.scheduleResultCountPast(filtered.length),
                style: TextStyle(fontSize: 11.5, color: tokens.mutedForeground),
              ),
              const SizedBox(height: 8),
              if (pageItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      _status == 'upcoming'
                          ? l10n.scheduleEmptyUpcoming
                          : l10n.scheduleEmptyPast,
                      style: TextStyle(color: tokens.mutedForeground),
                    ),
                  ),
                )
              else
                for (final b in pageItems) ...[
                  BuddyCard(buddy: b),
                  const SizedBox(height: 8),
                ],
              if (totalPages > 1) ...[
                const SizedBox(height: 8),
                _PaginationBar(
                  page: page,
                  totalPages: totalPages,
                  onPage: (p) => setState(() => _page = p),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.page,
    required this.totalPages,
    required this.onPage,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onPage;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: page > 1 ? () => onPage(page - 1) : null,
          icon: const Icon(PhosphorIcons.caretLeft),
        ),
        Text(
          '$page / $totalPages',
          style: TextStyle(
            color: tokens.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: page < totalPages ? () => onPage(page + 1) : null,
          icon: const Icon(PhosphorIcons.caretRight),
        ),
      ],
    );
  }
}
