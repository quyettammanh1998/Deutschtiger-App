import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

enum DictationMode { sentence, cloze }

/// Settings bottom sheet — web parity `dictation-settings-dialog.tsx`
/// (subset: mode toggle + "luôn hiện nghĩa tiếng Việt"; auto-replay/timing
/// knobs deferred, see report deviation notes).
Future<void> showDictationSettingsSheet(
  BuildContext context, {
  required DictationMode mode,
  required bool alwaysShowVietnamese,
  required ValueChanged<DictationMode> onModeChanged,
  required ValueChanged<bool> onAlwaysShowVietnameseChanged,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      final tokens = context.tokens;
      final l10n = AppLocalizations.of(context);
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.youtubeDictationModeLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<DictationMode>(
                  segments: [
                    ButtonSegment(
                      value: DictationMode.sentence,
                      label: Text(l10n.youtubeDictationModeSentence),
                    ),
                    ButtonSegment(
                      value: DictationMode.cloze,
                      label: Text(l10n.youtubeDictationModeCloze),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) {
                    setSheetState(() => mode = s.first);
                    onModeChanged(s.first);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.youtubeDictationAlwaysShowVietnamese),
                  value: alwaysShowVietnamese,
                  onChanged: (v) {
                    setSheetState(() => alwaysShowVietnamese = v);
                    onAlwaysShowVietnameseChanged(v);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
