import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Bottom sheet cài đặt đọc transcript podcast: cỡ chữ + hiện/ẩn bản dịch.
/// Web parity: `PodcastReaderSettingsDialog`.
class PodcastReaderSettingsSheet extends StatefulWidget {
  const PodcastReaderSettingsSheet({
    super.key,
    required this.initialScale,
    required this.initialShowVi,
    required this.onSave,
  });

  final double initialScale;
  final bool initialShowVi;
  final void Function(double scale, bool showVi) onSave;

  static Future<void> show(
    BuildContext context, {
    required double initialScale,
    required bool initialShowVi,
    required void Function(double scale, bool showVi) onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PodcastReaderSettingsSheet(
        initialScale: initialScale,
        initialShowVi: initialShowVi,
        onSave: onSave,
      ),
    );
  }

  @override
  State<PodcastReaderSettingsSheet> createState() => _PodcastReaderSettingsSheetState();
}

class _PodcastReaderSettingsSheetState extends State<PodcastReaderSettingsSheet> {
  late double _scale = widget.initialScale;
  late bool _showVi = widget.initialShowVi;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.podcastSettingsTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground)),
            const SizedBox(height: 16),
            Text(l10n.podcastFontSizeLabel((_scale * 100).round()), style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
            Slider(
              value: _scale,
              min: 0.8,
              max: 1.6,
              divisions: 8,
              activeColor: const Color(0xFF9333EA),
              onChanged: (v) => setState(() => _scale = v),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.podcastShowViTranslation, style: TextStyle(fontSize: 14, color: tokens.foreground)),
              value: _showVi,
              activeThumbColor: const Color(0xFF9333EA),
              onChanged: (v) => setState(() => _showVi = v),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF9333EA)),
                onPressed: () {
                  widget.onSave(_scale, _showVi);
                  Navigator.of(context).pop();
                },
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
