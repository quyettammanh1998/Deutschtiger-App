import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../view_models/preferences_provider.dart';
import 'language_picker_sheet.dart';
import 'settings_actions.dart';
import 'settings_tiles.dart';
import 'sound_settings_sheet.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// App-only settings blocks with no web page counterpart — Quyết định #3
/// keeper (c): "settings ngôn ngữ/âm thanh/About". Extracted from
/// `settings_screen.dart` to keep that file under the ~200-LOC guideline.
class SettingsAppOnlySection extends ConsumerWidget {
  const SettingsAppOnlySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final preferences = ref.watch(preferencesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsCardLabel(l10n.appOnlySettingsLabel),
        SettingsNavRowCard(
          children: [
            SettingsNavRow(
              icon: PhosphorIcons.globe,
              label: '${l10n.appLanguage} · ${_languageName(preferences.appLanguage)}',
              onTap: () => _showLanguagePicker(context, ref),
            ),
            SettingsNavRow(
              icon: PhosphorIcons.speakerHigh,
              label: l10n.sound,
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const SoundSettingsSheet(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SettingsCardLabel(l10n.about),
        SettingsNavRowCard(
          children: [
            SettingsNavRow(
              icon: PhosphorIcons.info,
              label: '${l10n.version} · 1.0.0',
              onTap: () {},
            ),
            SettingsNavRow(
              icon: PhosphorIcons.fileText,
              label: l10n.termsOfService,
              onTap: () => context.push('/terms-of-service'),
            ),
            SettingsNavRow(
              icon: PhosphorIcons.shield,
              label: l10n.privacyPolicy,
              onTap: () => context.push('/privacy-policy'),
            ),
            SettingsNavRow(
              icon: PhosphorIcons.question,
              label: l10n.helpCenter,
              onTap: () =>
                  SettingsActions.openUrl(context, 'https://deutschtiger.com/help'),
            ),
            SettingsNavRow(
              icon: PhosphorIcons.star,
              label: l10n.rateApp,
              onTap: () => SettingsActions.rateApp(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    final currentLang = ref.read(preferencesProvider).appLanguage;
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => LanguagePickerSheet(
        currentLanguage: currentLang,
        onSelect: (code) => ref.read(preferencesProvider.notifier).setLanguage(code),
      ),
    );
  }

  String _languageName(String code) => switch (code) {
    'vi' => 'Tiếng Việt',
    'en' => 'English',
    'de' => 'Deutsch',
    _ => 'Tiếng Việt',
  };
}
