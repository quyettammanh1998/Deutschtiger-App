import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// One row in the TELC B1 bundle chooser (`exam-section-page.tsx`
/// `TELC_BUNDLES`) — emoji tile + title/desc + chevron, or a disabled
/// "coming soon" pill when [onTap] is null (Sprechen bundle — speech hub is
/// P10's scope, gated off here rather than linking to a non-existent
/// route).
class ExamBundleRow extends StatelessWidget {
  const ExamBundleRow({
    super.key,
    required this.emoji,
    required this.title,
    required this.desc,
    this.comingSoonLabel,
    this.onTap,
  });

  final String emoji;
  final String title;
  final String desc;
  final String? comingSoonLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tokens.muted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tokens.foreground,
                    ),
                  ),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap == null && comingSoonLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tokens.muted,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  comingSoonLabel!,
                  style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                ),
              )
            else
              Icon(
                PhosphorIcons.caretRight,
                size: 18,
                color: tokens.mutedForeground,
              ),
          ],
        ),
      ),
    );
  }
}
