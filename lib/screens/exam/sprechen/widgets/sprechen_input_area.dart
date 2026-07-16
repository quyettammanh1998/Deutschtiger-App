import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/release/release_feature_flags.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/gradient_button.dart';

/// Web parity: `sprechen-input-area.tsx` — Viết (text) composer only.
/// Mic mode is gated behind `ReleaseFeatureFlags.speaking` (default off, no
/// on-device transcription in this phase) — shows a disabled mic affordance
/// instead of fake recording UI, matching the "gate the record action, no
/// fake data" scope note.
class SprechenInputArea extends StatefulWidget {
  const SprechenInputArea({
    super.key,
    required this.onSend,
    required this.onFetchSuggestions,
    this.sending = false,
  });

  final ValueChanged<String> onSend;
  final Future<List<String>> Function() onFetchSuggestions;
  final bool sending;

  @override
  State<SprechenInputArea> createState() => _SprechenInputAreaState();
}

class _SprechenInputAreaState extends State<SprechenInputArea> {
  final _controller = TextEditingController();
  List<String> _suggestions = const [];
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleSuggestions() async {
    if (_showSuggestions) {
      setState(() => _showSuggestions = false);
      return;
    }
    final suggestions = await widget.onFetchSuggestions();
    if (!mounted) return;
    setState(() {
      _suggestions = suggestions;
      _showSuggestions = true;
    });
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _showSuggestions = false);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showSuggestions)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final s in _suggestions)
                      ActionChip(
                        label: Text(s, style: const TextStyle(fontSize: 12)),
                        backgroundColor: tokens.warning.withValues(
                          alpha: 0.12,
                        ),
                        onPressed: () {
                          _controller.text = s;
                          setState(() => _showSuggestions = false);
                        },
                      ),
                    if (_suggestions.isEmpty)
                      Text(
                        l10n.sprechenNoSuggestions,
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.mutedForeground,
                        ),
                      ),
                  ],
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 3,
                    enabled: !widget.sending,
                    decoration: InputDecoration(
                      hintText: l10n.sprechenInputHint,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _toggleSuggestions,
                      icon: Icon(
                        AppPhosphorIcons.lightbulb,
                        size: 20,
                        color: _showSuggestions
                            ? tokens.warning
                            : tokens.mutedForeground,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 30,
                      child: GradientButton(
                        label: '',
                        loading: widget.sending,
                        onPressed: widget.sending ? null : _send,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  AppPhosphorIcons.microphone,
                  size: 14,
                  color: tokens.mutedForeground.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ReleaseFeatureFlags.speaking
                        ? l10n.sprechenMicComingSoon
                        : l10n.sprechenMicUnsupported,
                    style: TextStyle(
                      fontSize: 10,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
