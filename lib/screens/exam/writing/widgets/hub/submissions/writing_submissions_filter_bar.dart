import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_tokens.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

enum WritingSubmissionSort { date, score }

class WritingSubmissionsFilterState {
  const WritingSubmissionsFilterState({
    this.provider,
    this.level,
    this.teil,
    this.search = '',
    this.sortBy = WritingSubmissionSort.date,
  });

  final String? provider;
  final String? level;
  final int? teil;
  final String search;
  final WritingSubmissionSort sortBy;

  WritingSubmissionsFilterState copyWith({
    String? provider,
    bool clearProvider = false,
    String? level,
    bool clearLevel = false,
    int? teil,
    bool clearTeil = false,
    String? search,
    WritingSubmissionSort? sortBy,
  }) {
    return WritingSubmissionsFilterState(
      provider: clearProvider ? null : (provider ?? this.provider),
      level: clearLevel ? null : (level ?? this.level),
      teil: clearTeil ? null : (teil ?? this.teil),
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// Filter/search/sort chips for "Bài của tôi" — web parity
/// `SubmissionsFilterBar`. Simplified single-select chip rows per facet.
class WritingSubmissionsFilterBar extends StatelessWidget {
  const WritingSubmissionsFilterBar({
    super.key,
    required this.providers,
    required this.levels,
    required this.teils,
    required this.state,
    required this.onChange,
  });

  final List<String> providers;
  final List<String> levels;
  final List<int> teils;
  final WritingSubmissionsFilterState state;
  final ValueChanged<WritingSubmissionsFilterState> onChange;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tokens.border),
          ),
          child: TextField(
            onChanged: (v) => onChange(state.copyWith(search: v)),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              prefixIcon: Icon(PhosphorIcons.magnifyingGlass, size: 18, color: tokens.mutedForeground),
              hintText: l10n.writingSearchHint,
              hintStyle: TextStyle(fontSize: 13, color: tokens.mutedForeground),
            ),
          ),
        ),
        if (providers.length > 1 || levels.length > 1 || teils.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (providers.length > 1)
                for (final p in providers)
                  _Chip(
                    label: p,
                    active: state.provider == p,
                    onTap: () => onChange(
                      state.provider == p
                          ? state.copyWith(clearProvider: true)
                          : state.copyWith(provider: p),
                    ),
                  ),
              if (levels.length > 1)
                for (final l in levels)
                  _Chip(
                    label: l.toUpperCase(),
                    active: state.level == l,
                    onTap: () => onChange(
                      state.level == l ? state.copyWith(clearLevel: true) : state.copyWith(level: l),
                    ),
                  ),
              for (final t in teils)
                _Chip(
                  label: 'Teil $t',
                  active: state.teil == t,
                  onTap: () => onChange(
                    state.teil == t ? state.copyWith(clearTeil: true) : state.copyWith(teil: t),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Text(l10n.writingSortLabel, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
            const SizedBox(width: 8),
            _Chip(
              label: l10n.writingSortByDate,
              active: state.sortBy == WritingSubmissionSort.date,
              onTap: () => onChange(state.copyWith(sortBy: WritingSubmissionSort.date)),
            ),
            const SizedBox(width: 6),
            _Chip(
              label: l10n.writingSortByScore,
              active: state.sortBy == WritingSubmissionSort.score,
              onTap: () => onChange(state.copyWith(sortBy: WritingSubmissionSort.score)),
            ),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? tokens.primary : tokens.muted,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}
