import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';
import '../../repositories/flashcard/flashcard_quick_save_repository.dart';
import '../../view_models/providers.dart';

enum _SaveState { idle, saving, saved, duplicate, error }

enum SaveCardButtonVariant { button, compact, star }

class SaveCardButton extends ConsumerStatefulWidget {
  const SaveCardButton({
    super.key,
    required this.wordDe,
    this.wordVi = '',
    this.exampleSentence,
    this.compact = false,
    this.variant = SaveCardButtonVariant.button,
    this.onSaved,
  });

  final String wordDe;
  final String wordVi;
  final String? exampleSentence;
  final bool compact;
  final SaveCardButtonVariant variant;
  final VoidCallback? onSaved;

  @override
  ConsumerState<SaveCardButton> createState() => _SaveCardButtonState();
}

class _SaveCardButtonState extends ConsumerState<SaveCardButton> {
  _SaveState _state = _SaveState.idle;

  Future<void> _save({String? deckId}) async {
    if (_state == _SaveState.saving ||
        _state == _SaveState.saved ||
        _state == _SaveState.duplicate) {
      return;
    }
    setState(() => _state = _SaveState.saving);
    try {
      final result = await ref
          .read(flashcardQuickSaveRepositoryProvider)
          .save(
            wordDe: widget.wordDe,
            wordVi: widget.wordVi,
            exampleSentence: widget.exampleSentence,
            deckId: deckId,
          );
      if (!mounted) return;
      setState(() {
        _state = result == QuickSaveResult.saved
            ? _SaveState.saved
            : _SaveState.duplicate;
      });
      widget.onSaved?.call();
      if (deckId != null) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.wordSavedToDeck),
            action: SnackBarAction(
              label: l10n.openDeck,
              onPressed: () => context.push('/decks/$deckId'),
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = _SaveState.error);
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotSaveWord)));
    }
  }

  Future<void> _pickDeckAndSave() async {
    try {
      final l10n = AppLocalizations.of(context);
      final decks = await ref.read(deckRepositoryProvider).getDecks();
      if (!mounted) return;
      final deckId = await showModalBottomSheet<String?>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.chooseDeck),
                  subtitle: Text(l10n.chooseDeckDescription),
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark_add_outlined),
                  title: Text(l10n.quickSave),
                  onTap: () => Navigator.pop(context, ''),
                ),
                for (final deck in decks)
                  ListTile(
                    leading: const Icon(Icons.style_outlined),
                    title: Text(deck.name),
                    onTap: () => Navigator.pop(context, deck.id),
                  ),
              ],
            ),
          ),
        ),
      );
      if (!mounted || deckId == null) return;
      await _save(deckId: deckId.isEmpty ? null : deckId);
    } catch (_) {
      if (mounted) await _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final variant = widget.compact
        ? SaveCardButtonVariant.compact
        : widget.variant;
    final (icon, label, color) = switch (_state) {
      _SaveState.idle => (
        Icons.bookmark_add_outlined,
        variant == SaveCardButtonVariant.button ? l10n.saveToDeck : l10n.save,
        DesignTokens.orange500,
      ),
      _SaveState.saving => (
        Icons.hourglass_top_rounded,
        l10n.saving,
        DesignTokens.mutedForeground,
      ),
      _SaveState.saved => (
        Icons.bookmark_added,
        l10n.saved,
        DesignTokens.success,
      ),
      _SaveState.duplicate => (
        Icons.bookmark_added,
        l10n.alreadySaved,
        DesignTokens.success,
      ),
      _SaveState.error => (Icons.refresh, l10n.retry, DesignTokens.rose600),
    };
    if (variant == SaveCardButtonVariant.star) {
      return IconButton(
        onPressed: () => _save(),
        tooltip: label,
        icon: Icon(
          _state == _SaveState.saved || _state == _SaveState.duplicate
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: color,
        ),
      );
    }
    return FilledButton.icon(
      onPressed: variant == SaveCardButtonVariant.button
          ? _pickDeckAndSave
          : () => _save(),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: DesignTokens.card,
        padding: variant == SaveCardButtonVariant.compact
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : null,
      ),
    );
  }
}
