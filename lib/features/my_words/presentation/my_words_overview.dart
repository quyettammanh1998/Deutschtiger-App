import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/dictionary_service.dart';
import '../../../shared/widgets/word_lookup_sheet.dart';
import '../domain/my_word.dart';
import 'my_words_screen.dart';
import 'my_words_source_label.dart';

/// Embeddable "Của tôi" content — web parity: `MyWordsOverview`, embedded as
/// the ⭐ tab inside `/vocabulary` (`vocabulary-page.tsx`), NOT a standalone
/// screen. Three status groups (🔁 reviewing / 📔 saved / 👀 seen), each a
/// scoped query so its badge is the true server-side count, not the sample
/// size — matches the web comment on `MyWordsOverview`.
class MyWordsOverview extends ConsumerWidget {
  const MyWordsOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reviewing = ref.watch(myWordsProvider(MyWordsFilter.reviewing));
    final saved = ref.watch(myWordsProvider(MyWordsFilter.saved));
    final seen = ref.watch(myWordsProvider(MyWordsFilter.seen));

    final sections = [
      (
        filter: MyWordsFilter.reviewing,
        icon: '🔁',
        label: l10n.myWordsGroupReviewing,
        color: const Color(0xFF10B981),
        async: reviewing,
      ),
      (
        filter: MyWordsFilter.saved,
        icon: '📔',
        label: l10n.myWordsGroupSaved,
        color: const Color(0xFF8B5CF6),
        async: saved,
      ),
      (
        filter: MyWordsFilter.seen,
        icon: '👀',
        label: l10n.myWordsGroupSeen,
        color: const Color(0xFF64748B),
        async: seen,
      ),
    ];

    if (sections.every((s) => s.async.isLoading)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (sections.every((s) => s.async.hasError)) {
      // Chỉ hiện thông báo đã dịch — không lộ chi tiết lỗi thô của provider.
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.couldNotLoadMyWords, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                for (final s in sections) {
                  ref.invalidate(myWordsProvider(s.filter));
                }
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final grandTotal = sections.fold<int>(
      0,
      (sum, s) => sum + (s.async.value?.total ?? 0),
    );
    if (grandTotal == 0) {
      return _EmptyState(l10n: l10n);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in sections)
          if ((s.async.value?.total ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _WordGroupSection(
                icon: s.icon,
                label: s.label,
                color: s.color,
                page: s.async.value!,
              ),
            ),
      ],
    );
  }
}

class _WordGroupSection extends StatelessWidget {
  const _WordGroupSection({
    required this.icon,
    required this.label,
    required this.color,
    required this.page,
  });

  final String icon;
  final String label;
  final Color color;
  final MyWordsPage page;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final more = page.total - page.words.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: context.tokens.muted,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('${page.total}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final word in page.words) _WordRow(word: word),
        if (more > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.myWordsMoreCount(more),
              style: TextStyle(fontSize: 11, color: context.tokens.mutedForeground),
            ),
          ),
      ],
    );
  }
}

class _WordRow extends StatelessWidget {
  const _WordRow({required this.word});
  final MyWord word;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final source = sourceLabelVi(word.source);
    return InkWell(
      onTap: () => showWordLookupSheet(
        context,
        entry: WordEntry(
          id: word.learningItemId,
          word: word.contentDe,
          meanings: [word.contentVi],
        ),
      ),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: tokens.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.contentDe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                if (source != null)
                  Text(
                    l10n.myWordsSourceLabel(source),
                    style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                  ),
              ],
            ),
            if (word.contentVi.isNotEmpty)
              Text(
                word.contentVi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            if (word.lastContext != null && word.lastContext!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '"${word.lastContext}"',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: tokens.mutedForeground.withValues(alpha: 0.8)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(l10n.myWordsEmptyTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            l10n.myWordsEmptyDescription,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground),
          ),
        ],
      ),
    );
  }
}
