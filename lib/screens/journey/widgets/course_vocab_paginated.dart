import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/speak_button.dart';

/// Paginated vocabulary card (4/page) with per-word audio — web parity
/// `VocabularyPaginated` in `course-lesson-page.tsx`. Audio playback reuses
/// the shared [SpeakButton] (remote URL → on-device TTS fallback), same
/// pattern as web's `speakWithAudioUrl`.
class CourseVocabPaginated extends StatefulWidget {
  const CourseVocabPaginated({super.key, required this.vocabularies});

  final List<DwVocabularyItem> vocabularies;

  static const pageSize = 4;

  @override
  State<CourseVocabPaginated> createState() => _CourseVocabPaginatedState();
}

class _CourseVocabPaginatedState extends State<CourseVocabPaginated> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final totalPages = (widget.vocabularies.length / CourseVocabPaginated.pageSize).ceil();
    final items = widget.vocabularies
        .skip(_page * CourseVocabPaginated.pageSize)
        .take(CourseVocabPaginated.pageSize)
        .toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.coursesVocabularyCount(widget.vocabularies.length),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tokens.foreground),
                ),
              ),
              if (totalPages > 1)
                Text('${_page + 1}/$totalPages', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.vocabularies.isEmpty)
            Text(l10n.coursesVocabularyEmpty, style: TextStyle(fontSize: 12, color: tokens.mutedForeground))
          else ...[
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tokens.muted.withValues(alpha: 0.3),
                    border: Border.all(color: tokens.border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpeakButton(text: item.german, audioUrl: item.audioUrl, iconSize: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.german, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground)),
                            const SizedBox(height: 2),
                            Text(
                              item.vietnamese ?? item.english ?? '—',
                              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (totalPages > 1)
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_page > 0)
                      TextButton(
                        onPressed: () => setState(() => _page -= 1),
                        child: Text(l10n.coursesPaginationPrev),
                      ),
                    TextButton(
                      onPressed: _page < totalPages - 1 ? () => setState(() => _page += 1) : null,
                      child: Text(l10n.coursesPaginationNext),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
