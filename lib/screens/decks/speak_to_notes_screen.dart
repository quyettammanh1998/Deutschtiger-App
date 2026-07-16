import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../core/release/release_feature_flags.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';
import '../../shared/widgets/back_button.dart';
import '../../view_models/decks/deck_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';

/// `/notes/speak` — "Nói ra ghi chú". Web parity: `speak-to-notes-page.tsx`.
/// Full UI per web (mic button, editable streaming textarea, deck-name +
/// save). The live mic→text (STT) path is gated behind
/// [ReleaseFeatureFlags.speaking] — wiring is MASTER P8's job (see plan);
/// this screen lets the user type/paste sentences manually either way, so
/// the "→ deck" save flow is fully functional today.
class SpeakToNotesScreen extends ConsumerStatefulWidget {
  const SpeakToNotesScreen({super.key});

  @override
  ConsumerState<SpeakToNotesScreen> createState() => _SpeakToNotesScreenState();
}

class _SpeakToNotesScreenState extends ConsumerState<SpeakToNotesScreen> {
  final _textController = TextEditingController();
  late final TextEditingController _deckNameController = TextEditingController(
    text: _defaultDeckName(),
  );
  bool _saving = false;
  int? _savedCount;
  String? _error;

  static String _defaultDeckName() {
    final now = DateTime.now();
    return 'Nói ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _textController.dispose();
    _deckNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final lines = _textController.text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.isEmpty) {
      setState(() => _error = l10n.deckSpeakEmptyError);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = await ref.read(deckRepositoryProvider).saveSpokenSentencesAsDeck(
        deckName: _deckNameController.text.trim().isEmpty
            ? _defaultDeckName()
            : _deckNameController.text.trim(),
        sentences: lines,
      );
      ref.invalidate(decksProvider);
      if (mounted) setState(() => _savedCount = saved);
    } catch (_) {
      if (mounted) setState(() => _error = l10n.deckSpeakSaveError);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  l10n.deckSpeakTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tokens.foreground),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppCard.card(
              child: Column(
                children: [
                  Text(
                    l10n.deckSpeakHelper,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 16),
                  Tooltip(
                    message: ReleaseFeatureFlags.speaking
                        ? l10n.deckSpeakMicTooltip
                        : l10n.deckSpeakMicComingSoon,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(
                          alpha: ReleaseFeatureFlags.speaking ? 1 : 0.4,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 32,
                        color: Colors.white,
                        onPressed: ReleaseFeatureFlags.speaking
                            ? () {
                                // Ghi âm/STT thật thuộc MASTER P8 (wiring vào
                                // UI này) — chưa xử lý gì cho tới lúc đó.
                              }
                            : null,
                        icon: const Icon(PhosphorIconsBold.microphone),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!ReleaseFeatureFlags.speaking)
                    Text(l10n.deckSpeakMicComingSoon, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: l10n.deckSpeakTextareaHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            AppCard.card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.deckSpeakDeckNameLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                  const SizedBox(height: 6),
                  TextField(controller: _deckNameController),
                  const SizedBox(height: 6),
                  Text(l10n.deckSpeakDeckNameHelper, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                  if (_savedCount != null) ...[
                    const SizedBox(height: 12),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.deckSpeakSavedMessage(_savedCount!),
                                style: const TextStyle(fontSize: 12, color: Color(0xFF047857)),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/notes'),
                              child: Text(l10n.deckSpeakViewDeck),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: TextStyle(color: tokens.destructive, fontSize: 12)),
                  ],
                  const SizedBox(height: 16),
                  AppButton(
                    label: l10n.deckSpeakSaveCta,
                    onPressed: _saving ? null : _save,
                    loading: _saving,
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
