import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';
import 'course_transcript_segment_tile.dart';

/// Collapsible "Phụ đề" transcript card — web parity in
/// `course-lesson-page.tsx`: DE/VI copy buttons, VI toggle, tap-to-seek,
/// active-segment highlight (auto-scroll handled by [activeIndex] +
/// [ScrollController.animateTo] via the internal `AutoScrollController]`).
///
/// DEVIATION (documented): the floating-subtitle overlay
/// (`CourseFloatingSubtitle`) is dropped — same reasoning W2 used for
/// YouTube's cinema/floating-subtitle mode (no safe way to overlay video
/// chrome without extra native player control we don't have here either);
/// this collapsible panel with tap-to-seek covers the "video playback +
/// transcript" requirement from the plan table.
class CourseTranscriptPanel extends StatefulWidget {
  const CourseTranscriptPanel({
    super.key,
    required this.transcript,
    required this.activeIndex,
    required this.onSeek,
  });

  final List<CourseTranscriptSegment> transcript;
  final int activeIndex;
  final ValueChanged<double> onSeek;

  @override
  State<CourseTranscriptPanel> createState() => _CourseTranscriptPanelState();
}

class _CourseTranscriptPanelState extends State<CourseTranscriptPanel> {
  bool _open = true;
  bool _showVietnamese = true;
  final _itemKeys = <int, GlobalKey>{};
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant CourseTranscriptPanel old) {
    super.didUpdateWidget(old);
    if (widget.activeIndex != old.activeIndex && widget.activeIndex >= 0 && _open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _itemKeys[widget.activeIndex]?.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 250), alignment: 0.3);
        }
      });
    }
  }

  void _copy(bool german) {
    final text = widget.transcript
        .map((s) => german ? s.text : (s.textVi ?? s.text))
        .join('\n');
    Clipboard.setData(ClipboardData(text: text));
  }

  double _parseTimestamp(String value) {
    final parts = value.split(':').map((p) => double.tryParse(p) ?? 0).toList();
    if (parts.length == 3) return parts[0] * 3600 + parts[1] * 60 + parts[2];
    if (parts.length == 2) return parts[0] * 60 + parts[1];
    return double.tryParse(value) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.all(12),
              // `Wrap` (not `Row`) so the action-button cluster reflows to a
              // second line instead of overflowing horizontally at large
              // text scales (German 200%).
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedRotation(
                        turns: _open ? 0.25 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: Icon(AppPhosphorIcons.caretRight, size: 16, color: tokens.mutedForeground),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.coursesTranscriptTitle,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
                      ),
                    ],
                  ),
                  // `FittedBox` scales this action cluster down rather than
                  // letting it assert a RenderFlex overflow at large text
                  // scales (German 200%) — the buttons stay tappable, just
                  // visually smaller than their unconstrained natural size.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l10n.coursesTranscriptCopyDe,
                        icon: Icon(AppPhosphorIcons.copy, size: 16, color: tokens.mutedForeground),
                        onPressed: () => _copy(true),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _showVietnamese = !_showVietnamese),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        child: Text(
                          _showVietnamese ? l10n.coursesTranscriptHideVi : l10n.coursesTranscriptShowVi,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.primary),
                        ),
                      ),
                      if (_showVietnamese)
                        IconButton(
                          tooltip: l10n.coursesTranscriptCopyVi,
                          icon: Icon(AppPhosphorIcons.copy, size: 16, color: tokens.mutedForeground),
                          onPressed: () => _copy(false),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        ),
                    ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_open)
            Container(
              constraints: const BoxConstraints(maxHeight: 360),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: tokens.border))),
              child: widget.transcript.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(l10n.coursesTranscriptEmpty, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                    )
                  : ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(12),
                      itemCount: widget.transcript.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final segment = widget.transcript[index];
                        final key = _itemKeys.putIfAbsent(index, () => GlobalKey());
                        return CourseTranscriptSegmentTile(
                          key: key,
                          segment: segment,
                          isActive: index == widget.activeIndex,
                          showVietnamese: _showVietnamese,
                          onTap: () => widget.onSeek(_parseTimestamp(segment.start)),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
