import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/release/release_feature_flags.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../features/voice/presentation/widgets/record_button.dart';
import '../../../../l10n/app_localizations.dart';

/// Voice-mode composer shell — idle mic button + "Quay lại gõ" pill. Web
/// parity: `conversation-voice-mic-panel.tsx` (idle/recording/transcribing/
/// review states with a live waveform).
///
/// Actual microphone capture + Azure STT wiring is MASTER P8 scope. This
/// widget renders the idle-state shell only and reuses [RecordButton] (the
/// shared `features/voice` stack) as the tap target so MASTER P8 can wire
/// `RecordingService` in without rebuilding the shell. The button is
/// disabled — tapping it is a no-op — until [ReleaseFeatureFlags.speaking]
/// is on AND live recording is wired.
class ConversationVoiceMicPanel extends StatelessWidget {
  const ConversationVoiceMicPanel({super.key, required this.onSwitchToText});

  final VoidCallback onSwitchToText;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final voiceLive = ReleaseFeatureFlags.speaking; // still shell-only for P10

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: voiceLive ? 1 : 0.5,
            child: IgnorePointer(
              ignoring: !voiceLive,
              child: RecordButton(
                size: 64,
                // MASTER P8 wires the transcript → composer hookup; this
                // shell just needs a valid callback to satisfy the widget API.
                onRecordingComplete: (_) {},
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.conversationVoiceTapToSpeak,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.conversationVoiceComingSoon,
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onSwitchToText,
            icon: const Icon(PhosphorIcons.textAa, size: 16),
            label: Text(l10n.conversationVoiceBackToText),
          ),
        ],
      ),
    );
  }
}
