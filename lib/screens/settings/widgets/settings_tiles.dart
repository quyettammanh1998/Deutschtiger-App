import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Reusable tile widgets for SettingsScreen (Phase 05).
///
/// Trước đây nằm inline trong `settings_screen.dart` (~250 dòng), tách ra để
/// file chính < 300 dòng theo guideline plan.

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: DesignTokens.spacingXs,
        bottom: DesignTokens.spacingSm,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: DesignTokens.mutedForeground,
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Column(children: children),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: DesignTokens.foreground),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: DesignTokens.mutedForeground,
      ),
      onTap: onTap,
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: DesignTokens.foreground),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: DesignTokens.tigerOrange,
      ),
    );
  }
}

class SettingsSliderTile extends StatelessWidget {
  const SettingsSliderTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      child: Row(
        children: [
          Icon(icon, color: DesignTokens.foreground),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Slider(
                  value: value,
                  onChanged: onChanged,
                  activeColor: DesignTokens.tigerOrange,
                ),
              ],
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              color: DesignTokens.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeSettingTile extends StatelessWidget {
  const ThemeSettingTile({
    super.key,
    required this.themeMode,
    required this.onChanged,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  String _themeName(BuildContext context, ThemeMode mode) {
    final l10n = AppLocalizations.of(context);
    return switch (mode) {
      ThemeMode.system => l10n.systemTheme,
      ThemeMode.light => l10n.lightTheme,
      ThemeMode.dark => l10n.darkTheme,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.dark_mode_outlined,
        color: DesignTokens.foreground,
      ),
      title: Text(AppLocalizations.of(context).themeMode),
      subtitle: Text(_themeName(context, themeMode)),
      trailing: PopupMenuButton<ThemeMode>(
        initialValue: themeMode,
        onSelected: onChanged,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: ThemeMode.system,
            child: Text(_themeName(context, ThemeMode.system)),
          ),
          PopupMenuItem(
            value: ThemeMode.light,
            child: Text(_themeName(context, ThemeMode.light)),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Text(_themeName(context, ThemeMode.dark)),
          ),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _themeName(context, themeMode),
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: DesignTokens.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}
