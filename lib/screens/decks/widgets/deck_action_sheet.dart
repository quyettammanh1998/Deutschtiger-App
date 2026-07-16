import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bottom_sheet.dart';

/// "Tạo mới" bottom sheet — Tạo bộ thẻ / Tạo thư mục / Nói ra ghi chú. Web
/// parity: `flashcard-deck-list.tsx` action sheet.
Future<void> showDeckCreateActionSheet(
  BuildContext context, {
  required VoidCallback onCreateDeck,
  required VoidCallback onCreateFolder,
  required VoidCallback onSpeakToNotes,
}) {
  final l10n = AppLocalizations.of(context);
  return showAppBottomSheet<void>(
    context,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionRow(
          icon: PhosphorIconsBold.plus,
          iconColor: Theme.of(ctx).extension<AppTokens>()?.primary ?? Colors.orange,
          title: l10n.deckActionCreateDeck,
          subtitle: l10n.deckActionCreateDeckSubtitle,
          onTap: () {
            Navigator.pop(ctx);
            onCreateDeck();
          },
        ),
        _ActionRow(
          icon: PhosphorIconsFill.folder,
          iconColor: const Color(0xFFF59E0B),
          title: l10n.deckActionCreateFolder,
          subtitle: l10n.deckActionCreateFolderSubtitle,
          onTap: () {
            Navigator.pop(ctx);
            onCreateFolder();
          },
        ),
        _ActionRow(
          icon: PhosphorIconsBold.microphone,
          iconColor: const Color(0xFFF97316),
          title: l10n.deckActionSpeak,
          subtitle: l10n.deckActionSpeakSubtitle,
          onTap: () {
            Navigator.pop(ctx);
            onSpeakToNotes();
          },
        ),
      ],
    ),
  );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
