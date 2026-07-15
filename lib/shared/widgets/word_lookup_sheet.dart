import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../services/dictionary_service.dart';
import '../../view_models/providers.dart';
import 'speak_button.dart';
import 'save_card_button.dart';

final _wordLookupProvider = FutureProvider.family<WordEntry?, String>(
  (ref, word) => ref.watch(dictionaryServiceProvider).lookup(word),
);

const _kMuted = DesignTokens.mutedForeground;
const _kRose = DesignTokens.rose600;
const _kBorder = DesignTokens.border;
const _kWarning = DesignTokens.warning;

/// Bottom sheet showing the detail of a single word. Open via
/// [showWordLookupSheet] so the sheet animation, drag handle, and rounded
/// top corners stay consistent across the app.
class WordLookupSheet extends ConsumerWidget {
  const WordLookupSheet({super.key, this.word, this.entry, this.onSaved})
    : assert(word != null || entry != null);

  final String? word;
  final WordEntry? entry;
  // Called when the user taps the "Lưu từ" (save) button. The widget does
  // not persist anything itself; feature layers wire the callback.
  final ValueChanged<WordEntry>? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (entry != null) {
      return _WordEntryContent(entry: entry!, onSaved: onSaved);
    }
    return ref
        .watch(_wordLookupProvider(word!))
        .when(
          data: (result) => result == null
              ? _LookupMessage(
                  icon: Icons.search_off_rounded,
                  message: l10n.wordNotFound,
                )
              : _WordEntryContent(entry: result, onSaved: onSaved),
          loading: () => _LookupMessage(
            icon: Icons.hourglass_top_rounded,
            message: l10n.lookingUpWord,
            loading: true,
          ),
          error: (_, _) => _LookupMessage(
            icon: Icons.cloud_off_rounded,
            message: l10n.couldNotLookupWord,
          ),
        );
  }
}

class _WordEntryContent extends StatelessWidget {
  const _WordEntryContent({required this.entry, this.onSaved});

  final WordEntry entry;
  final ValueChanged<WordEntry>? onSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final surfaceColor = theme.brightness == Brightness.dark
        ? DesignTokens.darkCard
        : DesignTokens.card;
    final m = entry.meanings;
    final ex = entry.examples;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLg),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          DesignTokens.screenHorizontalPadding,
          DesignTokens.spacingSm + 4,
          DesignTokens.screenHorizontalPadding,
          DesignTokens.spacingLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: SizedBox(
                width: 40,
                height: 4,
                child: DecoratedBox(decoration: BoxDecoration(color: _kBorder)),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: Text(
                              entry.word,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (entry.gender != null) ...[
                            const SizedBox(width: DesignTokens.spacingSm),
                            Text(
                              entry.gender!,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: _kRose,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (entry.phonetic != null)
                        Text(
                          entry.phonetic!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _kMuted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      if (entry.partOfSpeech != null)
                        Text(
                          entry.partOfSpeech!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _kWarning,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SpeakButton(text: entry.word, audioUrl: entry.audioUrl),
                    SaveCardButton(
                      wordDe: entry.word,
                      wordVi: entry.meanings.join(', '),
                      exampleSentence: entry.examples.firstOrNull?.de,
                      compact: true,
                      onSaved: onSaved == null ? null : () => onSaved!(entry),
                    ),
                  ],
                ),
              ],
            ),
            if (m.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingMd),
              Text(
                l10n.meaning,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm - 2),
              for (final s in m)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: DesignTokens.spacingXs,
                  ),
                  child: Text('• $s', style: theme.textTheme.bodyMedium),
                ),
            ],
            if (ex.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingSm + 4),
              Text(
                l10n.example,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm - 2),
              for (final e in ex)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: DesignTokens.spacingSm + 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.de, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 2),
                      Text(
                        e.vi,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _kMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _SaveSentenceButton(example: e),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SaveSentenceButton extends ConsumerStatefulWidget {
  const _SaveSentenceButton({required this.example});

  final WordExample example;

  @override
  ConsumerState<_SaveSentenceButton> createState() =>
      _SaveSentenceButtonState();
}

class _SaveSentenceButtonState extends ConsumerState<_SaveSentenceButton> {
  bool _saving = false;
  bool _saved = false;

  Future<void> _save() async {
    if (_saving || _saved) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(apiClientProvider)
          .post<Map<String, dynamic>>(
            '/user/learning-items',
            body: {
              'type': 'sentence',
              'content_de': widget.example.de,
              'content_vi': widget.example.vi,
              'category': 'dictionary',
            },
          );
      if (mounted) setState(() => _saved = true);
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.couldNotSaveSentence)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextButton.icon(
      onPressed: _save,
      icon: _saving
          ? const SizedBox.square(
              dimension: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(_saved ? Icons.check_rounded : Icons.add_rounded, size: 16),
      label: Text(_saved ? l10n.sentenceSaved : l10n.saveSentence),
    );
  }
}

class _LookupMessage extends StatelessWidget {
  const _LookupMessage({
    required this.icon,
    required this.message,
    this.loading = false,
  });

  final IconData icon;
  final String message;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).brightness == Brightness.dark
        ? DesignTokens.darkCard
        : DesignTokens.card;
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              const CircularProgressIndicator()
            else
              Icon(icon, size: 40, color: DesignTokens.mutedForeground),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Convenience helper to show [WordLookupSheet] from any call site:
///
/// ```dart
/// await showWordLookupSheet(context, entry: entry, onSaved: save);
/// ```
Future<void> showWordLookupSheet(
  BuildContext context, {
  String? word,
  WordEntry? entry,
  ValueChanged<WordEntry>? onSaved,
}) {
  assert(word != null || entry != null);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.58,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: WordLookupSheet(word: word, entry: entry, onSaved: onSaved),
      ),
    ),
  );
}
