import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/preferences_provider.dart';
import '../../view_models/theme_provider.dart';
import 'widgets/settings_tiles.dart';

/// Giao diện — web parity: `settings-appearance-page.tsx` /
/// `settings-appearance-section.tsx`. Dark-mode toggle (drives the
/// `AppTokens` light/dark `ThemeData` registered in `app_theme.dart`) +
/// "Âm thanh & hiệu ứng" toggle (autoplay pronunciation — closest existing
/// on-device preference; there is no separate answer-feedback sound/haptics
/// flag in the current preferences model).
class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final preferences = ref.watch(preferencesProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: tokens.foreground),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.appearance,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tokens.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsCardLabel(l10n.appearance),
                  SettingsToggleRow(
                    label: l10n.darkModeToggle,
                    description: l10n.darkModeDescription,
                    value: isDark,
                    onChanged: (value) => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
                  ),
                  SettingsToggleRow(
                    label: l10n.soundAndEffects,
                    description: l10n.soundAndEffectsDescription,
                    value: preferences.autoPlayAudio,
                    onChanged: (value) =>
                        ref.read(preferencesProvider.notifier).setAutoPlayAudio(value),
                    topBorder: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
