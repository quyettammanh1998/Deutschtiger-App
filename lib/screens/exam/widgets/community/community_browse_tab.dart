import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/exam/exam_ecosystem_providers.dart';
import '../../../../widgets/common/async_state_views.dart';
import 'community_topic_card.dart';

/// "Duyệt đề" tab — provider/skill select + Teil 1/2/3 toggle + search input
/// + result list. Web parity: `BrowseTab` in `community-exams-page.tsx`.
///
/// Search is client-side over the already-filtered result set: the
/// repository (`community_exam_repository.dart`) only exposes `list()`/
/// `getById()` per this phase's scope — wiring the separate `/search`
/// endpoint was out of scope, so title matching happens locally instead.
class CommunityBrowseTab extends ConsumerStatefulWidget {
  const CommunityBrowseTab({super.key});

  @override
  ConsumerState<CommunityBrowseTab> createState() => _CommunityBrowseTabState();
}

enum _TypeOption { all, goetheWriting, telcSpeaking }

class _CommunityBrowseTabState extends ConsumerState<CommunityBrowseTab> {
  _TypeOption _type = _TypeOption.all;
  int? _teil;
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  CommunityExamFilter get _filter => switch (_type) {
    _TypeOption.all => CommunityExamFilter(teil: _teil),
    _TypeOption.goetheWriting => CommunityExamFilter(
      provider: 'goethe',
      skill: 'writing',
      teil: _teil,
    ),
    _TypeOption.telcSpeaking => CommunityExamFilter(
      provider: 'telc',
      skill: 'speaking',
      teil: _teil,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final filter = _filter;
    final topics = ref.watch(communityExamListProvider(filter));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TypeSelect(
              value: _type,
              onChanged: (v) => setState(() => _type = v),
            ),
            for (final t in [1, 2, 3])
              ChoiceChip(
                label: Text(l10n.communityTeilLabel(t)),
                selected: _teil == t,
                onSelected: (_) =>
                    setState(() => _teil = _teil == t ? null : t),
              ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _search = v),
          decoration: InputDecoration(
            hintText: l10n.communitySearchHint,
            prefixIcon: Icon(AppPhosphorIcons.magnifyingGlass, size: 18),
            isDense: true,
            filled: true,
            fillColor: tokens.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: tokens.border),
            ),
          ),
        ),
        const SizedBox(height: 12),
        topics.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: LoadingView(),
          ),
          error: (error, _) => ErrorView(
            message: l10n.couldNotLoadData,
            onRetry: () => ref.invalidate(communityExamListProvider(filter)),
          ),
          data: (list) {
            final filtered = _search.trim().isEmpty
                ? list
                : list
                      .where(
                        (t) =>
                            t.titleDe.toLowerCase().contains(
                              _search.toLowerCase(),
                            ) ||
                            (t.titleVi ?? '').toLowerCase().contains(
                              _search.toLowerCase(),
                            ),
                      )
                      .toList();
            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    l10n.communityExamsEmpty,
                    style: TextStyle(color: tokens.mutedForeground),
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (final topic in filtered) ...[
                  CommunityTopicCard(topic: topic),
                  const SizedBox(height: 8),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TypeSelect extends StatelessWidget {
  const _TypeSelect({required this.value, required this.onChanged});

  final _TypeOption value;
  final ValueChanged<_TypeOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final labels = {
      _TypeOption.all: l10n.communityFilterAll,
      _TypeOption.goetheWriting: l10n.communityFilterGoetheWriting,
      _TypeOption.telcSpeaking: l10n.communityFilterTelcSpeaking,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_TypeOption>(
          value: value,
          isDense: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          items: [
            for (final opt in _TypeOption.values)
              DropdownMenuItem(value: opt, child: Text(labels[opt]!)),
          ],
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}
