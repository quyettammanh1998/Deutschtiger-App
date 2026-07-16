import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/word_lookup_sheet.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import 'widgets/sprechen_exam_mode.dart';

/// Web parity: `goethe-sprechen-exam-page.tsx` — pure `SprechenExamMode`
/// wrapper for study (`/sprechen/:teil/:slug`) and practice
/// (`…/practice`) routes; on complete, saves the result and pops back to
/// the topic list. See scout §B.5. `teil` here is limited to
/// `goethe-teil1`/`goethe-teil2` per the web route guard.
class GoetheSprechenExamPage extends ConsumerWidget {
  const GoetheSprechenExamPage({
    super.key,
    required this.level,
    required this.teil,
    required this.slug,
    required this.contentId,
    this.startInPractice = false,
  });

  final String level;
  final String teil;
  final String slug;
  final String contentId;
  final bool startInPractice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(sprechenContentProvider(contentId));

    return Scaffold(
      body: SafeArea(
        child: contentAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
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
              subtitle: '$teil · 25 Punkte',
              teil: teil,
              topicSlug: slug,
              aufgabe: firstLine.trim(),
              studyMarkdown: content.markdown,
              contentLocked: content.locked,
              startInPractice: startInPractice,
              onExit: () => context.go('/exams/goethe/$level/sprechen/$teil'),
              onWordTap: (word) => showWordLookupSheet(context, word: word),
            );
          },
        ),
      ),
    );
  }
}
