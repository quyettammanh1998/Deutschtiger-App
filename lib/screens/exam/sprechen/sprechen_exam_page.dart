import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/word_lookup_sheet.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import 'widgets/sprechen_exam_mode.dart';

/// Web parity: `sprechen-exam-page.tsx` (TELC) — `SprechenExamMode`
/// wrapper for `/exams/telc/b1/noi/:teil/:slug(/practice)`; Teil 1 is
/// allowed without a `slug` (question-pool mode) — [slug] is then a
/// synthetic pool id supplied by the caller, see scout §B.11.
class SprechenExamPage extends ConsumerWidget {
  const SprechenExamPage({
    super.key,
    required this.teil,
    required this.slug,
    required this.contentId,
    this.startInPractice = false,
  });

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
              subtitle: '$teil · Punkte',
              teil: teil,
              topicSlug: slug,
              aufgabe: firstLine.trim(),
              studyMarkdown: content.markdown,
              contentLocked: content.locked,
              startInPractice: startInPractice,
              onExit: () => context.go('/exams/telc/b1/noi/$teil'),
              onWordTap: (word) => showWordLookupSheet(context, word: word),
            );
          },
        ),
      ),
    );
  }
}
