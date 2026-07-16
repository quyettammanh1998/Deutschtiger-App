import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/word_lookup_sheet.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import '../../../widgets/common/gradient_button.dart';
import 'widgets/sprechen_instruction_banner.dart';
import 'widgets/sprechen_study_panel.dart';

/// Web parity: `goethe-sprechen-teil-study-page.tsx` — study markdown +
/// fixed bottom "🎤 Luyện nói cùng Tiger AI" CTA, see scout §B.3.
///
/// Deviation: examiner rubric sheet / vocabulary+redemittel accordions are
/// folded into `SprechenStudyPanel`'s block renderer (see that widget's
/// doc comment) rather than parsed into per-section accordions.
class GoetheSprechenTeilStudyPage extends ConsumerWidget {
  const GoetheSprechenTeilStudyPage({
    super.key,
    required this.providerLevel,
    required this.slug,
    required this.teilSegment,
    required this.contentId,
  });

  final String providerLevel;
  final String slug;
  final String teilSegment;

  /// Exam-question uuid used by `GET /exams/official/sprechen-content`.
  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final contentAsync = ref.watch(sprechenContentProvider(contentId));

    return Scaffold(
      appBar: AppBar(title: Text(slug.replaceAll('-', ' '))),
      body: contentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.sprechenExamLoadError(e.toString())),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.back),
                ),
              ],
            ),
          ),
        ),
        data: (content) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SprechenInstructionBanner(
                      aufgabe: content.locked
                          ? l10n.sprechenContentLockedTitle
                          : _firstLine(content.markdown),
                      onWordTap: (word) =>
                          showWordLookupSheet(context, word: word),
                    ),
                    const SizedBox(height: 12),
                    SprechenStudyPanel(
                      markdown: content.markdown,
                      locked: content.locked,
                      onWordTap: (word) =>
                          showWordLookupSheet(context, word: word),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.background,
                    border: Border(top: BorderSide(color: tokens.border)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: GradientButton(
                        label: l10n.sprechenPracticeCta,
                        onPressed: content.locked
                            ? null
                            : () => context.push(
                                '/exams/$providerLevel/$slug/sprechen/$teilSegment/practice',
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _firstLine(String markdown) {
    final line = markdown.split('\n').firstWhere(
      (l) => l.trim().isNotEmpty,
      orElse: () => '',
    );
    return line.trim();
  }
}
