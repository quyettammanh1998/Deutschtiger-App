import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../core/theme/app_tokens.dart';
import '../../view_models/providers.dart';

/// Shared markdown renderer wrapping `markdown_widget` with app-token
/// colors so both grammar (P6) and media/reading (P11) content render
/// consistently with web `<ReactMarkdown>` styling (headings, tables,
/// blockquote, inline code, images, links).
///
/// Web parity notes:
/// - Web renders inline `<audio>` players for markdown links ending in
///   `.mp3/.ogg/.wav`. `markdown_widget` has no audio-node concept, so this
///   widget pre-extracts those links and renders a compact play row
///   underneath the markdown body instead of inline — documented deviation,
///   not a data loss (link + label both preserved).
/// - Raw HTML blocks (web `dangerouslySetInnerHTML` after DOMPurify) have no
///   safe renderer here without adding a new dependency; callers should
///   strip/convert HTML to markdown/plain text before passing [data] in, or
///   accept literal tag text as a known limitation.
class AppMarkdownView extends ConsumerWidget {
  const AppMarkdownView(
    this.data, {
    super.key,
    this.selectable = true,
    this.padding = EdgeInsets.zero,
    this.dense = false,
  });

  final String data;
  final bool selectable;
  final EdgeInsetsGeometry padding;

  /// Smaller heading sizes — used for lesson content blocks embedded inside
  /// an already-titled card (vs. a full standalone article page).
  final bool dense;

  static final RegExp _audioLinkRe = RegExp(
    r'!?\[([^\]]*)\]\((\S+\.(?:mp3|ogg|wav)(?:\?[^)\s]*)?)\)',
    caseSensitive: false,
  );

  ({String cleaned, List<({String label, String url})> audio}) _extractAudio(
    String source,
  ) {
    final audio = <({String label, String url})>[];
    final cleaned = source.replaceAllMapped(_audioLinkRe, (match) {
      final label = match.group(1) ?? '';
      final url = match.group(2) ?? '';
      if (url.isEmpty) return match.group(0) ?? '';
      audio.add((label: label.isEmpty ? url : label, url: url));
      return '';
    });
    return (cleaned: cleaned, audio: audio);
  }

  MarkdownConfig _buildConfig(AppTokens tokens) {
    final baseSize = dense ? 13.0 : 14.0;
    return MarkdownConfig(
      configs: [
        PConfig(
          textStyle: TextStyle(
            fontSize: baseSize,
            height: 1.5,
            color: tokens.foreground,
          ),
        ),
        H1Config(
          style: TextStyle(
            fontSize: dense ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: tokens.foreground,
            height: 1.4,
          ),
        ),
        H2Config(
          style: TextStyle(
            fontSize: dense ? 15 : 17,
            fontWeight: FontWeight.bold,
            color: tokens.foreground,
            height: 1.4,
          ),
        ),
        H3Config(
          style: TextStyle(
            fontSize: dense ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: tokens.foreground,
            height: 1.4,
          ),
        ),
        H4Config(
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: tokens.foreground,
          ),
        ),
        BlockquoteConfig(
          sideColor: tokens.primary.withValues(alpha: 0.4),
          textColor: tokens.mutedForeground,
          sideWith: 4,
          padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        TableConfig(
          border: TableBorder.all(color: tokens.border),
          headerRowDecoration: BoxDecoration(
            color: tokens.muted.withValues(alpha: 0.5),
          ),
          headerStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: tokens.foreground,
          ),
          bodyStyle: TextStyle(fontSize: 12, color: tokens.foreground),
        ),
        CodeConfig(
          style: TextStyle(
            backgroundColor: tokens.accent.withValues(alpha: 0.15),
            color: tokens.primary,
            fontFamily: 'monospace',
            fontSize: baseSize - 1,
          ),
        ),
        PreConfig(
          decoration: BoxDecoration(
            color: tokens.muted.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: baseSize - 1,
            color: tokens.foreground,
          ),
        ),
        LinkConfig(
          style: TextStyle(
            color: tokens.primary,
            decoration: TextDecoration.underline,
          ),
        ),
        ImgConfig(
          builder: (url, attributes) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final extracted = _extractAudio(data);
    final trimmed = extracted.cleaned.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trimmed.isNotEmpty)
          Padding(
            padding: padding,
            child: MarkdownWidget(
              data: trimmed,
              shrinkWrap: true,
              selectable: selectable,
              physics: const NeverScrollableScrollPhysics(),
              config: _buildConfig(tokens),
            ),
          ),
        for (final audio in extracted.audio)
          _AudioLinkTile(label: audio.label, url: audio.url),
      ],
    );
  }
}

class _AudioLinkTile extends ConsumerWidget {
  const _AudioLinkTile({required this.label, required this.url});
  final String label;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: tokens.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () =>
              ref.read(audioServiceProvider).play(audioUrl: url, text: ''),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_fill, color: tokens.primary, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 12, color: tokens.foreground),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
