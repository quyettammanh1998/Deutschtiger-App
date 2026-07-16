import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';
import '../../shared/widgets/back_button.dart';
import '../../view_models/decks/deck_provider.dart';
import '../../widgets/common/app_button.dart';
import 'deck_detail_screen.dart' show deckWordsProvider;

/// `/notes/:deckId/new` and `/notes/:deckId/edit/:cardId`. Web parity:
/// `flashcard-card-form.tsx` (front/back + example sentence; audio-gen and
/// AI ChatGPT-helper are out of scope for this pass — see report).
class CardFormScreen extends ConsumerStatefulWidget {
  const CardFormScreen({super.key, required this.deckId, this.cardId});

  final String deckId;
  final String? cardId;

  @override
  ConsumerState<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends ConsumerState<CardFormScreen> {
  final _wordDe = TextEditingController();
  final _wordVi = TextEditingController();
  final _example = TextEditingController();
  final _exampleVi = TextEditingController();
  bool _loading = false;
  bool _prefilled = false;
  String? _error;

  bool get _isEdit => widget.cardId != null;

  @override
  void dispose() {
    _wordDe.dispose();
    _wordVi.dispose();
    _example.dispose();
    _exampleVi.dispose();
    super.dispose();
  }

  Future<void> _prefill() async {
    if (_prefilled || widget.cardId == null) return;
    _prefilled = true;
    try {
      final card = await ref.read(deckRepositoryProvider).getCard(widget.cardId!);
      _wordDe.text = card.word;
      _wordVi.text = card.translation;
      _example.text = card.example ?? '';
      _exampleVi.text = card.exampleTranslation ?? '';
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).couldNotLoadDecks);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_wordDe.text.trim().isEmpty || _wordVi.text.trim().isEmpty) {
      setState(() => _error = l10n.deckCardFormRequired);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(deckRepositoryProvider);
      if (_isEdit) {
        await repo.updateCard(
          widget.cardId!,
          wordDe: _wordDe.text.trim(),
          wordVi: _wordVi.text.trim(),
          exampleSentence: _example.text.trim().isEmpty ? null : _example.text.trim(),
          exampleSentenceVi: _exampleVi.text.trim().isEmpty ? null : _exampleVi.text.trim(),
        );
      } else {
        await repo.createCard(
          deckId: widget.deckId,
          wordDe: _wordDe.text.trim(),
          wordVi: _wordVi.text.trim(),
          exampleSentence: _example.text.trim().isEmpty ? null : _example.text.trim(),
          exampleSentenceVi: _exampleVi.text.trim().isEmpty ? null : _exampleVi.text.trim(),
        );
      }
      ref.invalidate(deckWordsProvider(widget.deckId));
      ref.invalidate(deckSummaryProvider);
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = l10n.deckCardFormSaveError);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete() async {
    if (widget.cardId == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(deckRepositoryProvider).deleteCard(widget.cardId!);
      ref.invalidate(deckWordsProvider(widget.deckId));
      ref.invalidate(deckSummaryProvider);
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cardId != null && !_prefilled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefill());
    }
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const AppBackButton(),
                const SizedBox(width: 12),
                Text(
                  _isEdit ? l10n.deckEditCardTitle : l10n.deckNewCardTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tokens.foreground),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _FieldLabel(l10n.deckCardFrontLabel),
            TextField(controller: _wordDe, decoration: InputDecoration(hintText: l10n.deckCardFrontHint)),
            const SizedBox(height: 16),
            _FieldLabel(l10n.deckCardBackLabel),
            TextField(controller: _wordVi, decoration: InputDecoration(hintText: l10n.deckCardBackHint)),
            const SizedBox(height: 16),
            _FieldLabel(l10n.deckCardExampleLabel),
            TextField(controller: _example, maxLines: 2, decoration: InputDecoration(hintText: l10n.deckCardExampleHint)),
            const SizedBox(height: 16),
            _FieldLabel(l10n.deckCardExampleViLabel),
            TextField(controller: _exampleVi, maxLines: 2),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: tokens.destructive, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: _isEdit ? l10n.save : l10n.createDeck,
              onPressed: _loading ? null : _save,
              loading: _loading,
            ),
            if (_isEdit) ...[
              const SizedBox(height: 12),
              AppButton(
                label: l10n.delete,
                variant: AppButtonVariant.outline,
                onPressed: _loading ? null : _delete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
    );
  }
}
