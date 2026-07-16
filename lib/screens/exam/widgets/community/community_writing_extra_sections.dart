import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import 'community_detail_section_widgets.dart';

/// Remaining writing `generated_data` sections: useful phrases, grammar
/// focus, common mistakes (strikethrough wrong -> green correct). Web
/// parity: bottom 3 cards of `WritingTopicContent` in
/// `community-exam-detail-page.tsx`.
class CommunityWritingExtraSections extends StatelessWidget {
  const CommunityWritingExtraSections({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final usefulPhrases = (data['usefulPhrases'] as List?)
        ?.cast<Map<String, dynamic>>();
    final grammarFocus = (data['grammarFocus'] as List?)
        ?.cast<Map<String, dynamic>>();
    final commonMistakes = (data['commonMistakes'] as List?)
        ?.cast<Map<String, dynamic>>();
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (usefulPhrases != null && usefulPhrases.isNotEmpty)
          CommunityDetailSection(
            title: '💡 Cụm từ hữu ích',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final cat in usefulPhrases) ...[
                  if (cat['category'] is String)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 2),
                      child: CommunityMutedText(
                        cat['category'] as String,
                        bold: true,
                      ),
                    ),
                  for (final row
                      in (cat['rows'] as List? ?? [])
                          .cast<Map<String, dynamic>>())
                    CommunityBulletDeVi(
                      de: row['de'] as String?,
                      vi: row['vi'] as String?,
                      sep: '—',
                    ),
                ],
              ],
            ),
          ),
        if (grammarFocus != null && grammarFocus.isNotEmpty)
          CommunityDetailSection(
            title: '📖 Ngữ pháp trọng tâm',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final g in grammarFocus)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.foreground,
                        ),
                        children: [
                          TextSpan(
                            text: '${g['pattern']}: ',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: '${g['example']} '),
                          TextSpan(
                            text: '(${g['vi']})',
                            style: TextStyle(
                              color: tokens.mutedForeground,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (commonMistakes != null && commonMistakes.isNotEmpty)
          CommunityDetailSection(
            title: '⚠️ Lỗi thường gặp',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final m in commonMistakes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.foreground,
                        ),
                        children: [
                          TextSpan(
                            text: '${m['wrong']} ',
                            style: TextStyle(
                              color: tokens.destructive,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const TextSpan(text: '→ '),
                          TextSpan(
                            text: '${m['correct']} ',
                            style: TextStyle(color: tokens.success),
                          ),
                          TextSpan(
                            text: '(${m['vi']})',
                            style: TextStyle(
                              color: tokens.mutedForeground,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Speaking topics store either a raw string or `{content: string}` — no
/// structured sections on web either (`SpeakingTopicContent` just dumps the
/// text into a bordered card).
class CommunitySpeakingContent extends StatelessWidget {
  const CommunitySpeakingContent({super.key, required this.raw});

  final Object? raw;

  @override
  Widget build(BuildContext context) {
    final content = switch (raw) {
      String s => s,
      Map<String, dynamic> m when m['content'] is String =>
        m['content'] as String,
      _ => '',
    };
    if (content.isEmpty) return const SizedBox.shrink();
    return CommunityDetailSection(
      title: '🎙️ Nội dung',
      child: CommunityMutedText(content, muted: false),
    );
  }
}
