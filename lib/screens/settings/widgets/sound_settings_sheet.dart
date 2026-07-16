import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/preferences_provider.dart';
import 'settings_tiles.dart';

/// App-only "Âm thanh" bottom sheet — Quyết định #3 keeper (c). No web
/// page counterpart; opened from a nav row on the settings root, styled to
/// match the card/toggle language of the web settings tree.
class SoundSettingsSheet extends ConsumerWidget {
  const SoundSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final preferences = ref.watch(preferencesProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsCardLabel(l10n.sound),
            Text(
              l10n.pronunciationVolume,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: tokens.foreground,
              ),
            ),
            Slider(
              value: preferences.ttsVolume,
              onChanged: (value) =>
                  ref.read(preferencesProvider.notifier).setTtsVolume(value),
              activeColor: tokens.primary,
            ),
            SettingsToggleRow(
              label: l10n.autoplayPronunciation,
              description: l10n.autoplayDescription,
              value: preferences.autoPlayAudio,
              onChanged: (value) =>
                  ref.read(preferencesProvider.notifier).setAutoPlayAudio(value),
              topBorder: true,
            ),
          ],
        ),
      ),
    );
  }
}
