// Reader settings bottom sheet (font scale + highlight + word lookup) and
// reader guide dialog — web `reader-settings-button.tsx` / `reader-guide-button.tsx`,
// consolidated into 1 file (both are small, single-purpose triggers).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import 'exam_player_palette.dart';
import 'reader_prefs.dart';

Future<void> showReaderGuideDialog(
  BuildContext context, {
  required bool wordLookupEnabled,
  required VoidCallback onEnableWordLookup,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.examReaderGuideTitle),
      content: Text(l10n.examReaderGuideBody),
      actions: [
        if (!wordLookupEnabled)
          TextButton(
            onPressed: () {
              onEnableWordLookup();
              Navigator.pop(ctx);
            },
            child: Text(l10n.examReaderGuideEnableWordLookup),
          ),
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.close),
        ),
      ],
    ),
  );
}

void showReaderSettingsSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _ReaderSettingsSheet(),
  );
}

class _ReaderSettingsSheet extends ConsumerWidget {
  const _ReaderSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final fontScale = ref.watch(readerFontScaleProvider);
    final highlight = ref.watch(highlightControllerProvider);
    final wordLookupEnabled = ref.watch(wordLookupEnabledProvider);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: tokens.mutedForeground.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Text(
              l10n.examReaderSettingsTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.examReaderSettingsFontSize,
              style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
            ),
            Slider(
              value: fontScale,
              min: 0.85,
              max: 1.3,
              divisions: 9,
              label: '${(fontScale * 100).round()}%',
              activeColor: tokens.primary,
              onChanged: (v) =>
                  ref.read(readerFontScaleProvider.notifier).state = v,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.examReaderSettingsWordLookup,
                style: TextStyle(fontSize: 14, color: tokens.foreground),
              ),
              value: wordLookupEnabled,
              activeThumbColor: tokens.primary,
              onChanged: (v) =>
                  ref.read(wordLookupEnabledProvider.notifier).state = v,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.examReaderSettingsHighlight,
                style: TextStyle(fontSize: 14, color: tokens.foreground),
              ),
              value: highlight.enabled,
              activeThumbColor: tokens.primary,
              onChanged: (v) =>
                  ref.read(highlightControllerProvider.notifier).setEnabled(v),
            ),
            if (highlight.enabled)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  children: [
                    for (var i = 0; i < examHighlightColors.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => ref
                              .read(highlightControllerProvider.notifier)
                              .setActiveColor(i),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: examHighlightColors[i],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: highlight.activeColorIndex == i
                                    ? tokens.foreground
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
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
