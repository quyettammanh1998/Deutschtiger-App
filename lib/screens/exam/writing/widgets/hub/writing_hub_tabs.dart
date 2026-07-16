import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';

enum WritingHubTab { start, my, community }

/// Segmented tab bar for the unified writing hub (`/luyen-viet`) — web
/// parity `WritingHubTabs` (`components/writing/hub/writing-hub-tabs.tsx`).
class WritingHubTabsBar extends StatelessWidget {
  const WritingHubTabsBar({super.key, required this.active, required this.onChange});

  final WritingHubTab active;
  final ValueChanged<WritingHubTab> onChange;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final tabs = [
      (WritingHubTab.start, l10n.writingHubTabStart),
      (WritingHubTab.my, l10n.writingHubTabMy),
      (WritingHubTab.community, l10n.writingHubTabCommunity),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          for (final (tab, label) in tabs)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onChange(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: active == tab ? tokens.background : null,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: active == tab
                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 2)]
                        : null,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active == tab ? tokens.foreground : tokens.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
