import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../../l10n/app_localizations.dart';

/// SR mode picker — Marathon (1-session) vs Daily (SM-2 multi-day) selection
/// cards. Web parity `sr-mode-picker.tsx`.
class SrModePicker extends StatelessWidget {
  const SrModePicker({super.key, required this.value, required this.onChanged});

  final SRMode value;
  final ValueChanged<SRMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modes = [
      (mode: SRMode.marathon, icon: '⚡', title: l10n.writingSprintModeMarathonTitle, subtitle: l10n.writingSprintModeMarathonSubtitle, detail: l10n.writingSprintModeMarathonDetail),
      (mode: SRMode.daily, icon: '📅', title: l10n.writingSprintModeDailyTitle, subtitle: l10n.writingSprintModeDailySubtitle, detail: l10n.writingSprintModeDailyDetail),
    ];
    return Column(
      children: [
        for (final m in modes) ...[
          _ModeCard(
            icon: m.icon,
            title: m.title,
            subtitle: m.subtitle,
            detail: m.detail,
            selected: value == m.mode,
            onTap: () => onChanged(m.mode),
          ),
          if (m.mode != modes.last.mode) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? tokens.primary : tokens.border, width: selected ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground)),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(detail, style: TextStyle(fontSize: 12, color: tokens.mutedForeground, height: 1.4)),
              if (selected) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tokens.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.writingSprintModeSelected,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
