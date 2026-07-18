import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Reader section shell — web parity `collapsible.tsx`. Emoji lives in
/// [title]. Supports controlled ([isOpen]/[onToggle], used by TOC/autoplay
/// force-open) — this widget is always controlled by its parent (the detail
/// page owns one open-map so the floating TOC can force-open sections).
class CollapsibleSection extends StatelessWidget {
  const CollapsibleSection({
    super.key,
    required this.title,
    required this.isOpen,
    required this.onToggle,
    required this.child,
    this.sectionKey,
  });

  final String title;
  final bool isOpen;
  final VoidCallback onToggle;
  final Widget child;

  /// Anchor key for the floating-TOC scroll target.
  final Key? sectionKey;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      key: sectionKey,
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: tokens.primary),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(PhosphorIcons.caretDown, size: 18, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: child,
            ),
            secondChild: const SizedBox(width: double.infinity),
            crossFadeState: isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}
