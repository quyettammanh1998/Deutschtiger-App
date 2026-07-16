import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/app_phosphor_icons.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/community/community_browse_tab.dart';
import 'widgets/community/community_gated_tab.dart';

/// Danh sách đề thi cộng đồng. Web parity: `community-exams-page.tsx` — back
/// + title, segmented tab bar (Duyệt đề / Đóng góp / Đề của tôi), each tab
/// swapped in place.
///
/// Only "Duyệt đề" (browse, read-only) is fully wired to live data.
/// "Đóng góp" (AI-generate + publish) and "Đề của tôi" (my topics) render a
/// gated/coming-soon state — the write path is a product decision deferred
/// to GĐ2 P3, not omitted UI (web shows all three tabs).
class CommunityExamsListScreen extends StatefulWidget {
  const CommunityExamsListScreen({super.key});

  @override
  State<CommunityExamsListScreen> createState() =>
      _CommunityExamsListScreenState();
}

class _CommunityExamsListScreenState extends State<CommunityExamsListScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final tabLabels = [
      l10n.communityTabBrowse,
      l10n.communityTabContribute,
      l10n.communityTabMine,
    ];

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(AppPhosphorIcons.caretLeft),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.communityExamsTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _TabBar(
                labels: tabLabels,
                selected: _tab,
                onSelected: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 16),
              switch (_tab) {
                0 => const CommunityBrowseTab(),
                1 => CommunityGatedTab(
                  message: l10n.communityContributeComingSoon,
                ),
                _ => CommunityGatedTab(
                  message: l10n.communityMineEmptyGated,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.muted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: _TabButton(
                  label: labels[i],
                  active: selected == i,
                  onTap: () => onSelected(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: active ? tokens.card : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      elevation: active ? 1 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? tokens.foreground : tokens.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
