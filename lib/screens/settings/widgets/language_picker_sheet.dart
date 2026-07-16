import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Language picker bottom sheet for SettingsScreen.
class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({
    super.key,
    required this.currentLanguage,
    required this.onSelect,
  });

  final String currentLanguage;
  final ValueChanged<String> onSelect;

  static const _options = <({String code, String name, String flag})>[
    (code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳'),
    (code: 'en', name: 'English', flag: '🇬🇧'),
    (code: 'de', name: 'Deutsch', flag: '🇩🇪'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return SafeArea(
      child: Semantics(
        label: l10n.selectLanguage,
        explicitChildNodes: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.selectLanguage,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            for (final o in _options)
              Semantics(
                selected: currentLanguage == o.code,
                button: true,
                label: o.name,
                child: ListTile(
                  leading: Text(o.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(o.name),
                  trailing: currentLanguage == o.code
                      ? Icon(Icons.check, color: tokens.primary)
                      : null,
                  onTap: () {
                    onSelect(o.code);
                    Navigator.pop(context);
                  },
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
