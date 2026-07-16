import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';

class TocEntry {
  const TocEntry(this.id, this.emoji, this.label);
  final String id;
  final String emoji;
  final String label;
}

/// Floating TOC pill (`fixed bottom-20 right-4`) — web parity inline
/// `FloatingTOC` in `goethe-b1-writing-detail-page.tsx`. Simplified:
/// [activeId] is caller-tracked (no scroll-position IntersectionObserver —
/// this app doesn't have that primitive readily available); tapping an
/// entry calls [onSelect] which the page uses to force-open + scroll.
class FloatingTocPill extends StatefulWidget {
  const FloatingTocPill({super.key, required this.entries, required this.activeId, required this.onSelect});

  final List<TocEntry> entries;
  final String? activeId;
  final ValueChanged<String> onSelect;

  @override
  State<FloatingTocPill> createState() => _FloatingTocPillState();
}

class _FloatingTocPillState extends State<FloatingTocPill> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (widget.entries.isEmpty) return const SizedBox.shrink();
    final active = widget.entries.firstWhere(
      (e) => e.id == widget.activeId,
      orElse: () => widget.entries.first,
    );

    return Positioned(
      right: 16,
      bottom: 84,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_open)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              constraints: const BoxConstraints(maxWidth: 220, maxHeight: 320),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tokens.border),
                boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final e in widget.entries)
                      InkWell(
                        onTap: () {
                          setState(() => _open = false);
                          widget.onSelect(e.id);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: e.id == active.id ? const Color(0xFFFFF7ED) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${e.emoji} ${e.label}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: e.id == active.id ? FontWeight.w700 : FontWeight.normal,
                              color: e.id == active.id ? const Color(0xFFEA580C) : tokens.foreground,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: tokens.border),
                boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${active.emoji} ', style: const TextStyle(fontSize: 12)),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(active.label, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.foreground)),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(Icons.keyboard_arrow_down, size: 14, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
