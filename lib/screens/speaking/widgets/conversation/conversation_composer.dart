import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/release/release_feature_flags.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'conversation_voice_mic_panel.dart';

/// Composer footer: Viết (text) / Mic segmented toggle, suggestion-bulb
/// toggle, auto-grow textarea, orange-gradient send. Web parity:
/// `sprechen-input-area.tsx` layout reused for the conversation composer.
///
/// The Mic segment is rendered but disabled unless
/// [ReleaseFeatureFlags.speaking] is on (voice capture itself stays
/// MASTER P8 scope even when the flag flips — see [ConversationVoiceMicPanel]).
class ConversationComposer extends StatefulWidget {
  const ConversationComposer({
    super.key,
    required this.onSend,
    required this.sending,
    required this.suggestionsOpen,
    required this.onToggleSuggestions,
  });

  final ValueChanged<String> onSend;
  final bool sending;
  final bool suggestionsOpen;
  final VoidCallback onToggleSuggestions;

  @override
  State<ConversationComposer> createState() => _ConversationComposerState();
}

class _ConversationComposerState extends State<ConversationComposer> {
  final _controller = TextEditingController();
  bool _voiceMode = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty || widget.sending) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: tokens.border))),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_voiceMode)
            ConversationVoiceMicPanel(onSwitchToText: () => setState(() => _voiceMode = false))
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: widget.onToggleSuggestions,
                  style: IconButton.styleFrom(
                    backgroundColor: widget.suggestionsOpen ? const Color(0xFFFDE68A) : tokens.muted,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(PhosphorIcons.lightbulbFilament, size: 20),
                  tooltip: l10n.conversationSuggestionsTitle,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: l10n.conversationComposerHint,
                      filled: true,
                      fillColor: tokens.muted,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: widget.sending ? null : _send,
                  style: IconButton.styleFrom(
                    backgroundColor: tokens.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: widget.sending
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(PhosphorIcons.paperPlaneTilt, color: Colors.white, size: 20),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Center(
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(l10n.conversationComposerModeText), icon: const Icon(PhosphorIcons.textAa, size: 14)),
                ButtonSegment(
                  value: true,
                  label: Text(l10n.conversationComposerModeVoice),
                  icon: const Icon(PhosphorIcons.microphone, size: 14),
                  enabled: ReleaseFeatureFlags.speaking,
                ),
              ],
              selected: {_voiceMode},
              onSelectionChanged: (s) => setState(() => _voiceMode = s.first),
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ),
        ],
      ),
    );
  }
}
