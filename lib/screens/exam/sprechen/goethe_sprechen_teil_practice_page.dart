import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/word_lookup_sheet.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import 'widgets/sprechen_exam_mode.dart';

/// Web parity: `goethe-sprechen-teil-practice-page.tsx` — thin wrapper that
/// loads the topic's markdown and drops straight into `SprechenExamMode`'s
/// practice tab, see scout §B.4.
class GoetheSprechenTeilPracticePage extends ConsumerWidget {
  const GoetheSprechenTeilPracticePage({
    super.key,
    required this.teilSegment,
    required this.slug,
    required this.contentId,
  });

  final String teilSegment;
  final String slug;
  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(sprechenContentProvider(contentId));

    return Scaffold(
      body: SafeArea(
        child: contentAsync.when(
          loading: () => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(AppLocalizations.of(context).loadingExam),
                ],
              ),
            ),
          ),
          error: (e, _) => Center(
            child: Text(
              AppLocalizations.of(context).sprechenExamLoadError(e.toString()),
            ),
          ),
          data: (content) {
            final firstLine = content.markdown
                .split('\n')
                .firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');
            return SprechenExamMode(
              title: 'Sprechen — ${slug.replaceAll('-', ' ')}',
              subtitle: '$teilSegment · 25 Punkte',
              teil: teilSegment,
              topicSlug: slug,
              aufgabe: firstLine.trim(),
              studyMarkdown: content.markdown,
              contentLocked: content.locked,
              startInPractice: true,
              onExit: () => context.pop(),
              onWordTap: (word) => showWordLookupSheet(context, word: word),
            );
          },
        ),
      ),
    );
  }
}
