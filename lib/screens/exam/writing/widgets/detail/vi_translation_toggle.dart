import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';

/// Per-card VI reveal toggle — web parity `show-translation-toggle.tsx`.
class ViTranslationToggle extends StatelessWidget {
  const ViTranslationToggle({super.key, required this.show, required this.onToggle});

  final bool show;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: show ? const Color(0xFF3B82F6) : tokens.muted,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: show ? const Color(0xFF3B82F6) : tokens.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(show ? Icons.visibility_off : Icons.visibility,
                size: 12, color: show ? Colors.white : tokens.mutedForeground),
            const SizedBox(width: 4),
            Text(
              show ? l10n.writingHideTranslation : l10n.writingShowTranslation,
              style: TextStyle(fontSize: 11, color: show ? Colors.white : tokens.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
