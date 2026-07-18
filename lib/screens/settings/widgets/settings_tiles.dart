import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../widgets/common/app_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Reusable primitives for the settings tree — web parity:
/// `thamkhao/deutschtiger-frontend/src/pages/settings/settings-page.tsx`
/// nav-rows card + `settings-*-section.tsx` toggle pattern.
///
/// All colors read from `context.tokens` (never the deprecated
/// `DesignTokens`/`AppColors` statics) so every settings screen renders
/// correctly in dark mode.

/// `text-sm font-bold tracking-wider text-muted-foreground uppercase` card
/// header (e.g. "Hồ sơ", "Đổi mật khẩu", "Thông báo").
class SettingsCardLabel extends StatelessWidget {
  const SettingsCardLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: context.tokens.mutedForeground,
      ),
    ),
  );
}

/// `card divide-y divide-border` container of [SettingsNavRow]s.
class SettingsNavRowCard extends StatelessWidget {
  const SettingsNavRowCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AppCard.card(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) Divider(height: 1, color: context.tokens.border),
          children[i],
        ],
      ],
    ),
  );
}

/// A single web-style nav row: outline icon + label + chevron, full-width
/// tap target, `hover:bg-muted/50` press feedback (InkWell ripple here).
class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Red logout-row styling (`text-red-500`, `hover:bg-red-50`).
  final bool destructive;

  /// Overrides the default chevron (e.g. a badge count).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = destructive ? tokens.destructive : tokens.mutedForeground;
    final labelColor = destructive ? tokens.destructive : tokens.foreground;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: destructive
            ? tokens.destructive.withValues(alpha: 0.08)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ),
              trailing ??
                  Icon(PhosphorIcons.caretRight, size: 18, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill switch matching web's `h-7/8 w-12/14` custom toggle (bigger, more
/// tactile than Material's default [Switch]) — used on appearance,
/// notification and review-display toggles.
class SettingsToggleSwitch extends StatelessWidget {
  const SettingsToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    this.busy = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: GestureDetector(
        onTap: busy ? null : () => onChanged(!value),
        child: AnimatedOpacity(
          opacity: busy ? 0.6 : 1,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 28,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value ? tokens.primary : tokens.muted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `ToggleRow` on `settings-review-display-section.tsx` / appearance —
/// label + description on the left, [SettingsToggleSwitch] on the right.
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.topBorder = false,
  });

  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool topBorder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: EdgeInsets.only(top: topBorder ? 16 : 0, bottom: 8),
      decoration: topBorder
          ? BoxDecoration(
              border: Border(top: BorderSide(color: tokens.border)),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: tokens.foreground,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          SettingsToggleSwitch(
            value: value,
            onChanged: onChanged,
            semanticLabel: label,
          ),
        ],
      ),
    );
  }
}

/// `rounded-xl border-2 px-3 py-1.5` selectable chip — CEFR level / goal /
/// minute-preset buttons on `settings-learning-preferences-section.tsx`.
class SettingsChoiceChip extends StatelessWidget {
  const SettingsChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: selected ? tokens.primary.withValues(alpha: 0.1) : tokens.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? tokens.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? tokens.primary : tokens.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
